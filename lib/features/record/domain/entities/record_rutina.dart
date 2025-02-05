import 'package:gymaster/core/database/models/ejercicio.dart';
import 'package:gymaster/core/database/models/rutina.dart';
import 'package:gymaster/core/database/models/serie.dart';

class RecordRutina {
  final String nombre;
  final DateTime fechaRealizada;
  final String tiempoRealizado;
  final int color;
  final List<RecordEjercicios> ejercicios;

  RecordRutina({
    required this.nombre,
    required this.fechaRealizada,
    required this.tiempoRealizado,
    required this.color,
    required this.ejercicios,
  });

  RecordRutina copyWith({
    String? nombre,
    DateTime? fechaRealizada,
    String? tiempoRealizado,
    int? color,
    List<RecordEjercicios>? ejercicios,
  }) {
    return RecordRutina(
      nombre: nombre ?? this.nombre,
      fechaRealizada: fechaRealizada ?? this.fechaRealizada,
      tiempoRealizado: tiempoRealizado ?? this.tiempoRealizado,
      color: color ?? this.color,
      ejercicios: ejercicios ?? this.ejercicios,
    );
  }

  factory RecordRutina.fromDatabase({
    required Rutina rutinaDB,
    int? cantidadEjercicios,
  }) {
    return RecordRutina(
      nombre: rutinaDB.nombre,
      fechaRealizada: DateTime.parse(rutinaDB.fechaCreacion),
      tiempoRealizado: 'no hay tiempo',
      color: rutinaDB.color,
      ejercicios: [],
    );
  }
}

class RecordEjercicios {
  final String nombre;
  final List<String> series;
  final String iconoPath;
  final List<SeriesDelEjercicio> seriesDelEjercicio;

  RecordEjercicios({
    required this.nombre,
    required this.series,
    required this.iconoPath,
    required this.seriesDelEjercicio,
  });

  RecordEjercicios copyWith({
    String? nombre,
    List<String>? series,
    String? iconoPath,
    List<SeriesDelEjercicio>? seriesDelEjercicio,
  }) {
    return RecordEjercicios(
      nombre: nombre ?? this.nombre,
      series: series ?? this.series,
      iconoPath: iconoPath ?? this.iconoPath,
      seriesDelEjercicio: seriesDelEjercicio ?? this.seriesDelEjercicio,
    );
  }

  factory RecordEjercicios.fromDatabase({
    required Ejercicio ejercicioDB,
    required List<SeriesDelEjercicio> seriesDelEjercicio,
  }) {
    return RecordEjercicios(
      nombre: ejercicioDB.nombre,
      series: [],
      iconoPath: ejercicioDB.imagenDireccion ?? '',
      seriesDelEjercicio: seriesDelEjercicio,
    );
  }
}

class SeriesDelEjercicio {
  final double peso;
  final int repeticiones;

  SeriesDelEjercicio({
    required this.peso,
    required this.repeticiones,
  });

  SeriesDelEjercicio copyWith({
    double? peso,
    int? repeticiones,
  }) {
    return SeriesDelEjercicio(
      peso: peso ?? this.peso,
      repeticiones: repeticiones ?? this.repeticiones,
    );
  }

  factory SeriesDelEjercicio.fromDatabase({
    required Serie serieDB,
  }) {
    return SeriesDelEjercicio(
      peso: serieDB.peso,
      repeticiones: serieDB.repeticiones,
    );
  }
}
