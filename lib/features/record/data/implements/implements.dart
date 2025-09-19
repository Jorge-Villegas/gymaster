import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/database/models/routine_db.dart';
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
  Future<Either<Failure, RecordRutina>> obtenerRutinaPorId(String id) async {
    try {
      final rutina = await localDataSource.obtenerRutinaPorId(id);

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
  Future<Either<Failure, void>> guardarRutina(RecordRutina rutina) async {
    try {
      final rutinaModel = RecordRutinaModel(
        id: rutina.id,
        nombre: rutina.nombre,
        fechaRealizada: rutina.fechaRealizada,
        tiempoRealizado: rutina.tiempoRealizado,
        color: rutina.color,
        ejercicios: rutina.ejercicios,
      );
      await localDataSource.guardarRutina(rutinaModel);
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
  Future<Either<Failure, void>> eliminarRutina(String id) async {
    try {
      await localDataSource.eliminarRutina(id);
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
      obtenerRutinasCompletadasConEjercicios() async {
    try {
      final rutinaSessions =
          await localDataSource.obtenerSesionesRutinaCompletadas();

      if (rutinaSessions.isEmpty) {
        return const Right([]);
      }

      List<RecordRutina> resultadoRutinas = [];

      for (var rutinaSession in rutinaSessions) {
        try {
          final ejercicios = await _obtenerEjerciciosPorSesionId(
            rutinaSession.id,
          );

          // Obtener rutina de la base de datos
          RutinaDb? rutina;
          try {
            rutina = await localDataSource.obtenerRutinaPorId(
              rutinaSession.rutinaId,
            );
          } catch (e) {
            print('⚠️ No se pudo obtener rutina ${rutinaSession.rutinaId}: $e');
            continue;
          }

          if (rutinaSession.horaFin == null || rutinaSession.horaFin!.isEmpty) {
            print('⚠️ endTime nulo o vacío para sesión ${rutinaSession.id}');
            continue;
          }

          if (rutinaSession.horaInicio == null ||
              rutinaSession.horaInicio!.isEmpty) {
            print('⚠️ startTime nulo o vacío para sesión ${rutinaSession.id}');
            continue;
          }

          print(
              '✅ Rutina ${rutina.nombre} ${rutinaSession.rutinaId} procesada con ${ejercicios.length} ejercicios');

          resultadoRutinas.add(
            RecordRutina(
              id: rutina.id,
              nombre: rutina.nombre,
              fechaRealizada: DateTime.parse(rutinaSession.horaFin!),
              tiempoRealizado: rutinaSession.duracion.toString(),
              color: rutina.color ?? 0xFF2196F3,
              ejercicios: ejercicios,
            ),
          );
        } catch (e) {
          print('⚠️ Error procesando rutina ${rutinaSession.rutinaId}: $e');
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

  Future<List<RecordEjercicios>> _obtenerEjerciciosPorSesionId(
    String sessionId,
  ) async {
    final ejerciciosDB =
        await localDataSource.obtenerEjerciciosCompletadosPorSesionId(
      sessionId,
    );
    final Set<String> ejercicioIds = {};
    final List<RecordEjercicios> ejercicios = [];

    for (var ejercicioDB in ejerciciosDB) {
      if (!ejercicioIds.contains(ejercicioDB.id)) {
        final seriesDelEjercicio = await _obtenerSeriesPorEjercicioYSesionId(
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

  Future<List<SeriesDelEjercicio>> _obtenerSeriesPorEjercicioYSesionId(
    String ejercicioId,
    String sessionId,
  ) async {
    final seriesDelEjercicioDB =
        await localDataSource.obtenerSeriesPorEjercicioYSesionId(
      ejercicioId,
      sessionId,
    );
    return seriesDelEjercicioDB.map((serieDB) {
      return SeriesDelEjercicio.fromDatabase(serieDB: serieDB);
    }).toList();
  }
}
