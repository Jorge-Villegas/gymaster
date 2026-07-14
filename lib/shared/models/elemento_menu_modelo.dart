import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

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
      icono: IconsaxPlusLinear.weight,
      ruta: '/rutinas',
    ),
    ElementoMenuModelo(
      id: 'ejercicios',
      titulo: 'Catálogo de Ejercicios',
      icono: IconsaxPlusLinear.weight,
      ruta: '/ejercicios',
    ),
    ElementoMenuModelo(
      id: 'progreso',
      titulo: 'Mi Progreso',
      icono: IconsaxPlusLinear.trend_up,
      ruta: '/progreso',
    ),
  ];

  // Elementos del menú de seguimiento y estadísticas
  static List<ElementoMenuModelo> elementosSeguimiento = [
    ElementoMenuModelo(
      id: 'historial',
      titulo: 'Historial de Entrenamientos',
      icono: IconsaxPlusLinear.clock_1,
      ruta: '/historial',
    ),
    ElementoMenuModelo(
      id: 'estadisticas',
      titulo: 'Estadísticas',
      icono: IconsaxPlusLinear.chart_2,
      ruta: '/estadisticas',
    ),
    ElementoMenuModelo(
      id: 'objetivos',
      titulo: 'Mis Objetivos',
      icono: IconsaxPlusLinear.flag,
      ruta: '/objetivos',
    ),
  ];

  // Elemento para configuraciones
  static List<ElementoMenuModelo> elementosConfiguracion = [
    ElementoMenuModelo(
      id: 'configuracion',
      titulo: 'Configuración',
      icono: IconsaxPlusLinear.setting_2,
      ruta: '/configuracion',
    ),
  ];
}
