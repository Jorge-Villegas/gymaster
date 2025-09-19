import 'package:gymaster/core/database/database_helper.dart';
import 'package:gymaster/core/error/exceptions.dart';
import 'package:gymaster/features/exercise/data/models/exercise_model.dart';

import '../../../../core/database/models/models.dart';

class ExerciseLocalDataSource {
  final DatabaseHelper databaseHelper;

  ExerciseLocalDataSource(this.databaseHelper);

  Future<List<ExerciseModel>> getAllExercises() async {
    try {
      final db = await databaseHelper.database;
      final exercises = await db.query(EjercicioDb.tabla);

      List<ExerciseModel> exerciseModels = [];

      for (var exercise in exercises) {
        final exerciseDB = EjercicioDb.fromJson(exercise);
        final muscles = await getMusclesForExercise(exerciseDB.id);
        exerciseModels.add(
          ExerciseModel.fromDatabase(
            exerciseDB,
            muscles.map((m) => m.nombre).toList(),
          ),
        );
      }

      return exerciseModels;
    } catch (e) {
      throw ServerException();
    }
  }

  Future<List<MusculoDb>> getMusclesForExercise(String exerciseId) async {
    try {
      final db = await databaseHelper.database;
      final results = await db.rawQuery(
        '''
        SELECT m.* FROM ${MusculoDb.tabla} m
        INNER JOIN ${EjercicioMusculoDbModel.tabla} em
        ON m.${MusculoDb.columnaId}  = em.${EjercicioMusculoDbModel.columnaMusculoId} 
        WHERE em.${EjercicioMusculoDbModel.columnaEjercicioId} = ?
        ''',
        [exerciseId],
      );

      return results.map((e) => MusculoDb.fromJson(e)).toList();
    } catch (e) {
      throw ServerException();
    }
  }

  Future<List<ExerciseModel>> getExercisesByMuscle(String muscleId) async {
    try {
      final db = await databaseHelper.database;

      final exercises = await db.rawQuery(
        '''
      SELECT DISTINCT e.*
      FROM ${EjercicioDb.tabla} e
      INNER JOIN ${EjercicioMusculoDbModel.tabla} em ON e.${EjercicioDb.columnId}  = em.${EjercicioMusculoDbModel.columnaEjercicioId} 
      WHERE em.${EjercicioMusculoDbModel.columnaMusculoId}  = ?
      ''',
        [muscleId],
      );

      List<ExerciseModel> exerciseModels = [];

      // Para cada ejercicio, obtener todos sus músculos relacionados
      for (var exercise in exercises) {
        final exerciseDB = EjercicioDb.fromJson(exercise);
        final muscles = await getMusclesForExercise(exerciseDB.id);
        exerciseModels.add(
          ExerciseModel.fromDatabase(
            exerciseDB,
            muscles.map((m) => m.nombre).toList(),
          ),
        );
      }

      return exerciseModels;
    } catch (e) {
      throw ServerException();
    }
  }

  Future<ExerciseModel?> getExerciseById(String id) async {
    try {
      final db = await databaseHelper.database;
      final results = await db.query(
        EjercicioDb.tabla,
        where: '${EjercicioDb.columnId} = ?',
        whereArgs: [id],
      );

      if (results.isEmpty) return null;

      final exerciseDB = EjercicioDb.fromJson(results.first);
      final muscles = await getMusclesForExercise(exerciseDB.id);

      return ExerciseModel.fromDatabase(
        exerciseDB,
        muscles.map((m) => m.nombre).toList(), // Cambiado de id a name
      );
    } catch (e) {
      throw ServerException();
    }
  }

  Future<List<ExerciseModel>> searchExercises(String query) async {
    try {
      final db = await databaseHelper.database;
      final exercises = await db.query(
        EjercicioDb.tabla,
        where: 'name LIKE ? OR ${EjercicioDb.columnaDescripcion} LIKE ?',
        whereArgs: ['%$query%', '%$query%'],
      );

      List<ExerciseModel> exerciseModels = [];

      for (var exercise in exercises) {
        final exerciseDB = EjercicioDb.fromJson(exercise);
        final muscles = await getMusclesForExercise(exerciseDB.id);
        exerciseModels.add(
          ExerciseModel.fromDatabase(
            exerciseDB,
            muscles.map((m) => m.nombre).toList(),
          ),
        );
      }

      return exerciseModels;
    } catch (e) {
      throw ServerException();
    }
  }
}
