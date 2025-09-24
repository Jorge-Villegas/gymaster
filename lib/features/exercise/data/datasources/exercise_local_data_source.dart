import 'package:gymaster/core/database/database_helper.dart';
import 'package:gymaster/core/error/exceptions.dart';
import 'package:gymaster/features/exercise/data/models/exercise_model.dart';

import '../../../../core/database/models/models.dart';

class ExerciseLocalDataSource {
  final DatabaseHelper databaseHelper;

  ExerciseLocalDataSource(this.databaseHelper);

  Future<List<ExerciseModel>> obtenerTodosLosEjercicios() async {
    try {
      final db = await databaseHelper.database;
      final exercises = await db.query(EjercicioDb.tabla);

      List<ExerciseModel> exerciseModels = [];

      for (var exercise in exercises) {
        final exerciseDB = EjercicioDb.fromJson(exercise);
        final muscles = await obtenerMusculosPorEjercicio(exerciseDB.id);
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

  Future<List<MusculoDb>> obtenerMusculosPorEjercicio(String exerciseId) async {
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

  Future<List<ExerciseModel>> obtenerEjerciciosPorMusculo(
      String musculoId) async {
    try {
      final db = await databaseHelper.database;

      final exercises = await db.rawQuery(
        '''
      SELECT DISTINCT e.*
      FROM ${EjercicioDb.tabla} e
      INNER JOIN ${EjercicioMusculoDbModel.tabla} em ON e.${EjercicioDb.columnId}  = em.${EjercicioMusculoDbModel.columnaEjercicioId} 
      WHERE em.${EjercicioMusculoDbModel.columnaMusculoId}  = ?
      ''',
        [musculoId],
      );

      List<ExerciseModel> exerciseModels = [];

      // Para cada ejercicio, obtener todos sus músculos relacionados
      for (var exercise in exercises) {
        final exerciseDB = EjercicioDb.fromJson(exercise);
        final muscles = await obtenerMusculosPorEjercicio(exerciseDB.id);
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

  Future<ExerciseModel?> obtenerEjercicioPorId(String id) async {
    try {
      final db = await databaseHelper.database;
      final resultados = await db.query(
        EjercicioDb.tabla,
        where: '${EjercicioDb.columnId} = ?',
        whereArgs: [id],
      );

      if (resultados.isEmpty) return null;

      final ejercicioDB = EjercicioDb.fromJson(resultados.first);
      final musculos = await obtenerMusculosPorEjercicio(ejercicioDB.id);

      return ExerciseModel.fromDatabase(
        ejercicioDB,
        musculos.map((m) => m.nombre).toList(), // Cambiado de id a name
      );
    } catch (e) {
      throw ServerException();
    }
  }

  Future<List<ExerciseModel>> buscarEjercicios(String query) async {
    try {
      final db = await databaseHelper.database;
      final ejercicios = await db.query(
        EjercicioDb.tabla,
        where:
            '${EjercicioDb.columnaNombre} LIKE ? OR ${EjercicioDb.columnaDescripcion} LIKE ?',
        whereArgs: ['%$query%', '%$query%'],
      );

      List<ExerciseModel> modelosEjercicio = [];

      for (var exercise in ejercicios) {
        final ejercicioDB = EjercicioDb.fromJson(exercise);
        final musculos = await obtenerMusculosPorEjercicio(ejercicioDB.id);
        modelosEjercicio.add(
          ExerciseModel.fromDatabase(
            ejercicioDB,
            musculos.map((m) => m.nombre).toList(),
          ),
        );
      }

      return modelosEjercicio;
    } catch (e) {
      throw ServerException();
    }
  }
}
