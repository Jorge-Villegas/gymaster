import 'package:go_router/go_router.dart';
import 'package:gymaster/features/routine/presentation/pages/agregar_ejercicios_page.dart';
import 'package:gymaster/features/routine/presentation/pages/agregar_ejercicios_rutina_page.dart';
import 'package:gymaster/features/routine/presentation/pages/detalle_ejercicio_page.dart';
import 'package:gymaster/features/routine/presentation/pages/detalle_rutina_page.dart';
import 'package:gymaster/features/routine/presentation/pages/lista_rutina_screen.dart';
import 'package:gymaster/features/routine/presentation/pages/listar_ejercicios_page.dart';
import 'package:gymaster/features/routine/presentation/pages/agregar_rutina_page.dart';
import 'package:go_router/go_router.dart';

/// Configuración de GoRouter
final GoRouter router = GoRouter( 
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'listaRutinas',
      builder: (context, state) => const ListaRutinasPage(),
    ),
    GoRoute(
      path: '/agregar-ejercicios/:rutinaId',
      name: 'agregarEjercicios',
      builder: (context, state) {
        final rutinaId = state.pathParameters['rutinaId']!;
        return AgregarEjerciciosPage(rutinaid: rutinaId);
      },
    ),
    GoRoute(
      path: '/listar-ejercicios/:musculoId/:nombreMusculo/:rutinaId',
      name: 'listarEjercicios',
      builder: (context, state) {
        final musculoId = state.pathParameters['musculoId']!;
        final nombreMusculo = state.pathParameters['nombreMusculo']!;
        final rutinaId = state.pathParameters['rutinaId']!;
        return ListarEjerciciosPage(
          musculoId: musculoId,
          nombreMusculo: nombreMusculo,
          rutinaId: rutinaId,
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
          ejercicioImagenDireccion:
              data?['ejercicioImagenDireccion'],
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
  ],
);
