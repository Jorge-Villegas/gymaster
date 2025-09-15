import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_helper.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../shared/utils/uuid_generator.dart';
import '../../domain/entities/achievement.dart';
import '../../domain/repositories/achievement_repository.dart';
import 'achievement_local_data_source.dart';

/// Implementación del data source para logros usando SQLite
class AchievementLocalDataSourceImpl implements AchievementLocalDataSource {
  final DatabaseHelper databaseHelper;
  final IdGenerator idGenerator;

  AchievementLocalDataSourceImpl({
    required this.databaseHelper,
    required this.idGenerator,
  });

  @override
  Future<List<Achievement>> getAllAchievements() async {
    try {
      final db = await databaseHelper.database;
      final List<Map<String, dynamic>> achievements = await db.query(
        AchievementDbModel.table,
        orderBy:
            '${AchievementDbModel.columnRarity} ASC, ${AchievementDbModel.columnType} ASC',
      );

      return achievements
          .map((achievement) =>
              AchievementDbModel.fromJson(achievement).toDomain())
          .toList();
    } catch (e) {
      throw Exception('Error al obtener logros: $e');
    }
  }

  @override
  Future<List<Achievement>> getAchievementsByType(AchievementType type) async {
    try {
      final db = await databaseHelper.database;
      final List<Map<String, dynamic>> achievements = await db.query(
        AchievementDbModel.table,
        where: '${AchievementDbModel.columnType} = ?',
        whereArgs: [type.toString().split('.').last],
        orderBy: '${AchievementDbModel.columnRarity} ASC',
      );

      return achievements
          .map((achievement) =>
              AchievementDbModel.fromJson(achievement).toDomain())
          .toList();
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<List<Achievement>> getUnlockedAchievements() async {
    try {
      final db = await databaseHelper.database;
      final List<Map<String, dynamic>> achievements = await db.query(
        AchievementDbModel.table,
        where: '${AchievementDbModel.columnIsUnlocked} = ?',
        whereArgs: [1],
        orderBy: '${AchievementDbModel.columnAchievedAt} DESC',
      );

      return achievements
          .map((achievement) =>
              AchievementDbModel.fromJson(achievement).toDomain())
          .toList();
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<List<Achievement>> getAchievementsByRarity(
      AchievementRarity rarity) async {
    try {
      final db = await databaseHelper.database;
      final List<Map<String, dynamic>> achievements = await db.query(
        AchievementDbModel.table,
        where: '${AchievementDbModel.columnRarity} = ?',
        whereArgs: [rarity.toString().split('.').last],
        orderBy:
            '${AchievementDbModel.columnIsUnlocked} DESC, ${AchievementDbModel.columnTitle} ASC',
      );

      return achievements
          .map((achievement) =>
              AchievementDbModel.fromJson(achievement).toDomain())
          .toList();
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<Achievement> insertAchievement(Achievement achievement) async {
    try {
      final db = await databaseHelper.database;
      final id = achievement.id ?? idGenerator.generateId();
      final achievementWithId = achievement.copyWith(id: id);

      await db.insert(
        AchievementDbModel.table,
        AchievementDbModel.fromDomain(achievementWithId).toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return achievementWithId;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<Achievement> updateAchievement(Achievement achievement) async {
    try {
      final db = await databaseHelper.database;

      await db.update(
        AchievementDbModel.table,
        AchievementDbModel.fromDomain(achievement).toJson(),
        where: '${AchievementDbModel.columnId} = ?',
        whereArgs: [achievement.id],
      );

      return achievement;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<Achievement> unlockAchievement(String achievementId) async {
    try {
      final db = await databaseHelper.database;
      final now = DateTime.now();

      await db.update(
        AchievementDbModel.table,
        {
          AchievementDbModel.columnIsUnlocked: 1,
          AchievementDbModel.columnAchievedAt: now.toIso8601String(),
          AchievementDbModel.columnProgress: 1.0,
        },
        where: '${AchievementDbModel.columnId} = ?',
        whereArgs: [achievementId],
      );

      final updatedAchievement = await getAchievementById(achievementId);
      if (updatedAchievement == null) {
        throw CacheException();
      }

      return updatedAchievement;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<Achievement> updateAchievementProgress({
    required String achievementId,
    required double progress,
  }) async {
    try {
      final db = await databaseHelper.database;

      await db.update(
        AchievementDbModel.table,
        {AchievementDbModel.columnProgress: progress},
        where: '${AchievementDbModel.columnId} = ?',
        whereArgs: [achievementId],
      );

      final updatedAchievement = await getAchievementById(achievementId);
      if (updatedAchievement == null) {
        throw CacheException();
      }

      return updatedAchievement;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<Achievement?> getAchievementById(String id) async {
    try {
      final db = await databaseHelper.database;
      final List<Map<String, dynamic>> achievements = await db.query(
        AchievementDbModel.table,
        where: '${AchievementDbModel.columnId} = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (achievements.isEmpty) return null;

      return AchievementDbModel.fromJson(achievements.first).toDomain();
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<int> getTotalAchievementPoints() async {
    try {
      final db = await databaseHelper.database;
      final List<Map<String, dynamic>> result = await db.rawQuery(
          'SELECT SUM(${AchievementDbModel.columnPoints}) as total_points '
          'FROM ${AchievementDbModel.table} '
          'WHERE ${AchievementDbModel.columnIsUnlocked} = 1');

      return result.first['total_points'] ?? 0;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<AchievementStats> getAchievementStats() async {
    try {
      final db = await databaseHelper.database;

      // Total de logros
      final totalResult = await db.rawQuery(
          'SELECT COUNT(*) as total FROM ${AchievementDbModel.table}');
      final totalAchievements = totalResult.first['total'] as int;

      // Logros desbloqueados
      final unlockedResult = await db.rawQuery(
          'SELECT COUNT(*) as unlocked FROM ${AchievementDbModel.table} '
          'WHERE ${AchievementDbModel.columnIsUnlocked} = 1');
      final unlockedAchievements = unlockedResult.first['unlocked'] as int;

      // Puntos totales
      final totalPoints = await getTotalAchievementPoints();

      // Estadísticas por rareza
      final rarityResult = await db.rawQuery(
          'SELECT ${AchievementDbModel.columnRarity}, '
          'COUNT(*) as count, '
          'SUM(CASE WHEN ${AchievementDbModel.columnIsUnlocked} = 1 THEN 1 ELSE 0 END) as unlocked_count '
          'FROM ${AchievementDbModel.table} '
          'GROUP BY ${AchievementDbModel.columnRarity}');

      final achievementsByRarity = <AchievementRarity, int>{};
      for (final row in rarityResult) {
        final rarity = AchievementRarity.values.firstWhere(
          (e) => e.toString().split('.').last == row['rarity'],
        );
        achievementsByRarity[rarity] = row['unlocked_count'] as int;
      }

      // Estadísticas por tipo
      final typeResult = await db.rawQuery(
          'SELECT ${AchievementDbModel.columnType}, '
          'COUNT(*) as count, '
          'SUM(CASE WHEN ${AchievementDbModel.columnIsUnlocked} = 1 THEN 1 ELSE 0 END) as unlocked_count '
          'FROM ${AchievementDbModel.table} '
          'GROUP BY ${AchievementDbModel.columnType}');

      final achievementsByType = <AchievementType, int>{};
      for (final row in typeResult) {
        final type = AchievementType.values.firstWhere(
          (e) => e.toString().split('.').last == row['type'],
        );
        achievementsByType[type] = row['unlocked_count'] as int;
      }

      // Porcentaje de completitud
      final completionPercentage = totalAchievements > 0
          ? (unlockedAchievements / totalAchievements) * 100
          : 0.0;

      return AchievementStats(
        totalAchievements: totalAchievements,
        unlockedAchievements: unlockedAchievements,
        totalPoints: totalPoints,
        achievementsByRarity: achievementsByRarity,
        achievementsByType: achievementsByType,
        completionPercentage: completionPercentage,
      );
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<bool> hasInitializedAchievements() async {
    try {
      final db = await databaseHelper.database;
      final List<Map<String, dynamic>> result = await db.rawQuery(
          'SELECT COUNT(*) as count FROM ${AchievementDbModel.table}');

      return (result.first['count'] as int) > 0;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> initializePredefinedAchievements(
      List<Achievement> achievements) async {
    try {
      final db = await databaseHelper.database;

      await db.transaction((txn) async {
        for (final achievement in achievements) {
          final achievementWithId = achievement.copyWith(
            id: achievement.id ?? idGenerator.generateId(),
          );

          await txn.insert(
            AchievementDbModel.table,
            AchievementDbModel.fromDomain(achievementWithId).toJson(),
            conflictAlgorithm: ConflictAlgorithm.ignore,
          );
        }
      });
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> deleteAllAchievements() async {
    try {
      final db = await databaseHelper.database;
      await db.delete(AchievementDbModel.table);
    } catch (e) {
      throw CacheException();
    }
  }
}

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

  factory AchievementDbModel.fromDomain(Achievement achievement) {
    return AchievementDbModel(
      id: achievement.id!,
      type: achievement.type.toString().split('.').last,
      title: achievement.title,
      description: achievement.description,
      iconName: achievement.iconName,
      color: achievement.color,
      points: achievement.points,
      achievedAt: achievement.achievedAt?.toIso8601String(),
      isUnlocked: achievement.isUnlocked ? 1 : 0,
      criteria: achievement.criteria.toString(), // Simple string conversion
      progress: achievement.progress,
      rarity: achievement.rarity.toString().split('.').last,
    );
  }

  Achievement toDomain() {
    return Achievement(
      id: id,
      type: AchievementType.values.firstWhere(
        (e) => e.toString().split('.').last == type,
      ),
      title: title,
      description: description,
      iconName: iconName,
      color: color,
      points: points,
      achievedAt: achievedAt != null ? DateTime.parse(achievedAt!) : null,
      isUnlocked: isUnlocked == 1,
      criteria: _parseCriteria(criteria),
      progress: progress,
      rarity: AchievementRarity.values.firstWhere(
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
