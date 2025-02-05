import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/features/record/data/models/record_rutina_models.dart';
import 'package:gymaster/features/record/data/sources/record_local_data_source.dart';
import 'package:gymaster/features/record/domain/entities/record_rutina.dart';
import 'package:gymaster/features/record/domain/repositories/repositories.dart';

class RecordRepositoryImpl implements RecordRepository {
  final RecordLocalDataSource localDataSource;

  RecordRepositoryImpl({required this.localDataSource});
  @override
  Future<Either<Failure, List<RecordRutina>>> getAllRutinas() async {
    try {
      final rutinas = await localDataSource.getCompletedRoutines();
      final List<RecordRutina> result = [];

      for (var rutina in rutinas) {
        final ejerciciosDB =
            await localDataSource.getCompletedExercisesByRoutineId(rutina.id);

        // Convertir la lista de ejercicios de la base de datos a RecordEjercicios
        final Map<String, RecordEjercicios> ejerciciosMap = {};
        for (var ejercicioDB in ejerciciosDB) {
          // Obtener las series del ejercicio desde la base de datos
          final seriesDelEjercicioDB =
              await localDataSource.getSeriesByExerciseId(ejercicioDB.id);
          final List<SeriesDelEjercicio> seriesDelEjercicio =
              seriesDelEjercicioDB.map((serieDB) {
            return SeriesDelEjercicio.fromDatabase(serieDB: serieDB);
          }).toList();

          final recordEjercicio = RecordEjercicios.fromDatabase(
            ejercicioDB: ejercicioDB,
            seriesDelEjercicio: seriesDelEjercicio,
          );

          // Añadir el ejercicio al mapa para evitar duplicados
          ejerciciosMap[ejercicioDB.id] = recordEjercicio;
        }

        final recordRutina = RecordRutina.fromDatabase(
          rutinaDB: rutina,
        ).copyWith(ejercicios: ejerciciosMap.values.toList());

        result.add(recordRutina);
      }

      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, RecordRutina>> getRutinaById(String id) async {
    try {
      final result = await localDataSource.getRutinaById(id);
      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, void>> saveRutina(RecordRutina rutina) async {
    try {
      final rutinaModel = RecordRutinaModel(
        nombre: rutina.nombre,
        fechaRealizada: rutina.fechaRealizada,
        tiempoRealizado: rutina.tiempoRealizado,
        color: rutina.color,
        ejercicios: rutina.ejercicios,
      );
      await localDataSource.saveRutina(rutinaModel);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteRutina(String id) async {
    try {
      await localDataSource.deleteRutina(id);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, List<RecordRutina>>>
      getAllCompletedRoutinesWithExercises() async {
    try {
      final rutinas = await localDataSource.getCompletedRoutines();
      final List<RecordRutina> result = [];

      for (var rutina in rutinas) {
        final ejercicios = await _getExercisesByRoutineId(rutina.id);
        final recordRutina = RecordRutina.fromDatabase(
          rutinaDB: rutina,
        ).copyWith(ejercicios: ejercicios);

        result.add(recordRutina);
      }

      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  Future<List<RecordEjercicios>> _getExercisesByRoutineId(
      String rutinaId) async {
    final ejerciciosDB =
        await localDataSource.getCompletedExercisesByRoutineId(rutinaId);
    final Set<String> ejercicioIds = {};
    final List<RecordEjercicios> ejercicios = [];

    for (var ejercicioDB in ejerciciosDB) {
      if (!ejercicioIds.contains(ejercicioDB.id)) {
        final seriesDelEjercicio =
            await _getSeriesByEjercicioId(ejercicioDB.id);
        final recordEjercicio = RecordEjercicios.fromDatabase(
          ejercicioDB: ejercicioDB,
          seriesDelEjercicio: seriesDelEjercicio,
        );
        ejercicios.add(recordEjercicio);
        ejercicioIds.add(ejercicioDB.id);
      }
    }

    return ejercicios;
  }

  Future<List<SeriesDelEjercicio>> _getSeriesByEjercicioId(
      String ejercicioId) async {
    final seriesDelEjercicioDB =
        await localDataSource.getSeriesByExerciseId(ejercicioId);
    return seriesDelEjercicioDB.map((serieDB) {
      return SeriesDelEjercicio.fromDatabase(serieDB: serieDB);
    }).toList();
  }
}
