import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/database/models/models.dart';
import 'package:gymaster/core/database/seeders/database_seeder.dart';
import 'package:gymaster/core/database/seeders/rutina_data_seeder.dart';
import 'package:gymaster/core/error/exceptions.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/features/routine/data/datasources/routine_local_data_source.dart';
import 'package:gymaster/features/routine/data/models/ejercicios_de_rutina_model.dart'
    as ejercicio_de_rutina;
import 'package:gymaster/features/routine/data/models/ejercicios_por_musculo.dart';
import 'package:gymaster/features/routine/data/models/musculo_model.dart';
import 'package:gymaster/features/routine/data/models/routine_model.dart';
import 'package:gymaster/features/routine/data/models/rutina_data_model.dart';
import 'package:gymaster/features/routine/data/models/serie_model.dart';
import 'package:gymaster/features/routine/domain/entities/rutina_data.dart';
import 'package:gymaster/features/routine/domain/repositories/rutine_repository.dart';
import 'package:gymaster/features/routine/domain/usecases/add_ejercicio_rutina_usecase.dart';
import 'package:gymaster/shared/utils/enum.dart';
import 'package:gymaster/shared/utils/uuid_generator.dart';

class RoutineRepositoryImpl implements RoutineRepository {
  final RoutineLocalDataSource localDataSource;
  final IdGenerator idGenerator;

  RoutineRepositoryImpl({
    required this.localDataSource,
    required this.idGenerator,
  });

  @override
  Future<Either<Failure, List<RoutineModel>>> getAllRoutine() async {
    try {
      final result = await localDataSource.getAllRutinas();
      List<RoutineModel> routines = [];
      for (var rutina in result) {
        final cantEjercicio = await localDataSource.getEjerciciosByRutinaId(
          rutina.id,
        );
        routines.add(
          RoutineModel.fromDatabase(
            serieDB: rutina,
            cantidadEjercicios: cantEjercicio.length,
          ),
        );
      }
      return right(routines);
    } on NoRecordsException {
      return Left(
        NoRecordsFailure(errorMessage: 'No se encontraron registros.'),
      );
    } on ServerException {
      return Left(ServerFailure(errorMessage: 'Error del servidor.'));
    } catch (e) {
      return Left(
        UnexpectedFailure(errorMessage: 'Ocurrió un error inesperado.'),
      );
    }
  }

  @override
  Future<Either<Failure, RoutineModel>> addRoutine({
    required String name,
    String? description,
    required DateTime creationDate,
    required bool done,
    required int color,
    required String imagenDireccion,
  }) async {
    try {
      final rutina = Routine(
        id: idGenerator.generateId(),
        name: name,
        description: description,
        createdAt: creationDate.toString(),
        color: color,
        imagePath: imagenDireccion,
        userId: '1', //TODO: Cambiar por el usuario logueado
      );
      final result = await localDataSource.createRutina(rutina: rutina);

      if (result == false) {
        return Left(
          ServerFailure(
            errorMessage:
                'Error del servidor: No se pudo agregar la rutina. Por favor, inténtalo de nuevo más tarde.',
          ),
        );
      }
      return right(RoutineModel.fromDatabase(serieDB: rutina));
    } on ServerException {
      return Left(
        ServerFailure(
          errorMessage:
              'Error del servidor: No se pudo agregar la rutina. Por favor, inténtalo de nuevo más tarde.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<MusculoModel>>> getAllMusculos() async {
    try {
      var result = await localDataSource.getAllMusculos();

      if (result.isEmpty) {
        await DatabaseSeeder(idGenerator: idGenerator).seedGenerateDatabase();
        result = await localDataSource.getAllMusculos();

        await RoutineDataSeeder(idGenerator: idGenerator).generateFakeRutinas();

        // await EjercicioRutinaSeeder(idGenerator: idGenerator).generateData();
        // await generateData(DatabaseHelper.instance);
      }

      final musculos = result.map(MusculoModel.fromEntity).toList();
      return right(musculos);
    } on ServerException {
      return Left(
        ServerFailure(
          errorMessage:
              'Error del servidor: No se pudieron obtener los músculos. Por favor, inténtalo de nuevo más tarde.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<EjerciciosPorMusculoModel>>>
  getAllEjerciciosByMusculo({required String musculoId}) async {
    try {
      final ejercicios = await localDataSource.getEjerciciosPorMusculo(
        musculoId,
      );

      return right(
        ejercicios
            .map(
              (ejercicio) => EjerciciosPorMusculoModel(
                id: ejercicio.id,
                nombre: ejercicio.name,
                descripcion: ejercicio.description ?? '',
                imagenDireccion: ejercicio.imagePath ?? '',
                musculos: [],
              ),
            )
            .toList(),
      );
    } on NoRecordsException {
      return Left(
        NoRecordsFailure(
          errorMessage: 'No se encontraron ejercicios para este músculo.',
        ),
      );
    } on ServerException {
      return Left(
        ServerFailure(
          errorMessage:
              'Error del servidor: No se pudieron obtener los ejercicios. Por favor, inténtalo de nuevo más tarde.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> addEjericioRutina({
    required String idRutina,
    required String idSesion,
    required String idEjercicio,
    required List<DataSerie> dataSeries,
  }) async {
    try {
      final existingExercise = await localDataSource.getExerciseFromRoutine(
        idRutina: idRutina,
        exerciseId: idEjercicio,
        idRoutineSession: idSesion,
      );

      if (existingExercise != null) {
        return Left(
          ServerFailure(
            errorMessage: 'El ejercicio ya está agregado a la rutina.',
          ),
        );
      }

      await localDataSource.addEjercicioToRutina(
        idRutina: idRutina,
        idEjercicio: idEjercicio,
        dataSeries: dataSeries,
        idRoutineSession: idSesion,
      );
      return const Right(true);
    } on ServerException {
      return Left(
        ServerFailure(
          errorMessage:
              'Error del servidor: No se pudo agregar el ejercicio a la rutina. Por favor, inténtalo de nuevo más tarde.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, ejercicio_de_rutina.EjerciciosDeRutinaModel>>
  getAllEjercicioByRutinaId({
    required String rutinaId,
    required String idRoutineSession,
  }) async {
    try {
      //Obtener rutina
      final rutina = await localDataSource.getRutinaById(rutinaId);
      //erificar si me devolvio algo
      if (rutina == null) {
        return Left(ServerFailure(errorMessage: 'La rutina no existe'));
      }

      RoutineSession? session = await localDataSource.getRoutineSessionById(
        idRoutineSession,
      );

      //si no hay session, devolvemos un error
      //creamos una session ya que seria la primera vez que entra a la rutina
      if (session == null) {
        final newSession = RoutineSession(
          id: idGenerator.generateId(),
          routineId: rutinaId,
          status: RoutineSessionStatus.pending.name,
          createdAt: DateTime.now().toString(),
        );
        final result = await localDataSource.createRoutineSession(newSession);
        if (!result) {
          return Left(
            ServerFailure(errorMessage: 'No se pudo crear la session'),
          );
        }
        session = newSession;
      }

      //obtenemos los ejercicios de la rutina de esa session (session_exercise y exercise)

      List<ejercicio_de_rutina.EjercicioModel> ejerciciosConDetalles = [];

      final sessionExercises = await localDataSource
          .getSessionExercisesByRoutineSessionId(session.id);

      for (var sessionExercise in sessionExercises) {
        List<ejercicio_de_rutina.SeriesDelEjercicioModel> series = [];
        List<ejercicio_de_rutina.MusculoModel> musculos = [];

        final exercisesSet = await localDataSource
            .getExerciseSetsBySessionExerciseId(sessionExercise.id);

        for (var exerciseSet in exercisesSet) {
          series.add(
            ejercicio_de_rutina.SeriesDelEjercicioModel.fromDatabase(
              exerciseSet,
            ),
          );
        }

        final exercise = await localDataSource.getExerciseBySessionExerciseId(
          sessionExercise.id,
        );

        final muscles = await localDataSource.getMusculosByEjercicioId(
          sessionExercise.exerciseId,
        );

        for (var muscle in muscles) {
          musculos.add(ejercicio_de_rutina.MusculoModel.fromDatabase(muscle));
        }

        final ejercicios = ejercicio_de_rutina.EjercicioModel.fromDatabase(
          ejercicioDB: exercise,
          series: series,
          musculos: musculos,
        );

        ejerciciosConDetalles.add(ejercicios);
      }
      final ejerciciosDeRutinaConDetalles = ejercicio_de_rutina
          .EjerciciosDeRutinaModel.fromDatabase(
        session: session.id,
        rutinaDB: rutina,
        ejercicios: ejerciciosConDetalles,
        status: session.status,
      );

      return Right(ejerciciosDeRutinaConDetalles);
    } on ServerException {
      return Left(
        ServerFailure(
          errorMessage:
              'Error del servidor: No se pudieron obtener los ejercicios de la rutina. Por favor, inténtalo de nuevo más tarde.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, SerieModel>> updateSerie({
    required String id,
    double? peso,
    int? repeticiones,
    bool? realizado,
    int? tiempoDescanso,
  }) async {
    try {
      final serieDB = await localDataSource.getSerieById(id);

      final updatedSerie = serieDB.copyWith(
        weight: peso,
        repetitions: repeticiones,
        status:
            realizado == true
                ? ExerciseSetStatus.completed.name
                : 'not completed',
        restTime: tiempoDescanso,
      );

      final success = await localDataSource.updateSerie(updatedSerie);

      if (realizado != null) {
        //obtenermos el id de la session_exercise
        final sessionExerciseId = await localDataSource
            .getSessionExerciseIdByExerciseSetId(id);

        if (sessionExerciseId == null) {
          print('No se encontró el sessionExerciseId');
        }

        //consultamos todos los sets de la session
        final sets = await localDataSource.getExerciseSetsBySessionExerciseId(
          sessionExerciseId!,
        );

        //verificamos si todos los sets estan completados
        final allCompleted = sets.every(
          (element) => element.status == ExerciseSetStatus.completed.name,
        );

        //si todos los sets estan completados, actualizamos el sessionExercise
        if (allCompleted) {
          await localDataSource.markSessionExerciseAsCompletedById(
            sessionExerciseId,
          );
        }
      }

      final result = SerieModel.fromDatabase(serieDB: updatedSerie);
      if (success) {
        return Right(result);
      } else {
        return Left(
          ServerFailure(
            errorMessage:
                'Error del servidor: No se pudo actualizar la serie. Por favor, inténtalo de nuevo más tarde.',
          ),
        );
      }
    } on ServerException {
      return Left(
        ServerFailure(
          errorMessage:
              'Error del servidor: No se pudo actualizar la serie. Por favor, inténtalo de nuevo más tarde.',
        ),
      );
    }
  }

  Future<Either<Failure, List<SerieModel>>> getSeriesByRoutineId({
    required String rutinaId,
  }) async {
    try {
      return Left(
        ServerFailure(
          errorMessage:
              'Error del servidor: No se pudo eliminar la rutina. Por favor, inténtalo de nuevo más tarde.',
        ),
      );
    } on ServerException {
      return Left(
        ServerFailure(
          errorMessage:
              'Error del servidor: No se pudo eliminar la rutina. Por favor, inténtalo de nuevo más tarde.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteRoutine({required String id}) async {
    try {
      return Left(
        ServerFailure(
          errorMessage:
              'Error del servidor: No se pudo actualizar la rutina. Por favor, inténtalo de nuevo más tarde.',
        ),
      );
    } on ServerException {
      return Left(
        ServerFailure(
          errorMessage:
              'Error del servidor: No se pudo actualizar la rutina. Por favor, inténtalo de nuevo más tarde.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> updateRoutine({
    required String id,
    String? name,
    DateTime? creationDate,
    bool? done,
    int? color,
  }) async {
    try {
      return Left(
        ServerFailure(
          errorMessage:
              'Error del servidor: No se pudo obtener la rutina. Por favor, inténtalo de nuevo más tarde.',
        ),
      );
    } on ServerException {
      return Left(
        ServerFailure(
          errorMessage:
              'Error del servidor: No se pudo obtener la rutina. Por favor, inténtalo de nuevo más tarde.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, RoutineModel>> getRoutineById({
    required String id,
  }) async {
    try {
      return Left(ServerFailure(errorMessage: ''));
    } on ServerException {
      return Left(ServerFailure(errorMessage: ''));
    }
  }

  @override
  Future<Either<Failure, List<RoutineModel>>> getRoutineByName({
    required String name,
  }) async {
    try {
      final result = await localDataSource.getRutinasByNombre(name);
      if (result.isEmpty) {
        return Left(
          ServerFailure(
            errorMessage: 'No se encontraron rutinas con ese nombre.',
          ),
        );
      }
      List<RoutineModel> routines = [];
      for (var rutina in result) {
        final cantEjercicio = await localDataSource.getEjerciciosByRutinaId(
          rutina.id,
        );
        routines.add(
          RoutineModel.fromDatabase(
            serieDB: rutina,
            cantidadEjercicios: cantEjercicio.length,
          ),
        );
      }
      return right(routines);
    } on ServerException {
      return Left(
        ServerFailure(
          errorMessage:
              'Error del servidor: No se pudieron obtener las rutinas. Por favor, inténtalo de nuevo más tarde.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, SerieModel>> getSerieById(String id) async {
    try {
      return Left(
        ServerFailure(
          errorMessage:
              'Error del servidor: No se pudo obtener la serie. Por favor, inténtalo de nuevo más tarde.',
        ),
      );
    } on ServerException {
      return Left(
        ServerFailure(
          errorMessage:
              'Error del servidor: No se pudo obtener la serie. Por favor, inténtalo de nuevo más tarde.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, RutinaDataModel>> getRutina(int id) async {
    try {
      return Left(
        ServerFailure(
          errorMessage:
              'Error del servidor: No se pudo obtener la rutina. Por favor, inténtalo de nuevo más tarde.',
        ),
      );
    } on ServerException {
      return Left(
        ServerFailure(
          errorMessage:
              'Error del servidor: No se pudo obtener la rutina. Por favor, inténtalo de nuevo más tarde.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, RutinaData>> obtenerRutinaDetalles({
    required String idRutina,
  }) async {
    try {
      return Left(
        ServerFailure(
          errorMessage:
              'Error del servidor: No se pudieron obtener los detalles de la rutina. Por favor, inténtalo de nuevo más tarde.',
        ),
      );
    } on ServerException {
      return Left(
        ServerFailure(
          errorMessage:
              'Error del servidor: No se pudieron obtener los detalles de la rutina. Por favor, inténtalo de nuevo más tarde.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, RoutineSession>> getLastRoutineSessionByRoutineId(
    String id,
  ) async {
    RoutineSession? session = await localDataSource
        .getLastRoutineSessionByRoutineId(id);

    if (session != null) {
      return Right(session);
    }

    final newSession = RoutineSession(
      id: idGenerator.generateId(),
      routineId: id,
      status: RoutineSessionStatus.pending.name,
      createdAt: DateTime.now().toString(),
    );
    final result = await localDataSource.createRoutineSession(newSession);

    if (!result) {
      return Left(ServerFailure(errorMessage: 'No se pudo crear la session'));
    }

    return Right(newSession);
  }

  @override
  Future<Either<Failure, void>> updateExerciseOrder({
    required String routineId,
    required List<String> exerciseIds,
  }) async {
    try {
      // First get the active session for this routine
      final sessionResult = await getLastRoutineSessionByRoutineId(routineId);

      return sessionResult.fold((failure) => Left(failure), (session) async {
        final result = await localDataSource.updateExerciseOrder(
          routineSessionId: session.id,
          exerciseIds: exerciseIds,
        );

        if (result) {
          return const Right(null);
        } else {
          return Left(
            ServerFailure(
              errorMessage: 'Error al actualizar el orden de los ejercicios.',
            ),
          );
        }
      });
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> markExerciseAsCompleted({
    required String exerciseId,
    required String routineId,
  }) async {
    try {
      // Obtener la sesión activa para esta rutina
      final sessionResult = await getLastRoutineSessionByRoutineId(routineId);

      return sessionResult.fold((failure) => Left(failure), (session) async {
        // Obtener el sessionExerciseId asociado
        final sessionExercise = await localDataSource
            .getSessionExerciseByExerciseId(
              routineSessionId: session.id,
              exerciseId: exerciseId,
            );

        if (sessionExercise == null) {
          return Left(
            ServerFailure(
              errorMessage: 'No se encontró el ejercicio en la sesión.',
            ),
          );
        }

        final result = await localDataSource.markExerciseAsCompleted(
          sessionExerciseId: sessionExercise.id,
          routineSessionId: session.id,
        );

        if (result) {
          return const Right(true);
        } else {
          return Left(
            ServerFailure(
              errorMessage: 'Error al marcar el ejercicio como completado.',
            ),
          );
        }
      });
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteEjercicioRutina(
    String idEjercicio,
    String idSesion,
  ) async {
    try {
      final result = await localDataSource.deleteExerciseFromRoutineSession(
        exerciseId: idEjercicio,
        routineSessionId: idSesion,
      );

      if (result) {
        return const Right(true);
      } else {
        return const Right(false);
      }
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> startRoutineSession(
    String sessionId,
    String routineId,
  ) async {
    try {
      // Verificar si la sesión actual está completada
      final currentSession = await localDataSource.getRoutineSessionById(
        sessionId,
      );
      if (currentSession != null &&
          currentSession.status == RoutineSessionStatus.completed.name) {
        // Crear una nueva sesión con estado en_progreso
        final newSession = RoutineSession(
          id: idGenerator.generateId(),
          routineId: routineId,
          status: RoutineSessionStatus.in_progress.name,
          startTime: DateTime.now().toIso8601String(),
          createdAt: DateTime.now().toString(),
        );

        final sessionCreated = await localDataSource.createRoutineSession(
          newSession,
        );
        if (!sessionCreated) {
          return Left(
            ServerFailure(errorMessage: 'No se pudo crear la sesión nueva'),
          );
        }

        // Obtener todos los ejercicios y sus series de la sesión completada (sessionId)
        final sessionExercises = await localDataSource
            .getSessionExercisesByRoutineSessionId(sessionId);

        // Copiar cada ejercicio y sus series a la nueva sesión
        for (var sessionExercise in sessionExercises) {
          // Crear nuevo session_exercise para la nueva sesión
          final newSessionExerciseId = idGenerator.generateId();
          final newSessionExercise = SessionExercise(
            id: newSessionExerciseId,
            sessionId: newSession.id,
            exerciseId: sessionExercise.exerciseId,
            status: SessionExerciseStatus.pending.name,
            orderIndex: sessionExercise.orderIndex,
          );

          await localDataSource.insertSessionExercise(newSessionExercise);

          // Obtener todas las series del ejercicio original
          final exerciseSets = await localDataSource
              .getExerciseSetsBySessionExerciseId(sessionExercise.id);

          // Copiar cada serie para el nuevo ejercicio, reiniciando el estado
          for (var set in exerciseSets) {
            final newSet = ExerciseSet(
              id: idGenerator.generateId(),
              sessionExerciseId: newSessionExerciseId,
              weight: set.weight,
              repetitions: set.repetitions,
              restTime: set.restTime,
              status:
                  ExerciseSetStatus
                      .pending
                      .name, // Reiniciar estado a pendiente
            );

            await localDataSource.insertExerciseSet(newSet);
          }
        }

        // Retornar la información sobre la nueva sesión creada para poder navegar a ella
        return const Right(true);
      }

      // Si la sesión actual no estaba completada, solo actualizamos su estado a in_progress
      final result = await localDataSource.updateRoutineSessionStatus(
        sessionId: sessionId,
        status: RoutineSessionStatus.in_progress.name,
        startTime: DateTime.now(),
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> stopRoutineSession(String sessionId) async {
    try {
      //verificamops si esta routine session esta en porceso
      final statusRoutineSession = await localDataSource
          .getRoutineSessionStatusById(sessionId);

      if (statusRoutineSession == RoutineSessionStatus.completed.name) {
        return Left(
          ServerFailure(errorMessage: 'La sesión ya ha sido completada'),
        );
      }

      final result = await localDataSource.updateRoutineSessionStatus(
        sessionId: sessionId,
        status: RoutineSessionStatus.cancelled.name,
        endTime: DateTime.now(),
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> completeRoutineSession(String sessionId) async {
    try {
      // Verificar si esta rutina está en proceso
      final routineSessionStatus = await localDataSource
          .getRoutineSessionStatusById(sessionId);

      if (routineSessionStatus == RoutineSessionStatus.completed.name) {
        return Left(
          ServerFailure(errorMessage: 'La sesión ya ha sido completada'),
        );
      }

      final allSessionExercisesCompleted = await localDataSource
          .checkAllSessionExercisesCompleted(sessionId);

      if (!allSessionExercisesCompleted) {
        return Left(
          ServerFailure(
            errorMessage: 'No se han completado todos los ejercicios',
          ),
        );
      }
      final updateResult = await localDataSource.updateRoutineSessionStatus(
        sessionId: sessionId,
        status: RoutineSessionStatus.completed.name,
        endTime: DateTime.now(),
      );
      return Right(updateResult);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
