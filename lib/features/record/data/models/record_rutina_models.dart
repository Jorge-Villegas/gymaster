import 'package:gymaster/features/record/domain/entities/record_rutina.dart';

class RecordRutinaModel extends RecordRutina {
  RecordRutinaModel({
    required super.nombre,
    required super.fechaRealizada,
    required super.tiempoRealizado,
    required super.color,
    required super.ejercicios,
  });

  factory RecordRutinaModel.fromMap(Map<String, dynamic> map) {
    return RecordRutinaModel(
      nombre: map['nombre'],
      fechaRealizada:
          map['fechaRealizada'] != null && map['fechaRealizada'].isNotEmpty
              ? DateTime.parse(map['fechaRealizada'])
              : DateTime.now(), // Maneja el caso de fecha nula o vacía
      tiempoRealizado: map['tiempoRealizado'],
      color: map['color'],
      ejercicios: (map['ejercicios'] as List)
          .map((e) => RecordEjerciciosModel.fromMap(e))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'fechaRealizada': fechaRealizada.toIso8601String(),
      'tiempoRealizado': tiempoRealizado,
      'color': color,
      'ejercicios':
          ejercicios.map((e) => (e as RecordEjerciciosModel).toMap()).toList(),
    };
  }
}

class RecordEjerciciosModel extends RecordEjercicios {
  RecordEjerciciosModel({
    required super.nombre,
    required super.series,
    required super.iconoPath,
    required super.seriesDelEjercicio,
  });

  factory RecordEjerciciosModel.fromMap(Map<String, dynamic> map) {
    return RecordEjerciciosModel(
      nombre: map['nombre'],
      series: List<String>.from(map['series']),
      iconoPath: map['iconoPath'],
      seriesDelEjercicio: (map['seriesDelEjercicio'] as List)
          .map((e) => SeriesDelEjercicioModel.fromMap(e))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'series': series,
      'iconoPath': iconoPath,
      'seriesDelEjercicio': seriesDelEjercicio
          .map((e) => (e as SeriesDelEjercicioModel).toMap())
          .toList(),
    };
  }
}

class SeriesDelEjercicioModel extends SeriesDelEjercicio {
  SeriesDelEjercicioModel({
    required super.peso,
    required super.repeticiones,
  });

  factory SeriesDelEjercicioModel.fromMap(Map<String, dynamic> map) {
    return SeriesDelEjercicioModel(
      peso: map['peso'],
      repeticiones: map['repeticiones'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'peso': peso,
      'repeticiones': repeticiones,
    };
  }
}
