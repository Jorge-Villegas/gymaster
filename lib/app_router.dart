import 'package:go_router/go_router.dart';
import 'package:gymaster/features/routine/presentation/pages/agregar_ejercicios_page.dart';
import 'package:gymaster/features/routine/presentation/pages/agregar_ejercicios_rutina_page.dart';
import 'package:gymaster/features/routine/presentation/pages/detalle_ejercicio_page.dart';
import 'package:gymaster/features/routine/presentation/pages/lista_rutina_screen.dart';
import 'package:gymaster/features/routine/presentation/pages/listar_ejercicios_page.dart';
import 'package:gymaster/features/routine/presentation/pages/agregar_rutina_page.dart';
import 'package:gymaster/features/routine/domain/entities/ejercicio.dart';

/// Configuración de GoRouter
final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
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
      path: '/agregar-rutina',
      name: 'agregarRutina',
      builder: (context, state) => const AgregarRutinaPage(),
    ),
    GoRoute(
      path: '/agregar-ejercicio-rutina',
      name: 'agregarEjercicioRutina',
      builder: (context, state) {
        final ejercicio = state.extra as Ejercicio;
        final rutinaId = state.pathParameters['rutinaId']!;
        return AgregarEjercicioRutinaPage(
          ejercicioNombre: ejercicio.nombre,
          ejercicioImagenDireccion: ejercicio.imagenDireccion,
          ejercicioId: ejercicio.id,
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
  ],
);
