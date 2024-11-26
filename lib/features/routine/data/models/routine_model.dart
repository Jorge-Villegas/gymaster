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
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'creationDate': fechaCreacion.toIso8601String(),
      'done': echo,
      'color': color,
      'cantidadEjercicios': cantidadEjercicios,
    };
  }

}
