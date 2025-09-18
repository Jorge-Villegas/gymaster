import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/database/models/routine_db_model.dart';
import 'package:gymaster/core/error/exceptions.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/features/record/data/models/record_rutina_models.dart';
import 'package:gymaster/features/record/data/sources/record_local_data_source.dart';
import 'package:gymaster/features/record/domain/entities/record_rutina.dart';
import 'package:gymaster/features/record/domain/repositories/repositories.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class RecordRepositoryImpl implements RecordRepository {
  final RecordLocalDataSource localDataSource;

  RecordRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, RecordRutina>> getRutinaById(String id) async {
    try {
      final rutina = await localDataSource.getRutinaById(id);

      return Right(
        RecordRutina.fromDatabase(rutinaDB: rutina, cantidadEjercicios: 0),
      );
    } on ServerException {
      return Left(
        ServerFailure(
          errorMessage:
              'No se pudo obtener la rutina. Por favor, inténtalo de nuevo más tarde.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> saveRutina(RecordRutina rutina) async {
    try {
      final rutinaModel = RecordRutinaModel(
        id: rutina.id,
        nombre: rutina.nombre,
        fechaRealizada: rutina.fechaRealizada,
        tiempoRealizado: rutina.tiempoRealizado,
        color: rutina.color,
        ejercicios: rutina.ejercicios,
      );
      await localDataSource.saveRutina(rutinaModel);
      return const Right(null);
    } on ServerException {
      return Left(
        ServerFailure(
          errorMessage:
              'No se pudo guardar la rutina. Por favor, inténtalo de nuevo más tarde.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteRutina(String id) async {
    try {
      await localDataSource.deleteRutina(id);
      return const Right(null);
    } on ServerException {
      return Left(
        ServerFailure(
          errorMessage:
              ' No se pudo eliminar la rutina. Por favor, inténtalo de nuevo más tarde.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<RecordRutina>>>
      obtenerTodasLasRutinasCompletadasConEjercicios() async {
    try {
      final rutinaSessions = await localDataSource.getCompletedRoutines();

      if (rutinaSessions.isEmpty) {
        return const Right([]);
      }

      List<RecordRutina> resultadoRutinas = [];

      for (var rutinaSession in rutinaSessions) {
        try {
          final ejercicios = await _getExercisesBySessionId(
            rutinaSession.id,
          );

          // Obtener rutina de la base de datos
          RoutineDbModel? rutina;
          try {
            rutina = await localDataSource.getRutinaById(
              rutinaSession.routineId,
            );
          } catch (e) {
            print(
                '⚠️ No se pudo obtener rutina ${rutinaSession.routineId}: $e');
            continue;
          }

          if (rutinaSession.endTime == null || rutinaSession.endTime!.isEmpty) {
            print('⚠️ endTime nulo o vacío para sesión ${rutinaSession.id}');
            continue;
          }

          if (rutinaSession.startTime == null ||
              rutinaSession.startTime!.isEmpty) {
            print('⚠️ startTime nulo o vacío para sesión ${rutinaSession.id}');
            continue;
          }

          print(
              '✅ Rutina ${rutina.nombre} ${rutinaSession.routineId} procesada con ${ejercicios.length} ejercicios');

          resultadoRutinas.add(
            RecordRutina(
              id: rutina.id,
              nombre: rutina.nombre,
              fechaRealizada: DateTime.parse(rutinaSession.endTime!),
              tiempoRealizado: rutinaSession.duration.toString(),
              color: rutina.color ?? 0xFF2196F3,
              ejercicios: ejercicios,
            ),
          );
        } catch (e) {
          print('⚠️ Error procesando rutina ${rutinaSession.routineId}: $e');
          continue;
        }
      }
      return Right(resultadoRutinas);
    } on DatabaseException {
      return Left(
        CacheFailure(
          errorMessage:
              'Error al acceder a la base de datos. Verifica tu conexión.',
        ),
      );
    } catch (e) {
      return Left(
        CacheFailure(
          errorMessage:
              'No se pudieron obtener las rutinas completadas. Por favor, inténtalo de nuevo más tarde.',
        ),
      );
    }
  }

  Future<List<RecordEjercicios>> _getExercisesBySessionId(
    String sessionId,
  ) async {
    final ejerciciosDB = await localDataSource.getCompletedExercisesBySessionId(
      sessionId,
    );
    final Set<String> ejercicioIds = {};
    final List<RecordEjercicios> ejercicios = [];

    for (var ejercicioDB in ejerciciosDB) {
      if (!ejercicioIds.contains(ejercicioDB.id)) {
        final seriesDelEjercicio = await _getSeriesByEjercicioAndSessionId(
          ejercicioDB.id,
          sessionId,
        );
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

  Future<List<SeriesDelEjercicio>> _getSeriesByEjercicioAndSessionId(
    String ejercicioId,
    String sessionId,
  ) async {
    final seriesDelEjercicioDB =
        await localDataSource.getSeriesByExerciseAndSessionId(
      ejercicioId,
      sessionId,
    );
    return seriesDelEjercicioDB.map((serieDB) {
      return SeriesDelEjercicio.fromDatabase(serieDB: serieDB);
    }).toList();
  }
}
