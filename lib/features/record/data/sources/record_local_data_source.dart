import 'package:gymaster/core/database/database_helper.dart';
import 'package:gymaster/core/database/models/models.dart';
import 'package:gymaster/core/error/exceptions.dart';
import 'package:gymaster/features/record/data/models/record_rutina_models.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class RecordLocalDataSource {
  final DatabaseHelper databaseHelper;

  RecordLocalDataSource(this.databaseHelper);

  Future<List<Routine>> getCompletedRoutines() async {
    final db = await databaseHelper.database;
    final rutinas = await db.query(
      DatabaseHelper.tbRoutine,
      where: 'realizado = ?',
      whereArgs: [1],
    );
    // return rutinas.map((rutina) => Database.fromJson(rutina)).toList();
    throw CacheException();
  }

  Future<List<Exercise>> getCompletedExercisesByRoutineId(
    String routineId,
  ) async {
    final db = await databaseHelper.database;
    final ejercicios = await db.rawQuery(
      '''
        SELECT e.*
        FROM ejercicio e
        INNER JOIN detalle_rutina dr ON e.id = dr.ejercicio_id
        INNER JOIN serie s ON dr.id = s.detalle_rutina_id
        INNER JOIN rutina r ON dr.rutina_id = r.id
        WHERE r.id = ? AND r.realizado = 1 AND s.realizado = 1;
      ''',
      [routineId],
    );

    return ejercicios.map((ejercicio) => Exercise.fromJson(ejercicio)).toList();
  }

  Future<List<ExerciseSet>> getSeriesByExerciseId(String exerciseId) async {
    final db = await databaseHelper.database;
    final series = await db.rawQuery(
      '''
        SELECT s.*
        FROM serie s
        INNER JOIN detalle_rutina dr ON s.detalle_rutina_id = dr.id
        WHERE dr.ejercicio_id = ? AND s.realizado = 1;
      ''',
      [exerciseId],
    );

    return series.map((serie) => ExerciseSet.fromJson(serie)).toList();
  }

  Future<List<Routine>> getAllRutinas() async {
    try {
      final db = await databaseHelper.database;
      final rutinas = await db.query(
        DatabaseHelper.tbRoutine,
        orderBy: 'fecha_creacion',
      );
      return rutinas.map((rutina) => Routine.fromJson(rutina)).toList();
    } catch (e) {
      throw CacheException();
    }
  }

  Future<RecordRutinaModel> getRutinaById(String id) async {
    final db = await databaseHelper.database;
    final result = await db.query(
      DatabaseHelper.tbRoutine,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return RecordRutinaModel.fromMap(result.first);
    } else {
      throw Exception('Rutina not found');
    }
  }

  Future<void> saveRutina(RecordRutinaModel rutina) async {
    final db = await databaseHelper.database;
    await db.insert(
      DatabaseHelper.tbRoutine,
      rutina.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteRutina(String id) async {
    final db = await databaseHelper.database;
    await db.delete(DatabaseHelper.tbRoutine, where: 'id = ?', whereArgs: [id]);
  }
}
