part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initDatabaseHelper();
  _initRoutine();
  _initIdGenerator();
  _initSettings();
  _initRecord();
}

void _initDatabaseHelper() {
  serviceLocator
      .registerLazySingleton<DatabaseHelper>(() => DatabaseHelper.instance);
}

void _initIdGenerator() {
  serviceLocator.registerLazySingleton<IdGenerator>(() => UuidGenerator());
}

void _initRoutine() {
  serviceLocator
    // Data source
    ..registerFactory<RoutineLocalDataSource>(
        () => RoutineLocalDataSource(serviceLocator()))

    // Repository
    ..registerFactory<RoutineRepository>(() => RoutineRepositoryImpl(
          localDataSource: serviceLocator(),
          idGenerator: serviceLocator(),
        ))

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

    //Cubit
    ..registerFactory(() => RoutineCubit(
          addRoutineUseCase: serviceLocator(),
          getAllRoutineUseCase: serviceLocator(),
          deleteRoutineUseCase: serviceLocator(),
          getRoutineByNameUseCase: serviceLocator(),
        ))
    ..registerFactory(() => MusculoCubit(
          getAllMusculoUsecase: serviceLocator(),
        ))
    ..registerFactory(() => SerieCubit(
          getAllSerieUseCase: serviceLocator(),
        ))
    ..registerFactory(() => EjercicioCubit(
          getAllEjerciciosByMusculoUseCase: serviceLocator(),
          getAllEjerciciosByRutinaUseCase: serviceLocator(),
        ))
    ..registerFactory(() => AgregarSeriesCubit(serviceLocator()))
    ..registerFactory(() => EjerciciosByRutinaCubit(
          serviceLocator(),
          serviceLocator(),
        ))
    ..registerFactory(() => RealizacionEjercicioCubit())
    ..registerFactory(() => RealizarEjercicioRutinaCubit(serviceLocator()));
}

void _initSettings() {
  serviceLocator
    // Data Source
    ..registerFactory<SettingLocalDataSource>(
        () => SettingLocalDataSource(serviceLocator()))

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
        () => GetAllCompletedRoutinesWithExercises(serviceLocator()))

    // Cubit
    ..registerFactory(() => SettingCubit(
          getLanguageUseCase: serviceLocator(),
          getThemeModeUseCase: serviceLocator(),
          setLanguageUseCase: serviceLocator(),
          setThemeModeUseCase: serviceLocator(),
        ));
}

void _initRecord() {
  serviceLocator
    // Data sources
    ..registerFactory<RecordLocalDataSource>(
        () => RecordLocalDataSource(databaseHelper: serviceLocator()))

    // Cubit
    ..registerFactory(() => RecordCubit(
          getAllCompletedRoutinesWithExercises: serviceLocator(),
          getAllRutinasUseCase: serviceLocator(),
          getRutinaByIdUseCase: serviceLocator(),
          saveRutinaUseCase: serviceLocator(),
          deleteRutinaUseCase: serviceLocator(),
        ))

    // Use cases
    ..registerLazySingleton(
        () => GetAllRutinasUseCase(repository: serviceLocator()))
    ..registerLazySingleton(
        () => GetRutinaByIdUseCase(repository: serviceLocator()))
    ..registerLazySingleton(
        () => SaveRutinaUseCase(repository: serviceLocator()))
    ..registerLazySingleton(
        () => DeleteRutinaUseCase(repository: serviceLocator()))

    // Repository
    ..registerLazySingleton<RecordRepository>(
      () => RecordRepositoryImpl(localDataSource: serviceLocator()),
    );
}
