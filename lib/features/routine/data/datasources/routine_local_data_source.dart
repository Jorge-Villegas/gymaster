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

  Future<List<Routine>> getAllRutinas() async {
    try {
      final db = await databaseHelper.database;
      final rutinas = await db.query(
        DatabaseHelper.tbRoutine,
        orderBy: 'created_at DESC',
      );
      if (rutinas.isEmpty) {
        throw NoRecordsException();
      }
      return rutinas.map((rutina) => Routine.fromJson(rutina)).toList();
    } catch (e) {
      if (e is NoRecordsException) {
        rethrow;
      } else {
        throw ServerException();
      }
    }
  }

  Future<bool> createRutina({required Routine rutina}) async {
    try {
      final db = await databaseHelper.database;
      final id = await db.insert(DatabaseHelper.tbRoutine, rutina.toJson());
      return id > 0;
    } catch (e) {
      throw ServerException();
    }
  }

  Future<List<Muscle>> getAllMusculos() async {
    try {
      final db = await databaseHelper.database;
      final musculos = await db.query(DatabaseHelper.tbMuscle);
      return List.generate(musculos.length, (i) {
        return Muscle.fromJson(musculos[i]);
      });
    } catch (e) {
      throw ServerException();
    }
  }

  Future<List<Exercise>> getEjerciciosPorMusculo(String musculoId) async {
    try {
      final db = await databaseHelper.database;
      final ejercicios = await db.rawQuery(
        '''
            SELECT e.* FROM exercise e
            JOIN exercise_muscle em ON e.id = em.exercise_id
            JOIN muscle m ON em.muscle_id = m.id
            WHERE m.id = ?;
          ''',
        [musculoId],
      );

      if (ejercicios.isEmpty) throw NoRecordsException();
      return ejercicios.map((map) => Exercise.fromJson(map)).toList();
    } catch (e) {
      throw ServerException();
    }
  }

  Future<Routine> getRutinaById(String id) async {
    try {
      final db = await databaseHelper.database;
      final rutina = await db.query(
        DatabaseHelper.tbRoutine,
        where: 'id = ?',
        whereArgs: [id],
      );
      return Routine.fromJson(rutina.first);
    } catch (e) {
      throw ServerException();
    }
  }

  Future<Exercise> getEjercicioById(String id) async {
    try {
      final db = await databaseHelper.database;
      final ejercicio = await db.query(
        DatabaseHelper.tbExercise,
        where: 'id = ?',
        whereArgs: [id],
      );
      return Exercise.fromJson(ejercicio.first);
    } catch (e) {
      throw ServerException();
    }
  }

  Future<ExerciseSet> getSerieById(String id) async {
    try {
      final db = await databaseHelper.database;
      final serie = await db.query(
        DatabaseHelper.tbExerciseSet,
        where: 'id = ?',
        whereArgs: [id],
      );
      return ExerciseSet.fromJson(serie.first);
    } catch (e) {
      throw ServerException();
    }
  }

  Future<ExerciseSet> createSerie({required ExerciseSet serie}) async {
    try {
      final db = await databaseHelper.database;
      final id = await db.insert(DatabaseHelper.tbExerciseSet, serie.toJson());
      return id > 0 ? serie : throw ServerException();
    } catch (e) {
      throw ServerException();
    }
  }

  Future<void> createDetalleEjercicio() async {
    try {
      final db = await databaseHelper.database;
      throw UnimplementedError();
    } catch (e) {
      throw ServerException();
    }
  }

  Future<List<Exercise>> getEjerciciosByRutinaId(String rutinaId) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.rawQuery(
        '''
          SELECT DISTINCT e.*
          FROM session_exercise se
          JOIN exercise e ON se.exercise_id = e.id
          LEFT JOIN exercise_set es ON se.id = es.session_exercise_id
          WHERE se.session_id = ?;
        ''',
        [rutinaId],
      );
      if (result.isEmpty) return [];
      return result.map((map) => Exercise.fromJson(map)).toList();
    } catch (e) {
      throw ServerException();
    }
  }

  Future<List<ExerciseSet>> getSeriesByEjercicioIdAndRutinaId(
    String ejercicioId,
    String rutinaId,
  ) async {
    try {
      final db = await databaseHelper.database;
      final series = await db.rawQuery(
        '''
          SELECT s.* FROM serie s
          JOIN detalle_rutina dr on dr.id = s.detalle_rutina_id
          JOIN ejercicio e on e.id = dr.ejercicio_id
          JOIN rutina r on r.id = dr.rutina_id
          WHERE r.id = ?
          AND e.id = ?;
        ''',
        [rutinaId, ejercicioId],
      );
      return List.generate(series.length, (i) {
        return ExerciseSet.fromJson(series[i]);
      });
    } catch (e) {
      throw ServerException();
    }
  }

  Future<List<Muscle>> getMusculosByEjercicioId(String exerciseId) async {
    try {
      final db = await databaseHelper.database;
      final maps = await db.rawQuery(
        '''
          SELECT m.id, m.name, m.image_path, m.created_at
          FROM muscle m
          JOIN exercise_muscle em ON m.id = em.muscle_id
          WHERE em.exercise_id = ?
        ''',
        [exerciseId],
      );
      return maps.map((map) => Muscle.fromJson(map)).toList();
    } catch (e) {
      throw ServerException();
    }
  }

  Future<bool> updateSerie(ExerciseSet serie) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.update(
        DatabaseHelper.tbExerciseSet,
        serie.toJson(),
        where: 'id = ?',
        whereArgs: [serie.id],
      );
      return result > 0;
    } catch (e) {
      throw ServerException();
    }
  }

  Future<List<Routine>> getRutinasByNombre(String nombre) async {
    try {
      final db = await databaseHelper.database;
      final rutinas = await db.rawQuery(
        '''
          SELECT * FROM ${DatabaseHelper.tbRoutine}
          WHERE nombre LIKE ?;
        ''',
        ['%$nombre%'],
      );
      return rutinas.map((rutina) => Routine.fromJson(rutina)).toList();
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
          DatabaseHelper.tbSessionExercise,
          columns: ['MAX(order_index) as max_order'],
          where: 'session_id = ?',
          whereArgs: [idRoutineSession],
        );

        int nextOrder = 0;

        // Si hay ejercicios en la sesión, el siguiente ejercicio tendrá el siguiente orden
        if (orderResults.isNotEmpty &&
            orderResults.first['max_order'] != null) {
          nextOrder = (orderResults.first['max_order'] as int) + 1;
        }

        final idSessionExercise = idGenerator.generateId();
        final sessionExercise = SessionExercise(
          id: idSessionExercise,
          sessionId: idRoutineSession,
          exerciseId: idEjercicio,
          status: SessionExerciseStatus.pending.name,
          orderIndex: nextOrder,
        );

        await txn.insert(
          DatabaseHelper.tbSessionExercise,
          sessionExercise.toJson(),
        );

        for (final serie in dataSeries) {
          final exerciseSet = ExerciseSet(
            id: idGenerator.generateId(),
            sessionExerciseId: idSessionExercise,
            weight: serie.peso,
            repetitions: serie.numeroRepeticon,
            restTime: 60, //TODO: Cambiar a valor configurable
            status: ExerciseSetStatus.pending.name,
          );
          await txn.insert(DatabaseHelper.tbExerciseSet, exerciseSet.toJson());
        }
      });
    } catch (e) {
      throw ServerException();
    }
  }

  Future<List<Exercise>> getExercisesByRoutine(String routineId) async {
    final db = await databaseHelper.database;

    final results = await db.rawQuery(
      '''
        SELECT DISTINCT e.id, e.name, e.description, e.image_path
        FROM session_exercise se
        JOIN exercise e ON se.exercise_id = e.id
        JOIN routine_session rs ON se.session_id = rs.id
        WHERE rs.routine_id = ?
      ''',
      [routineId],
    );

    return results.map((map) => Exercise.fromJson(map)).toList();
  }

  Future<RoutineSession?> getLastRoutineSessionByRoutineId(String id) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.query(
        DatabaseHelper.tbRoutineSession,
        where: 'routine_id = ?',
        whereArgs: [id],
        orderBy: 'created_at DESC',
        limit: 1,
      );
      if (result.isEmpty) {
        return null;
      }
      return RoutineSession.fromJson(result.first);
    } catch (e) {
      return null;
    }
  }

  Future<List<SessionExercise>> getSessionExercisesByRoutineSessionId(
    String routineSessionId,
  ) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.query(
        DatabaseHelper.tbSessionExercise,
        where: 'session_id = ?',
        whereArgs: [routineSessionId],
        // Primero ordena por estado (no completados primero), luego por order_index
        orderBy:
            "CASE WHEN status = 'completed' THEN 1 ELSE 0 END, order_index ASC",
      );
      return result.map((map) => SessionExercise.fromJson(map)).toList();
    } catch (e) {
      throw ServerException();
    }
  }

  Future<ExerciseSet> getExerciseSetBySessionExerciseId(
    String sessionExerciseId,
  ) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.query(
        DatabaseHelper.tbExerciseSet,
        where: 'session_exercise_id = ?',
        whereArgs: [sessionExerciseId],
      );
      return ExerciseSet.fromJson(result.first);
    } catch (e) {
      throw ServerException();
    }
  }

  //obtener todos los exercises-sets de un ejercicio
  Future<List<ExerciseSet>> getExerciseSetsBySessionExerciseId(
    String sessionExerciseId,
  ) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.query(
        DatabaseHelper.tbExerciseSet,
        where: 'session_exercise_id = ?',
        whereArgs: [sessionExerciseId],
      );
      return result.map((map) => ExerciseSet.fromJson(map)).toList();
    } catch (e) {
      throw ServerException();
    }
  }

  Future<Exercise> getExerciseBySessionExerciseId(
    String sessionExerciseId,
  ) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.rawQuery(
        '''
        SELECT e.*
        FROM exercise e
        JOIN session_exercise se ON e.id = se.exercise_id
        WHERE se.id = ?
      ''',
        [sessionExerciseId],
      );
      return Exercise.fromJson(result.first);
    } catch (e) {
      throw ServerException();
    }
  }

  //creamos uns session de rutina
  Future<bool> createRoutineSession(RoutineSession routineSession) async {
    try {
      final db = await databaseHelper.database;
      final id = await db.insert(
        DatabaseHelper.tbRoutineSession,
        routineSession.toJson(),
      );
      return id > 0;
    } catch (e) {
      throw ServerException();
    }
  }

  Future<RoutineSession?> getRoutineSessionById(String id) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.query(
        DatabaseHelper.tbRoutineSession,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (result.isEmpty) {
        return null; // No se encontró la rutina
      }

      return RoutineSession.fromJson(result.first);
    } catch (e) {
      throw ServerException();
    }
  }

  //getEjercicioFromRutina
  Future<Exercise?> getExerciseFromRoutine({
    required String idRutina,
    required String exerciseId,
    required String idRoutineSession,
  }) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.rawQuery(
        '''
        SELECT e.*
        FROM session_exercise se
        JOIN exercise e ON se.exercise_id = e.id
        WHERE se.session_id = ?
        AND e.id = ?
      ''',
        [idRoutineSession, exerciseId],
      );

      if (result.isEmpty) {
        return null;
      }

      return Exercise.fromJson(result.first);
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

      final result = await db.transaction((txn) async {
        // Actualiza el orden de cada ejercicio
        for (int i = 0; i < exerciseIds.length; i++) {
          await txn.update(
            DatabaseHelper.tbSessionExercise,
            {'order_index': i},
            where: 'session_id = ? AND exercise_id = ?',
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
          DatabaseHelper.tbSessionExercise,
          columns: ['COUNT(*) as count'],
          where: 'session_id = ?',
          whereArgs: [routineSessionId],
        );

        final totalExercises = Sqflite.firstIntValue(countResult) ?? 0;

        // Actualizar el estado a completado
        await txn.update(
          DatabaseHelper.tbSessionExercise,
          {
            'status': SessionExerciseStatus.completed.name,
            'order_index':
                totalExercises +
                1000, // Un valor alto para asegurar que esté al final
          },
          where: 'id = ?',
          whereArgs: [sessionExerciseId],
        );

        // Reorganizar todos los índices para mantener el orden correcto
        final exercises = await txn.query(
          DatabaseHelper.tbSessionExercise,
          where: 'session_id = ?',
          whereArgs: [routineSessionId],
          orderBy:
              "CASE WHEN status = 'completed' THEN 1 ELSE 0 END, order_index ASC",
        );

        // Reasignar los order_index en secuencia
        for (int i = 0; i < exercises.length; i++) {
          await txn.update(
            DatabaseHelper.tbSessionExercise,
            {'order_index': i},
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

  Future<SessionExercise?> getSessionExerciseByExerciseId({
    required String routineSessionId,
    required String exerciseId,
  }) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.query(
        DatabaseHelper.tbSessionExercise,
        where: 'session_id = ? AND exercise_id = ?',
        whereArgs: [routineSessionId, exerciseId],
      );

      if (result.isEmpty) {
        return null;
      }

      return SessionExercise.fromJson(result.first);
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
          SELECT es.status AS exercise_set_status
          FROM exercise e
          JOIN session_exercise se ON e.id = se.exercise_id
          JOIN exercise_set es ON se.id = es.session_exercise_id
          WHERE se.session_id = ?
          AND se.id = ?
          ORDER BY se.order_index;
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
        DatabaseHelper.tbExerciseSet,
        columns: ['session_exercise_id'],
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
        DatabaseHelper.tbSessionExercise,
        {'status': SessionExerciseStatus.completed.name},
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
          DatabaseHelper.tbSessionExercise,
          where: 'exercise_id = ? AND session_id = ?',
          whereArgs: [exerciseId, routineSessionId],
        );

        if (sessionExercise.isEmpty) {
          throw ServerException();
        }

        // Verificar si el ejercicio tiene series completadas o en proceso
        final exerciseSets = await txn.query(
          DatabaseHelper.tbExerciseSet,
          where:
              'session_exercise_id IN (SELECT id FROM ${DatabaseHelper.tbSessionExercise} WHERE exercise_id = ? AND session_id = ?)',
          whereArgs: [exerciseId, routineSessionId],
        );

        final hasCompletedOrInProgressSets = exerciseSets.any((set) {
          final status = set['status'] as String;
          return status == 'completed' || status == 'in_progress';
        });

        if (hasCompletedOrInProgressSets) {
          // Si el ejercicio tiene series completadas o en proceso, no se puede eliminar
          return false;
        }

        // Eliminar el ejercicio de la sesión
        await txn.delete(
          DatabaseHelper.tbSessionExercise,
          where: 'exercise_id = ? AND session_id = ?',
          whereArgs: [exerciseId, routineSessionId],
        );

        // Eliminar los sets de ejercicio asociados
        await txn.delete(
          DatabaseHelper.tbExerciseSet,
          where: '''
              session_exercise_id IN (
                SELECT id FROM ${DatabaseHelper.tbSessionExercise} 
                WHERE exercise_id = ? AND session_id = ?)
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

      final values = {'status': status};

      if (startTime != null) {
        values['start_time'] = startTime.toIso8601String();
      }

      if (endTime != null) {
        values['end_time'] = endTime.toIso8601String();
      }

      final result = await db.update(
        DatabaseHelper.tbRoutineSession,
        values,
        where: 'id = ?',
        whereArgs: [sessionId],
      );

      return result > 0;
    } catch (e) {
      throw ServerException();
    }
  }

  /// Obtiene la sesión de rutina en progreso
  Future<RoutineSession?> getInProgressRoutineSession() async {
    try {
      final db = await databaseHelper.database;
      final result = await db.query(
        DatabaseHelper.tbRoutineSession,
        where: 'status = ?',
        whereArgs: [RoutineSessionStatus.in_progress.name],
        orderBy: 'created_at DESC',
        limit: 1,
      );

      if (result.isEmpty) {
        return null;
      }

      return RoutineSession.fromJson(result.first);
    } catch (e) {
      throw ServerException();
    }
  }

  //obtener estado de la routinse session por su id
  Future<String?> getRoutineSessionStatusById(String id) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.query(
        DatabaseHelper.tbRoutineSession,
        columns: ['status'],
        where: 'id = ?',
        whereArgs: [id],
      );

      if (result.isEmpty) {
        return null;
      }

      return result.first['status'] as String?;
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
        DatabaseHelper.tbSessionExercise,
        columns: ['COUNT(*) as count'],
        where: 'session_id = ? AND status != ?',
        whereArgs: [routineSessionId, SessionExerciseStatus.completed.name],
      );

      final count = Sqflite.firstIntValue(result) ?? 0;

      return count == 0;
    } catch (e) {
      throw ServerException();
    }
  }

  Future<bool> insertSessionExercise(SessionExercise sessionExercise) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.insert(
        DatabaseHelper.tbSessionExercise,
        sessionExercise.toJson(),
      );
      return result > 0;
    } catch (e) {
      throw ServerException();
    }
  }

  Future<bool> insertExerciseSet(ExerciseSet exerciseSet) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.insert(
        DatabaseHelper.tbExerciseSet,
        exerciseSet.toJson(),
      );
      return result > 0;
    } catch (e) {
      throw ServerException();
    }
  }
}
