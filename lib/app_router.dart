import 'package:go_router/go_router.dart';
import 'package:gymaster/features/record/presentation/pages/historial_ejercicios_page.dart';
import 'package:gymaster/features/routine/presentation/pages/agregar_ejercicios_page.dart';
import 'package:gymaster/features/routine/presentation/pages/agregar_ejercicios_rutina_page.dart';
import 'package:gymaster/features/routine/presentation/pages/agregar_rutina_page.dart';
import 'package:gymaster/features/routine/presentation/pages/detalle_ejercicio_page.dart';
import 'package:gymaster/features/routine/presentation/pages/detalle_rutina_page.dart';
import 'package:gymaster/features/routine/presentation/pages/lista_rutina_page.dart';
import 'package:gymaster/features/routine/presentation/pages/listar_ejercicios_page.dart';
import 'package:gymaster/features/setting/presentation/pages/app_start_page.dart';
import 'package:gymaster/features/setting/presentation/pages/onboarding_contenedor_unificado_page.dart';
import 'package:gymaster/features/setting/presentation/pages/onboarding_bienvenida_page.dart';
import 'package:gymaster/features/setting/presentation/pages/setting_page.dart';
import 'package:gymaster/shared/widgets/barra_navegacion.dart';
import 'package:gymaster/shared/widgets/loading_dialog_page.dart';
import 'package:gymaster/features/exercise/domain/entities/exercise.dart';

import 'package:gymaster/features/exercise/presentation/pages/exercise_detail_page.dart';
import 'package:gymaster/features/exercise/presentation/pages/favorites_page.dart';

/// Configuración de GoRouter
final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    //-----------------------------------------
    //                Rutinas
    //-----------------------------------------
    GoRoute(
      path: '/',
      name: 'appStart',
      builder: (context, state) => const AppStartPage(),
    ),
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (context, state) => const OnboardingBienvenidaPage(),
    ),
    GoRoute(
      path: '/onboarding_unificado',
      name: 'onboarding_unificado',
      builder: (context, state) => const OnboardingContenedorUnificadoPage(),
    ),
    GoRoute(
      path: '/main',
      name: 'listaRutinas',
      builder: (context, state) {
        final initialIndex =
            int.tryParse(state.uri.queryParameters['tab'] ?? '0') ?? 0;
        return BottomNavigationBarExampleApp(initialIndex: initialIndex);
      },
    ),
    // Rutas específicas para navegar a tabs específicos
    GoRoute(
      path: '/exercise-catalog',
      name: 'exerciseCatalog',
      builder: (context, state) =>
          const BottomNavigationBarExampleApp(initialIndex: 2),
    ),
    // Ruta para la pantalla de diálogo de carga
    GoRoute(
      path: '/dialog-loading',
      name: 'dialogLoading',
      builder: (context, state) => const LoadingDialogPage(),
    ),
    GoRoute(
      path: '/agregar-ejercicios/:rutinaId/:sesionId',
      name: 'agregarEjercicios',
      builder: (context, state) {
        return AgregarEjerciciosPage(
          sesionId: state.pathParameters['sesionId']!,
          rutinaid: state.pathParameters['rutinaId']!,
        );
      },
    ),
    GoRoute(
      path: '/listar-ejercicios/:musculoId/:nombreMusculo/:rutinaId/:sesionId',
      name: 'listarEjercicios',
      builder: (context, state) {
        return ListarEjerciciosPage(
          idSesion: state.pathParameters['sesionId']!,
          idMusculo: state.pathParameters['musculoId']!,
          nombreMusculo: state.pathParameters['nombreMusculo']!,
          idRutina: state.pathParameters['rutinaId']!,
        );
      },
    ),
    GoRoute(
      path: '/detalle-ejercicio',
      name: 'detalleEjercicio',
      builder: (context, state) {
        return const DetalleEjercicioScreen();
      },
    ),
    GoRoute(
      path: '/lista-rutinas-screen',
      name: 'listaRutinasScreen',
      builder: (context, state) {
        return const ListaRutinasPage();
      },
    ),
    GoRoute(
      path:
          '/agregar-ejercicio-rutina/:rutinaId/:ejercicioId/:ejercicioNombre/:sesionId',
      name: 'agregarEjercicioRutina',
      builder: (context, state) {
        // Extrae el objeto enviado a través de "extra".
        final data = state.extra as Map<String, dynamic>?;
        return AgregarEjercicioRutinaPage(
          idSesion: state.pathParameters['sesionId']!,
          idEjercicio: state.pathParameters['ejercicioId']!,
          idRutina: state.pathParameters['rutinaId']!,
          nombreEjercicio: state.pathParameters['ejercicioNombre']!,
          direccionImagenEjercicio: data?['ejercicioImagenDireccion'],
        );
      },
    ),
    GoRoute(
      path: '/rutina/create',
      name: 'rutinaCreate',
      builder: (context, state) => const AgregarRutinaPage(),
    ),
    GoRoute(
      path: '/rutina/detalle/:rutinaId',
      name: 'detallerutina',
      builder: (constext, state) {
        return DetalleRutinaScreen(rutinaId: state.pathParameters['rutinaId']!);
      },
    ),

    //-----------------------------------------
    //                Settings
    //-----------------------------------------
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingPage(),
    ),
    //-----------------------------------------
    //                Historial
    //-----------------------------------------
    GoRoute(
      path: '/record',
      builder: (context, state) => const HistorialEjerciciosPage(),
    ),
    //-----------------------------------------
    //                Exercise
    //-----------------------------------------
    GoRoute(
      path: '/exercise-detail',
      name: 'exerciseDetail',
      builder: (context, state) {
        final exercise = state.extra as Exercise;
        return ExerciseDetailPage(exercise: exercise);
      },
    ),
    GoRoute(
      path: '/favorites',
      name: 'favorites',
      builder: (context, state) => const FavoritesPage(),
    ),
  ],
);
