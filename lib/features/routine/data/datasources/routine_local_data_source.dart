import 'package:gymaster/core/database/database_helper.dart';
import 'package:gymaster/core/database/models/ejercicio.dart';
import 'package:gymaster/core/database/models/musculo.dart';
import 'package:gymaster/core/database/models/rutina.dart';
import 'package:gymaster/core/database/models/serie.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/features/routine/data/models/ejercicios_por_musculo.dart';
import 'package:sqflite/sqflite.dart';

class RoutineLocalDataSource {
  // Obtener todas las rutinas
  Future<List<Rutina>> getAllRutinas() async {
    try {
      final db = await DatabaseHelper.instance.database;
      final rutinas = await db.query(DatabaseHelper.tableRutina);

      // Convertir los mapas a una lista de objetos Rutina usando el método de fábrica fromJson
      return List.generate(rutinas.length, (i) {
        return Rutina.fromJson(rutinas[i]);
      });
    } catch (e) {
      throw LocalFailure();
    }
  }

  Future<bool> createRutina({required Rutina rutina}) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final id = await db.insert(DatabaseHelper.tableRutina, rutina.toJson());
      return id > 0;
    } catch (e) {
      throw LocalFailure();
    }
  }

  //obtener numero de ejercicios por id de rutina
  Future<int> getCantidadEjerciciosPorRutinaId(String idRutina) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final result = Sqflite.firstIntValue(await db.rawQuery('''
          SELECT COUNT(E.id) AS numeroEjercicios
          FROM ${DatabaseHelper.tableRutina} r
          JOIN ${DatabaseHelper.tableSerie} S ON r.id = S.rutinaId
          JOIN ${DatabaseHelper.tableEjercicio} E ON S.ejercicioId = E.id
          WHERE r.id = ?
        ''', [idRutina]));
      return result ?? 0;
    } catch (e) {
      throw LocalFailure();
    }
  }

  Future<List<Musculo>> getAllMusculos() async {
    try {
      final db = await DatabaseHelper.instance.database;
      final musculos = await db.query(DatabaseHelper.tableMusculo);
      return List.generate(musculos.length, (i) {
        return Musculo.fromJson(musculos[i]);
      });
    } catch (e) {
      throw LocalFailure();
    }
  }

  Future<List<EjerciciosPorMusculoModel>> getEjerciciosPorMusculo(
      String musculoId) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final ejercicios = await db.rawQuery(
        '''
        SELECT e.id, e.nombre, e.descripcion, e.imagenDireccion, json_group_array(m.nombre) AS musculos
        FROM ${DatabaseHelper.tableEjercicio} e
        JOIN ${DatabaseHelper.tableEjercicioMusculo}  em ON e.id = em.ejercicioId
        JOIN ${DatabaseHelper.tableMusculo}  m ON m.id = em.musculoId
        WHERE e.id IN (
            SELECT e.id
            FROM ${DatabaseHelper.tableEjercicio}  e
            JOIN ${DatabaseHelper.tableEjercicioMusculo} em ON e.id = em.ejercicioId
            WHERE em.musculoId = ?
        )
        GROUP BY e.id, e.nombre;
      ''',
        [musculoId],
      );
      return List.generate(ejercicios.length, (i) {
        print(ejercicios[i]);
        return EjerciciosPorMusculoModel.fromJson(ejercicios[i]);
      });
    } catch (e) {
      throw LocalFailure();
    }
  }

  Future<Rutina> getRutinaById(String id) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final rutina = await db.query(
        DatabaseHelper.tableRutina,
        where: 'id = ?',
        whereArgs: [id],
      );
      return Rutina.fromJson(rutina.first);
    } catch (e) {
      throw LocalFailure();
    }
  }

  //obtener ejercicio por su id
  Future<Ejercicio> getEjercicioById(String id) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final ejercicio = await db.query(
        DatabaseHelper.tableEjercicio,
        where: 'id = ?',
        whereArgs: [id],
      );
      return Ejercicio.fromJson(ejercicio.first);
    } catch (e) {
      throw LocalFailure();
    }
  }

  //crear serie
  Future<Serie> createSerie({required Serie serie}) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final id = await db.insert(DatabaseHelper.tableSerie, serie.toJson());
      return id > 0 ? serie : throw LocalFailure();
    } catch (e) {
      throw LocalFailure();
    }
  }
}
