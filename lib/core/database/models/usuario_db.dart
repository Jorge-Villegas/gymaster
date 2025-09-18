import 'dart:convert';

UsuarioDb userFromJson(String str) => UsuarioDb.fromJson(json.decode(str));

String userToJson(UsuarioDb data) => json.encode(data.toJson());

class UsuarioDb {
  //nombres de las columnas de la tabla
  static const String tabla = 'usuario';
  static const String columnaId = 'id';
  static const String columnaNombreUsuario = 'nombre_usuario';
  static const String columnaCorreo = 'correo';
  static const String columnaContrasena = 'contrasena';
  static const String columnaFechaCreacion = 'fecha_creacion';
  static const String columnaFechaActualizacion = 'fecha_actualizacion';

  final String id;
  final String nombreUsuario;
  final String correo;
  final String contrasena;
  final String fechaCreacion;
  final String fechaActualizacion;

  UsuarioDb({
    required this.id,
    required this.nombreUsuario,
    required this.correo,
    required this.contrasena,
    required this.fechaCreacion,
    required this.fechaActualizacion,
  });

  UsuarioDb copyWith({
    String? id,
    String? nombreUsuario,
    String? correo,
    String? contrasena,
    String? fechaCreacion,
    String? fechaActualizacion,
  }) =>
      UsuarioDb(
        id: id ?? this.id,
        nombreUsuario: nombreUsuario ?? this.nombreUsuario,
        correo: correo ?? this.correo,
        contrasena: contrasena ?? this.contrasena,
        fechaCreacion: fechaCreacion ?? this.fechaCreacion,
        fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
      );

  factory UsuarioDb.fromJson(Map<String, dynamic> json) => UsuarioDb(
        id: json["id"],
        nombreUsuario: json["nombre_usuario"],
        correo: json["correo"],
        contrasena: json["contrasena"],
        fechaCreacion: json["fecha_creacion"],
        fechaActualizacion: json["fecha_actualizacion"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre_usuario": nombreUsuario,
        "correo": correo,
        "contrasena": contrasena,
        "fecha_creacion": fechaCreacion,
        "fecha_actualizacion": fechaActualizacion,
      };
}
