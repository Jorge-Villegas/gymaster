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

  // Nuevos campos de perfil
  static const String columnaFotoPerfil = 'foto_perfil';
  static const String columnaNombreCompleto = 'nombre_completo';
  static const String columnaFechaNacimiento = 'fecha_nacimiento';
  static const String columnaGenero = 'genero';
  static const String columnaObjetivoFitness = 'objetivo_fitness';
  static const String columnaNivelExperiencia = 'nivel_experiencia';
  static const String columnaAlturaCm = 'altura_cm';
  static const String columnaPesoActualKg = 'peso_actual_kg';
  static const String columnaPesoObjetivoKg = 'peso_objetivo_kg';
  static const String columnaFechaActualizacionPerfil =
      'fecha_actualizacion_perfil';

  final String id;
  final String nombreUsuario;
  final String correo;
  final String contrasena;
  final String fechaCreacion;
  final String fechaActualizacion;

  // Nuevos campos de perfil
  final String? fotoPerfil;
  final String? nombreCompleto;
  final String? fechaNacimiento;
  final String? genero;
  final String? objetivoFitness;
  final String? nivelExperiencia;
  final int? alturaCm;
  final double? pesoActualKg;
  final double? pesoObjetivoKg;
  final String? fechaActualizacionPerfil;

  UsuarioDb({
    required this.id,
    required this.nombreUsuario,
    required this.correo,
    required this.contrasena,
    required this.fechaCreacion,
    required this.fechaActualizacion,
    this.fotoPerfil,
    this.nombreCompleto,
    this.fechaNacimiento,
    this.genero,
    this.objetivoFitness,
    this.nivelExperiencia,
    this.alturaCm,
    this.pesoActualKg,
    this.pesoObjetivoKg,
    this.fechaActualizacionPerfil,
  });

  UsuarioDb copyWith({
    String? id,
    String? nombreUsuario,
    String? correo,
    String? contrasena,
    String? fechaCreacion,
    String? fechaActualizacion,
    String? fotoPerfil,
    String? nombreCompleto,
    String? fechaNacimiento,
    String? genero,
    String? objetivoFitness,
    String? nivelExperiencia,
    int? alturaCm,
    double? pesoActualKg,
    double? pesoObjetivoKg,
    String? fechaActualizacionPerfil,
  }) =>
      UsuarioDb(
        id: id ?? this.id,
        nombreUsuario: nombreUsuario ?? this.nombreUsuario,
        correo: correo ?? this.correo,
        contrasena: contrasena ?? this.contrasena,
        fechaCreacion: fechaCreacion ?? this.fechaCreacion,
        fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
        fotoPerfil: fotoPerfil ?? this.fotoPerfil,
        nombreCompleto: nombreCompleto ?? this.nombreCompleto,
        fechaNacimiento: fechaNacimiento ?? this.fechaNacimiento,
        genero: genero ?? this.genero,
        objetivoFitness: objetivoFitness ?? this.objetivoFitness,
        nivelExperiencia: nivelExperiencia ?? this.nivelExperiencia,
        alturaCm: alturaCm ?? this.alturaCm,
        pesoActualKg: pesoActualKg ?? this.pesoActualKg,
        pesoObjetivoKg: pesoObjetivoKg ?? this.pesoObjetivoKg,
        fechaActualizacionPerfil:
            fechaActualizacionPerfil ?? this.fechaActualizacionPerfil,
      );

  factory UsuarioDb.fromJson(Map<String, dynamic> json) => UsuarioDb(
        id: json[columnaId],
        nombreUsuario: json[columnaNombreUsuario],
        correo: json[columnaCorreo],
        contrasena: json[columnaContrasena],
        fechaCreacion: json[columnaFechaCreacion],
        fechaActualizacion: json[columnaFechaActualizacion],
        fotoPerfil: json[columnaFotoPerfil],
        nombreCompleto: json[columnaNombreCompleto],
        fechaNacimiento: json[columnaFechaNacimiento],
        genero: json[columnaGenero],
        objetivoFitness: json[columnaObjetivoFitness],
        nivelExperiencia: json[columnaNivelExperiencia],
        alturaCm: json[columnaAlturaCm],
        pesoActualKg: json[columnaPesoActualKg]?.toDouble(),
        pesoObjetivoKg: json[columnaPesoObjetivoKg]?.toDouble(),
        fechaActualizacionPerfil: json[columnaFechaActualizacionPerfil],
      );

  Map<String, dynamic> toJson() => {
        columnaId: id,
        columnaNombreUsuario: nombreUsuario,
        columnaCorreo: correo,
        columnaContrasena: contrasena,
        columnaFechaCreacion: fechaCreacion,
        columnaFechaActualizacion: fechaActualizacion,
        columnaFotoPerfil: fotoPerfil,
        columnaNombreCompleto: nombreCompleto,
        columnaFechaNacimiento: fechaNacimiento,
        columnaGenero: genero,
        columnaObjetivoFitness: objetivoFitness,
        columnaNivelExperiencia: nivelExperiencia,
        columnaAlturaCm: alturaCm,
        columnaPesoActualKg: pesoActualKg,
        columnaPesoObjetivoKg: pesoObjetivoKg,
        columnaFechaActualizacionPerfil: fechaActualizacionPerfil,
      };
}
