import 'dart:convert';

MusculoDbModel muscleFromJson(String str) =>
    MusculoDbModel.fromJson(json.decode(str));

String muscleToJson(MusculoDbModel data) => json.encode(data.toJson());

class MusculoDbModel {
  // Nombres de las columnas de la tabla
  static const String tabla = 'muscle';
  static const String columnaId = 'id';
  static const String columnaNombre = 'name';
  static const String columnaRutaImagen = 'ruta_imagen';
  static const String columnaFechaCreacion = 'fecha_creacion';

  final String id;
  final String nombre;
  final String? rutaImagen;
  final String fechaCreacion;

  MusculoDbModel({
    required this.id,
    required this.nombre,
    this.rutaImagen,
    required this.fechaCreacion,
  });

  MusculoDbModel copyWith({
    String? id,
    String? nombre,
    String? rutaImagen,
    String? fechaCreacion,
  }) =>
      MusculoDbModel(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        rutaImagen: rutaImagen ?? this.rutaImagen,
        fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      );

  factory MusculoDbModel.fromJson(Map<String, dynamic> json) => MusculoDbModel(
        id: json["id"],
        nombre: json["name"],
        rutaImagen: json["ruta_imagen"],
        fechaCreacion: json["fecha_creacion"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": nombre,
        "ruta_imagen": rutaImagen,
        "fecha_creacion": fechaCreacion,
      };
}
