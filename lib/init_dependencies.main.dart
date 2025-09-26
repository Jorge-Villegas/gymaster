part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initDatabaseHelper();
  _initRoutine();
  _initIdGenerator();
  _initSettings();
  _initRecord();
  _initExercise();
  _initEmotionalSystem();
}

void _initDatabaseHelper() {
  serviceLocator.registerLazySingleton<DatabaseHelper>(
    () => DatabaseHelper.instance,
  );
}

void _initIdGenerator() {
  serviceLocator.registerLazySingleton<IdGenerator>(() => UuidGenerator());
  serviceLocator.registerLazySingleton<UuidGenerator>(() => UuidGenerator());
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
    ..registerFactory(() => AgregarRutinaUseCase(serviceLocator()))
    ..registerFactory(() => EliminarRutinaPlantillaUseCase(serviceLocator()))
    ..registerFactory(() => ObtenerTodasLasRutinasUseCase(serviceLocator()))
    ..registerFactory(() => ObtenerTodasLasSeriesUseCase(serviceLocator()))
    ..registerFactory(() => ObtenerTodosLosMusculosUseCase(serviceLocator()))
    ..registerFactory(
        () => ObtenerEjerciciosRutinaPorMusculoUseCase(serviceLocator()))
    ..registerFactory(() => AgregarEjercicioARutinaUseCase(serviceLocator()))
    ..registerFactory(() => ObtenerEjerciciosPorRutinaUseCase(serviceLocator()))
    ..registerFactory(() => ActualizarSerieUseCase(serviceLocator()))
    ..registerFactory(() => ObtenerRutinaPorNombreUseCase(serviceLocator()))
    ..registerFactory(() => EliminarEjercicioDeRutinaUseCase(serviceLocator()))
    ..registerFactory(() => IniciarSesionRutinaUseCase(serviceLocator()))
    ..registerFactory(() => FinalizarSesionRutinaUseCase(serviceLocator()))
    ..registerFactory(() => CompletarSesionRutinaUseCase(serviceLocator()))
    ..registerFactory(() => ActualizarEstadoEjercicioUseCase(serviceLocator()))
    ..registerCachedFactory(
      () => ObtenerUltimaSesionPorRutinaIdUseCase(serviceLocator()),
    )
    ..registerFactory(() => RestoreRoutineUseCase(serviceLocator()))
    ..registerFactory(() => GetDeletedRoutinesUseCase(serviceLocator()))
    //Cubit
    ..registerFactory(
      () => RoutineCubit(
        addRoutineUseCase: serviceLocator(),
        getAllRoutineUseCase: serviceLocator(),
        deleteRoutineUseCase: serviceLocator(),
        getRoutineByNameUseCase: serviceLocator(),
        restoreRoutineUseCase: serviceLocator(),
        getDeletedRoutinesUseCase: serviceLocator(),
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
    // Repository
    ..registerLazySingleton<RecordRepository>(
      () => RecordRepositoryImpl(localDataSource: serviceLocator()),
    )
    // Use cases
    ..registerLazySingleton(
      () => ObtenerRutinaPorIdUseCase(repository: serviceLocator()),
    )
    ..registerLazySingleton(
      () => GuardarRutinaUseCase(repository: serviceLocator()),
    )
    ..registerLazySingleton(
      () => EliminarRutinaHistorialUseCase(repository: serviceLocator()),
    )
    ..registerCachedFactory(
      () => ObtenerRutinasCompletadasConEjerciciosUseCase(serviceLocator()),
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
    ..registerFactory(() => SelectedRoutineCubit()); // Nuevo Cubit
}

void _initExercise() {
  serviceLocator
    // Data sources
    ..registerFactory<ExerciseLocalDataSource>(
      () => ExerciseLocalDataSource(serviceLocator()),
    )
    ..registerFactory<FavoritoEjercicioLocalDataSource>(
      () => FavoritoEjercicioLocalDataSource(
        databaseHelper: serviceLocator(),
        uuidGenerator: serviceLocator(),
      ),
    )
    // Repository
    ..registerLazySingleton<ExerciseRepository>(
      () => ExerciseRepositoryImpl(localDataSource: serviceLocator()),
    )
    ..registerFactory<FavoritoEjercicioRepository>(
      () => FavoritoEjercicioRepositoryImpl(
        localDataSource: serviceLocator(),
        exerciseRepository: serviceLocator(),
      ),
    )
    // Use cases - Ejercicios regulares
    ..registerFactory(() => ObtenerTodosLosEjerciciosUseCase(serviceLocator()))
    ..registerFactory(
        () => ObtenerEjerciciosCatalogoPorMusculoUseCase(serviceLocator()))
    ..registerFactory(() => BuscarEjerciciosUseCase(serviceLocator()))
    // Use cases - Ejercicios favoritos
    ..registerFactory(() => AgregarEjercicioAFavoritosUseCase(serviceLocator()))
    ..registerFactory(
        () => RemoverEjercicioDeFavoritosUseCase(serviceLocator()))
    ..registerFactory(() => VerificarEjercicioFavoritoUseCase(serviceLocator()))
    ..registerFactory(() => ObtenerEjerciciosFavoritosUseCase(serviceLocator()))
    // Cubits
    ..registerFactory(
      () => ExerciseCubit(
        getAllExercisesUseCase: serviceLocator(),
        getExercisesByMuscleUseCase: serviceLocator(),
        buscarEjerciciosUseCase: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => FavoritoEjercicioCubit(
        agregarEjercicioAFavoritosUseCase: serviceLocator(),
        removerEjercicioDeFavoritosUseCase: serviceLocator(),
        verificarEjercicioFavoritoUseCase: serviceLocator(),
        obtenerEjerciciosFavoritosUseCase: serviceLocator(),
      ),
    );
}

void _initEmotionalSystem() {
  serviceLocator
    // Data sources - User Emotional
    ..registerFactory<UserEmotionalLocalDataSource>(
      () => UserEmotionalLocalDataSourceImpl(serviceLocator()),
    )

    // Data sources - Achievement
    ..registerFactory<LogroLocalDataSource>(
      () => LogroLocalDataSourceImpl(
        databaseHelper: serviceLocator(),
        idGenerator: serviceLocator(),
      ),
    )

    // Repositories
    ..registerFactory<UserEmotionalRepository>(
      () => UserEmotionalRepositoryImpl(localDataSource: serviceLocator()),
    )
    ..registerFactory<AchievementRepository>(
      () => AchievementRepositoryImpl(localDataSource: serviceLocator()),
    )

    // Use cases - User Emotional
    ..registerFactory(() => SaveUserMotivationUseCase(serviceLocator()))
    ..registerFactory(() => SaveUserMoodUseCase(serviceLocator()))
    ..registerFactory(() => GetUserMotivationUseCase(serviceLocator()))
    ..registerFactory(() => GetLatestUserMoodUseCase(serviceLocator()))
    ..registerFactory(() => IsOnboardingCompletedUseCase(serviceLocator()))
    ..registerFactory(() => MarkOnboardingCompletedUseCase(serviceLocator()))

    // Use cases - Achievement
    ..registerFactory(() => GetAchievementUseCase(serviceLocator()))

    // Cubits
    ..registerFactory(
      () => AppStartCubit(
        isOnboardingCompletedUseCase: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => OnboardingCubit(
        saveUserMotivationUseCase: serviceLocator(),
        markOnboardingCompletedUseCase: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => AchievementCubit(
        getAchievementUseCase: serviceLocator(),
        achievementRepository: serviceLocator(),
      ),
    );
}
