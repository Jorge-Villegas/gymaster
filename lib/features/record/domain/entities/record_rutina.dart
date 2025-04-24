import 'package:gymaster/core/database/models/models.dart';

class RecordRutina {
  final String id;
  final String nombre;
  final DateTime fechaRealizada;
  final String tiempoRealizado;
  final int color;
  final List<RecordEjercicios> ejercicios;

  RecordRutina({
    required this.id,
    required this.nombre,
    required this.fechaRealizada,
    required this.tiempoRealizado,
    required this.color,
    required this.ejercicios,
  });

  RecordRutina copyWith({
    String? id,
    String? nombre,
    DateTime? fechaRealizada,
    String? tiempoRealizado,
    int? color,
    List<RecordEjercicios>? ejercicios,
  }) {
    return RecordRutina(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      fechaRealizada: fechaRealizada ?? this.fechaRealizada,
      tiempoRealizado: tiempoRealizado ?? this.tiempoRealizado,
      color: color ?? this.color,
      ejercicios: ejercicios ?? this.ejercicios,
    );
  }

  factory RecordRutina.fromDatabase({
    required RoutineDbModel rutinaDB,
    int? cantidadEjercicios,
  }) {
    return RecordRutina(
      id: rutinaDB.id,
      nombre: rutinaDB.name,
      fechaRealizada: DateTime.parse(rutinaDB.createdAt),
      tiempoRealizado: 'no hay tiempo',
      color: rutinaDB.color ?? 0,
      ejercicios: [],
    );
  }
}

class RecordEjercicios {
  final String id;
  final String nombre;
  final List<String> series;
  final String iconoPath;
  final List<SeriesDelEjercicio> seriesDelEjercicio;

  RecordEjercicios({
    required this.id,
    required this.nombre,
    required this.series,
    required this.iconoPath,
    required this.seriesDelEjercicio,
  });

  RecordEjercicios copyWith({
    String? id,
    String? nombre,
    List<String>? series,
    String? iconoPath,
    List<SeriesDelEjercicio>? seriesDelEjercicio,
  }) {
    return RecordEjercicios(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      series: series ?? this.series,
      iconoPath: iconoPath ?? this.iconoPath,
      seriesDelEjercicio: seriesDelEjercicio ?? this.seriesDelEjercicio,
    );
  }

  factory RecordEjercicios.fromDatabase({
    required ExerciseDbModel ejercicioDB,
    required List<SeriesDelEjercicio> seriesDelEjercicio,
  }) {
    return RecordEjercicios(
      id: ejercicioDB.id,
      nombre: ejercicioDB.name,
      series: [],
      iconoPath: ejercicioDB.imagePath ?? '',
      seriesDelEjercicio: seriesDelEjercicio,
    );
  }
}

class SeriesDelEjercicio {
  final String id;
  final double peso;
  final int repeticiones;

  SeriesDelEjercicio({
    required this.id,
    required this.peso,
    required this.repeticiones,
  });

  SeriesDelEjercicio copyWith({String? id, double? peso, int? repeticiones}) {
    return SeriesDelEjercicio(
      id: id ?? this.id,
      peso: peso ?? this.peso,
      repeticiones: repeticiones ?? this.repeticiones,
    );
  }

  factory SeriesDelEjercicio.fromDatabase(
      {required ExerciseSetDbModel serieDB}) {
    return SeriesDelEjercicio(
      id: serieDB.id,
      peso: serieDB.weight ?? 0.0,
      repeticiones: serieDB.repetitions ?? 0,
    );
  }
}
