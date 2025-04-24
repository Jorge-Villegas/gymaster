import 'package:gymaster/core/database/database_helper.dart';
import 'package:gymaster/core/database/models/models.dart';
import 'package:gymaster/core/error/exceptions.dart';
import 'package:gymaster/features/record/data/models/record_rutina_models.dart';
import 'package:gymaster/shared/utils/enum.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class RecordLocalDataSource {
  final DatabaseHelper databaseHelper;

  RecordLocalDataSource(this.databaseHelper);

  Future<List<RoutineSessionDbModel>> getCompletedRoutines() async {
    try {
      final db = await databaseHelper.database;
      final result = await db.query(
        RoutineSessionDbModel.table,
        where: 'status = ?',
        whereArgs: [RoutineSessionStatus.completed.name],
        orderBy: 'created_at DESC',
      );

      if (result.isEmpty) {
        throw NoRecordsException();
      }

      return result
          .map((session) => RoutineSessionDbModel.fromJson(session))
          .toList();
    } catch (e) {
      throw CacheException();
    }
  }

  Future<List<ExerciseDbModel>> getCompletedExercisesByRoutineId(
    String routineId,
  ) async {
    final db = await databaseHelper.database;
    final ejercicios = await db.rawQuery(
      '''
        SELECT e.*
        FROM exercise e
        INNER JOIN session_exercise se ON e.id = se.exercise_id
        INNER JOIN routine_session rs ON se.session_id = rs.id
        WHERE rs.routine_id = ? AND rs.status = 'completed' AND se.status = 'completed';
      ''',
      [routineId],
    );

    return ejercicios
        .map((ejercicio) => ExerciseDbModel.fromJson(ejercicio))
        .toList();
  }

  Future<List<ExerciseSetDbModel>> getSeriesByExerciseId(
      String exerciseId) async {
    final db = await databaseHelper.database;
    final series = await db.rawQuery(
      '''
        SELECT es.*
        FROM exercise_set es
        INNER JOIN session_exercise se ON es.session_exercise_id = se.id
        WHERE se.exercise_id = ? AND es.status = 'completed';
      ''',
      [exerciseId],
    );

    return series.map((serie) => ExerciseSetDbModel.fromJson(serie)).toList();
  }

  Future<List<RoutineDbModel>> getAllRutinas() async {
    try {
      final db = await databaseHelper.database;
      final rutinas = await db.query(
        RoutineDbModel.table,
        orderBy: 'created_at',
      );
      return rutinas.map((rutina) => RoutineDbModel.fromJson(rutina)).toList();
    } catch (e) {
      throw CacheException();
    }
  }

  Future<RoutineDbModel> getRutinaById(String id) async {
    final db = await databaseHelper.database;
    final result = await db.query(
      RoutineDbModel.table,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return RoutineDbModel.fromJson(result.first);
    } else {
      throw Exception('Rutina not found');
    }
  }

  Future<void> saveRutina(RecordRutinaModel rutina) async {
    final db = await databaseHelper.database;
    await db.insert(
      RoutineDbModel.table,
      rutina.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteRutina(String id) async {
    final db = await databaseHelper.database;
    await db.delete(RoutineDbModel.table, where: 'id = ?', whereArgs: [id]);
  }
}
