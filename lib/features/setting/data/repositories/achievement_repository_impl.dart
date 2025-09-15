import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/features/setting/data/datasources/achievement_local_data_source.dart';
import 'package:gymaster/features/setting/domain/entities/achievement.dart';
import 'package:gymaster/features/setting/domain/repositories/achievement_repository.dart';

class AchievementRepositoryImpl implements AchievementRepository {
  final AchievementLocalDataSource localDataSource;

  AchievementRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Achievement>>> getAllAchievements() async {
    try {
      final achievements = await localDataSource.getAllAchievements();
      return Right(achievements);
    } on Exception catch (e) {
      return Left(CacheFailure(errorMessage: 'Error al obtener logros: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Achievement>>> getAchievementsByType(
      AchievementType type) async {
    try {
      final achievements = await localDataSource.getAchievementsByType(type);
      return Right(achievements);
    } on Exception catch (e) {
      return Left(
          CacheFailure(errorMessage: 'Error al obtener logros por tipo: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Achievement>>> getUnlockedAchievements() async {
    try {
      final achievements = await localDataSource.getUnlockedAchievements();
      return Right(achievements);
    } on Exception catch (e) {
      return Left(CacheFailure(
          errorMessage: 'Error al obtener logros desbloqueados: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Achievement>>> getAchievementsByRarity(
      AchievementRarity rarity) async {
    try {
      final achievements =
          await localDataSource.getAchievementsByRarity(rarity);
      return Right(achievements);
    } on Exception catch (e) {
      return Left(
          CacheFailure(errorMessage: 'Error al obtener logros por rareza: $e'));
    }
  }

  @override
  Future<Either<Failure, Achievement>> unlockAchievement(
      String achievementId) async {
    try {
      final achievement =
          await localDataSource.unlockAchievement(achievementId);
      return Right(achievement);
    } on Exception catch (e) {
      return Left(CacheFailure(errorMessage: 'Error al desbloquear logro: $e'));
    }
  }

  @override
  Future<Either<Failure, Achievement>> updateAchievementProgress({
    required String achievementId,
    required double progress,
  }) async {
    try {
      final achievement = await localDataSource.updateAchievementProgress(
        achievementId: achievementId,
        progress: progress,
      );
      return Right(achievement);
    } on Exception catch (e) {
      return Left(
          CacheFailure(errorMessage: 'Error al actualizar progreso: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Achievement>>> checkAchievementsToUnlock(
      Map<String, dynamic> userStats) async {
    try {
      // Lógica para verificar qué logros deben desbloquearse
      // basado en las estadísticas del usuario
      final allAchievements = await localDataSource.getAllAchievements();

      final achievementsToUnlock = <Achievement>[];

      for (final achievement in allAchievements) {
        if (!achievement.isUnlocked &&
            _shouldUnlockAchievement(achievement, userStats)) {
          final achievementId = achievement.id;
          if (achievementId != null) {
            final unlockedAchievement =
                await localDataSource.unlockAchievement(achievementId);
            achievementsToUnlock.add(unlockedAchievement);
          }
        }
      }

      return Right(achievementsToUnlock);
    } on Exception catch (e) {
      return Left(CacheFailure(errorMessage: 'Error al verificar logros: $e'));
    }
  }

  @override
  Future<Either<Failure, int>> getTotalAchievementPoints() async {
    try {
      final points = await localDataSource.getTotalAchievementPoints();
      return Right(points);
    } on Exception catch (e) {
      return Left(
          CacheFailure(errorMessage: 'Error al obtener puntos totales: $e'));
    }
  }

  @override
  Future<Either<Failure, AchievementStats>> getAchievementStats() async {
    try {
      final stats = await localDataSource.getAchievementStats();
      return Right(stats);
    } on Exception catch (e) {
      return Left(
          CacheFailure(errorMessage: 'Error al obtener estadísticas: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> initializePredefinedAchievements() async {
    try {
      final hasInitialized = await localDataSource.hasInitializedAchievements();

      if (!hasInitialized) {
        final predefinedAchievements = _getPredefinedAchievements();
        await localDataSource
            .initializePredefinedAchievements(predefinedAchievements);
      }

      return const Right(null);
    } on Exception catch (e) {
      return Left(
          CacheFailure(errorMessage: 'Error al inicializar logros: $e'));
    }
  }

  /// Determina si un logro debe desbloquearse basado en las estadísticas del usuario
  bool _shouldUnlockAchievement(
      Achievement achievement, Map<String, dynamic> userStats) {
    // Lógica específica para cada tipo de logro usando criterios del achievement
    final criteria = achievement.criteria;

    for (final criterion in criteria.entries) {
      final key = criterion.key;
      final requiredValue = criterion.value;
      final userValue = userStats[key];

      if (userValue == null) return false;

      // Comparar valores según el tipo
      if (userValue is num && requiredValue is num) {
        if (userValue < requiredValue) return false;
      } else if (userValue is String && requiredValue is String) {
        if (userValue != requiredValue) return false;
      }
    }

    return true;
  }

  /// Obtiene la lista de logros predefinidos
  List<Achievement> _getPredefinedAchievements() {
    return AchievementTemplates.allAchievements;
  }
}
