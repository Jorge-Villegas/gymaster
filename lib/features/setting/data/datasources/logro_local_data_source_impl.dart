import 'package:gymaster/core/database/models/logro_db_model.dart';
import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_helper.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../shared/utils/uuid_generator.dart';
import '../../domain/entities/logro.dart';
import '../../domain/repositories/achievement_repository.dart';
import 'logro_local_data_source.dart';

/// Implementación del data source para logros usando SQLite
class LogroLocalDataSourceImpl implements LogroLocalDataSource {
  final DatabaseHelper databaseHelper;
  final IdGenerator idGenerator;

  LogroLocalDataSourceImpl({
    required this.databaseHelper,
    required this.idGenerator,
  });

  @override
  Future<List<Logro>> obtenerTodosLosLogros() async {
    try {
      final db = await databaseHelper.database;
      final List<Map<String, dynamic>> logros = await db.query(
        LogroDbModel.tabla,
        orderBy:
            '${LogroDbModel.columnaRareza} ASC, ${LogroDbModel.columnaTipo} ASC',
      );

      return logros
          .map((logro) => LogroDbModel.fromJson(logro).toDomain())
          .toList();
    } catch (e) {
      throw Exception('Error al obtener logros: $e');
    }
  }

  @override
  Future<List<Logro>> obtenerLogrosPorTipo(TipoLogro type) async {
    try {
      final db = await databaseHelper.database;
      final List<Map<String, dynamic>> logros = await db.query(
        LogroDbModel.tabla,
        where: '${LogroDbModel.columnaTipo} = ?',
        whereArgs: [type.toString().split('.').last],
        orderBy: '${LogroDbModel.columnaRareza} ASC',
      );

      return logros
          .map((logro) => LogroDbModel.fromJson(logro).toDomain())
          .toList();
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<List<Logro>> obtenerLogrosDesbloqueados() async {
    try {
      final db = await databaseHelper.database;
      final List<Map<String, dynamic>> logros = await db.query(
        LogroDbModel.tabla,
        where: '${LogroDbModel.columnaDesbloqueado} = ?',
        whereArgs: [1],
        orderBy: '${LogroDbModel.columnaFechaDesbloqueo} DESC',
      );

      return logros
          .map((logro) => LogroDbModel.fromJson(logro).toDomain())
          .toList();
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<List<Logro>> obtenerLogrosPorRareza(RarezaLogro rarity) async {
    try {
      final db = await databaseHelper.database;
      final List<Map<String, dynamic>> logros = await db.query(
        LogroDbModel.tabla,
        where: '${LogroDbModel.columnaRareza} = ?',
        whereArgs: [rarity.toString().split('.').last],
        orderBy:
            '${LogroDbModel.columnaDesbloqueado} DESC, ${LogroDbModel.columnaTitulo} ASC',
      );

      return logros
          .map((logro) => LogroDbModel.fromJson(logro).toDomain())
          .toList();
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<Logro> insertarLogro(Logro achievement) async {
    try {
      final db = await databaseHelper.database;
      final id = achievement.id ?? idGenerator.generateId();
      final logroConId = achievement.copyWith(id: id);

      await db.insert(
        LogroDbModel.tabla,
        LogroDbModel.fromDomain(logroConId).toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return logroConId;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<Logro> actualizarLogro(Logro achievement) async {
    try {
      final db = await databaseHelper.database;

      await db.update(
        LogroDbModel.tabla,
        LogroDbModel.fromDomain(achievement).toJson(),
        where: '${LogroDbModel.columnaId} = ?',
        whereArgs: [achievement.id],
      );

      return achievement;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<Logro> desbloquearLogro(String achievementId) async {
    try {
      final db = await databaseHelper.database;
      final now = DateTime.now();

      await db.update(
        LogroDbModel.tabla,
        {
          LogroDbModel.columnaDesbloqueado: 1,
          LogroDbModel.columnaFechaDesbloqueo: now.toIso8601String(),
          LogroDbModel.columnaProgreso: 1.0,
        },
        where: '${LogroDbModel.columnaId} = ?',
        whereArgs: [achievementId],
      );

      final updatedAchievement = await obtenerLogroPorId(achievementId);
      if (updatedAchievement == null) {
        throw CacheException();
      }

      return updatedAchievement;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<Logro> actualizarProgresoLogro({
    required String logroId,
    required double progreso,
  }) async {
    try {
      final db = await databaseHelper.database;

      await db.update(
        LogroDbModel.tabla,
        {LogroDbModel.columnaProgreso: progreso},
        where: '${LogroDbModel.columnaId} = ?',
        whereArgs: [logroId],
      );

      final logroActualizado = await obtenerLogroPorId(logroId);
      if (logroActualizado == null) {
        throw CacheException();
      }

      return logroActualizado;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<Logro?> obtenerLogroPorId(String id) async {
    try {
      final db = await databaseHelper.database;
      final List<Map<String, dynamic>> logros = await db.query(
        LogroDbModel.tabla,
        where: '${LogroDbModel.columnaId} = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (logros.isEmpty) return null;

      return LogroDbModel.fromJson(logros.first).toDomain();
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<int> obtenerTotalPuntosLogros() async {
    try {
      final db = await databaseHelper.database;
      final List<Map<String, dynamic>> result = await db
          .rawQuery('SELECT SUM(${LogroDbModel.columnaPuntos}) as total_points '
              'FROM ${LogroDbModel.tabla} '
              'WHERE ${LogroDbModel.columnaDesbloqueado} = 1');

      return result.first['total_points'] ?? 0;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<AchievementStats> obtenerEstadisticasLogros() async {
    try {
      final db = await databaseHelper.database;

      // Total de logros
      final totalResult = await db
          .rawQuery('SELECT COUNT(*) as total FROM ${LogroDbModel.tabla}');
      final totalAchievements = totalResult.first['total'] as int;

      // Logros desbloqueados
      final unlockedResult = await db
          .rawQuery('SELECT COUNT(*) as unlocked FROM ${LogroDbModel.tabla} '
              'WHERE ${LogroDbModel.columnaDesbloqueado} = 1');
      final unlockedAchievements = unlockedResult.first['unlocked'] as int;

      // Puntos totales
      final totalPoints = await obtenerTotalPuntosLogros();

      // Estadísticas por rareza
      final rarityResult = await db.rawQuery(
          'SELECT ${LogroDbModel.columnaRareza}, '
          'COUNT(*) as count, '
          'SUM(CASE WHEN ${LogroDbModel.columnaDesbloqueado} = 1 THEN 1 ELSE 0 END) as unlocked_count '
          'FROM ${LogroDbModel.tabla} '
          'GROUP BY ${LogroDbModel.columnaRareza}');

      final achievementsByRarity = <RarezaLogro, int>{};
      for (final row in rarityResult) {
        final rarity = RarezaLogro.values.firstWhere(
          (e) => e.toString().split('.').last == row['rarity'],
        );
        achievementsByRarity[rarity] = row['unlocked_count'] as int;
      }

      // Estadísticas por tipo
      final typeResult = await db.rawQuery(
          'SELECT ${LogroDbModel.columnaTipo}, '
          'COUNT(*) as count, '
          'SUM(CASE WHEN ${LogroDbModel.columnaDesbloqueado} = 1 THEN 1 ELSE 0 END) as unlocked_count '
          'FROM ${LogroDbModel.tabla} '
          'GROUP BY ${LogroDbModel.columnaTipo}');

      final achievementsByType = <TipoLogro, int>{};
      for (final row in typeResult) {
        final type = TipoLogro.values.firstWhere(
          (e) => e.toString().split('.').last == row['tipo'],
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
  Future<bool> existenLogrosInicializados() async {
    try {
      final db = await databaseHelper.database;
      final List<Map<String, dynamic>> result = await db
          .rawQuery('SELECT COUNT(*) as count FROM ${LogroDbModel.tabla}');

      return (result.first['count'] as int) > 0;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> inicializarLogrosPredefinidos(List<Logro> achievements) async {
    try {
      final db = await databaseHelper.database;

      await db.transaction((txn) async {
        for (final achievement in achievements) {
          final achievementWithId = achievement.copyWith(
            id: achievement.id ?? idGenerator.generateId(),
          );

          await txn.insert(
            LogroDbModel.tabla,
            LogroDbModel.fromDomain(achievementWithId).toJson(),
            conflictAlgorithm: ConflictAlgorithm.ignore,
          );
        }
      });
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> eliminarTodosLosLogros() async {
    try {
      final db = await databaseHelper.database;
      await db.delete(LogroDbModel.tabla);
    } catch (e) {
      throw CacheException();
    }
  }
}
