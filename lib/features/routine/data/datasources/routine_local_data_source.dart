import 'package:gymaster/core/database/database_helper.dart';
import 'package:gymaster/core/database/models/models.dart';
import 'package:gymaster/core/error/exceptions.dart';
import 'package:gymaster/features/routine/domain/usecases/add_ejercicio_rutina_usecase.dart';
import 'package:gymaster/shared/utils/enum.dart';
import 'package:gymaster/shared/utils/uuid_generator.dart';

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

      final resul = await db.transaction((txn) async {
        final idSessionExercise = idGenerator.generateId();
        final sessionExercise = SessionExercise(
          id: idSessionExercise,
          sessionId: idRoutineSession,
          exerciseId: idEjercicio,
          status: SessionExerciseStatus.pending.name,
        );
        // Insertar el ejercicio en la sesión de la rutina
        await txn.insert(
          DatabaseHelper.tbSessionExercise,
          sessionExercise.toJson(),
        );

        // Insertar las series asociadas al ejercicio
        for (final serie in dataSeries) {
          final exerciseSet = ExerciseSet(
            id: idGenerator.generateId(),
            sessionExerciseId: idSessionExercise,
            weight: serie.peso,
            repetitions: serie.numeroRepeticon,
            restTime: 60, // Valor por defecto o configurable
            status: ExerciseSetStatus.pending.name,
          );
          await txn.insert(DatabaseHelper.tbExerciseSet, exerciseSet.toJson());
        }
      });
      print(resul);
    } catch (e) {
      throw ServerException();
    }
  }

  Future<List<Exercise>> getExercisesByRoutine(String routineId) async {
    final db = await databaseHelper.database;

    final List<Map<String, dynamic>> results = await db.rawQuery(
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
}
