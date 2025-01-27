part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initRoutine();
  _initIdGenerator();
  _initSettings();
}

void _initIdGenerator() {
  serviceLocator.registerLazySingleton<IdGenerator>(() => UuidGenerator());
}

void _initRoutine() {
  serviceLocator
    // Data source
    ..registerFactory<RoutineLocalDataSource>(() => RoutineLocalDataSource())

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

    //Cubit
    ..registerFactory(() => RoutineCubit(
          addRoutineUseCase: serviceLocator(),
          getAllRoutineUseCase: serviceLocator(),
          deleteRoutineUseCase: serviceLocator(),
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
    ..registerFactory<SettingLocalDataSource>(() => SettingLocalDataSource())

    // Repository
    ..registerFactory<SettingRepository>(
      () => SettingRepositoryImp(localDataSource: serviceLocator()),
    )
    // Use Case
    ..registerFactory(() => SetThemeModeUseCase(repository: serviceLocator()))
    ..registerFactory(() => GetThemeModeUseCase(repository: serviceLocator()))
    ..registerFactory(() => SetLanguageUseCase(repository: serviceLocator()))
    ..registerFactory(() => GetLanguageUseCase(repository: serviceLocator()))

    // Cubit
    ..registerFactory(() => SettingCubit(
          getLanguageUseCase: serviceLocator(),
          getThemeModeUseCase: serviceLocator(),
          setLanguageUseCase: serviceLocator(),
          setThemeModeUseCase: serviceLocator(),
        ));
}
