import 'package:gymaster/core/database/database_helper.dart';
import 'package:gymaster/core/database/models/ejercicio.dart';

class EjercicioDataSource {
  final DatabaseHelper _databaseHelper;

  EjercicioDataSource(this._databaseHelper);

  Future<Ejercicio> getEjercicioById(String id) async {
    final db = await _databaseHelper.database;
    final res = await db
        .query(DatabaseHelper.tbEjercicio, where: 'id = ?', whereArgs: [id]);
    return Ejercicio.fromJson(res.first);
  }

  Future<Ejercicio> createEjercicio(Ejercicio ejercicio) async {
    final db = await _databaseHelper.database;
    final id = await db.insert(DatabaseHelper.tbEjercicio, ejercicio.toJson());
    return id > 0 ? ejercicio : throw Exception('Error al crear el ejercicio');
  }

  Future<Ejercicio> updateEjercicio(Ejercicio ejercicio) async {
    final db = await _databaseHelper.database;
    final res = await db.update(DatabaseHelper.tbEjercicio, ejercicio.toJson(),
        where: 'id = ?', whereArgs: [ejercicio.id]);
    return res > 0
        ? ejercicio
        : throw Exception('Error al actualizar el ejercicio');
  }
  
  Future<bool> deleteEjercicio(String id) async {
    final db = await _databaseHelper.database;
    final res = await db
        .delete(DatabaseHelper.tbEjercicio, where: 'id = ?', whereArgs: [id]);
    return res > 0 ? true : throw Exception('Error al eliminar el ejercicio');
  }

  Future<List<Ejercicio>> getAllEjercicios() async {
    final db = await _databaseHelper.database;
    final res = await db.query(DatabaseHelper.tbEjercicio);
    return res.isNotEmpty
        ? res.map((c) => Ejercicio.fromJson(c)).toList()
        : [];
  }

  Future<List<Ejercicio>> getEjerciciosByNombre(String nombre) async {
    final db = await _databaseHelper.database;
    final res = await db.query(DatabaseHelper.tbEjercicio,
        where: 'nombre = ?', whereArgs: [nombre]);
    return res.isNotEmpty
        ? res.map((c) => Ejercicio.fromJson(c)).toList()
        : [];
  }

  Future<List<Ejercicio>> getEjerciciosByDescripcion(String descripcion) async {
    final db = await _databaseHelper.database;
    final res = await db.query(DatabaseHelper.tbEjercicio,
        where: 'descripcion = ?', whereArgs: [descripcion]);
    return res.isNotEmpty
        ? res.map((c) => Ejercicio.fromJson(c)).toList()
        : [];
  }

  Future<List<Ejercicio>> getEjerciciosByMusculoId(String musculoId) async {
    final db = await _databaseHelper.database;
    final res = await db.query(DatabaseHelper.tbEjercicio,
        where: 'musculo_id = ?', whereArgs: [musculoId]);
    return res.isNotEmpty
        ? res.map((c) => Ejercicio.fromJson(c)).toList()
        : [];
  }
  

}
