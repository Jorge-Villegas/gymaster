import 'package:gymaster/features/routine/domain/entities/rutina_data.dart';

class RutinaDataModel extends RutinaData {
  RutinaDataModel({
    required super.id,
    required super.nombre,
    super.descripcion,
    required super.fechaCreacion,
    required super.realizado,
    required super.color,
    super.fechaRealizacion,
    required super.estado,
    super.ejercicios,
  });

  //json
  factory RutinaDataModel.fromJson(Map<String, dynamic> json) {
    return RutinaDataModel(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      fechaCreacion: json['fechaCreacion'],
      realizado: json['realizado'],
      color: json['color'],
      fechaRealizacion: json['fechaRealizacion'],
      estado: json['estado'],
      ejercicios: json['ejercicios'],
    );
  }

  factory RutinaDataModel.fromMap(Map<String, dynamic> map) {
    return RutinaDataModel(
      id: map['id'],
      nombre: map['nombre'],
      descripcion: map['descripcion'],
      fechaCreacion: map['fechaCreacion'],
      realizado: map['realizado'],
      color: map['color'],
      fechaRealizacion: map['fechaRealizacion'],
      estado: map['estado'],
      ejercicios: map['ejercicios'],
    );
  }
}

class EjercicioDataModel extends EjercicioData {
  EjercicioDataModel({
    required super.id,
    super.nombre,
    super.imagenDireccion,
    super.descripcion,
    super.series,
    super.musculos,
  });

  factory EjercicioDataModel.fromMap(Map<String, dynamic> map) {
    return EjercicioDataModel(
      id: map['id'],
      nombre: map['nombre'],
      imagenDireccion: map['imagenDireccion'],
      descripcion: map['descripcion'],
      series: map['series'],
      musculos: map['musculos'],
    );
  }

  //json
  factory EjercicioDataModel.fromJson(Map<String, dynamic> json) {
    return EjercicioDataModel(
      id: json['id'],
      nombre: json['nombre'],
      imagenDireccion: json['imagenDireccion'],
      descripcion: json['descripcion'],
      series: json['series'],
      musculos: json['musculos'],
    );
  }
}

class MusculoDataModel extends MusculoData {
  MusculoDataModel({
    required super.id,
    super.nombre,
    super.imagenDireccion,
  });

  //map
  factory MusculoDataModel.fromMap(Map<String, dynamic> map) {
    return MusculoDataModel(
      id: map['id'],
      nombre: map['nombre'],
      imagenDireccion: map['imagenDireccion'],
    );
  }

  //json
  factory MusculoDataModel.fromJson(Map<String, dynamic> json) {
    return MusculoDataModel(
      id: json['id'],
      nombre: json['nombre'],
      imagenDireccion: json['imagenDireccion'],
    );
  }
}

class SerieDataModel extends SerieData {
  SerieDataModel({
    required super.id,
    required super.peso,
    required super.repeticiones,
    required super.realizado,
    required super.tiempoDescanso,
  });

  //map
  factory SerieDataModel.fromMap(Map<String, dynamic> map) {
    return SerieDataModel(
      id: map['id'],
      peso: map['peso'],
      repeticiones: map['repeticiones'],
      realizado: map['realizado'],
      tiempoDescanso: map['tiempoDescanso'],
    );
  }

  //json
  factory SerieDataModel.fromJson(Map<String, dynamic> json) {
    return SerieDataModel(
      id: json['id'],
      peso: json['peso'],
      repeticiones: json['repeticiones'],
      realizado: json['realizado'],
      tiempoDescanso: json['tiempoDescanso'],
    );
  }
}
