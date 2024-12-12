import 'package:gymaster/features/routine/domain/entities/musculo.dart';
import 'package:gymaster/core/database/models/musculo.dart' as musculo_db;
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

  factory MusculoModel.fromEntity(musculo_db.Musculo musculo) {
    return MusculoModel(
      id: musculo.id,
      nombre: musculo.nombre,
      imagenDirecion: musculo.imagenDireccion ?? '',
    );
  }

}
