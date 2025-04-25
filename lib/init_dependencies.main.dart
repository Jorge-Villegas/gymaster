part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initDatabaseHelper();
  _initRoutine();
  _initIdGenerator();
  _initSettings();
  _initRecord();
  _initExercise();
}

void _initDatabaseHelper() {
  serviceLocator.registerLazySingleton<DatabaseHelper>(
    () => DatabaseHelper.instance,
  );
}

void _initIdGenerator() {
  serviceLocator.registerLazySingleton<IdGenerator>(() => UuidGenerator());
}

void _initRoutine() {
  serviceLocator
    // Data source
    ..registerFactory<RoutineLocalDataSource>(
      () => RoutineLocalDataSource(serviceLocator(), serviceLocator()),
    )
    // Repository
    ..registerFactory<RoutineRepository>(
      () => RoutineRepositoryImpl(
        localDataSource: serviceLocator(),
        idGenerator: serviceLocator(),
      ),
    )
    // Use cases
    ..registerFactory(() => AddRoutineUseCase(serviceLocator()))
    ..registerFactory(() => DeleteRoutineUseCase(serviceLocator()))
    ..registerFactory(() => GetAllRoutineUsecase(serviceLocator()))
    ..registerFactory(() => GetAllSerieUseCase(serviceLocator()))
    ..registerFactory(() => GetAllMusculoUsecase(serviceLocator()))
    ..registerFactory(() => GetAllEjerciciosByMusculoUseCase(serviceLocator()))
    ..registerFactory(() => AddEjercicioRutinaUsecase(serviceLocator()))
    ..registerFactory(() => GetAllEjerciciosByRutinaUseCase(serviceLocator()))
    ..registerFactory(() => UpdateSerieUseCase(serviceLocator()))
    ..registerFactory(() => GetRoutineByNameUseCase(serviceLocator()))
    ..registerFactory(() => DeleteEjercicioRutinaUseCase(serviceLocator()))
    ..registerFactory(() => StartRoutineSessionUseCase(serviceLocator()))
    ..registerFactory(() => StopRoutineSessionUseCase(serviceLocator()))
    ..registerFactory(() => CompleteRoutineSessionUseCase(serviceLocator()))
    ..registerFactory(() => UpdateExerciseStatusUseCase(serviceLocator()))
    ..registerCachedFactory(
      () => GetLastRoutineSessionByRoutineId(serviceLocator()),
    )
    //Cubit
    ..registerFactory(
      () => RoutineCubit(
        addRoutineUseCase: serviceLocator(),
        getAllRoutineUseCase: serviceLocator(),
        deleteRoutineUseCase: serviceLocator(),
        getRoutineByNameUseCase: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => MusculoCubit(getAllMusculoUsecase: serviceLocator()),
    )
    ..registerFactory(() => SerieCubit(getAllSerieUseCase: serviceLocator()))
    ..registerFactory(
      () => EjercicioCubit(
        getLastRoutineSessionByRoutineId: serviceLocator(),
        getAllEjerciciosByMusculoUseCase: serviceLocator(),
        getAllEjerciciosByRutinaUseCase: serviceLocator(),
      ),
    )
    ..registerFactory(() => AgregarSeriesCubit(serviceLocator()))
    ..registerFactory(
      () => EjerciciosByRutinaCubit(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    )
    ..registerFactory(() => RealizacionEjercicioCubit())
    ..registerFactory(() => RealizarEjercicioRutinaCubit(serviceLocator()));
}

void _initSettings() {
  serviceLocator
    // Data Source
    ..registerFactory<SettingLocalDataSource>(
      () => SettingLocalDataSource(serviceLocator()),
    )
    // Repository
    ..registerFactory<SettingRepository>(
      () => SettingRepositoryImp(localDataSource: serviceLocator()),
    )
    // Use Case
    ..registerFactory(() => SetThemeModeUseCase(serviceLocator()))
    ..registerFactory(() => GetThemeModeUseCase(serviceLocator()))
    ..registerFactory(() => SetLanguageUseCase(serviceLocator()))
    ..registerFactory(() => GetLanguageUseCase(serviceLocator()))
    ..registerCachedFactory(
      () => GetAllCompletedRoutinesWithExercises(serviceLocator()),
    )
    // Cubit
    ..registerFactory(
      () => SettingCubit(
        getLanguageUseCase: serviceLocator(),
        getThemeModeUseCase: serviceLocator(),
        setLanguageUseCase: serviceLocator(),
        setThemeModeUseCase: serviceLocator(),
      ),
    );
}

void _initRecord() {
  serviceLocator
    // Data sources
    ..registerFactory<RecordLocalDataSource>(
      () => RecordLocalDataSource(serviceLocator()),
    )
    // Cubit
    ..registerFactory(
      () => RecordCubit(
        getAllCompletedRoutinesWithExercises: serviceLocator(),
        getRutinaByIdUseCase: serviceLocator(),
        saveRutinaUseCase: serviceLocator(),
        deleteRutinaUseCase: serviceLocator(),
      ),
    )
    ..registerFactory(() => SelectedRoutineCubit()) // Nuevo Cubit
    // Use cases
    ..registerLazySingleton(
      () => GetRutinaByIdUseCase(repository: serviceLocator()),
    )
    ..registerLazySingleton(
      () => SaveRutinaUseCase(repository: serviceLocator()),
    )
    ..registerLazySingleton(
      () => DeleteRutinaUseCase(repository: serviceLocator()),
    )
    // Repository
    ..registerLazySingleton<RecordRepository>(
      () => RecordRepositoryImpl(localDataSource: serviceLocator()),
    );
}

void _initExercise() {
  serviceLocator
    // Data sources
    ..registerFactory<ExerciseLocalDataSource>(
      () => ExerciseLocalDataSource(serviceLocator()),
    )
    // Repository
    ..registerLazySingleton<ExerciseRepository>(
      () => ExerciseRepositoryImpl(localDataSource: serviceLocator()),
    )
    // Use cases
    ..registerFactory(() => GetAllExercisesUseCase(serviceLocator()))
    ..registerFactory(() => GetExercisesByMuscleUseCase(serviceLocator()))
    // Cubit
    ..registerFactory(
      () => ExerciseCubit(
        getAllExercisesUseCase: serviceLocator(),
        getExercisesByMuscleUseCase: serviceLocator(),
      ),
    );
}
