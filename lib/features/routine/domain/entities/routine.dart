// To parse this JSON data, do
//
//     final routine = routineFromJson(jsonString);

import 'dart:convert';

List<Routine> routineFromJson(String str) =>
    List<Routine>.from(json.decode(str).map((x) => Routine.fromJson(x)));

String routineToJson(List<Routine> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Routine {
  String? id;
  final String name;
  String? description;
  final DateTime fechaCreacion;
  final bool echo;
  final int color;
  final int cantidadEjercicios;
  final String imagenDireccion;

  Routine({
    this.id,
    required this.name,
    this.description,
    required this.fechaCreacion,
    required this.echo,
    required this.color,
    required this.cantidadEjercicios,
    required this.imagenDireccion,
  });

  Routine copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? fechaCreacion,
    bool? echo,
    int? color,
    int? cantidadEjercicios,
    String? imagenDireccion,
  }) =>
      Routine(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        fechaCreacion: fechaCreacion ?? this.fechaCreacion,
        echo: echo ?? this.echo,
        color: color ?? this.color,
        cantidadEjercicios: cantidadEjercicios ?? this.cantidadEjercicios,
        imagenDireccion: imagenDireccion ?? this.imagenDireccion,
      );

  factory Routine.fromJson(Map<String, dynamic> json) => Routine(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        fechaCreacion: DateTime.parse(json["fechaCreacion"]),
        echo: json["echo"],
        color: json["color"],
        cantidadEjercicios: json["cantidadEjercicios"],
        imagenDireccion: json["imagenDireccion"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "fechaCreacion": fechaCreacion.toIso8601String(),
        "echo": echo,
        "color": color,
        "cantidadEjercicios": cantidadEjercicios,
        "imagenDireccion": imagenDireccion,
      };

  @override
  String toString() {
    return 'Routine(id: $id, name: $name, description: $description, fechaCreacion: $fechaCreacion, echo: $echo, color: $color, cantidadEjercicios: $cantidadEjercicios, imagenDireccion: $imagenDireccion)';
  }
}
