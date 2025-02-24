import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/database/models/models.dart';
import 'package:gymaster/core/database/seeders/database_seeder.dart';
import 'package:gymaster/core/database/seeders/ejercicio_rutina_seeder.dart';
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
          .EjerciciosDeRutinaModel.fromDatabase(rutina, ejerciciosConDetalles);

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
                ? 'completed'
                : 'not completed', //TODO: Cambiar a enum
        restTime: tiempoDescanso,
      );

      final success = await localDataSource.updateSerie(updatedSerie);

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
}
