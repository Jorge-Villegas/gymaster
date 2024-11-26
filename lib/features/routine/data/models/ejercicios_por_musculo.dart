
import 'package:gymaster/features/routine/domain/entities/ejercicios_por_musculo.dart';

class EjerciciosPorMusculoModel extends EjerciciosPorMusculo {
  EjerciciosPorMusculoModel({
    required super.id,
    required super.nombre,
    super.descripcion,
    super.imagenDireccion,
    required super.musculos,
  });

  factory EjerciciosPorMusculoModel.fromJson(Map<String, dynamic> json) {
    return EjerciciosPorMusculoModel(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      imagenDireccion: json['imagenDireccion'],
      musculos: json['musculos'].toString().split(','),
    );
  }

  factory EjerciciosPorMusculoModel.fromMap(Map<String, dynamic> map) {
    return EjerciciosPorMusculoModel(
      id: map['id'],
      nombre: map['nombre'],
      descripcion: map['descripcion'],
      imagenDireccion: map['imagenDireccion'],
      musculos: map['musculos'].toString().split(','),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'imagenDireccion': imagenDireccion,
      'musculos': musculos.join(','),
    };
  }

  @override
  String toString() {
    return 'EjerciciosPorMusculo{id: $id, nombre: $nombre, musculos: $musculos}';
  }
}