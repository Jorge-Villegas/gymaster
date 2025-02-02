import 'package:go_router/go_router.dart';
import 'package:gymaster/features/record/presentation/pages/historial_ejercicios_page.dart';
import 'package:gymaster/features/routine/presentation/pages/agregar_ejercicios_page.dart';
import 'package:gymaster/features/routine/presentation/pages/agregar_ejercicios_rutina_page.dart';
import 'package:gymaster/features/routine/presentation/pages/agregar_rutina_page.dart';
import 'package:gymaster/features/routine/presentation/pages/detalle_ejercicio_page.dart';
import 'package:gymaster/features/routine/presentation/pages/detalle_rutina_page.dart';
import 'package:gymaster/features/routine/presentation/pages/lista_rutina_screen.dart';
import 'package:gymaster/features/routine/presentation/pages/listar_ejercicios_page.dart';
import 'package:gymaster/features/setting/presentation/pages/setting_page.dart';
import 'package:gymaster/shared/widgets/barra_navegacion.dart';
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
      builder: (context, state) => BottomNavigationBarExampleApp(),
    ),
    GoRoute(
      path: '/agregar-ejercicios/:rutinaId',
      name: 'agregarEjercicios',
      builder: (context, state) {
        return AgregarEjerciciosPage(
            rutinaid: state.pathParameters['rutinaId']!);
      },
    ),
    GoRoute(
      path: '/listar-ejercicios/:musculoId/:nombreMusculo/:rutinaId',
      name: 'listarEjercicios',
      builder: (context, state) {
        return ListarEjerciciosPage(
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
      path: '/agregar-ejercicio-rutina/:rutinaId/:ejercicioId/:ejercicioNombre',
      name: 'agregarEjercicioRutina',
      builder: (context, state) {
        // Extrae el objeto enviado a través de "extra".
        final data = state.extra as Map<String, dynamic>?;
        return AgregarEjercicioRutinaPage(
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
        return DetalleRutinaScreen(
          rutinaId: state.pathParameters['rutinaId']!,
        );
      },
    ),

    //-----------------------------------------
    //                Pruebas
    //-----------------------------------------
    GoRoute(
      path: '/settings',
      builder: (context, state) => SettingPage(),
    ),
    //-----------------------------------------
    //                Setting
    //-----------------------------------------
    GoRoute(
      path: '/home',
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      path: '/business',
      builder: (context, state) => BusinessPage(),
    ),
    GoRoute(
      path: '/school',
      builder: (context, state) => SchoolPage(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => SettingsPage(),
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
