import 'package:flutter/foundation.dart';
import 'package:gymaster/core/database/database_helper.dart';
import 'package:gymaster/core/database/models/detalle_rutina.dart';
import 'package:gymaster/core/database/models/ejercicio.dart';
import 'package:gymaster/core/database/models/musculo.dart';
import 'package:gymaster/core/database/models/rutina.dart';
import 'package:gymaster/core/database/models/serie.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/features/routine/data/models/ejercicios_por_musculo.dart';

class RoutineLocalDataSource {
  final DatabaseHelper databaseHelper;

  RoutineLocalDataSource(this.databaseHelper);

  Future<List<Rutina>> getAllRutinas() async {
    try {
      final db = await DatabaseHelper.instance.database;
      final rutinas =
          await db.query(DatabaseHelper.tbRutina, orderBy: 'fecha_creacion');
      return rutinas.map((rutina) => Rutina.fromJson(rutina)).toList();
    } catch (e) {
      throw LocalFailure();
    }
  }

  Future<bool> createRutina({required Rutina rutina}) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final id = await db.insert(DatabaseHelper.tbRutina, rutina.toJson());
      return id > 0;
    } catch (e) {
      throw LocalFailure();
    }
  }

  Future<List<Musculo>> getAllMusculos() async {
    try {
      final db = await DatabaseHelper.instance.database;
      final musculos = await db.query(DatabaseHelper.tbMusculo);
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
          SELECT e.*
          FROM ${DatabaseHelper.tbEjercicio} e
          JOIN ${DatabaseHelper.tbEjercicioMusculo} em ON e.id = em.ejercicio_id
          JOIN ${DatabaseHelper.tbMusculo} m ON em.musculo_id = m.id
            WHERE m.id = ?;
          ''',
        [musculoId],
      );
      return List.generate(ejercicios.length, (i) {
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
        DatabaseHelper.tbRutina,
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
        DatabaseHelper.tbEjercicio,
        where: 'id = ?',
        whereArgs: [id],
      );
      return Ejercicio.fromJson(ejercicio.first);
    } catch (e) {
      throw LocalFailure();
    }
  }

  Future<Serie> getSerieById(String id) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final serie = await db.query(
        DatabaseHelper.tbSerie,
        where: 'id = ?',
        whereArgs: [id],
      );
      return Serie.fromJson(serie.first);
    } catch (e) {
      throw LocalFailure();
    }
  }

  Future<Serie> createSerie({required Serie serie}) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final id = await db.insert(DatabaseHelper.tbSerie, serie.toJson());
      return id > 0 ? serie : throw LocalFailure();
    } catch (e) {
      throw LocalFailure();
    }
  }

  Future<DetalleRutina> createDetalleEjercicio(
      DetalleRutina detalleRutina) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final id = await db.insert(
        DatabaseHelper.tbDetalleRutina,
        detalleRutina.toJson(),
      );
      return id > 0 ? detalleRutina : throw LocalFailure();
    } catch (e) {
      throw LocalFailure();
    }
  }

  Future<List<Ejercicio>> getEjerciciosByRutinaId(String rutinaId) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final ejercicios = await db.rawQuery('''
          SELECT e.*
          FROM ${DatabaseHelper.tbEjercicio} e
          join ${DatabaseHelper.tbDetalleRutina} dr on e.id = dr.ejercicio_id
          join ${DatabaseHelper.tbRutina} r on dr.rutina_id = r.id
          WHERE r.id = ?;
        ''', [rutinaId]);

      final result =
          ejercicios.map((json) => Ejercicio.fromJson(json)).toList();
      // Convierte la lista de Ejercicio a JSON y lo imprime
      debugPrint(ejerciciosToJson(result));
      return result;
    } catch (e) {
      throw LocalFailure();
    }
  }

  Future<List<Serie>> getSeriesByEjercicioIdAndRutinaId(
    String ejercicioId,
    String rutinaId,
  ) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final series = await db.rawQuery('''
          SELECT s.* FROM serie s
          JOIN detalle_rutina dr on dr.id = s.detalle_rutina_id
          JOIN ejercicio e on e.id = dr.ejercicio_id
          JOIN rutina r on r.id = dr.rutina_id
          WHERE r.id = ?
          AND e.id = ?;
        ''', [rutinaId, ejercicioId]);

      final result = List.generate(series.length, (i) {
        return Serie.fromJson(series[i]);
      });
      print("getSeriesByEjercicioId -> ${seriesListToJson(result)}");
      return result;
    } catch (e) {
      throw LocalFailure();
    }
  }

  Future<List<Musculo>> getMusculosByEjercicioId(String ejercicioId) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final musculos = await db.rawQuery('''
          SELECT m.id,m.nombre
          FROM ${DatabaseHelper.tbMusculo} m
          JOIN ${DatabaseHelper.tbEjercicioMusculo} em ON m.id = em.musculo_id
          JOIN ${DatabaseHelper.tbEjercicio} e ON e.id = em.ejercicio_id
          WHERE e.id = ?;
        ''', [ejercicioId]);

      return musculos.map((json) => Musculo.fromJson(json)).toList();
    } catch (e) {
      throw LocalFailure();
    }
  }

  // Actualiza una serie en la base de datos
  Future<bool> updateSerie(Serie serie) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final result = await db.update(
        DatabaseHelper.tbSerie,
        serie.toJson(),
        where: 'id = ?',
        whereArgs: [serie.id],
      );
      return result > 0;
    } catch (e) {
      throw LocalFailure();
    }
  }

  Future<List<Rutina>> getRutinasByNombre(String nombre) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final rutinas = await db.rawQuery('''
            SELECT * FROM ${DatabaseHelper.tbRutina}
            WHERE nombre LIKE ?;
          ''', ['%$nombre%']);
      return rutinas.map((rutina) => Rutina.fromJson(rutina)).toList();
    } catch (e) {
      throw LocalFailure();
    }
  }
}
