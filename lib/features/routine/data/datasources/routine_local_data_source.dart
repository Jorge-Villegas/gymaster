import 'dart:convert';

import 'package:flutter/foundation.dart';
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

  Future<Serie> getSerieById(String id) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final serie = await db.query(
        DatabaseHelper.tableSerie,
        where: 'id = ?',
        whereArgs: [id],
      );
      return Serie.fromJson(serie.first);
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

  Future<List<Ejercicio>> getEjerciciosByRutinaId(String rutinaId) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final ejercicios = await db.rawQuery('''
          SELECT e.id, e.nombre, e.descripcion, e.imagenDireccion
          FROM  ${DatabaseHelper.tableEjercicio} e
          JOIN  ${DatabaseHelper.tableSerie} s ON e.id = s.ejercicioId
          JOIN  ${DatabaseHelper.tableRutina} r ON s.rutinaId = r.id
          WHERE s.rutinaId = ?
          GROUP BY e.nombre;
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

  Future<List<Serie>> getSeriesByEjercicioId(String ejercicioId) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final series = await db.rawQuery('''
          SELECT s.* 
          FROM ${DatabaseHelper.tableSerie} s
          JOIN ${DatabaseHelper.tableEjercicio} e ON e.id = s.ejercicioId
          JOIN ${DatabaseHelper.tableRutina} r ON r.id = s.rutinaId
          WHERE e.id = ?;
        ''', [ejercicioId]);

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
          FROM ${DatabaseHelper.tableMusculo} m
          JOIN ${DatabaseHelper.tableEjercicioMusculo} em ON m.id = em.musculoId
          JOIN ${DatabaseHelper.tableEjercicio} e ON e.id = em.ejercicioId
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
        DatabaseHelper.tableSerie,
        serie.toJson(),
        where: 'id = ?',
        whereArgs: [serie.id],
      );
      return result > 0;
    } catch (e) {
      throw LocalFailure();
    }
  }
}
