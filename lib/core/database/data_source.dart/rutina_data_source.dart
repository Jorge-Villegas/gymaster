import 'package:gymaster/core/database/database_helper.dart';
import 'package:gymaster/core/database/interface_datasource.dart/interface_rutina_data_source.dart';
import 'package:gymaster/core/database/models/rutina.dart';

class RutinaDataSource implements IRutinaDataSource {
  final DatabaseHelper _databaseHelper;

  RutinaDataSource(this._databaseHelper);

  @override
  Future<List<Rutina>> getRutinas() async {
    final db = await _databaseHelper.database;
    final res = await db.query('Rutina');
    return res.isNotEmpty ? res.map((c) => Rutina.fromJson(c)).toList() : [];
  }

  @override
  Future<Rutina> getRutinaById(String id) async {
    final db = await _databaseHelper.database;
    final res = await db.query(DatabaseHelper.tbRutina, where: 'id = ?', whereArgs: [id]);
    return Rutina.fromJson(res.first);
  }

  @override
  Future<Rutina> createRutina(Rutina rutina) async {
    final db = await _databaseHelper.database;
    final id = await db.insert(DatabaseHelper.tbRutina, rutina.toJson());
    return id > 0 ? rutina : throw Exception('Error al crear la rutina');
  }

  @override
  Future<Rutina> updateRutina(Rutina rutina) async {
    final db = await _databaseHelper.database;
    final res = await db.update(DatabaseHelper.tbRutina, rutina.toJson(), where: 'id = ?', whereArgs: [rutina.id]);
    return res > 0 ? rutina : throw Exception('Error al actualizar la rutina');
  }

  @override
  Future<bool> deleteRutina(String id) async {
    final db = await _databaseHelper.database;
    final res = await db.delete(DatabaseHelper.tbRutina, where: 'id = ?', whereArgs: [id]);
    return res > 0 ? true : throw Exception('Error al eliminar la rutina');
  }

  @override
  Future<List<Rutina>> getRutinasByEstado(int estado) async {
    final db = await _databaseHelper.database;
    final res = await db.query(DatabaseHelper.tbRutina, where: 'estado = ?', whereArgs: [estado]);
    return res.isNotEmpty ? res.map((c) => Rutina.fromJson(c)).toList() : [];
  }

  @override
  Future<List<Rutina>> getRutinasByFechaRealizacion(String fechaRealizacion) async {
    final db = await _databaseHelper.database;
    final res = await db.query(DatabaseHelper.tbRutina, where: 'fecha_realizacion = ?', whereArgs: [fechaRealizacion]);
    return res.isNotEmpty ? res.map((c) => Rutina.fromJson(c)).toList() : [];
  }

  @override
  Future<List<Rutina>> getRutinasByFechaCreacion(String fechaCreacion) async {
    final db = await _databaseHelper.database;
    final res = await db.query(DatabaseHelper.tbRutina, where: 'fecha_creacion = ?', whereArgs: [fechaCreacion]);
    return res.isNotEmpty ? res.map((c) => Rutina.fromJson(c)).toList() : [];
  }

  @override
  Future<List<Rutina>> getRutinasByColor(int color) async {
    final db = await _databaseHelper.database;
    final res = await db.query(DatabaseHelper.tbRutina, where: 'color = ?', whereArgs: [color]);
    return res.isNotEmpty ? res.map((c) => Rutina.fromJson(c)).toList() : [];
  }

  @override
  Future<List<Rutina>> getRutinasByNombre(String nombre) async {
    final db = await _databaseHelper.database;
    final res = await db.query(DatabaseHelper.tbRutina, where: 'nombre = ?', whereArgs: [nombre]);
    return res.isNotEmpty ? res.map((c) => Rutina.fromJson(c)).toList() : [];
  }

  @override
  Future<List<Rutina>> getRutinasByDescripcion(String descripcion) async {
    final db = await _databaseHelper.database;
    final res = await db.query(DatabaseHelper.tbRutina, where: 'descripcion = ?', whereArgs: [descripcion]);
    return res.isNotEmpty ? res.map((c) => Rutina.fromJson(c)).toList() : [];
  }

  @override
  Future<List<Rutina>> getRutinasByEstadoAndFechaRealizacion(int estado, String fechaRealizacion) async {
    final db = await _databaseHelper.database;
    final res = await db.query(DatabaseHelper.tbRutina, where: 'estado = ? AND fecha_realizacion = ?', whereArgs: [estado, fechaRealizacion]);
    return res.isNotEmpty ? res.map((c) => Rutina.fromJson(c)).toList() : [];
  }

  @override
  Future<List<Rutina>> getRutinasByEstadoAndFechaCreacion(int estado, String fechaCreacion) async {
    final db = await _databaseHelper.database;
    final res = await db.query(DatabaseHelper.tbRutina, where: 'estado = ? AND fecha_creacion = ?', whereArgs: [estado, fechaCreacion]);
    return res.isNotEmpty ? res.map((c) => Rutina.fromJson(c)).toList() : [];
  }
}