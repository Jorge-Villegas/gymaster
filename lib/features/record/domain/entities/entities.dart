import 'package:flutter/material.dart';

class RecordEntity {
  // ...
  // An entity represents a real-world object with a distinct identity.
}

class RecordEjercicios {
  final String nombre;
  final List<String> series;
  final IconData icono;

  RecordEjercicios({
    required this.nombre,
    required this.series,
    required this.icono,
  });

  factory RecordEjercicios.fromMap(Map<String, dynamic> map) {
    return RecordEjercicios(
      nombre: map['nombre'],
      series: List<String>.from(map['series']),
      icono: map['icono'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'series': series,
      'icono': icono,
    };
  }
}
