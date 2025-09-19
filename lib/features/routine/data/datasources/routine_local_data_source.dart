import 'package:gymaster/core/database/database_helper.dart';
import 'package:gymaster/core/database/models/models.dart';
import 'package:gymaster/core/error/exceptions.dart';
import 'package:gymaster/features/routine/domain/usecases/add_ejercicio_rutina_usecase.dart';
import 'package:gymaster/shared/utils/enum.dart';
import 'package:gymaster/shared/utils/uuid_generator.dart';
import 'package:sqflite/sqflite.dart';

class RoutineLocalDataSource {
  final DatabaseHelper databaseHelper;
  final IdGenerator idGenerator;

  RoutineLocalDataSource(this.databaseHelper, this.idGenerator);

  Future<List<RutinaDb>> getAllRutinas() async {
    try {
      final db = await databaseHelper.database;
      final rutinas = await db.query(
        RutinaDb.tabla,
        orderBy: '${RutinaDb.columnaFechaCreacion} DESC',
      );
      if (rutinas.isEmpty) {
        throw NoRecordsException();
      }
      return rutinas.map((rutina) => RutinaDb.fromJson(rutina)).toList();
    } catch (e) {
      if (e is NoRecordsException) {
        rethrow;
      } else {
        throw ServerException();
      }
    }
  }

  Future<bool> createRutina({required RutinaDb rutina}) async {
    try {
      final db = await databaseHelper.database;
      final id = await db.insert(RutinaDb.tabla, rutina.toJson());
      return id > 0;
    } catch (e) {
      throw ServerException();
    }
  }

  Future<List<MusculoDb>> getAllMusculos() async {
    try {
      final db = await databaseHelper.database;
      final musculos = await db.query(MusculoDb.tabla);
      return List.generate(musculos.length, (i) {
        return MusculoDb.fromJson(musculos[i]);
      });
    } catch (e) {
      throw ServerException();
    }
  }

  Future<List<EjercicioDb>> getEjerciciosPorMusculo(String musculoId) async {
    try {
      final db = await databaseHelper.database;
      final ejercicios = await db.rawQuery(
        '''
            SELECT e.* FROM ${EjercicioDb.tabla} e
            JOIN ${EjercicioMusculoDbModel.tabla} em ON e.${EjercicioDb.columnId} = em.${EjercicioMusculoDbModel.columnaEjercicioId}
            JOIN ${MusculoDb.tabla} m ON em.${EjercicioMusculoDbModel.columnaMusculoId} = m.${MusculoDb.columnaId}
            WHERE m.${MusculoDb.columnaId} = ?;
          ''',
        [musculoId],
      );

      if (ejercicios.isEmpty) throw NoRecordsException();
      return ejercicios.map((map) => EjercicioDb.fromJson(map)).toList();
    } catch (e) {
      throw ServerException();
    }
  }

  Future<RutinaDb> getRutinaById(String id) async {
    try {
      final db = await databaseHelper.database;
      final rutina = await db.query(
        RutinaDb.tabla,
        where: '${RutinaDb.columnaId} = ?',
        whereArgs: [id],
      );
      return RutinaDb.fromJson(rutina.first);
    } catch (e) {
      throw ServerException();
    }
  }

  Future<RutinaDb> getEjercicioById(String id) async {
    try {
      final db = await databaseHelper.database;
      final ejercicio = await db.query(
        EjercicioDb.tabla,
        where: '${EjercicioDb.columnId} = ?',
        whereArgs: [id],
      );
      return RutinaDb.fromJson(ejercicio.first);
    } catch (e) {
      throw ServerException();
    }
  }

  Future<SerieEjercicioDb> getSerieById(String id) async {
    try {
      final db = await databaseHelper.database;
      final serie = await db.query(
        SerieEjercicioDb.tabla,
        where: '${SerieEjercicioDb.columnaId} = ?',
        whereArgs: [id],
      );
      return SerieEjercicioDb.fromJson(serie.first);
    } catch (e) {
      throw ServerException();
    }
  }

  Future<SerieEjercicioDb> createSerie(
      {required SerieEjercicioDb serie}) async {
    try {
      final db = await databaseHelper.database;
      final id = await db.insert(SerieEjercicioDb.tabla, serie.toJson());
      return id > 0 ? serie : throw ServerException();
    } catch (e) {
      throw ServerException();
    }
  }

  Future<List<EjercicioDb>> getEjerciciosByRutinaId(String rutinaId) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.rawQuery(
        '''
          SELECT DISTINCT e.*
          FROM ${SessionEjercicioDb.tabla} es
          JOIN ${EjercicioDb.tabla} e ON es.${SessionEjercicioDb.columnExerciseId} = e.${EjercicioDb.columnId}
          JOIN ${RutinaSesionDb.tabla} rs ON es.${SessionEjercicioDb.columnSessionId} = rs.${RutinaSesionDb.columnaId}
          WHERE rs.${RutinaSesionDb.columnaRutinaId} = ?;
        ''',
        [rutinaId],
      );
      if (result.isEmpty) return [];
      return result.map((map) => EjercicioDb.fromJson(map)).toList();
    } catch (e) {
      throw ServerException();
    }
  }

  Future<List<SerieEjercicioDb>> getSeriesByEjercicioIdAndRutinaId(
    String ejercicioId,
    String rutinaId,
  ) async {
    try {
      final db = await databaseHelper.database;
      final series = await db.rawQuery(
        '''
          SELECT s.* FROM ${SerieEjercicioDb.tabla} s
          JOIN detalle_rutina dr on dr.id = s.detalle_rutina_id
          JOIN ${SerieEjercicioDb.tabla} e on e.id = dr.ejercicio_id
          JOIN ${RutinaDb.tabla} r on r.id = dr.rutina_id
          WHERE r.id = ?
          AND e.id = ?;
        ''',
        [rutinaId, ejercicioId],
      );
      return List.generate(series.length, (i) {
        return SerieEjercicioDb.fromJson(series[i]);
      });
    } catch (e) {
      throw ServerException();
    }
  }

  Future<List<MusculoDb>> getMusculosByEjercicioId(String exerciseId) async {
    try {
      final db = await databaseHelper.database;
      final maps = await db.rawQuery(
        '''
          SELECT m.id, m.${MusculoDb.columnaNombre}, m.${MusculoDb.columnaRutaImagen}, m.${MusculoDb.columnaFechaCreacion}
          FROM ${MusculoDb.tabla} m
          JOIN ${EjercicioMusculoDbModel.tabla} em ON m.id = em.${EjercicioMusculoDbModel.columnaMusculoId} 
          WHERE em.${EjercicioMusculoDbModel.columnaEjercicioId} = ?
        ''',
        [exerciseId],
      );
      return maps.map((map) => MusculoDb.fromJson(map)).toList();
    } catch (e) {
      throw ServerException();
    }
  }

  Future<bool> updateSerie(SerieEjercicioDb serie) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.update(
        SerieEjercicioDb.tabla,
        serie.toJson(),
        where: '${SerieEjercicioDb.columnaId} = ?',
        whereArgs: [serie.id],
      );
      return result > 0;
    } catch (e) {
      throw ServerException();
    }
  }

  Future<List<RutinaDb>> getRutinasByNombre(String nombre) async {
    try {
      final db = await databaseHelper.database;
      final rutinas = await db.rawQuery(
        '''
          SELECT * FROM ${RutinaDb.tabla}
          WHERE ${RutinaDb.columnaNombre} LIKE ?;
        ''',
        ['%$nombre%'],
      );
      return rutinas.map((rutina) => RutinaDb.fromJson(rutina)).toList();
    } catch (e) {
      throw ServerException();
    }
  }

  Future<void> addEjercicioToRutina({
    required String idRutina,
    required String idRoutineSession,
    required String idEjercicio,
    required List<DataSerie> dataSeries,
  }) async {
    try {
      final db = await databaseHelper.database;

      await db.transaction((txn) async {
        final orderResults = await txn.query(
          SessionEjercicioDb.tabla,
          columns: ['MAX(${SessionEjercicioDb.columnOrderIndex}) as max_order'],
          where: '${SessionEjercicioDb.columnSessionId} = ?',
          whereArgs: [idRoutineSession],
        );

        int nextOrder = 0;

        // Si hay ejercicios en la sesión, el siguiente ejercicio tendrá el siguiente orden
        if (orderResults.isNotEmpty &&
            orderResults.first['max_order'] != null) {
          nextOrder = (orderResults.first['max_order'] as int) + 1;
        }

        final idSessionExercise = idGenerator.generateId();
        final sessionExercise = SessionEjercicioDb(
          id: idSessionExercise,
          sessionId: idRoutineSession,
          exerciseId: idEjercicio,
          status: EstadoEjercicioSesion.pendiente.name,
          orderIndex: nextOrder,
        );

        await txn.insert(
          SessionEjercicioDb.tabla,
          sessionExercise.toJson(),
        );

        for (final serie in dataSeries) {
          final exerciseSet = SerieEjercicioDb(
            id: idGenerator.generateId(),
            ejercicioSesionId: idSessionExercise,
            peso: serie.peso,
            repeticiones: serie.numeroRepeticon,
            tiempoDescanso: 60, //TODO: Cambiar a valor configurable
            estado: EstadoSerieEjercicio.pendiente.name,
          );
          await txn.insert(SerieEjercicioDb.tabla, exerciseSet.toJson());
        }
      });
    } catch (e) {
      throw ServerException();
    }
  }

  Future<List<RutinaDb>> getExercisesByRoutine(String routineId) async {
    final db = await databaseHelper.database;

    final results = await db.rawQuery(
      '''
        SELECT DISTINCT e.id, e.${EjercicioDb.columnaNombre}, e.${EjercicioDb.columnaDescripcion}, e.${EjercicioDb.columnaRutaImagen}
        FROM ${SessionEjercicioDb.tabla} se
        JOIN ${EjercicioDb.tabla} e ON se.${SessionEjercicioDb.columnExerciseId} = e.id
        JOIN ${RutinaSesionDb.tabla} rs ON se.${SessionEjercicioDb.columnSessionId} = rs.id
        WHERE rs.${RutinaSesionDb.columnaRutinaId} = ?
      ''',
      [routineId],
    );

    return results.map((map) => RutinaDb.fromJson(map)).toList();
  }

  Future<RutinaSesionDb?> getLastRoutineSessionByRoutineId(String id) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.query(
        RutinaSesionDb.tabla,
        where: '${RutinaSesionDb.columnaRutinaId} = ?',
        whereArgs: [id],
        orderBy: '${RutinaSesionDb.columnaFechaCreacion} DESC',
        limit: 1,
      );
      if (result.isEmpty) {
        return null;
      }
      return RutinaSesionDb.fromJson(result.first);
    } catch (e) {
      return null;
    }
  }

  Future<List<SessionEjercicioDb>> getSessionExercisesByRoutineSessionId(
    String routineSessionId,
  ) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.query(
        SessionEjercicioDb.tabla,
        where: '${SessionEjercicioDb.columnSessionId} = ?',
        whereArgs: [routineSessionId],
        orderBy: '${SessionEjercicioDb.columnOrderIndex} ASC',
      );
      return result.map((map) => SessionEjercicioDb.fromJson(map)).toList();
    } catch (e) {
      throw ServerException();
    }
  }

  Future<SerieEjercicioDb> getExerciseSetBySessionExerciseId(
    String sessionExerciseId,
  ) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.query(
        SerieEjercicioDb.tabla,
        where: '${SessionEjercicioDb.columnExerciseId} = ?',
        whereArgs: [sessionExerciseId],
      );
      return SerieEjercicioDb.fromJson(result.first);
    } catch (e) {
      throw ServerException();
    }
  }

  //obtener todos los exercises-sets de un ejercicio
  Future<List<SerieEjercicioDb>> getExerciseSetsBySessionExerciseId(
    String sessionExerciseId,
  ) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.query(
        SerieEjercicioDb.tabla,
        where: '${SerieEjercicioDb.columnaEjercicioSesionId} = ?',
        whereArgs: [sessionExerciseId],
      );
      return result.map((map) => SerieEjercicioDb.fromJson(map)).toList();
    } catch (e) {
      throw ServerException();
    }
  }

  Future<EjercicioDb> getExerciseBySessionExerciseId(
    String sessionExerciseId,
  ) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.rawQuery(
        '''
          SELECT e.*
          FROM ${EjercicioDb.tabla} e
          JOIN ${SessionEjercicioDb.tabla} se ON e.id = se.${SessionEjercicioDb.columnExerciseId}
          WHERE se.${SessionEjercicioDb.columnId}  = ?
        ''',
        [sessionExerciseId],
      );
      return EjercicioDb.fromJson(result.first);
    } catch (e) {
      throw ServerException();
    }
  }

  //creamos uns session de rutina
  Future<bool> createRoutineSession(RutinaSesionDb routineSession) async {
    try {
      final db = await databaseHelper.database;
      final id = await db.insert(
        RutinaSesionDb.tabla,
        routineSession.toJson(),
      );
      return id > 0;
    } catch (e) {
      throw ServerException();
    }
  }

  Future<RutinaSesionDb?> getRoutineSessionById(String id) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.query(
        RutinaSesionDb.tabla,
        where: '${RutinaSesionDb.columnaId} = ?',
        whereArgs: [id],
      );

      if (result.isEmpty) {
        return null; // No se encontró la rutina
      }

      return RutinaSesionDb.fromJson(result.first);
    } catch (e) {
      throw ServerException();
    }
  }

  //getEjercicioFromRutina
  Future<EjercicioDb?> getExerciseFromRoutine({
    required String idRutina,
    required String exerciseId,
    required String idRoutineSession,
  }) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.rawQuery(
        '''
        SELECT e.*
        FROM ${SessionEjercicioDb.tabla} se
        JOIN ${EjercicioDb.tabla} e ON se.${SessionEjercicioDb.columnExerciseId} = e.id
        WHERE se.${SessionEjercicioDb.columnSessionId} = ?
        AND e.${EjercicioDb.columnId}  = ?
      ''',
        [idRoutineSession, exerciseId],
      );

      if (result.isEmpty) {
        return null;
      }

      return EjercicioDb.fromJson(result.first);
    } catch (e) {
      throw ServerException();
    }
  }

  Future<bool> updateExerciseOrder({
    required String routineSessionId,
    required List<String> exerciseIds,
  }) async {
    try {
      final db = await databaseHelper.database;

      await db.transaction((txn) async {
        // Actualiza el orden de cada ejercicio
        for (int i = 0; i < exerciseIds.length; i++) {
          await txn.update(
            SessionEjercicioDb.tabla,
            {SessionEjercicioDb.columnOrderIndex: i},
            where:
                '${SessionEjercicioDb.columnSessionId} = ? AND ${SessionEjercicioDb.columnExerciseId} = ?',
            whereArgs: [routineSessionId, exerciseIds[i]],
          );
        }
      });

      return true;
    } catch (e) {
      throw ServerException();
    }
  }

  Future<bool> markExerciseAsCompleted({
    required String sessionExerciseId,
    required String routineSessionId,
  }) async {
    try {
      final db = await databaseHelper.database;

      return await db.transaction((txn) async {
        // Obtener el número total de ejercicios para esta sesión
        final countResult = await txn.query(
          SessionEjercicioDb.tabla,
          columns: ['COUNT(*) as count'],
          where: '${SessionEjercicioDb.columnSessionId} = ?',
          whereArgs: [routineSessionId],
        );

        final totalExercises = Sqflite.firstIntValue(countResult) ?? 0;

        // Actualizar el estado a completado
        await txn.update(
          SessionEjercicioDb.tabla,
          {
            SessionEjercicioDb.columnStatus:
                EstadoEjercicioSesion.completado.name,
            SessionEjercicioDb.columnOrderIndex: totalExercises +
                1000, // Un valor alto para asegurar que esté al final
          },
          where: '${SessionEjercicioDb.columnId} = ?',
          whereArgs: [sessionExerciseId],
        );

        // Reorganizar todos los índices para mantener el orden correcto
        final exercises = await txn.query(
          SessionEjercicioDb.tabla,
          where: '${SessionEjercicioDb.columnSessionId} = ?',
          whereArgs: [routineSessionId],
          orderBy:
              "CASE WHEN ${SessionEjercicioDb.columnStatus} = 'completado' THEN 1 ELSE 0 END, ${SessionEjercicioDb.columnOrderIndex} ASC",
        );

        // Reasignar los order_index en secuencia
        for (int i = 0; i < exercises.length; i++) {
          await txn.update(
            SessionEjercicioDb.tabla,
            {SessionEjercicioDb.columnOrderIndex: i},
            where: '${SessionEjercicioDb.columnId} = ?',
            whereArgs: [exercises[i]['id']],
          );
        }

        return true;
      });
    } catch (e) {
      throw ServerException();
    }
  }

  Future<SessionEjercicioDb?> getSessionExerciseByExerciseId({
    required String routineSessionId,
    required String exerciseId,
  }) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.query(
        SessionEjercicioDb.tabla,
        where:
            '${SessionEjercicioDb.columnSessionId} = ? AND ${SessionEjercicioDb.columnExerciseId} = ?',
        whereArgs: [routineSessionId, exerciseId],
      );

      if (result.isEmpty) {
        return null;
      }

      return SessionEjercicioDb.fromJson(result.first);
    } catch (e) {
      throw ServerException();
    }
  }

  Future<List<String>> getExerciseSetStatuses({
    required String sessionId,
    required String sessionExerciseId,
  }) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.rawQuery(
        '''
          SELECT es.${SerieEjercicioDb.columnaEstado} AS exercise_set_status
          FROM ${EjercicioDb.tabla} e
          JOIN ${SessionEjercicioDb.tabla} se ON e.${SessionEjercicioDb.columnId} = se.${SessionEjercicioDb.columnExerciseId}
          JOIN ${SerieEjercicioDb.tabla} es ON se.${SerieEjercicioDb.columnaId}  = es.${SerieEjercicioDb.columnaEjercicioSesionId}
          WHERE se.${SessionEjercicioDb.columnSessionId} = ?
          AND se.${SessionEjercicioDb.columnId} = ?
          ORDER BY se.${SessionEjercicioDb.columnOrderIndex};
        ''',
        [sessionId, sessionExerciseId],
      );

      return result.map((row) => row['exercise_set_status'] as String).toList();
    } catch (e) {
      throw ServerException();
    }
  }

  Future<String?> getSessionExerciseIdByExerciseSetId(
    String exerciseSetId,
  ) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.query(
        SerieEjercicioDb.tabla,
        columns: [SerieEjercicioDb.columnaEjercicioSesionId],
        where: '${SerieEjercicioDb.columnaId} = ?',
        whereArgs: [exerciseSetId],
      );

      if (result.isEmpty) {
        return null;
      }

      return result.first[SerieEjercicioDb.columnaEjercicioSesionId] as String?;
    } catch (e) {
      throw ServerException();
    }
  }

  Future<bool> markSessionExerciseAsCompletedById(id) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.update(
        SessionEjercicioDb.tabla,
        {'${SessionEjercicioDb.columnStatus}': EstadoEjercicioSesion.completado.name},
        where: 'id = ?',
        whereArgs: [id],
      );
      return result > 0;
    } catch (e) {
      throw ServerException();
    }
  }

  Future<bool> deleteExerciseFromRoutineSession({
    required String exerciseId,
    required String routineSessionId,
  }) async {
    try {
      final db = await databaseHelper.database;

      final result = await db.transaction((txn) async {
        // Verificar si el ejercicio está en la sesión
        final sessionExercise = await txn.query(
          SessionEjercicioDb.tabla,
          where:
              '${SessionEjercicioDb.columnExerciseId} = ? AND ${SessionEjercicioDb.columnSessionId} = ?',
          whereArgs: [exerciseId, routineSessionId],
        );

        if (sessionExercise.isEmpty) {
          throw ServerException();
        }

        // Verificar si el ejercicio tiene series completadas o en proceso
        final exerciseSets = await txn.query(
          SerieEjercicioDb.tabla,
          where:
              '${SerieEjercicioDb.columnaEjercicioSesionId} IN (SELECT id FROM ${SessionEjercicioDb.tabla} WHERE ${SessionEjercicioDb.columnExerciseId} = ? AND ${SessionEjercicioDb.columnSessionId} = ?)',
          whereArgs: [exerciseId, routineSessionId],
        );

        final hasCompletedOrInProgressSets = exerciseSets.any((set) {
          final status = set[SerieEjercicioDb.columnaEstado] as String;
          return status == 'completado' || status == 'en_progreso';
        });

        if (hasCompletedOrInProgressSets) {
          // Si el ejercicio tiene series completadas o en proceso, no se puede eliminar
          return false;
        }

        // Eliminar el ejercicio de la sesión
        await txn.delete(
          SessionEjercicioDb.tabla,
          where: '${SessionEjercicioDb.columnExerciseId}  = ? AND ${SessionEjercicioDb.columnSessionId}  = ?',
          whereArgs: [exerciseId, routineSessionId],
        );

        // Eliminar los sets de ejercicio asociados
        await txn.delete(
          SerieEjercicioDb.tabla,
          where: '''
              ${SerieEjercicioDb.columnaEjercicioSesionId} IN (
                SELECT id FROM ${SessionEjercicioDb.tabla} 
                WHERE ejercicio_id = ? AND ${SessionEjercicioDb.columnSessionId} = ?)
            ''',
          whereArgs: [exerciseId, routineSessionId],
        );

        return true;
      });

      return result;
    } catch (e) {
      throw ServerException();
    }
  }

  Future<bool> updateRoutineSessionStatus({
    required String sessionId,
    required String status,
    DateTime? startTime,
    DateTime? endTime,
  }) async {
    try {
      final db = await databaseHelper.database;

      final values = {RutinaSesionDb.columnaEstado: status};

      if (startTime != null) {
        values[RutinaSesionDb.columnaHoraInicio] = startTime.toIso8601String();
      }

      if (endTime != null) {
        values[RutinaSesionDb.columnaHoraFin] = endTime.toIso8601String();
      }

      final result = await db.update(
        RutinaSesionDb.tabla,
        values,
        where: '${RutinaSesionDb.columnaId} = ?',
        whereArgs: [sessionId],
      );

      return result > 0;
    } catch (e) {
      throw ServerException();
    }
  }

  /// Obtiene la sesión de rutina en progreso
  Future<RutinaSesionDb?> getInProgressRoutineSession() async {
    try {
      final db = await databaseHelper.database;
      final result = await db.query(
        RutinaSesionDb.tabla,
        where: '${RutinaSesionDb.columnaEstado} = ?',
        whereArgs: [EstadoSesionRutina.en_progreso.name],
        orderBy: '${RutinaSesionDb.columnaFechaCreacion} DESC',
        limit: 1,
      );

      if (result.isEmpty) {
        return null;
      }

      return RutinaSesionDb.fromJson(result.first);
    } catch (e) {
      throw ServerException();
    }
  }

  //obtener estado de la routinse session por su id
  Future<String?> getRoutineSessionStatusById(String id) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.query(
        RutinaSesionDb.tabla,
        columns: [RutinaSesionDb.columnaEstado],
        where: '${RutinaSesionDb.columnaId} = ?',
        whereArgs: [id],
      );

      if (result.isEmpty) {
        return null;
      }

      return result.first[SessionEjercicioDb.columnStatus] as String?;
    } catch (e) {
      throw ServerException();
    }
  }

  //verificar que todas mis session_exercise estaen completadas por su id
  Future<bool> checkAllSessionExercisesCompleted(
    String routineSessionId,
  ) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.query(
        SessionEjercicioDb.tabla,
        columns: ['COUNT(*) as count'],
        where:
            '${SessionEjercicioDb.columnSessionId} = ? AND ${SessionEjercicioDb.columnStatus} != ?',
        whereArgs: [routineSessionId, EstadoEjercicioSesion.completado.name],
      );

      final count = Sqflite.firstIntValue(result) ?? 0;

      return count == 0;
    } catch (e) {
      throw ServerException();
    }
  }

  Future<bool> insertSessionExercise(SessionEjercicioDb sessionExercise) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.insert(
        SessionEjercicioDb.tabla,
        sessionExercise.toJson(),
      );
      return result > 0;
    } catch (e) {
      throw ServerException();
    }
  }

  Future<bool> insertExerciseSet(SerieEjercicioDb exerciseSet) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.insert(
        SerieEjercicioDb.tabla,
        exerciseSet.toJson(),
      );
      return result > 0;
    } catch (e) {
      throw ServerException();
    }
  }

  Future<bool> updateExerciseStatusById({
    required String exerciseId,
    required String routineSessionId,
    required String status,
  }) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.update(
        SessionEjercicioDb.tabla,
        {SessionEjercicioDb.columnStatus: status},
        where:
            '${SessionEjercicioDb.columnExerciseId} = ? AND ${SessionEjercicioDb.columnSessionId} = ?',
        whereArgs: [exerciseId, routineSessionId],
      );
      return result > 0;
    } catch (e) {
      throw ServerException();
    }
  }

  //obtener ejercicios
}
