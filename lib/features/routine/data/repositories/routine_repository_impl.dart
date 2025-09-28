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
import 'package:gymaster/features/routine/domain/usecases/agregar_ejercicio_a_rutina_usecase.dart';
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
      final rutina = RutinaDb(
        id: idGenerator.generateId(),
        nombre: name,
        descripcion: description,
        fechaCreacion: creationDate.toString(),
        color: color,
        rutaImagen: imagenDireccion,
        usuarioId: '1', //TODO: Cambiar por el usuario logueado
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
                nombre: ejercicio.nombre,
                descripcion: ejercicio.descripcion ?? '',
                imagenDireccion: ejercicio.rutaImagen ?? '',
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
      // Obtener rutina
      final rutina = await localDataSource.getRutinaById(rutinaId);

      // IMPORTANTE: Ya no creamos sesión aquí, debe venir del parámetro
      RutinaSesionDb? session = await localDataSource.getRoutineSessionById(
        idRoutineSession,
      );

      // Si no hay sesión, devolvemos un error - la sesión debe haberse creado antes
      if (session == null) {
        print('❌ Error: No se encontró la sesión $idRoutineSession');
        return Left(
          ServerFailure(
              errorMessage: 'No se encontró la sesión de rutina especificada'),
        );
      }

      // Obtenemos los ejercicios de la rutina de esa sesión (session_exercise y exercise)
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
          orderIndex: sessionExercise.orderIndex,
          status: sessionExercise.status,
          ejercicioDB: exercise,
          series: series,
          musculos: musculos,
        );

        ejerciciosConDetalles.add(ejercicios);
      }
      final ejerciciosDeRutinaConDetalles =
          ejercicio_de_rutina.EjerciciosDeRutinaModel.fromDatabase(
        session: session.id,
        rutinaDB: rutina,
        ejercicios: ejerciciosConDetalles,
        status: session.estado,
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
        peso: peso,
        repeticiones: repeticiones,
        estado: realizado == true
            ? EstadoSerieEjercicio.completado.name
            : EstadoSerieEjercicio.pendiente.name,
        tiempoDescanso: tiempoDescanso,
      );

      final success = await localDataSource.updateSerie(updatedSerie);

      if (realizado != null) {
        //obtenermos el id de la session_exercise
        final sessionExerciseId =
            await localDataSource.getSessionExerciseIdByExerciseSetId(id);

        if (sessionExerciseId == null) {
          print('No se encontró el sessionExerciseId');
        }

        //consultamos todos los sets de la session
        final sets = await localDataSource.getExerciseSetsBySessionExerciseId(
          sessionExerciseId!,
        );

        //verificamos si todos los sets estan completados
        final allCompleted = sets.every(
          (element) => element.estado == EstadoSerieEjercicio.completado.name,
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
      final result = await localDataSource.deleteRutina(id: id);

      if (!result) {
        return Left(
          ServerFailure(
            errorMessage:
                'No se pudo eliminar la rutina. Por favor, inténtalo de nuevo.',
          ),
        );
      }

      return const Right(null);
    } on NoRecordsException {
      return Left(
        NoRecordsFailure(
          errorMessage: 'La rutina no existe o ya fue eliminada.',
        ),
      );
    } on ServerException {
      return Left(
        ServerFailure(
          errorMessage:
              'Error del servidor: No se pudo eliminar la rutina. Por favor, inténtalo de nuevo más tarde.',
        ),
      );
    } catch (e) {
      return Left(
        UnexpectedFailure(
          errorMessage: 'Ocurrió un error inesperado al eliminar la rutina.',
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
  Future<Either<Failure, RutinaSesionDb>> getLastRoutineSessionByRoutineId(
    String id,
  ) async {
    RutinaSesionDb? session =
        await localDataSource.getLastRoutineSessionByRoutineId(id);

    if (session != null) {
      return Right(session);
    }

    // Buscar si hay alguna sesión anterior con ejercicios para copiar
    final allPreviousSessions = await _getPreviousSessionsWithExercises(id);

    final newSession = RutinaSesionDb(
      id: idGenerator.generateId(),
      rutinaId: id,
      estado: EstadoSesionRutina.pendiente.name,
      fechaCreacion: DateTime.now().toString(),
    );

    final result = await localDataSource.createRoutineSession(newSession);

    if (!result) {
      print('❌ Error: No se pudo crear la sesión');
      return Left(ServerFailure(errorMessage: 'No se pudo crear la session'));
    }

    // Si existe una sesión anterior con ejercicios, copiarlos a la nueva sesión
    if (allPreviousSessions.isNotEmpty) {
      print('🔄 Copiando ejercicios de sesión anterior...');
      await _copyExercisesFromSession(
          allPreviousSessions.first.id, newSession.id);
    }

    print('✅ Nueva sesión creada: ${newSession.id}');
    return Right(newSession);
  }

  Future<List<RutinaSesionDb>> _getPreviousSessionsWithExercises(
      String routineId) async {
    try {
      // Buscar todas las sesiones de esta rutina ordenadas por fecha descendente
      final allSessions =
          await localDataSource.getAllSessionsByRoutineId(routineId);

      // Filtrar solo las que tienen ejercicios
      List<RutinaSesionDb> sessionsWithExercises = [];

      for (var session in allSessions) {
        final exercises = await localDataSource
            .getSessionExercisesByRoutineSessionId(session.id);
        if (exercises.isNotEmpty) {
          sessionsWithExercises.add(session);
        }
      }

      return sessionsWithExercises;
    } catch (e) {
      print('⚠️ Error buscando sesiones anteriores: $e');
      return [];
    }
  }

  Future<void> _copyExercisesFromSession(
      String fromSessionId, String toSessionId) async {
    try {
      final sessionExercises = await localDataSource
          .getSessionExercisesByRoutineSessionId(fromSessionId);

      for (var sessionExercise in sessionExercises) {
        final newSessionExerciseId = idGenerator.generateId();
        final newSessionExercise = SessionEjercicioDb(
          id: newSessionExerciseId,
          sessionId: toSessionId,
          exerciseId: sessionExercise.exerciseId,
          status: EstadoEjercicioSesion.pendiente.name,
          orderIndex: sessionExercise.orderIndex,
        );

        await localDataSource.insertSessionExercise(newSessionExercise);

        // Copiar series
        final exerciseSets = await localDataSource
            .getExerciseSetsBySessionExerciseId(sessionExercise.id);

        for (var set in exerciseSets) {
          final newSet = SerieEjercicioDb(
            id: idGenerator.generateId(),
            ejercicioSesionId: newSessionExerciseId,
            peso: set.peso,
            repeticiones: set.repeticiones,
            tiempoDescanso: set.tiempoDescanso,
            estado: EstadoSerieEjercicio.pendiente.name,
          );

          await localDataSource.insertExerciseSet(newSet);
        }
      }

      print('✅ Ejercicios copiados exitosamente');
    } catch (e) {
      print('❌ Error copiando ejercicios: $e');
    }
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
        final sessionExercise =
            await localDataSource.getSessionExerciseByExerciseId(
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
      print(
          '🚀 startRoutineSession: sessionId=$sessionId, routineId=$routineId');

      // Verificar si la sesión actual existe y su estado
      final currentSession =
          await localDataSource.getRoutineSessionById(sessionId);

      if (currentSession == null) {
        print('❌ Error: No se encontró la sesión $sessionId');
        return Left(ServerFailure(
            errorMessage: 'No se encontró la sesión especificada'));
      }

      print('📋 Estado actual de la sesión: ${currentSession.estado}');

      // Si la sesión está completada o cancelada, necesitamos crear una nueva
      if (currentSession.estado == EstadoSesionRutina.completado.name ||
          currentSession.estado == EstadoSesionRutina.cancelado.name) {
        print('🔄 Sesión completada/cancelada. Creando nueva sesión...');

        // Verificar si ya existe una sesión pendiente más reciente para esta rutina
        final latestSession =
            await localDataSource.getLastRoutineSessionByRoutineId(routineId);

        if (latestSession != null &&
            latestSession.id != sessionId &&
            latestSession.estado == EstadoSesionRutina.pendiente.name) {
          print(
              '✅ Ya existe una sesión pendiente más reciente: ${latestSession.id}');
          return const Right(true);
        }

        // Crear nueva sesión limpia
        return await _createFreshSessionFromCompleted(sessionId, routineId);
      }

      // Si la sesión está pendiente, cambiarla a en_progreso
      if (currentSession.estado == EstadoSesionRutina.pendiente.name) {
        print('▶️ Iniciando sesión pendiente...');
        final result = await localDataSource.updateRoutineSessionStatus(
          sessionId: sessionId,
          status: EstadoSesionRutina.en_progreso.name,
          startTime: DateTime.now(),
        );
        print('✅ Sesión iniciada: $result');
        return Right(result);
      }

      // Si ya está en progreso, no hacer nada
      if (currentSession.estado == EstadoSesionRutina.en_progreso.name) {
        print('ℹ️ La sesión ya está en progreso');
        return const Right(true);
      }

      print('⚠️ Estado de sesión no manejado: ${currentSession.estado}');
      return const Right(false);
    } catch (e) {
      print('❌ Error en startRoutineSession: $e');
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<Failure, bool>> _createFreshSessionFromCompleted(
      String completedSessionId, String routineId) async {
    try {
      // Crear nueva sesión
      final newSession = RutinaSesionDb(
        id: idGenerator.generateId(),
        rutinaId: routineId,
        estado: EstadoSesionRutina.pendiente.name,
        horaInicio: null,
        horaFin: null,
        fechaCreacion: DateTime.now().toString(),
      );

      print('📝 Creando nueva sesión: ${newSession.id}');

      final sessionCreated =
          await localDataSource.createRoutineSession(newSession);
      if (!sessionCreated) {
        return Left(
            ServerFailure(errorMessage: 'No se pudo crear la sesión nueva'));
      }

      // Verificar si la nueva sesión ya tiene ejercicios (evitar duplicación)
      final existingExercises = await localDataSource
          .getSessionExercisesByRoutineSessionId(newSession.id);

      if (existingExercises.isNotEmpty) {
        print('ℹ️ La nueva sesión ya tiene ejercicios, no se duplicarán');
        return const Right(true);
      }

      // Obtener ejercicios de la sesión completada para copiarlos
      final sessionExercises = await localDataSource
          .getSessionExercisesByRoutineSessionId(completedSessionId);

      print(
          '📋 Copiando ${sessionExercises.length} ejercicios de sesión completada...');

      // Copiar cada ejercicio y sus series a la nueva sesión
      for (var sessionExercise in sessionExercises) {
        final newSessionExerciseId = idGenerator.generateId();
        final newSessionExercise = SessionEjercicioDb(
          id: newSessionExerciseId,
          sessionId: newSession.id,
          exerciseId: sessionExercise.exerciseId,
          status: EstadoEjercicioSesion.pendiente.name,
          orderIndex: sessionExercise.orderIndex,
        );

        await localDataSource.insertSessionExercise(newSessionExercise);

        // Copiar series reiniciando estados
        final exerciseSets = await localDataSource
            .getExerciseSetsBySessionExerciseId(sessionExercise.id);

        for (var set in exerciseSets) {
          final newSet = SerieEjercicioDb(
            id: idGenerator.generateId(),
            ejercicioSesionId: newSessionExerciseId,
            peso: set.peso,
            repeticiones: set.repeticiones,
            tiempoDescanso: set.tiempoDescanso,
            estado: EstadoSerieEjercicio.pendiente.name,
          );

          await localDataSource.insertExerciseSet(newSet);
        }
      }

      print('✅ Nueva sesión creada exitosamente con ejercicios copiados');
      return const Right(true);
    } catch (e) {
      print('❌ Error creando sesión fresca: $e');
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> stopRoutineSession(String sessionId) async {
    try {
      //verificamops si esta routine session esta en porceso
      final statusRoutineSession =
          await localDataSource.getRoutineSessionStatusById(sessionId);

      if (statusRoutineSession == EstadoSesionRutina.completado.name) {
        return Left(
          ServerFailure(errorMessage: 'La sesión ya ha sido completada'),
        );
      }

      final result = await localDataSource.updateRoutineSessionStatus(
        sessionId: sessionId,
        status: EstadoSesionRutina.cancelado.name,
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
      print('🏁 Iniciando completar sesión de rutina: $sessionId');

      // Verificar si esta rutina está en proceso
      final routineSessionStatus =
          await localDataSource.getRoutineSessionStatusById(sessionId);

      print('📋 Estado actual de la sesión: $routineSessionStatus');

      if (routineSessionStatus == EstadoSesionRutina.completado.name) {
        print('⚠️ La sesión ya está completada');
        return Left(
          ServerFailure(errorMessage: 'La sesión ya ha sido completada'),
        );
      }

      print('🔍 Verificando si todos los ejercicios están completados...');
      final allSessionExercisesCompleted =
          await localDataSource.checkAllSessionExercisesCompleted(sessionId);

      print(
          '✅ ¿Todos los ejercicios completados?: $allSessionExercisesCompleted');

      if (!allSessionExercisesCompleted) {
        print('❌ No todos los ejercicios están completados');
        return Left(
          ServerFailure(
            errorMessage: 'No se han completado todos los ejercicios',
          ),
        );
      }

      print('💾 Actualizando estado de la sesión a completado...');
      final updateResult = await localDataSource.updateRoutineSessionStatus(
        sessionId: sessionId,
        status: EstadoSesionRutina.completado.name,
        endTime: DateTime.now(),
      );

      print('🎉 Rutina marcada como completada: $updateResult');
      return Right(updateResult);
    } catch (e) {
      print('❌ Error completando rutina: $e');
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateExerciseStatusById({
    required String exerciseId,
    required String routineSessionId,
    required String statusExercise,
  }) async {
    try {
      await localDataSource.updateExerciseStatusById(
        exerciseId: exerciseId,
        routineSessionId: routineSessionId,
        status: statusExercise,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> restoreRoutine({required String id}) async {
    try {
      final result = await localDataSource.restoreRutina(id: id);

      if (!result) {
        return Left(
          ServerFailure(
            errorMessage:
                'No se pudo restaurar la rutina. Por favor, inténtalo de nuevo.',
          ),
        );
      }

      return const Right(null);
    } on NoRecordsException {
      return Left(
        NoRecordsFailure(
          errorMessage: 'La rutina no existe en la papelera.',
        ),
      );
    } on ServerException {
      return Left(
        ServerFailure(
          errorMessage:
              'Error del servidor: No se pudo restaurar la rutina. Por favor, inténtalo de nuevo más tarde.',
        ),
      );
    } catch (e) {
      return Left(
        UnexpectedFailure(
          errorMessage: 'Ocurrió un error inesperado al restaurar la rutina.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<RoutineModel>>> getDeletedRoutines() async {
    try {
      final result = await localDataSource.getDeletedRutinas();
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
        NoRecordsFailure(errorMessage: 'No hay rutinas en la papelera.'),
      );
    } on ServerException {
      return Left(ServerFailure(errorMessage: 'Error del servidor.'));
    } catch (e) {
      return Left(
        UnexpectedFailure(errorMessage: 'Ocurrió un error inesperado.'),
      );
    }
  }
}
