// ignore_for_file: depend_on_referenced_packages
import 'package:gymaster/core/database/database_helper.dart';
import 'package:gymaster/core/theme/app_colors.dart';
import 'package:gymaster/features/routine/presentation/cubits/agregar_series/agregar_series_cubit.dart';
import 'package:gymaster/features/routine/presentation/cubits/ejercicio/ejercicio_cubit.dart';
import 'package:gymaster/features/routine/presentation/cubits/ejercicios_by_rutina/ejercicios_by_rutina_cubit.dart';
import 'package:gymaster/features/routine/presentation/cubits/musculo/musculo_cubit.dart';
import 'package:gymaster/features/routine/presentation/cubits/realizacion_ejercicio/realizacion_ejercicio_cubit.dart';
import 'package:gymaster/features/routine/presentation/cubits/realizar_ejercicio_rutina/realizar_ejercicio_rutina_cubit.dart';
import 'package:gymaster/features/routine/presentation/cubits/rutina/routine_cubit.dart';
import 'package:gymaster/features/routine/presentation/cubits/serie/serie_cubit.dart';
import 'package:gymaster/features/routine/presentation/pages/lista_rutina_screen.dart';
import 'package:gymaster/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Punto de entrada principal de la aplicación.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDependencies();

  // Inicializa la base de datos
  await DatabaseHelper.instance.database;

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
    return MaterialApp(
      // Configuración de localización de la aplicación
      locale: const Locale('es', 'US'),
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      // Configuración de localización de la aplicación
      supportedLocales: const [
        Locale('es', 'US'),
      ],
      // Fin de la configuración de localización
      debugShowCheckedModeBanner: false,
      title: 'GyMaster',
      // Pantalla principal de la aplicación
      home: const ListaRutinasPage(),
      // Configuración del tema de la aplicación
      theme: ThemeData(
        useMaterial3: true,
        //scaffoldBackgroundColor: AppColors.backgroundLight,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          elevation: 0,
        ),
        fontFamily: 'ZonaPro',
        // fontFamily: 'Roboto',
        primaryColor: AppColors.primary,
      ),
    );
  }
}
