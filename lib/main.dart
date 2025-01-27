// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gymaster/app_router.dart';
import 'package:gymaster/core/database/database_helper.dart';
import 'package:gymaster/core/theme/app_theme.dart';
import 'package:gymaster/features/routine/presentation/cubits/agregar_series/agregar_series_cubit.dart';
import 'package:gymaster/features/routine/presentation/cubits/ejercicio/ejercicio_cubit.dart';
import 'package:gymaster/features/routine/presentation/cubits/ejercicios_by_rutina/ejercicios_by_rutina_cubit.dart';
import 'package:gymaster/features/routine/presentation/cubits/musculo/musculo_cubit.dart';
import 'package:gymaster/features/routine/presentation/cubits/realizacion_ejercicio/realizacion_ejercicio_cubit.dart';
import 'package:gymaster/features/routine/presentation/cubits/realizar_ejercicio_rutina/realizar_ejercicio_rutina_cubit.dart';
import 'package:gymaster/features/routine/presentation/cubits/rutina/routine_cubit.dart';
import 'package:gymaster/features/routine/presentation/cubits/serie/serie_cubit.dart';
import 'package:gymaster/features/setting/presentation/cubit/setting_cubit.dart';
import 'package:gymaster/features/setting/presentation/cubit/setting_state.dart';
import 'package:gymaster/init_dependencies.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDependencies();

  // Inicializa la base de datos
  await DatabaseHelper.instance.database;

  final sharedPreferences = await SharedPreferences.getInstance();

  // Ejecuta la aplicación
  runApp(const Proveedores());
}

/// Widget que proporciona los proveedores de Bloc a la aplicación.
class Proveedores extends StatelessWidget {
  const Proveedores({super.key});
  @override
  Widget build(BuildContext context) {
    DatabaseHelper.instance.database;
    return MultiBlocProvider(
      providers: [
        // Proveedores de los diferentes Cubits utilizados en la aplicación
        BlocProvider(create: (_) => serviceLocator<RoutineCubit>()),
        BlocProvider(create: (_) => serviceLocator<SerieCubit>()),
        BlocProvider(create: (_) => serviceLocator<MusculoCubit>()),
        BlocProvider(create: (_) => serviceLocator<EjercicioCubit>()),
        // BlocProvider(create: (_) => serviceLocator<ConfiguracionCubit>()),
        BlocProvider(create: (_) => serviceLocator<AgregarSeriesCubit>()),
        BlocProvider(create: (_) => serviceLocator<EjerciciosByRutinaCubit>()),
        BlocProvider(
            create: (_) => serviceLocator<RealizacionEjercicioCubit>()),
        BlocProvider(
            create: (_) => serviceLocator<RealizarEjercicioRutinaCubit>()),
        BlocProvider(create: (_) => serviceLocator<SettingCubit>()),
      ],
      child: const MyApp(),
    );
  }
}

/// Widget principal de la aplicación.
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
          // Configuración de localización de la aplicación
          locale: const Locale('es', 'US'),
          localizationsDelegates: const [
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('es', 'US'),
          ],
          debugShowCheckedModeBanner: true,
          title: 'GyMaster',
          routerConfig: router,
          // Configuración del tema de la aplicación
          theme: isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
        );
      },
    );
  }
}
