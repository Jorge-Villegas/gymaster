import 'package:gymaster/features/record/domain/entities/record_rutina.dart';

class RecordRutinaModel extends RecordRutina {
  RecordRutinaModel({
    required super.id,
    required super.nombre,
    required super.fechaRealizada,
    required super.tiempoRealizado,
    required super.color,
    required super.ejercicios,
  });

  factory RecordRutinaModel.fromMap(Map<String, dynamic> map) {
    return RecordRutinaModel(
      id: map['id'],
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
      'id': id,
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
    required super.id,
    required super.nombre,
    required super.series,
    required super.iconoPath,
    required super.seriesDelEjercicio,
  });

  factory RecordEjerciciosModel.fromMap(Map<String, dynamic> map) {
    return RecordEjerciciosModel(
      id: map['id'],
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
      'id': id,
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
    required super.id,
    required super.peso,
    required super.repeticiones,
  });

  factory SeriesDelEjercicioModel.fromMap(Map<String, dynamic> map) {
    return SeriesDelEjercicioModel(
      id: map['id'],
      peso: map['peso'],
      repeticiones: map['repeticiones'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'peso': peso,
      'repeticiones': repeticiones,
    };
  }
}
