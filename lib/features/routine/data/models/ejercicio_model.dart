import 'dart:convert';
import 'package:gymaster/features/routine/domain/entities/ejercicio.dart';

List<EjercicioModel> ejercicioFromJson(String str) => List<EjercicioModel>.from(json.decode(str).map((x) => EjercicioModel.fromJson(x)));

String ejercicioToJson(List<EjercicioModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EjercicioModel extends Ejercicio {
  EjercicioModel({
    super.isarId,
    required super.id,
    required super.nombre,
    required super.descripcion,
    required super.imagenDireccion,
    required super.cantidadRepeticiones,
    required super.cantidadSeries,
    required super.estado,
  });

  factory EjercicioModel.fromEntity(Ejercicio entity) {
    return EjercicioModel(
      isarId: entity.isarId,
      id: entity.id,
      nombre: entity.nombre,
      descripcion: entity.descripcion,
      imagenDireccion: entity.imagenDireccion,
      cantidadRepeticiones: entity.cantidadRepeticiones,
      cantidadSeries: entity.cantidadSeries,
      estado: entity.estado,
    );
  }

  factory EjercicioModel.fromMap(Map<String, dynamic> map) {
    return EjercicioModel(
      isarId: map['isarId'],
      id: map['id'],
      nombre: map['nombre'],
      descripcion: map['descripcion'],
      imagenDireccion: map['imagen'],
      cantidadRepeticiones: map['repeticiones'],
      cantidadSeries: map['series'],
      estado: map['estado'],
    );
  }

  factory EjercicioModel.fromJson(Map<String, dynamic> json) {
    return EjercicioModel(
      isarId: json['isarId'],
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      imagenDireccion: json['imagen'],
      cantidadRepeticiones: json['repeticiones'],
      cantidadSeries: json['series'],
      estado: json['estado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isarId': isarId,
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'imagen': imagenDireccion,
      'repeticiones': cantidadRepeticiones,
      'series': cantidadSeries,
      'estado': estado,
    };
  }
  
  @override
  String toString() {
    return 'EjercicioModel(isarId: $isarId, id: $id, nombre: $nombre, descripcion: $descripcion, imagen: $imagenDireccion, repeticiones: $cantidadRepeticiones, series: $cantidadSeries, estado: $estado)';
  }
}