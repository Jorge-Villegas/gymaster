import 'dart:convert';

EjercicioDb exerciseFromJson(String str) =>
    EjercicioDb.fromJson(json.decode(str));

String exerciseToJson(EjercicioDb data) => json.encode(data.toJson());

class EjercicioDb {
  // Nombres de las columnas de la tabla
  static const String tabla = 'ejercicio';
  static const String columnId = 'id';
  static const String columnaNombre = 'nombre';
  static const String columnaDescripcion = 'descripcion';
  static const String columnaRutaImagen = 'ruta_imagen';
  static const String columnaFechaCreacion = 'fecha_creacion';
  static const String columnaFechaActualizacion = 'fecha_actualizacion';

  final String id;
  final String nombre;
  final String? descripcion;
  final String? rutaImagen;
  final String fechaCreacion;
  final String? fechaActualizacion;

  EjercicioDb({
    required this.id,
    required this.nombre,
    this.descripcion,
    this.rutaImagen,
    required this.fechaCreacion,
    this.fechaActualizacion,
  });

  EjercicioDb copyWith({
    String? id,
    String? nombre,
    String? descripcion,
    String? rutaImagen,
    String? fechaCreacion,
    String? fechaActualizacion,
  }) =>
      EjercicioDb(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        descripcion: descripcion ?? this.descripcion,
        rutaImagen: rutaImagen ?? this.rutaImagen,
        fechaCreacion: fechaCreacion ?? this.fechaCreacion,
        fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
      );

  factory EjercicioDb.fromJson(Map<String, dynamic> json) => EjercicioDb(
        id: json["id"],
        nombre: json["nombre"],
        descripcion: json["descripcion"],
        rutaImagen: json["ruta_imagen"],
        fechaCreacion: json["fecha_creacion"],
        fechaActualizacion: json["fecha_actualizacion"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "descripcion": descripcion,
        "ruta_imagen": rutaImagen,
        "fecha_creacion": fechaCreacion,
        "fecha_actualizacion": fechaActualizacion,
      };
}
