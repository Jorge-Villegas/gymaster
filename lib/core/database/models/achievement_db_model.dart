import 'package:gymaster/features/setting/data/models/logro.dart';

/// Modelo de base de datos para Achievement
class AchievementDbModel {
  static const String table = 'achievement';

  // Columnas
  static const String columnId = 'id';
  static const String columnType = 'type';
  static const String columnTitle = 'title';
  static const String columnDescription = 'description';
  static const String columnIconName = 'icon_name';
  static const String columnColor = 'color';
  static const String columnPoints = 'points';
  static const String columnAchievedAt = 'achieved_at';
  static const String columnIsUnlocked = 'is_unlocked';
  static const String columnCriteria = 'criteria';
  static const String columnProgress = 'progress';
  static const String columnRarity = 'rarity';

  final String id;
  final String type;
  final String title;
  final String description;
  final String iconName;
  final int color;
  final int points;
  final String? achievedAt;
  final int isUnlocked;
  final String criteria; // JSON string
  final double progress;
  final String rarity;

  AchievementDbModel({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.iconName,
    required this.color,
    required this.points,
    this.achievedAt,
    required this.isUnlocked,
    required this.criteria,
    required this.progress,
    required this.rarity,
  });

  factory AchievementDbModel.fromDomain(Logro achievement) {
    return AchievementDbModel(
      id: achievement.id!,
      type: achievement.tipo.toString().split('.').last,
      title: achievement.titulo,
      description: achievement.descripcion,
      iconName: achievement.nombreIcono,
      color: achievement.color,
      points: achievement.puntos,
      achievedAt: achievement.fechaDesbloqueo?.toIso8601String(),
      isUnlocked: achievement.desbloqueado ? 1 : 0,
      criteria: achievement.criterios.toString(), // Simple string conversion
      progress: achievement.progreso,
      rarity: achievement.rareza.toString().split('.').last,
    );
  }

  Logro toDomain() {
    return Logro(
      id: id,
      tipo: TipoLogro.values.firstWhere(
        (e) => e.toString().split('.').last == type,
      ),
      titulo: title,
      descripcion: description,
      nombreIcono: iconName,
      color: color,
      puntos: points,
      fechaDesbloqueo: achievedAt != null ? DateTime.parse(achievedAt!) : null,
      desbloqueado: isUnlocked == 1,
      criterios: _parseCriteria(criteria),
      progreso: progress,
      rareza: RarezaLogro.values.firstWhere(
        (e) => e.toString().split('.').last == rarity,
      ),
    );
  }

  factory AchievementDbModel.fromJson(Map<String, dynamic> json) {
    return AchievementDbModel(
      id: json[columnId],
      type: json[columnType],
      title: json[columnTitle],
      description: json[columnDescription],
      iconName: json[columnIconName],
      color: json[columnColor],
      points: json[columnPoints],
      achievedAt: json[columnAchievedAt],
      isUnlocked: json[columnIsUnlocked],
      criteria: json[columnCriteria],
      progress: (json[columnProgress] ?? 0.0).toDouble(),
      rarity: json[columnRarity],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      columnId: id,
      columnType: type,
      columnTitle: title,
      columnDescription: description,
      columnIconName: iconName,
      columnColor: color,
      columnPoints: points,
      columnAchievedAt: achievedAt,
      columnIsUnlocked: isUnlocked,
      columnCriteria: criteria,
      columnProgress: progress,
      columnRarity: rarity,
    };
  }

  /// Parse criteria desde string (implementación simple)
  Map<String, dynamic> _parseCriteria(String criteriaString) {
    try {
      // Por ahora, criterios simples como "routines_completed: 1"
      if (criteriaString.contains('routines_completed')) {
        final value = int.parse(criteriaString.split(':').last.trim());
        return {'routines_completed': value};
      }
      if (criteriaString.contains('consecutive_days')) {
        final value = int.parse(criteriaString.split(':').last.trim());
        return {'consecutive_days': value};
      }
      if (criteriaString.contains('workout_duration_minutes')) {
        final value = int.parse(criteriaString.split(':').last.trim());
        return {'workout_duration_minutes': value};
      }
      if (criteriaString.contains('total_weight_kg')) {
        final value = int.parse(criteriaString.split(':').last.trim());
        return {'total_weight_kg': value};
      }
      if (criteriaString.contains('total_hours')) {
        final value = int.parse(criteriaString.split(':').last.trim());
        return {'total_hours': value};
      }
      return {};
    } catch (e) {
      return {};
    }
  }

  /// SQL para crear la tabla
  static String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS $table (
      $columnId TEXT PRIMARY KEY,
      $columnType TEXT NOT NULL,
      $columnTitle TEXT NOT NULL,
      $columnDescription TEXT NOT NULL,
      $columnIconName TEXT NOT NULL,
      $columnColor INTEGER NOT NULL,
      $columnPoints INTEGER NOT NULL,
      $columnAchievedAt TEXT,
      $columnIsUnlocked INTEGER NOT NULL DEFAULT 0,
      $columnCriteria TEXT NOT NULL,
      $columnProgress REAL NOT NULL DEFAULT 0.0,
      $columnRarity TEXT NOT NULL
    )
  ''';
}
