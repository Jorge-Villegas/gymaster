import 'package:equatable/equatable.dart';

class RutinaData extends Equatable {
  final String id;
  final String nombre;
  final String? descripcion;
  final DateTime fechaCreacion;
  final bool realizado;
  final int color;
  final DateTime? fechaRealizacion;
  final bool estado;
  final List<EjercicioData>? ejercicios;

  const RutinaData({
    required this.id,
    required this.nombre,
    this.descripcion,
    required this.fechaCreacion,
    required this.realizado,
    required this.color,
    this.fechaRealizacion,
    required this.estado,
    this.ejercicios,
  });

  RutinaData copyWith({
    String? id,
    String? nombre,
    String? descripcion,
    DateTime? fechaCreacion,
    bool? realizado,
    int? color,
    DateTime? fechaRealizacion,
    bool? estado,
    List<EjercicioData>? ejercicios,
  }) {
    return RutinaData(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        descripcion: descripcion ?? this.descripcion,
        fechaCreacion: fechaCreacion ?? this.fechaCreacion,
        realizado: realizado ?? this.realizado,
        color: color ?? this.color,
        fechaRealizacion: fechaRealizacion ?? this.fechaRealizacion,
        estado: estado ?? this.estado,
        ejercicios: ejercicios ?? this.ejercicios);
  }

  @override
  List<Object?> get props => [
        id,
        nombre,
        descripcion,
        fechaCreacion,
        realizado,
        color,
        fechaRealizacion,
        estado,
        ejercicios
      ];
}

class EjercicioData extends Equatable {
  final String id;
  final String? nombre;
  final String? imagenDireccion;
  final String? descripcion;
  final List<SerieData>? series;
  final List<MusculoData>? musculos;

  const EjercicioData({
    required this.id,
    this.nombre,
    this.imagenDireccion,
    this.descripcion,
    this.series,
    this.musculos,
  });

  EjercicioData copyWith({
    String? id,
    String? nombre,
    String? imagenDireccion,
    String? descripcion,
    List<SerieData>? series,
    List<MusculoData>? musculos,
  }) {
    return EjercicioData(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        imagenDireccion: imagenDireccion ?? this.imagenDireccion,
        descripcion: descripcion ?? this.descripcion,
        series: series ?? this.series,
        musculos: musculos ?? this.musculos);
  }

  @override
  List<Object?> get props => [
        id,
        nombre,
        imagenDireccion,
        descripcion,
        series,
        musculos,
      ];
}

class MusculoData extends Equatable {
  final String id;
  final String? nombre;
  final String? imagenDireccion;

  const MusculoData({
    required this.id,
    this.nombre,
    this.imagenDireccion,
  });

  MusculoData copyWith({
    String? id,
    String? nombre,
    String? imagenDireccion,
  }) {
    return MusculoData(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        imagenDireccion: imagenDireccion ?? this.imagenDireccion);
  }

  @override
  List<Object?> get props => [id, nombre, imagenDireccion];
}

class SerieData extends Equatable {
  final String id;
  final double peso;
  final int repeticiones;
  final bool realizado;
  final int tiempoDescanso;

  const SerieData({
    required this.id,
    required this.peso,
    required this.repeticiones,
    required this.realizado,
    required this.tiempoDescanso,
  });

  SerieData copyWith({
    String? id,
    double? peso,
    int? repeticiones,
    bool? realizado,
    int? tiempoDescanso,
  }) {
    return SerieData(
        id: id ?? this.id,
        peso: peso ?? this.peso,
        repeticiones: repeticiones ?? this.repeticiones,
        realizado: realizado ?? this.realizado,
        tiempoDescanso: tiempoDescanso ?? this.tiempoDescanso);
  }

  @override
  List<Object?> get props =>
      [id, peso, repeticiones, realizado, tiempoDescanso];
}
