import 'package:gymaster/features/routine/domain/entities/musculo.dart';

class MusculoModel extends Musculo {
  MusculoModel({
    required super.id,
    required super.nombre,
    required super.imagenDirecion,
  });

  MusculoModel copyWith({
    String? id,
    String? nombre,
    String? imagenDirecion,
  }) {
    return MusculoModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      imagenDirecion: imagenDirecion ?? this.imagenDirecion,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'imagenDirecion': imagenDirecion,
    };
  }

  factory MusculoModel.fromJson(Map<String, dynamic> json) {
    return MusculoModel(
      id: json['id'],
      nombre: json['nombre'],
      imagenDirecion: json['imagenDirecion'],
    );
  }
}
