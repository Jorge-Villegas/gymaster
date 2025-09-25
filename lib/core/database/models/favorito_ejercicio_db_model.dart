import 'package:gymaster/features/exercise/domain/entities/favorito_ejercicio.dart';

class FavoritoEjercicioDbModel extends FavoritoEjercicio {
  static const String table = 'ejercicios_favoritos';
  static const String columnId = 'id';
  static const String columnEjercicioId = 'ejercicio_id';
  static const String columnFechaAgregado = 'fecha_agregado';

  const FavoritoEjercicioDbModel({
    super.id,
    required super.ejercicioId,
    required super.fechaAgregado,
  });

  /// Convierte desde Map de base de datos
  factory FavoritoEjercicioDbModel.fromMap(Map<String, dynamic> map) =>
      FavoritoEjercicioDbModel(
        id: map[columnId],
        ejercicioId: map[columnEjercicioId],
        fechaAgregado: DateTime.parse(map[columnFechaAgregado]),
      );

  /// Convierte a Map para base de datos
  Map<String, dynamic> toMap() => {
        columnId: id,
        columnEjercicioId: ejercicioId,
        columnFechaAgregado: fechaAgregado.toIso8601String(),
      };

  /// Convierte desde entity
  factory FavoritoEjercicioDbModel.fromEntity(FavoritoEjercicio entity) =>
      FavoritoEjercicioDbModel(
        id: entity.id,
        ejercicioId: entity.ejercicioId,
        fechaAgregado: entity.fechaAgregado,
      );

  /// Convierte a entity
  FavoritoEjercicio toEntity() => FavoritoEjercicio(
        id: id,
        ejercicioId: ejercicioId,
        fechaAgregado: fechaAgregado,
      );

  /// SQL para crear la tabla
  static String get createTableSql => '''
    CREATE TABLE $table (
      $columnId TEXT PRIMARY KEY,
      $columnEjercicioId TEXT NOT NULL,
      $columnFechaAgregado TEXT NOT NULL,
      FOREIGN KEY ($columnEjercicioId) REFERENCES ejercicios(id) ON DELETE CASCADE,
      UNIQUE($columnEjercicioId)
    )
  ''';

  /// SQL para crear índices (performance)
  static List<String> get createIndexesSql => [
        'CREATE INDEX idx_ejercicios_favoritos_ejercicio_id ON $table ($columnEjercicioId)',
        'CREATE INDEX idx_ejercicios_favoritos_fecha ON $table ($columnFechaAgregado)',
      ];

  @override
  FavoritoEjercicioDbModel copyWith({
    String? id,
    String? ejercicioId,
    DateTime? fechaAgregado,
  }) =>
      FavoritoEjercicioDbModel(
        id: id ?? this.id,
        ejercicioId: ejercicioId ?? this.ejercicioId,
        fechaAgregado: fechaAgregado ?? this.fechaAgregado,
      );
}
