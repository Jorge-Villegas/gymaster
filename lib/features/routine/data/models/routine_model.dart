import 'package:gymaster/core/database/models/routine_db_model.dart'
    as rutina_db;
import 'package:gymaster/features/routine/domain/entities/routine.dart';

class RoutineModel extends Routine {
  RoutineModel({
    required super.id,
    required super.name,
    super.description,
    required super.fechaCreacion,
    required super.echo,
    required super.color,
    required super.cantidadEjercicios,
    required super.imagenDireccion,
  });

  factory RoutineModel.fromJson(Map<String, dynamic> map) {
    return RoutineModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      fechaCreacion: DateTime.parse(map['creationDate']),
      echo: map['done'],
      color: map['color'],
      cantidadEjercicios: 0,
      imagenDireccion: map['imagenDireccion'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'creationDate': fechaCreacion.toIso8601String(),
      'done': echo,
      'color': color,
      'cantidadEjercicios': cantidadEjercicios,
      'imagenDireccion': imagenDireccion,
    };
  }

  factory RoutineModel.fromDatabase({
    required rutina_db.RoutineDbModel serieDB,
    int? cantidadEjercicios,
  }) {
    return RoutineModel(
      id: serieDB.id,
      name: serieDB.name,
      description: serieDB.description,
      fechaCreacion: DateTime.parse(serieDB.createdAt),
      echo: false, //TODO: Cambiar
      color: serieDB.color ?? 0,
      cantidadEjercicios: cantidadEjercicios ?? 0,
      imagenDireccion: serieDB.imagePath ?? '',
    );
  }
}
