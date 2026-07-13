import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gymaster/app_router.dart';
import 'package:gymaster/core/database/database_helper.dart';
import 'package:gymaster/core/theme/gym_theme.dart';
import 'package:gymaster/features/record/presentation/cubit/record_cubit.dart';
import 'package:gymaster/features/record/presentation/cubit/selected_routine/selected_routine_cubit.dart';
import 'package:gymaster/features/routine/presentation/cubits/agregar_series/agregar_series_cubit.dart';
import 'package:gymaster/features/routine/presentation/cubits/ejercicio/ejercicio_cubit.dart';
import 'package:gymaster/features/routine/presentation/cubits/ejercicios_by_rutina/ejercicios_by_rutina_cubit.dart';
import 'package:gymaster/features/routine/presentation/cubits/musculo/musculo_cubit.dart';
import 'package:gymaster/features/routine/presentation/cubits/realizacion_ejercicio/realizacion_ejercicio_cubit.dart';
import 'package:gymaster/features/routine/presentation/cubits/realizar_ejercicio_rutina/realizar_ejercicio_rutina_cubit.dart';
import 'package:gymaster/features/routine/presentation/cubits/rutina/routine_cubit.dart';
import 'package:gymaster/features/routine/presentation/cubits/serie/serie_cubit.dart';
import 'package:gymaster/features/setting/presentation/cubits/setting_cubit.dart';
import 'package:gymaster/features/setting/presentation/cubits/setting_state.dart';
import 'package:gymaster/features/setting/presentation/cubits/app_start_cubit.dart';
import 'package:gymaster/features/setting/presentation/cubits/onboarding/onboarding_cubit.dart';
import 'package:gymaster/features/setting/presentation/cubits/onboarding_usuario_cubit.dart';
import 'package:gymaster/init_dependencies.dart';
import 'package:gymaster/features/exercise/presentation/cubits/exercise/exercise_cubit.dart';
import 'package:gymaster/features/exercise/presentation/cubits/favorito_ejercicio_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDependencies();

  await DatabaseHelper.instance.database;

  runApp(const Proveedores());
}

class Proveedores extends StatelessWidget {
  const Proveedores({super.key});
  @override
  Widget build(BuildContext context) {
    DatabaseHelper.instance.database;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<RoutineCubit>()),
        BlocProvider(create: (_) => serviceLocator<SerieCubit>()),
        BlocProvider(create: (_) => serviceLocator<MusculoCubit>()),
        BlocProvider(create: (_) => serviceLocator<EjercicioCubit>()),
        BlocProvider(create: (_) => serviceLocator<AgregarSeriesCubit>()),
        BlocProvider(create: (_) => serviceLocator<EjerciciosByRutinaCubit>()),
        BlocProvider(
            create: (_) => serviceLocator<RealizacionEjercicioCubit>()),
        BlocProvider(
            create: (_) => serviceLocator<RealizarEjercicioRutinaCubit>()),
        BlocProvider(create: (_) => serviceLocator<SettingCubit>()),
        BlocProvider(create: (_) => serviceLocator<AppStartCubit>()),
        BlocProvider(create: (_) => serviceLocator<OnboardingCubit>()),
        BlocProvider(create: (_) => serviceLocator<OnboardingUsuarioCubit>()),
        BlocProvider(create: (_) => serviceLocator<RecordCubit>()),
        BlocProvider(create: (_) => serviceLocator<SelectedRoutineCubit>()),
        BlocProvider(create: (_) => serviceLocator<ExerciseCubit>()),
        BlocProvider(create: (_) => serviceLocator<FavoritoEjercicioCubit>()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingCubit, SettingState>(
      builder: (context, state) {
        bool isDarkMode = false;

        if (state is SettingLoaded) {
          isDarkMode = state.isDarkMode;
        }

        return MaterialApp.router(
          locale: const Locale('es', 'US'),
          localizationsDelegates: const [
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [Locale('es', 'US')],
          debugShowCheckedModeBanner: false,
          title: 'GyMaster',
          routerConfig: router,
          theme: GymTheme.light,
          darkTheme: GymTheme.dark,
          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
        );
      },
    );
  }
}
