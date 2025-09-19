import 'package:gymaster/core/database/database_helper.dart';
import 'package:gymaster/core/database/models/models.dart';
import 'package:gymaster/core/error/exceptions.dart';
import 'package:gymaster/features/record/data/models/record_rutina_models.dart';
import 'package:gymaster/shared/utils/enum.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class RecordLocalDataSource {
  final DatabaseHelper databaseHelper;

  RecordLocalDataSource(this.databaseHelper);

  Future<List<RutinaSesionDb>> getCompletedRoutines() async {
    try {
      final db = await databaseHelper.database;

      // Corregir registros inconsistentes: sesiones marcadas como completadas pero sin timestamps
      await _fixInconsistentCompletedSessions(db);

      final result = await db.query(
        RutinaSesionDb.tabla,
        where:
            '${RutinaSesionDb.columnaEstado} = ? AND ${RutinaSesionDb.columnaHoraInicio} IS NOT NULL AND ${RutinaSesionDb.columnaHoraFin} IS NOT NULL',
        whereArgs: [EstadoSesionRutina.completado.name],
        orderBy: '${RutinaSesionDb.columnaFechaCreacion} DESC',
      );

      if (result.isEmpty) {
        return []; // Retornar lista vacía en lugar de lanzar excepción
      }

      final sessions =
          result.map((session) => RutinaSesionDb.fromJson(session)).toList();

      return sessions;
    } on DatabaseException catch (e) {
      print('❌ Error de base de datos: $e');
      throw CacheException();
    } catch (e) {
      print('❌ Error inesperado al obtener rutinas completadas: $e');
      throw CacheException();
    }
  }

  Future<List<EjercicioDb>> getCompletedExercisesByRoutineId(
    String routineId,
  ) async {
    final db = await databaseHelper.database;
    final ejercicios = await db.rawQuery(
      '''
        SELECT e.*
        FROM ${EjercicioDb.tabla} e
        INNER JOIN ${SessionEjercicioDb.tabla} se ON e.id = se.${SessionEjercicioDb.columnId}
        INNER JOIN ${RutinaSesionDb.tabla} rs ON se.${SessionEjercicioDb.columnSessionId} = rs.${RutinaSesionDb.columnaId}
        WHERE rs.${RutinaSesionDb.columnaRutinaId}  = ? AND rs.${RutinaSesionDb.columnaEstado}  = '${EstadoSesionRutina.completado.name}' AND se.${SessionEjercicioDb.columnStatus}  = '${EstadoEjercicioSesion.completado.name}';
      ''',
      [routineId],
    );

    return ejercicios
        .map((ejercicio) => EjercicioDb.fromJson(ejercicio))
        .toList();
  }

  // Nuevo método para obtener ejercicios por sessionId específico
  Future<List<EjercicioDb>> getCompletedExercisesBySessionId(
    String sessionId,
  ) async {
    final db = await databaseHelper.database;
    final ejercicios = await db.rawQuery(
      '''
        SELECT e.*
        FROM ${EjercicioDb.tabla}  e
        INNER JOIN ${SessionEjercicioDb.tabla}  se ON e.id = se.${SessionEjercicioDb.columnExerciseId}
        WHERE se.${SessionEjercicioDb.columnSessionId}  = ? AND se.${SessionEjercicioDb.columnStatus}  = '${EstadoSerieEjercicio.completado.name}';
      ''',
      [sessionId],
    );

    return ejercicios
        .map((ejercicio) => EjercicioDb.fromJson(ejercicio))
        .toList();
  }

  Future<List<SerieEjercicioDb>> getSeriesByExerciseId(
      String exerciseId) async {
    final db = await databaseHelper.database;
    final series = await db.rawQuery(
      '''
        SELECT es.*
        FROM ${SerieEjercicioDb.tabla} es
        INNER JOIN ${SessionEjercicioDb.tabla} se ON es.${SerieEjercicioDb.columnaEjercicioSesionId}  = se.${SessionEjercicioDb.columnId} 
        WHERE se.${SessionEjercicioDb.columnExerciseId}  = ? AND es.${SerieEjercicioDb.columnaEstado}  = '${EstadoSerieEjercicio.completado.name}';
      ''',
      [exerciseId],
    );

    return series.map((serie) => SerieEjercicioDb.fromJson(serie)).toList();
  }

  // Nuevo método para obtener series por ejercicio y sesión específicos
  Future<List<SerieEjercicioDb>> getSeriesByExerciseAndSessionId(
      String exerciseId, String sessionId) async {
    final db = await databaseHelper.database;
    final series = await db.rawQuery(
      '''
        SELECT es.*
        FROM ${SerieEjercicioDb.tabla}  es
        INNER JOIN ${SessionEjercicioDb.tabla} se ON es.${SerieEjercicioDb.columnaEjercicioSesionId} = se.${SessionEjercicioDb.columnId}
        WHERE se.${SessionEjercicioDb.columnExerciseId} = ? AND se.${SessionEjercicioDb.columnSessionId} = ? AND es.${SerieEjercicioDb.columnaEstado}  = '${EstadoSerieEjercicio.completado.name}';
      ''',
      [exerciseId, sessionId],
    );

    return series.map((serie) => SerieEjercicioDb.fromJson(serie)).toList();
  }

  Future<List<RutinaDb>> getAllRutinas() async {
    try {
      final db = await databaseHelper.database;
      final rutinas = await db.query(
        RutinaDb.tabla,
        orderBy: RutinaDb.columnaFechaCreacion,
      );
      return rutinas.map((rutina) => RutinaDb.fromJson(rutina)).toList();
    } catch (e) {
      throw CacheException();
    }
  }

  Future<RutinaDb> getRutinaById(String id) async {
    final db = await databaseHelper.database;
    final result = await db.query(
      RutinaDb.tabla,
      where: '${RutinaDb.columnaId} = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return RutinaDb.fromJson(result.first);
    } else {
      throw Exception('Rutina not found');
    }
  }

  Future<void> saveRutina(RecordRutinaModel rutina) async {
    final db = await databaseHelper.database;
    await db.insert(
      RutinaDb.tabla,
      rutina.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteRutina(String id) async {
    final db = await databaseHelper.database;
    await db.delete(
      RutinaDb.tabla,
      where: '${RutinaDb.columnaId} = ?',
      whereArgs: [id],
    );
  }

  // Método privado para corregir datos inconsistentes
  Future<void> _fixInconsistentCompletedSessions(Database db) async {
    try {
      // Buscar sesiones completed sin timestamps
      final inconsistentSessions = await db.query(
        RutinaSesionDb.tabla,
        where:
            '${RutinaSesionDb.columnaEstado} = ? AND (${RutinaSesionDb.columnaHoraInicio} IS NULL OR ${RutinaSesionDb.columnaHoraFin} IS NULL)',
        whereArgs: [EstadoSesionRutina.completado.name],
      );

      for (var session in inconsistentSessions) {
        final sessionId = session[RutinaSesionDb.columnaId] as String;
        final createdAt =
            session[RutinaSesionDb.columnaFechaCreacion] as String;

        print('🔧 Corrigiendo sesión inconsistente: $sessionId');

        // Asignar timestamps basados en created_at si faltan
        final createdDate = DateTime.parse(createdAt);
        final estimatedStartTime = createdDate;
        final estimatedEndTime =
            createdDate.add(const Duration(minutes: 45)); // Duración estimada

        await db.update(
          RutinaSesionDb.tabla,
          {
            RutinaSesionDb.columnaHoraInicio:
                session[RutinaSesionDb.columnaHoraInicio] ??
                    estimatedStartTime.toIso8601String(),
            RutinaSesionDb.columnaHoraFin:
                session[RutinaSesionDb.columnaHoraFin] ??
                    estimatedEndTime.toIso8601String(),
          },
          where: '${RutinaSesionDb.columnaId} = ?',
          whereArgs: [sessionId],
        );
      }
    } catch (e) {
      print('⚠️ Error corrigiendo sesiones inconsistentes: $e');
    }
  }
}
