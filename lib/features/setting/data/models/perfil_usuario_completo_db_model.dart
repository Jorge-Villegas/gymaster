import '../../domain/entities/perfil_usuario_completo.dart';

class PerfilUsuarioCompletoDbModel {
  static const String table = 'perfil_usuario_completo';

  // Columnas de la tabla
  static const String columnId = 'id';
  static const String columnNombreUsuario = 'nombre_usuario';
  static const String columnCorreo = 'correo';
  static const String columnFotoPerfil = 'foto_perfil';
  static const String columnNombreCompleto = 'nombre_completo';
  static const String columnFechaNacimiento = 'fecha_nacimiento';
  static const String columnGenero = 'genero';
  static const String columnObjetivoFitness = 'objetivo_fitness';
  static const String columnNivelExperiencia = 'nivel_experiencia';
  static const String columnAlturaCm = 'altura_cm';
  static const String columnPesoActualKg = 'peso_actual_kg';
  static const String columnPesoObjetivoKg = 'peso_objetivo_kg';
  static const String columnFechaCreacion = 'fecha_creacion';
  static const String columnFechaActualizacion = 'fecha_actualizacion';

  final String? id;
  final String nombreUsuario;
  final String? correo;
  final String fotoPerfil;
  final String nombreCompleto;
  final String? fechaNacimiento; // ISO 8601 string
  final String genero;
  final String objetivoFitness;
  final String nivelExperiencia;
  final int? alturaCm;
  final double? pesoActualKg;
  final double? pesoObjetivoKg;
  final String fechaCreacion; // ISO 8601 string
  final String? fechaActualizacion; // ISO 8601 string

  const PerfilUsuarioCompletoDbModel({
    this.id,
    required this.nombreUsuario,
    this.correo,
    required this.fotoPerfil,
    required this.nombreCompleto,
    this.fechaNacimiento,
    required this.genero,
    required this.objetivoFitness,
    required this.nivelExperiencia,
    this.alturaCm,
    this.pesoActualKg,
    this.pesoObjetivoKg,
    required this.fechaCreacion,
    this.fechaActualizacion,
  });

  // Convertir de entidad de dominio a modelo de DB
  factory PerfilUsuarioCompletoDbModel.fromEntity(
      PerfilUsuarioCompleto entity) {
    return PerfilUsuarioCompletoDbModel(
      id: entity.id,
      nombreUsuario: entity.nombreUsuario,
      correo: entity.correo,
      fotoPerfil: entity.fotoPerfil,
      nombreCompleto: entity.nombreCompleto,
      fechaNacimiento: entity.fechaNacimiento?.toIso8601String(),
      genero: entity.genero.valor,
      objetivoFitness: entity.objetivoFitness.valor,
      nivelExperiencia: entity.nivelExperiencia.valor,
      alturaCm: entity.alturaCm,
      pesoActualKg: entity.pesoActualKg,
      pesoObjetivoKg: entity.pesoObjetivoKg,
      fechaCreacion: entity.fechaCreacion.toIso8601String(),
      fechaActualizacion: entity.fechaActualizacion?.toIso8601String(),
    );
  }

  // Convertir de modelo de DB a entidad de dominio
  PerfilUsuarioCompleto toEntity() {
    return PerfilUsuarioCompleto(
      id: id,
      nombreUsuario: nombreUsuario,
      correo: correo,
      fotoPerfil: fotoPerfil,
      nombreCompleto: nombreCompleto,
      fechaNacimiento:
          fechaNacimiento != null ? DateTime.parse(fechaNacimiento!) : null,
      genero: GeneroExtension.fromString(genero),
      objetivoFitness: ObjetivoFitnessExtension.fromString(objetivoFitness),
      nivelExperiencia: NivelExperienciaExtension.fromString(nivelExperiencia),
      alturaCm: alturaCm,
      pesoActualKg: pesoActualKg,
      pesoObjetivoKg: pesoObjetivoKg,
      fechaCreacion: DateTime.parse(fechaCreacion),
      fechaActualizacion: fechaActualizacion != null
          ? DateTime.parse(fechaActualizacion!)
          : null,
    );
  }

  // Convertir de Map a modelo de DB
  factory PerfilUsuarioCompletoDbModel.fromMap(Map<String, dynamic> map) {
    return PerfilUsuarioCompletoDbModel(
      id: map[columnId],
      nombreUsuario: map[columnNombreUsuario],
      correo: map[columnCorreo],
      fotoPerfil: map[columnFotoPerfil],
      nombreCompleto: map[columnNombreCompleto],
      fechaNacimiento: map[columnFechaNacimiento],
      genero: map[columnGenero],
      objetivoFitness: map[columnObjetivoFitness],
      nivelExperiencia: map[columnNivelExperiencia],
      alturaCm: map[columnAlturaCm],
      pesoActualKg: map[columnPesoActualKg],
      pesoObjetivoKg: map[columnPesoObjetivoKg],
      fechaCreacion: map[columnFechaCreacion],
      fechaActualizacion: map[columnFechaActualizacion],
    );
  }

  // Convertir de modelo de DB a Map
  Map<String, dynamic> toMap() {
    return {
      columnId: id,
      columnNombreUsuario: nombreUsuario,
      columnCorreo: correo,
      columnFotoPerfil: fotoPerfil,
      columnNombreCompleto: nombreCompleto,
      columnFechaNacimiento: fechaNacimiento,
      columnGenero: genero,
      columnObjetivoFitness: objetivoFitness,
      columnNivelExperiencia: nivelExperiencia,
      columnAlturaCm: alturaCm,
      columnPesoActualKg: pesoActualKg,
      columnPesoObjetivoKg: pesoObjetivoKg,
      columnFechaCreacion: fechaCreacion,
      columnFechaActualizacion: fechaActualizacion,
    };
  }

  // SQL para crear la tabla
  static String get createTableSql => '''
    CREATE TABLE $table (
      $columnId TEXT PRIMARY KEY,
      $columnNombreUsuario TEXT NOT NULL UNIQUE,
      $columnCorreo TEXT,
      $columnFotoPerfil TEXT NOT NULL,
      $columnNombreCompleto TEXT NOT NULL,
      $columnFechaNacimiento TEXT,
      $columnGenero TEXT NOT NULL,
      $columnObjetivoFitness TEXT NOT NULL,
      $columnNivelExperiencia TEXT NOT NULL,
      $columnAlturaCm INTEGER,
      $columnPesoActualKg REAL,
      $columnPesoObjetivoKg REAL,
      $columnFechaCreacion TEXT NOT NULL,
      $columnFechaActualizacion TEXT
    )
  ''';
}
