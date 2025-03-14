import 'package:go_router/go_router.dart';
import 'package:gymaster/features/record/presentation/pages/historial_ejercicios_page.dart';
import 'package:gymaster/features/routine/presentation/pages/agregar_ejercicios_page.dart';
import 'package:gymaster/features/routine/presentation/pages/agregar_ejercicios_rutina_page.dart';
import 'package:gymaster/features/routine/presentation/pages/agregar_rutina_page.dart';
import 'package:gymaster/features/routine/presentation/pages/detalle_ejercicio_page.dart';
import 'package:gymaster/features/routine/presentation/pages/detalle_rutina_page.dart';
import 'package:gymaster/features/routine/presentation/pages/lista_rutina_page.dart';
import 'package:gymaster/features/routine/presentation/pages/listar_ejercicios_page.dart';
import 'package:gymaster/features/setting/presentation/pages/setting_page.dart';
import 'package:gymaster/shared/widgets/barra_navegacion.dart';
import 'package:gymaster/shared/widgets/loading_dialog_page.dart';
import 'package:gymaster/theme_preview_page.dart';

/// Configuración de GoRouter
final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    //-----------------------------------------
    //                Rutinas
    //-----------------------------------------
    GoRoute(
      path: '/theme-preview',
      name: 'themePreview',
      builder: (context, state) => ThemePreviewPage(),
    ),
    GoRoute(
      path: '/',
      name: 'listaRutinas',
      builder: (context, state) => const BottomNavigationBarExampleApp(),
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
          sessionId: state.pathParameters['sesionId']!,
          musculoId: state.pathParameters['musculoId']!,
          nombreMusculo: state.pathParameters['nombreMusculo']!,
          rutinaId: state.pathParameters['rutinaId']!,
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
          sesionId: state.pathParameters['sesionId']!,
          ejercicioId: state.pathParameters['ejercicioId']!,
          rutinaId: state.pathParameters['rutinaId']!,
          ejercicioNombre: state.pathParameters['ejercicioNombre']!,
          ejercicioImagenDireccion: data?['ejercicioImagenDireccion'],
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
    //                Pruebas
    //-----------------------------------------
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingPage(),
    ),
    //-----------------------------------------
    //                Setting
    //-----------------------------------------
    GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    GoRoute(
      path: '/business',
      builder: (context, state) => const BusinessPage(),
    ),
    GoRoute(path: '/school', builder: (context, state) => const SchoolPage()),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsPage(),
    ),
    //-----------------------------------------
    //                Historial
    //-----------------------------------------
    GoRoute(
      path: '/record',
      builder: (context, state) => HistorialEjerciciosPage(),
    ),
  ],
);
