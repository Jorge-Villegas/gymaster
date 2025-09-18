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

  Future<List<RutinaDbModel>> getAllRutinas() async {
    try {
      final db = await databaseHelper.database;
      final rutinas = await db.query(
        RutinaDbModel.tabla,
        orderBy: '${RutinaDbModel.columnaFechaCreacion} DESC',
      );
      if (rutinas.isEmpty) {
        throw NoRecordsException();
      }
      return rutinas.map((rutina) => RutinaDbModel.fromJson(rutina)).toList();
    } catch (e) {
      if (e is NoRecordsException) {
        rethrow;
      } else {
        throw ServerException();
      }
    }
  }

  Future<bool> createRutina({required RutinaDbModel rutina}) async {
    try {
      final db = await databaseHelper.database;
      final id = await db.insert(RutinaDbModel.tabla, rutina.toJson());
      return id > 0;
    } catch (e) {
      throw ServerException();
    }
  }

  Future<List<MusculoDbModel>> getAllMusculos() async {
    try {
      final db = await databaseHelper.database;
      final musculos = await db.query(MusculoDbModel.tabla);
      return List.generate(musculos.length, (i) {
        return MusculoDbModel.fromJson(musculos[i]);
      });
    } catch (e) {
      throw ServerException();
    }
  }

  Future<List<EjercicioDbModel>> getEjerciciosPorMusculo(
      String musculoId) async {
    try {
      final db = await databaseHelper.database;
      final ejercicios = await db.rawQuery(
        '''
            SELECT e.* FROM ${EjercicioDbModel.tabla} e
            JOIN ${EjercicioMusculoDbModel.tabla} em ON e.${EjercicioDbModel.columnId} = em.${EjercicioMusculoDbModel.columnaEjercicioId}
            JOIN ${MusculoDbModel.tabla} m ON em.${EjercicioMusculoDbModel.columnaMusculoId} = m.${MusculoDbModel.columnaId}
            WHERE m.${MusculoDbModel.columnaId} = ?;
          ''',
        [musculoId],
      );

      if (ejercicios.isEmpty) throw NoRecordsException();
      return ejercicios.map((map) => EjercicioDbModel.fromJson(map)).toList();
    } catch (e) {
      throw ServerException();
    }
  }

  Future<RutinaDbModel> getRutinaById(String id) async {
    try {
      final db = await databaseHelper.database;
      final rutina = await db.query(
        RutinaDbModel.tabla,
        where: 'id = ?',
        whereArgs: [id],
      );
      return RutinaDbModel.fromJson(rutina.first);
    } catch (e) {
      throw ServerException();
    }
  }

  Future<RutinaDbModel> getEjercicioById(String id) async {
    try {
      final db = await databaseHelper.database;
      final ejercicio = await db.query(
        EjercicioDbModel.tabla,
        where: '${EjercicioDbModel.columnId} = ?',
        whereArgs: [id],
      );
      return RutinaDbModel.fromJson(ejercicio.first);
    } catch (e) {
      throw ServerException();
    }
  }

  Future<SerieEjercicioDbModel> getSerieById(String id) async {
    try {
      final db = await databaseHelper.database;
      final serie = await db.query(
        SerieEjercicioDbModel.tabla,
        where: 'id = ?',
        whereArgs: [id],
      );
      return SerieEjercicioDbModel.fromJson(serie.first);
    } catch (e) {
      throw ServerException();
    }
  }

  Future<SerieEjercicioDbModel> createSerie(
      {required SerieEjercicioDbModel serie}) async {
    try {
      final db = await databaseHelper.database;
      final id = await db.insert(SerieEjercicioDbModel.tabla, serie.toJson());
      return id > 0 ? serie : throw ServerException();
    } catch (e) {
      throw ServerException();
    }
  }

  Future<List<EjercicioDbModel>> getEjerciciosByRutinaId(
      String rutinaId) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.rawQuery(
        '''
          SELECT DISTINCT e.*
          FROM ${SessionEjercicioDbModel.tabla} es
          JOIN ${EjercicioDbModel.tabla} e ON es.${SessionEjercicioDbModel.columnExerciseId} = e.${EjercicioDbModel.columnId}
          JOIN ${RutinaSesionDbModel.tabla} rs ON es.${SessionEjercicioDbModel.columnSessionId} = rs.${RutinaSesionDbModel.columnaId}
          WHERE rs.${RutinaSesionDbModel.columnaRutinaId} = ?;
        ''',
        [rutinaId],
      );
      if (result.isEmpty) return [];
      return result.map((map) => EjercicioDbModel.fromJson(map)).toList();
    } catch (e) {
      throw ServerException();
    }
  }

  Future<List<SerieEjercicioDbModel>> getSeriesByEjercicioIdAndRutinaId(
    String ejercicioId,
    String rutinaId,
  ) async {
    try {
      final db = await databaseHelper.database;
      final series = await db.rawQuery(
        '''
          SELECT s.* FROM ${SerieEjercicioDbModel.tabla} s
          JOIN detalle_rutina dr on dr.id = s.detalle_rutina_id
          JOIN ${SerieEjercicioDbModel.tabla} e on e.id = dr.ejercicio_id
          JOIN ${RutinaDbModel.tabla} r on r.id = dr.rutina_id
          WHERE r.id = ?
          AND e.id = ?;
        ''',
        [rutinaId, ejercicioId],
      );
      return List.generate(series.length, (i) {
        return SerieEjercicioDbModel.fromJson(series[i]);
      });
    } catch (e) {
      throw ServerException();
    }
  }

  Future<List<MusculoDbModel>> getMusculosByEjercicioId(
      String exerciseId) async {
    try {
      final db = await databaseHelper.database;
      final maps = await db.rawQuery(
        '''
          SELECT m.id, m.${MusculoDbModel.columnaNombre}, m.${MusculoDbModel.columnaRutaImagen}, m.${MusculoDbModel.columnaFechaCreacion}
          FROM ${MusculoDbModel.tabla} m
          JOIN ${EjercicioMusculoDbModel.tabla} em ON m.id = em.${EjercicioMusculoDbModel.columnaMusculoId} 
          WHERE em.${EjercicioMusculoDbModel.columnaEjercicioId} = ?
        ''',
        [exerciseId],
      );
      return maps.map((map) => MusculoDbModel.fromJson(map)).toList();
    } catch (e) {
      throw ServerException();
    }
  }

  Future<bool> updateSerie(SerieEjercicioDbModel serie) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.update(
        SerieEjercicioDbModel.tabla,
        serie.toJson(),
        where: 'id = ?',
        whereArgs: [serie.id],
      );
      return result > 0;
    } catch (e) {
      throw ServerException();
    }
  }

  Future<List<RutinaDbModel>> getRutinasByNombre(String nombre) async {
    try {
      final db = await databaseHelper.database;
      final rutinas = await db.rawQuery(
        '''
          SELECT * FROM ${RutinaDbModel.tabla}
          WHERE name LIKE ?;
        ''',
        ['%$nombre%'],
      );
      return rutinas.map((rutina) => RutinaDbModel.fromJson(rutina)).toList();
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
          SessionEjercicioDbModel.tabla,
          columns: [
            'MAX(${SessionEjercicioDbModel.columnOrderIndex}) as max_order'
          ],
          where: '${SessionEjercicioDbModel.columnSessionId} = ?',
          whereArgs: [idRoutineSession],
        );

        int nextOrder = 0;

        // Si hay ejercicios en la sesión, el siguiente ejercicio tendrá el siguiente orden
        if (orderResults.isNotEmpty &&
            orderResults.first['max_order'] != null) {
          nextOrder = (orderResults.first['max_order'] as int) + 1;
        }

        final idSessionExercise = idGenerator.generateId();
        final sessionExercise = SessionEjercicioDbModel(
          id: idSessionExercise,
          sessionId: idRoutineSession,
          exerciseId: idEjercicio,
          status: EstadoEjercicioSesion.pendiente.name,
          orderIndex: nextOrder,
        );

        await txn.insert(
          SessionEjercicioDbModel.tabla,
          sessionExercise.toJson(),
        );

        for (final serie in dataSeries) {
          final exerciseSet = SerieEjercicioDbModel(
            id: idGenerator.generateId(),
            ejercicioSesionId: idSessionExercise,
            peso: serie.peso,
            repeticiones: serie.numeroRepeticon,
            tiempoDescanso: 60, //TODO: Cambiar a valor configurable
            estado: EstadoSerieEjercicio.pendiente.name,
          );
          await txn.insert(SerieEjercicioDbModel.tabla, exerciseSet.toJson());
        }
      });
    } catch (e) {
      throw ServerException();
    }
  }

  Future<List<RutinaDbModel>> getExercisesByRoutine(String routineId) async {
    final db = await databaseHelper.database;

    final results = await db.rawQuery(
      '''
        SELECT DISTINCT e.id, e.${EjercicioDbModel.columnaNombre}, e.${EjercicioDbModel.columnaDescripcion}, e.${EjercicioDbModel.columnaRutaImagen}
        FROM ${SessionEjercicioDbModel.tabla} se
        JOIN ${EjercicioDbModel.tabla} e ON se.${SessionEjercicioDbModel.columnExerciseId} = e.id
        JOIN ${RutinaSesionDbModel.tabla} rs ON se.${SessionEjercicioDbModel.columnSessionId} = rs.id
        WHERE rs.${RutinaSesionDbModel.columnaRutinaId} = ?
      ''',
      [routineId],
    );

    return results.map((map) => RutinaDbModel.fromJson(map)).toList();
  }

  Future<RutinaSesionDbModel?> getLastRoutineSessionByRoutineId(
      String id) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.query(
        RutinaSesionDbModel.tabla,
        where: '${RutinaSesionDbModel.columnaRutinaId} = ?',
        whereArgs: [id],
        orderBy: '${RutinaSesionDbModel.columnaFechaCreacion} DESC',
        limit: 1,
      );
      if (result.isEmpty) {
        return null;
      }
      return RutinaSesionDbModel.fromJson(result.first);
    } catch (e) {
      return null;
    }
  }

  Future<List<SessionEjercicioDbModel>> getSessionExercisesByRoutineSessionId(
    String routineSessionId,
  ) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.query(
        SessionEjercicioDbModel.tabla,
        where: '${SessionEjercicioDbModel.columnSessionId} = ?',
        whereArgs: [routineSessionId],
        orderBy: '${SessionEjercicioDbModel.columnOrderIndex} ASC',
      );
      return result
          .map((map) => SessionEjercicioDbModel.fromJson(map))
          .toList();
    } catch (e) {
      throw ServerException();
    }
  }

  Future<SerieEjercicioDbModel> getExerciseSetBySessionExerciseId(
    String sessionExerciseId,
  ) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.query(
        SerieEjercicioDbModel.tabla,
        where: '${SessionEjercicioDbModel.columnExerciseId} = ?',
        whereArgs: [sessionExerciseId],
      );
      return SerieEjercicioDbModel.fromJson(result.first);
    } catch (e) {
      throw ServerException();
    }
  }

  //obtener todos los exercises-sets de un ejercicio
  Future<List<SerieEjercicioDbModel>> getExerciseSetsBySessionExerciseId(
    String sessionExerciseId,
  ) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.query(
        SerieEjercicioDbModel.tabla,
        where: '${SessionEjercicioDbModel.columnExerciseId} = ?',
        whereArgs: [sessionExerciseId],
      );
      return result.map((map) => SerieEjercicioDbModel.fromJson(map)).toList();
    } catch (e) {
      throw ServerException();
    }
  }

  Future<EjercicioDbModel> getExerciseBySessionExerciseId(
    String sessionExerciseId,
  ) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.rawQuery(
        '''
          SELECT e.*
          FROM ${EjercicioDbModel.tabla} e
          JOIN ${SessionEjercicioDbModel.tabla} se ON e.id = se.${SessionEjercicioDbModel.columnExerciseId}
          WHERE se.id = ?
        ''',
        [sessionExerciseId],
      );
      return EjercicioDbModel.fromJson(result.first);
    } catch (e) {
      throw ServerException();
    }
  }

  //creamos uns session de rutina
  Future<bool> createRoutineSession(RutinaSesionDbModel routineSession) async {
    try {
      final db = await databaseHelper.database;
      final id = await db.insert(
        RutinaSesionDbModel.tabla,
        routineSession.toJson(),
      );
      return id > 0;
    } catch (e) {
      throw ServerException();
    }
  }

  Future<RutinaSesionDbModel?> getRoutineSessionById(String id) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.query(
        RutinaSesionDbModel.tabla,
        where: '${RutinaSesionDbModel.columnaId} = ?',
        whereArgs: [id],
      );

      if (result.isEmpty) {
        return null; // No se encontró la rutina
      }

      return RutinaSesionDbModel.fromJson(result.first);
    } catch (e) {
      throw ServerException();
    }
  }

  //getEjercicioFromRutina
  Future<EjercicioDbModel?> getExerciseFromRoutine({
    required String idRutina,
    required String exerciseId,
    required String idRoutineSession,
  }) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.rawQuery(
        '''
        SELECT e.*
        FROM ${SessionEjercicioDbModel.tabla} se
        JOIN ${EjercicioDbModel.tabla} e ON se.${SessionEjercicioDbModel.columnExerciseId} = e.id
        WHERE se.${SessionEjercicioDbModel.columnSessionId} = ?
        AND e.id = ?
      ''',
        [idRoutineSession, exerciseId],
      );

      if (result.isEmpty) {
        return null;
      }

      return EjercicioDbModel.fromJson(result.first);
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
            SessionEjercicioDbModel.tabla,
            {SessionEjercicioDbModel.columnOrderIndex: i},
            where:
                '${SessionEjercicioDbModel.columnSessionId} = ? AND ${SessionEjercicioDbModel.columnExerciseId} = ?',
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
          SessionEjercicioDbModel.tabla,
          columns: ['COUNT(*) as count'],
          where: '${SessionEjercicioDbModel.columnSessionId} = ?',
          whereArgs: [routineSessionId],
        );

        final totalExercises = Sqflite.firstIntValue(countResult) ?? 0;

        // Actualizar el estado a completado
        await txn.update(
          SessionEjercicioDbModel.tabla,
          {
            SessionEjercicioDbModel.columnStatus:
                EstadoEjercicioSesion.completado.name,
            SessionEjercicioDbModel.columnOrderIndex: totalExercises +
                1000, // Un valor alto para asegurar que esté al final
          },
          where: 'id = ?',
          whereArgs: [sessionExerciseId],
        );

        // Reorganizar todos los índices para mantener el orden correcto
        final exercises = await txn.query(
          SessionEjercicioDbModel.tabla,
          where: '${SessionEjercicioDbModel.columnSessionId} = ?',
          whereArgs: [routineSessionId],
          orderBy:
              "CASE WHEN ${SessionEjercicioDbModel.columnStatus} = 'completado' THEN 1 ELSE 0 END, ${SessionEjercicioDbModel.columnOrderIndex} ASC",
        );

        // Reasignar los order_index en secuencia
        for (int i = 0; i < exercises.length; i++) {
          await txn.update(
            SessionEjercicioDbModel.tabla,
            {SessionEjercicioDbModel.columnOrderIndex: i},
            where: 'id = ?',
            whereArgs: [exercises[i]['id']],
          );
        }

        return true;
      });
    } catch (e) {
      throw ServerException();
    }
  }

  Future<SessionEjercicioDbModel?> getSessionExerciseByExerciseId({
    required String routineSessionId,
    required String exerciseId,
  }) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.query(
        SessionEjercicioDbModel.tabla,
        where:
            '${SessionEjercicioDbModel.columnSessionId} = ? AND ${SessionEjercicioDbModel.columnExerciseId} = ?',
        whereArgs: [routineSessionId, exerciseId],
      );

      if (result.isEmpty) {
        return null;
      }

      return SessionEjercicioDbModel.fromJson(result.first);
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
          SELECT es.${SerieEjercicioDbModel.columnaEstado} AS exercise_set_status
          FROM ${EjercicioDbModel.tabla} e
          JOIN ${SessionEjercicioDbModel.tabla} se ON e.${SessionEjercicioDbModel.columnId} = se.${SessionEjercicioDbModel.columnExerciseId}
          JOIN ${SerieEjercicioDbModel.tabla} es ON se.${SerieEjercicioDbModel.columnaId}  = es.${SerieEjercicioDbModel.columnaEjercicioSesionId}
          WHERE se.${SessionEjercicioDbModel.columnSessionId} = ?
          AND se.id = ?
          ORDER BY se.${SessionEjercicioDbModel.columnOrderIndex};
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
        SerieEjercicioDbModel.tabla,
        columns: [SerieEjercicioDbModel.columnaEjercicioSesionId],
        where: 'id = ?',
        whereArgs: [exerciseSetId],
      );

      if (result.isEmpty) {
        return null;
      }

      return result.first['session_exercise_id'] as String?;
    } catch (e) {
      throw ServerException();
    }
  }

  Future<bool> markSessionExerciseAsCompletedById(id) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.update(
        SessionEjercicioDbModel.tabla,
        {'status': EstadoEjercicioSesion.completado.name},
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
          SessionEjercicioDbModel.tabla,
          where:
              '${SessionEjercicioDbModel.columnExerciseId} = ? AND ${SessionEjercicioDbModel.columnSessionId} = ?',
          whereArgs: [exerciseId, routineSessionId],
        );

        if (sessionExercise.isEmpty) {
          throw ServerException();
        }

        // Verificar si el ejercicio tiene series completadas o en proceso
        final exerciseSets = await txn.query(
          SerieEjercicioDbModel.tabla,
          where:
              '${SerieEjercicioDbModel.columnaEjercicioSesionId} IN (SELECT id FROM ${SessionEjercicioDbModel.tabla} WHERE ${SessionEjercicioDbModel.columnExerciseId} = ? AND ${SessionEjercicioDbModel.columnSessionId} = ?)',
          whereArgs: [exerciseId, routineSessionId],
        );

        final hasCompletedOrInProgressSets = exerciseSets.any((set) {
          final status = set[SerieEjercicioDbModel.columnaEstado] as String;
          return status == 'completado' || status == 'en_progreso';
        });

        if (hasCompletedOrInProgressSets) {
          // Si el ejercicio tiene series completadas o en proceso, no se puede eliminar
          return false;
        }

        // Eliminar el ejercicio de la sesión
        await txn.delete(
          SessionEjercicioDbModel.tabla,
          where: 'exercise_id = ? AND session_id = ?',
          whereArgs: [exerciseId, routineSessionId],
        );

        // Eliminar los sets de ejercicio asociados
        await txn.delete(
          SerieEjercicioDbModel.tabla,
          where: '''
              session_exercise_id IN (
                SELECT id FROM ${SessionEjercicioDbModel.tabla} 
                WHERE exercise_id = ? AND ${SessionEjercicioDbModel.columnSessionId} = ?)
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

      final values = {RutinaSesionDbModel.columnaEstado: status};

      if (startTime != null) {
        values[RutinaSesionDbModel.columnaHoraInicio] =
            startTime.toIso8601String();
      }

      if (endTime != null) {
        values[RutinaSesionDbModel.columnaHoraFin] = endTime.toIso8601String();
      }

      final result = await db.update(
        RutinaSesionDbModel.tabla,
        values,
        where: '${RutinaSesionDbModel.columnaId} = ?',
        whereArgs: [sessionId],
      );

      return result > 0;
    } catch (e) {
      throw ServerException();
    }
  }

  /// Obtiene la sesión de rutina en progreso
  Future<RutinaSesionDbModel?> getInProgressRoutineSession() async {
    try {
      final db = await databaseHelper.database;
      final result = await db.query(
        RutinaSesionDbModel.tabla,
        where: '${RutinaSesionDbModel.columnaEstado} = ?',
        whereArgs: [EstadoSesionRutina.en_progreso.name],
        orderBy: '${RutinaSesionDbModel.columnaFechaCreacion} DESC',
        limit: 1,
      );

      if (result.isEmpty) {
        return null;
      }

      return RutinaSesionDbModel.fromJson(result.first);
    } catch (e) {
      throw ServerException();
    }
  }

  //obtener estado de la routinse session por su id
  Future<String?> getRoutineSessionStatusById(String id) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.query(
        RutinaSesionDbModel.tabla,
        columns: [RutinaSesionDbModel.columnaEstado],
        where: '${RutinaSesionDbModel.columnaId} = ?',
        whereArgs: [id],
      );

      if (result.isEmpty) {
        return null;
      }

      return result.first[SessionEjercicioDbModel.columnStatus] as String?;
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
        SessionEjercicioDbModel.tabla,
        columns: ['COUNT(*) as count'],
        where:
            '${SessionEjercicioDbModel.columnSessionId} = ? AND ${SessionEjercicioDbModel.columnStatus} != ?',
        whereArgs: [routineSessionId, EstadoEjercicioSesion.completado.name],
      );

      final count = Sqflite.firstIntValue(result) ?? 0;

      return count == 0;
    } catch (e) {
      throw ServerException();
    }
  }

  Future<bool> insertSessionExercise(
      SessionEjercicioDbModel sessionExercise) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.insert(
        SessionEjercicioDbModel.tabla,
        sessionExercise.toJson(),
      );
      return result > 0;
    } catch (e) {
      throw ServerException();
    }
  }

  Future<bool> insertExerciseSet(SerieEjercicioDbModel exerciseSet) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.insert(
        SerieEjercicioDbModel.tabla,
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
        SessionEjercicioDbModel.tabla,
        {SessionEjercicioDbModel.columnStatus: status},
        where:
            '${SessionEjercicioDbModel.columnExerciseId} = ? AND ${SessionEjercicioDbModel.columnSessionId} = ?',
        whereArgs: [exerciseId, routineSessionId],
      );
      return result > 0;
    } catch (e) {
      throw ServerException();
    }
  }

  //obtener ejercicios
}
