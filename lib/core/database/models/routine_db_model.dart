import 'dart:convert';

RoutineDbModel routineFromJson(String str) =>
    RoutineDbModel.fromJson(json.decode(str));

String routineToJson(RoutineDbModel data) => json.encode(data.toJson());

class RoutineDbModel {
  // Nombres de las columnas de la tabla
  static const String tabla = 'rutina';
  static const String columnaId = 'id';
  static const String columnaUsuarioId = 'usuario_id';
  static const String columnaNombre = 'nombre';
  static const String columnaDescripcion = 'descripcion';
  static const String columnaColor = 'color';
  static const String columnaRutaImagen = 'ruta_imagen';
  static const String columnaFechaCreacion = 'fecha_creacion';
  static const String columnaFechaActualizacion = 'fecha_actualizacion';

  final String id;
  final String usuarioId;
  final String nombre;
  final String? descripcion;
  final int? color;
  final String? rutaImagen;
  final String fechaCreacion;
  final String? fechaActualizacion;

  RoutineDbModel({
    required this.id,
    required this.usuarioId,
    required this.nombre,
    this.descripcion,
    this.color,
    this.rutaImagen,
    required this.fechaCreacion,
    this.fechaActualizacion,
  });

  RoutineDbModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    int? color,
    String? imagePath,
    String? createdAt,
    String? updatedAt,
  }) =>
      RoutineDbModel(
        id: id ?? this.id,
        usuarioId: userId ?? usuarioId,
        nombre: name ?? nombre,
        descripcion: description ?? descripcion,
        color: color ?? this.color,
        rutaImagen: imagePath ?? rutaImagen,
        fechaCreacion: createdAt ?? fechaCreacion,
        fechaActualizacion: updatedAt ?? fechaActualizacion,
      );

  factory RoutineDbModel.fromJson(Map<String, dynamic> json) => RoutineDbModel(
        id: json["id"],
        usuarioId: json["usuario_id"],
        nombre: json["nombre"],
        descripcion: json["descripcion"],
        color: json["color"],
        rutaImagen: json["ruta_imagen"],
        fechaCreacion: json["fecha_creacion"],
        fechaActualizacion: json["fecha_actualizacion"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "usuario_id": usuarioId,
        "nombre": nombre,
        "descripcion": descripcion,
        "color": color,
        "ruta_imagen": rutaImagen,
        "fecha_creacion": fechaCreacion,
        "fecha_actualizacion": fechaActualizacion,
      };
}
