import 'package:gymaster/core/database/database_helper.dart';
import 'package:gymaster/core/database/models/models.dart';
import 'package:gymaster/core/error/exceptions.dart';
import 'package:gymaster/features/record/data/models/record_rutina_models.dart';
import 'package:gymaster/shared/utils/enum.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class RecordLocalDataSource {
  final DatabaseHelper databaseHelper;

  RecordLocalDataSource(this.databaseHelper);

  Future<List<RutinaSesionDbModel>> getCompletedRoutines() async {
    try {
      final db = await databaseHelper.database;

      // Corregir registros inconsistentes: sesiones marcadas como completadas pero sin timestamps
      await _fixInconsistentCompletedSessions(db);

      final result = await db.query(
        RutinaSesionDbModel.tabla,
        where:
            'estado = ? AND ${RutinaSesionDbModel.columnaHoraInicio} IS NOT NULL AND ${RutinaSesionDbModel.columnaHoraFin} IS NOT NULL',
        whereArgs: [EstadoSesionRutina.completado.name],
        orderBy: '${RutinaSesionDbModel.columnaFechaCreacion} DESC',
      );

      if (result.isEmpty) {
        return []; // Retornar lista vacía en lugar de lanzar excepción
      }

      final sessions = result
          .map((session) => RutinaSesionDbModel.fromJson(session))
          .toList();

      return sessions;
    } on DatabaseException catch (e) {
      print('❌ Error de base de datos: $e');
      throw CacheException();
    } catch (e) {
      print('❌ Error inesperado al obtener rutinas completadas: $e');
      throw CacheException();
    }
  }

  Future<List<EjercicioDbModel>> getCompletedExercisesByRoutineId(
    String routineId,
  ) async {
    final db = await databaseHelper.database;
    final ejercicios = await db.rawQuery(
      '''
        SELECT e.*
        FROM exercise e
        INNER JOIN session_exercise se ON e.id = se.exercise_id
        INNER JOIN routine_session rs ON se.session_id = rs.id
        WHERE rs.routine_id = ? AND rs.status = 'completado' AND se.status = 'completado';
      ''',
      [routineId],
    );

    return ejercicios
        .map((ejercicio) => EjercicioDbModel.fromJson(ejercicio))
        .toList();
  }

  // Nuevo método para obtener ejercicios por sessionId específico
  Future<List<EjercicioDbModel>> getCompletedExercisesBySessionId(
    String sessionId,
  ) async {
    final db = await databaseHelper.database;
    final ejercicios = await db.rawQuery(
      '''
        SELECT e.*
        FROM exercise e
        INNER JOIN session_exercise se ON e.id = se.exercise_id
        WHERE se.session_id = ? AND se.status = 'completado';
      ''',
      [sessionId],
    );

    return ejercicios
        .map((ejercicio) => EjercicioDbModel.fromJson(ejercicio))
        .toList();
  }

  Future<List<SerieEjercicioDbModel>> getSeriesByExerciseId(
      String exerciseId) async {
    final db = await databaseHelper.database;
    final series = await db.rawQuery(
      '''
        SELECT es.*
        FROM exercise_set es
        INNER JOIN session_exercise se ON es.session_exercise_id = se.id
        WHERE se.exercise_id = ? AND es.status = 'completado';
      ''',
      [exerciseId],
    );

    return series
        .map((serie) => SerieEjercicioDbModel.fromJson(serie))
        .toList();
  }

  // Nuevo método para obtener series por ejercicio y sesión específicos
  Future<List<SerieEjercicioDbModel>> getSeriesByExerciseAndSessionId(
      String exerciseId, String sessionId) async {
    final db = await databaseHelper.database;
    final series = await db.rawQuery(
      '''
        SELECT es.*
        FROM exercise_set es
        INNER JOIN session_exercise se ON es.session_exercise_id = se.id
        WHERE se.exercise_id = ? AND se.session_id = ? AND es.status = 'completado';
      ''',
      [exerciseId, sessionId],
    );

    return series
        .map((serie) => SerieEjercicioDbModel.fromJson(serie))
        .toList();
  }

  Future<List<RutinaDbModel>> getAllRutinas() async {
    try {
      final db = await databaseHelper.database;
      final rutinas = await db.query(
        RutinaDbModel.tabla,
        orderBy: RutinaDbModel.columnaFechaCreacion,
      );
      return rutinas.map((rutina) => RutinaDbModel.fromJson(rutina)).toList();
    } catch (e) {
      throw CacheException();
    }
  }

  Future<RutinaDbModel> getRutinaById(String id) async {
    final db = await databaseHelper.database;
    final result = await db.query(
      RutinaDbModel.tabla,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return RutinaDbModel.fromJson(result.first);
    } else {
      throw Exception('Rutina not found');
    }
  }

  Future<void> saveRutina(RecordRutinaModel rutina) async {
    final db = await databaseHelper.database;
    await db.insert(
      RutinaDbModel.tabla,
      rutina.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteRutina(String id) async {
    final db = await databaseHelper.database;
    await db.delete(
      RutinaDbModel.tabla,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Método privado para corregir datos inconsistentes
  Future<void> _fixInconsistentCompletedSessions(Database db) async {
    try {
      // Buscar sesiones completed sin timestamps
      final inconsistentSessions = await db.query(
        RutinaSesionDbModel.tabla,
        where:
            '${RutinaSesionDbModel.columnaEstado} = ? AND (${RutinaSesionDbModel.columnaHoraInicio} IS NULL OR ${RutinaSesionDbModel.columnaHoraFin} IS NULL)',
        whereArgs: [EstadoSesionRutina.completado.name],
      );

      for (var session in inconsistentSessions) {
        final sessionId = session[RutinaSesionDbModel.columnaId] as String;
        final createdAt =
            session[RutinaSesionDbModel.columnaFechaCreacion] as String;

        print('🔧 Corrigiendo sesión inconsistente: $sessionId');

        // Asignar timestamps basados en created_at si faltan
        final createdDate = DateTime.parse(createdAt);
        final estimatedStartTime = createdDate;
        final estimatedEndTime =
            createdDate.add(const Duration(minutes: 45)); // Duración estimada

        await db.update(
          RutinaSesionDbModel.tabla,
          {
            RutinaSesionDbModel.columnaHoraInicio:
                session[RutinaSesionDbModel.columnaHoraInicio] ??
                    estimatedStartTime.toIso8601String(),
            RutinaSesionDbModel.columnaHoraFin:
                session[RutinaSesionDbModel.columnaHoraFin] ??
                    estimatedEndTime.toIso8601String(),
          },
          where: '${RutinaSesionDbModel.columnaId} = ?',
          whereArgs: [sessionId],
        );
      }
    } catch (e) {
      print('⚠️ Error corrigiendo sesiones inconsistentes: $e');
    }
  }
}
