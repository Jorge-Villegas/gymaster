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
  _initEstadisticas();
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
    // Data Layer - DataSources
    ..registerFactory<SettingLocalDataSource>(
      () => SettingLocalDataSource(
        serviceLocator(),
      ),
    )
    ..registerFactory<ConfiguracionUsuarioLocalDataSource>(
      () => ConfiguracionUsuarioLocalDataSource(
        databaseHelper: serviceLocator(),
      ),
    )
    ..registerFactory<PerfilUsuarioLocalDataSource>(
      () => PerfilUsuarioLocalDataSource(
        databaseHelper: serviceLocator(),
      ),
    )
    ..registerFactory<InformacionAplicacionLocalDataSource>(
      () => InformacionAplicacionLocalDataSource(
        databaseHelper: serviceLocator(),
      ),
    )

    // Data Layer - Repositories
    ..registerFactory<SettingRepository>(
      () => SettingRepositoryImp(
        localDataSource: serviceLocator(),
      ),
    )
    ..registerFactory<ConfiguracionUsuarioRepository>(
      () => ConfiguracionUsuarioRepositoryImpl(
        localDataSource: serviceLocator(),
      ),
    )
    ..registerFactory<PerfilUsuarioRepository>(
      () => PerfilUsuarioRepositoryImpl(
        localDataSource: serviceLocator(),
      ),
    )
    ..registerFactory<InformacionAplicacionRepository>(
      () => InformacionAplicacionRepositoryImpl(
        localDataSource: serviceLocator(),
      ),
    )

    // Domain Layer - Use Cases - Settings General
    ..registerFactory(
      () => GetLanguageUseCase(serviceLocator()),
    )
    ..registerFactory(
      () => SetLanguageUseCase(serviceLocator()),
    )
    ..registerFactory(
      () => GetThemeModeUseCase(serviceLocator()),
    )
    ..registerFactory(
      () => SetThemeModeUseCase(serviceLocator()),
    )
    ..registerFactory(
      () => GetThemeAccentUseCase(serviceLocator()),
    )
    ..registerFactory(
      () => SetThemeAccentUseCase(serviceLocator()),
    )

    // Domain Layer - Use Cases - Configuración Usuario
    ..registerFactory(
      () => ObtenerConfiguracionPorUsuarioIdUseCase(serviceLocator()),
    )
    ..registerFactory(
      () => CrearConfiguracionUsuarioUseCase(serviceLocator()),
    )
    ..registerFactory(
      () => ActualizarConfiguracionUsuarioUseCase(serviceLocator()),
    )

    // Domain Layer - Use Cases - Perfil Usuario
    ..registerFactory(
      () => ObtenerPerfilPorIdUseCase(serviceLocator()),
    )
    ..registerFactory(
      () => ActualizarPerfilUsuarioUseCase(serviceLocator()),
    )

    // Domain Layer - Use Cases - Información Aplicación
    ..registerFactory(
      () => ObtenerInformacionAplicacionUseCase(serviceLocator()),
    )
    ..registerFactory(
      () => IncrementarContadorInicioAppUseCase(serviceLocator()),
    )
    ..registerFactory(
      () => ActualizarRachaActualUseCase(serviceLocator()),
    )

    // Services Layer
    ..registerLazySingleton<NotificationServiceInterface>(
      () => NotificationService(),
    )
    ..registerLazySingleton<LocalizationServiceInterface>(
      () => LocalizationService(),
    )

    // Presentation Layer - Cubits
    ..registerFactory(
      () => SettingCubit(
        getLanguageUseCase: serviceLocator(),
        setLanguageUseCase: serviceLocator(),
        getThemeModeUseCase: serviceLocator(),
        setThemeModeUseCase: serviceLocator(),
        getThemeAccentUseCase: serviceLocator(),
        setThemeAccentUseCase: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => ConfiguracionUsuarioCubit(
        obtenerConfiguracionUseCase: serviceLocator(),
        crearConfiguracionUseCase: serviceLocator(),
        actualizarConfiguracionUseCase: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => PerfilUsuarioCubit(
        obtenerPerfilUseCase: serviceLocator(),
        actualizarPerfilUseCase: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => InformacionAplicacionCubit(
        obtenerInformacionUseCase: serviceLocator(),
        incrementarContadorInicioUseCase: serviceLocator(),
        actualizarRachaUseCase: serviceLocator(),
      ),
    )

    // Data Layer - Perfil Usuario Completo
    ..registerFactory<PerfilUsuarioCompletoLocalDataSource>(
      () => PerfilUsuarioCompletoLocalDataSourceImpl(
        databaseHelper: serviceLocator(),
        idGenerator: serviceLocator(),
      ),
    )

    // Repository - Perfil Usuario Completo
    ..registerFactory<PerfilUsuarioCompletoRepository>(
      () => PerfilUsuarioCompletoRepositoryImpl(
        localDataSource: serviceLocator(),
      ),
    )

    // Use Cases - Perfil Usuario Completo
    ..registerFactory(
      () => VerificarPerfilCompletoExisteUseCase(serviceLocator()),
    )
    ..registerFactory(
      () => ObtenerPerfilCompletoUseCase(serviceLocator()),
    )
    ..registerFactory(
      () => CrearPerfilCompletoUseCase(serviceLocator()),
    )

    // Cubit - Onboarding Usuario
    ..registerFactory(
      () => OnboardingUsuarioCubit(
        verificarPerfilCompletoExisteUseCase: serviceLocator(),
        obtenerPerfilCompletoUseCase: serviceLocator(),
        crearPerfilCompletoUseCase: serviceLocator(),
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
        verificarPerfilCompletoExisteUseCase: serviceLocator(),
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

void _initEstadisticas() {
  serviceLocator
    // Data Layer - DataSource
    ..registerFactory<EstadisticasLocalDataSource>(
      () => EstadisticasLocalDataSource(
        serviceLocator(),
      ),
    )

    // Data Layer - Repository
    ..registerFactory<EstadisticasRepository>(
      () => EstadisticasRepositoryImpl(
        serviceLocator(),
      ),
    )

    // Domain Layer - UseCases
    ..registerFactory(
      () => ObtenerProgresoEjercicioUseCase(serviceLocator()),
    )
    ..registerFactory(
      () => ObtenerDistribucionMuscularUseCase(serviceLocator()),
    )
    ..registerFactory(
      () => ObtenerRankingEjerciciosUseCase(serviceLocator()),
    )
    ..registerFactory(
      () => ObtenerMusculosOlvidadosUseCase(serviceLocator()),
    )
    ..registerFactory(
      () => ObtenerResumenGeneralUseCase(serviceLocator()),
    )

    // Presentation Layer - Cubit
    ..registerFactory(
      () => EstadisticasCubit(
        obtenerDistribucionMuscularUseCase: serviceLocator(),
        obtenerRankingEjerciciosUseCase: serviceLocator(),
        obtenerMusculosOlvidadosUseCase: serviceLocator(),
        obtenerResumenGeneralUseCase: serviceLocator(),
      ),
    );
}
