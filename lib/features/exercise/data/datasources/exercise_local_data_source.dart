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
      final exercises = await db.query(ExerciseDbModel.table);

      List<ExerciseModel> exerciseModels = [];

      for (var exercise in exercises) {
        final exerciseDB = ExerciseDbModel.fromJson(exercise);
        final muscles = await getMusclesForExercise(exerciseDB.id);
        exerciseModels.add(
          ExerciseModel.fromDatabase(
            exerciseDB,
            muscles.map((m) => m.name).toList(),
          ),
        );
      }

      return exerciseModels;
    } catch (e) {
      throw ServerException();
    }
  }

  Future<List<MuscleDbModel>> getMusclesForExercise(String exerciseId) async {
    try {
      final db = await databaseHelper.database;
      final results = await db.rawQuery(
        '''
        SELECT m.* FROM ${MuscleDbModel.table} m
        INNER JOIN ${ExerciseDbModel.table} em 
        ON m.id = em.muscle_id
        WHERE em.exercise_id = ?
        ''',
        [exerciseId],
      );

      return results.map((e) => MuscleDbModel.fromJson(e)).toList();
    } catch (e) {
      throw ServerException();
    }
  }

  Future<List<ExerciseModel>> getExercisesByMuscle(String muscleId) async {
    try {
      final db = await databaseHelper.database;
      // Obtener ejercicios que tienen el músculo solicitado y todos sus músculos relacionados
      final exercises = await db.rawQuery(
        '''
        SELECT DISTINCT e.* 
        FROM ${ExerciseDbModel.table} e
        INNER JOIN ${ExerciseDbModel.table} em ON e.id = em.exercise_id
        WHERE em.muscle_id = ?
        ''',
        [muscleId],
      );

      List<ExerciseModel> exerciseModels = [];

      // Para cada ejercicio, obtener todos sus músculos relacionados
      for (var exercise in exercises) {
        final exerciseDB = ExerciseDbModel.fromJson(exercise);
        // Obtener todos los músculos relacionados con este ejercicio
        final muscles = await getMusclesForExercise(exerciseDB.id);
        exerciseModels.add(
          ExerciseModel.fromDatabase(
            exerciseDB,
            muscles.map((m) => m.name).toList(),
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
        ExerciseDbModel.table,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (results.isEmpty) return null;

      final exerciseDB = ExerciseDbModel.fromJson(results.first);
      final muscles = await getMusclesForExercise(exerciseDB.id);

      return ExerciseModel.fromDatabase(
        exerciseDB,
        muscles.map((m) => m.name).toList(), // Cambiado de id a name
      );
    } catch (e) {
      throw ServerException();
    }
  }

  Future<List<ExerciseModel>> searchExercises(String query) async {
    try {
      final db = await databaseHelper.database;
      final exercises = await db.query(
        ExerciseDbModel.table,
        where: 'name LIKE ? OR description LIKE ?',
        whereArgs: ['%$query%', '%$query%'],
      );

      List<ExerciseModel> exerciseModels = [];

      for (var exercise in exercises) {
        final exerciseDB = ExerciseDbModel.fromJson(exercise);
        final muscles = await getMusclesForExercise(exerciseDB.id);
        exerciseModels.add(
          ExerciseModel.fromDatabase(
            exerciseDB,
            muscles.map((m) => m.name).toList(),
          ),
        );
      }

      return exerciseModels;
    } catch (e) {
      throw ServerException();
    }
  }
}
