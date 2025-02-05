import 'package:gymaster/core/database/database_helper.dart';
import 'package:gymaster/core/database/models/ejercicio.dart';
import 'package:gymaster/core/database/models/rutina.dart';
import 'package:gymaster/core/database/models/serie.dart';
import 'package:gymaster/features/record/data/models/record_rutina_models.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class RecordLocalDataSource {
  final DatabaseHelper databaseHelper;

  RecordLocalDataSource({required this.databaseHelper});

  Future<List<Rutina>> getCompletedRoutines() async {
    final db = await databaseHelper.database;
    final rutinas = await db.query(
      DatabaseHelper.tbRutina,
      where: 'realizado = ?',
      whereArgs: [1],
    );
    return rutinas.map((rutina) => Rutina.fromJson(rutina)).toList();
  }

  Future<List<Ejercicio>> getCompletedExercisesByRoutineId(
      String routineId) async {
    final db = await databaseHelper.database;
    final ejercicios = await db.rawQuery('''
      SELECT e.*
      FROM ejercicio e
      INNER JOIN detalle_rutina dr ON e.id = dr.ejercicio_id
      INNER JOIN serie s ON dr.id = s.detalle_rutina_id
      INNER JOIN rutina r ON dr.rutina_id = r.id
      WHERE r.id = ? AND r.realizado = 1 AND s.realizado = 1;
    ''', [routineId]);

    return ejercicios
        .map((ejercicio) => Ejercicio.fromJson(ejercicio))
        .toList();
  }

  Future<List<Serie>> getSeriesByExerciseId(String exerciseId) async {
    final db = await databaseHelper.database;
    final series = await db.rawQuery('''
      SELECT s.*
      FROM serie s
      INNER JOIN detalle_rutina dr ON s.detalle_rutina_id = dr.id
      WHERE dr.ejercicio_id = ? AND s.realizado = 1;
    ''', [exerciseId]);

    return series.map((serie) => Serie.fromJson(serie)).toList();
  }

  Future<List<RecordRutinaModel>> getAllRutinas() async {
    final db = await databaseHelper.database;
    final result = await db.query(DatabaseHelper.tbRutina);
    return result.map((e) => RecordRutinaModel.fromMap(e)).toList();
  }

  Future<RecordRutinaModel> getRutinaById(String id) async {
    final db = await databaseHelper.database;
    final result = await db
        .query(DatabaseHelper.tbRutina, where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return RecordRutinaModel.fromMap(result.first);
    } else {
      throw Exception('Rutina not found');
    }
  }

  Future<void> saveRutina(RecordRutinaModel rutina) async {
    final db = await databaseHelper.database;
    await db.insert(DatabaseHelper.tbRutina, rutina.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteRutina(String id) async {
    final db = await databaseHelper.database;
    await db.delete(DatabaseHelper.tbRutina, where: 'id = ?', whereArgs: [id]);
  }
}
