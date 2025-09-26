import 'package:flutter/material.dart';

class ElementoMenuModelo {
  ElementoMenuModelo({
    this.id,
    this.titulo = "",
    required this.icono,
    this.ruta,
    this.accion,
    this.indiceNavegacion,
  });

  final String? id;
  final String titulo;
  final IconData icono;
  final String? ruta;
  final VoidCallback? accion;
  final int? indiceNavegacion;

  // Elementos del menú principal de navegación
  static List<ElementoMenuModelo> elementosNavegacion = [
    ElementoMenuModelo(
      id: 'rutinas',
      titulo: 'Mis Rutinas',
      icono: Icons.fitness_center,
      ruta: '/rutinas',
    ),
    ElementoMenuModelo(
      id: 'ejercicios',
      titulo: 'Catálogo de Ejercicios',
      icono: Icons.sports_gymnastics,
      ruta: '/ejercicios',
    ),
    ElementoMenuModelo(
      id: 'progreso',
      titulo: 'Mi Progreso',
      icono: Icons.trending_up,
      ruta: '/progreso',
    ),
  ];

  // Elementos del menú de seguimiento y estadísticas
  static List<ElementoMenuModelo> elementosSeguimiento = [
    ElementoMenuModelo(
      id: 'historial',
      titulo: 'Historial de Entrenamientos',
      icono: Icons.history,
      ruta: '/historial',
    ),
    ElementoMenuModelo(
      id: 'estadisticas',
      titulo: 'Estadísticas',
      icono: Icons.analytics,
      ruta: '/estadisticas',
    ),
    ElementoMenuModelo(
      id: 'objetivos',
      titulo: 'Mis Objetivos',
      icono: Icons.flag,
      ruta: '/objetivos',
    ),
  ];

  // Elemento para configuraciones
  static List<ElementoMenuModelo> elementosConfiguracion = [
    ElementoMenuModelo(
      id: 'configuracion',
      titulo: 'Configuración',
      icono: Icons.settings,
      ruta: '/configuracion',
    ),
  ];
}
