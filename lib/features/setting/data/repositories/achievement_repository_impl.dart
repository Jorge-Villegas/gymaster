import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/features/setting/data/datasources/logro_local_data_source.dart';
import 'package:gymaster/features/setting/domain/entities/logro.dart';
import 'package:gymaster/features/setting/domain/repositories/achievement_repository.dart';

class AchievementRepositoryImpl implements AchievementRepository {
  final LogroLocalDataSource localDataSource;

  AchievementRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Logro>>> getAllAchievements() async {
    try {
      final achievements = await localDataSource.obtenerTodosLosLogros();
      return Right(achievements);
    } on Exception catch (e) {
      return Left(CacheFailure(errorMessage: 'Error al obtener logros: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Logro>>> getAchievementsByType(
      TipoLogro type) async {
    try {
      final achievements = await localDataSource.obtenerLogrosPorTipo(type);
      return Right(achievements);
    } on Exception catch (e) {
      return Left(
          CacheFailure(errorMessage: 'Error al obtener logros por tipo: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Logro>>> getUnlockedAchievements() async {
    try {
      final achievements = await localDataSource.obtenerLogrosDesbloqueados();
      return Right(achievements);
    } on Exception catch (e) {
      return Left(CacheFailure(
          errorMessage: 'Error al obtener logros desbloqueados: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Logro>>> getAchievementsByRarity(
      RarezaLogro rarity) async {
    try {
      final achievements = await localDataSource.obtenerLogrosPorRareza(rarity);
      return Right(achievements);
    } on Exception catch (e) {
      return Left(
          CacheFailure(errorMessage: 'Error al obtener logros por rareza: $e'));
    }
  }

  @override
  Future<Either<Failure, Logro>> unlockAchievement(String achievementId) async {
    try {
      final achievement = await localDataSource.desbloquearLogro(achievementId);
      return Right(achievement);
    } on Exception catch (e) {
      return Left(CacheFailure(errorMessage: 'Error al desbloquear logro: $e'));
    }
  }

  @override
  Future<Either<Failure, Logro>> updateAchievementProgress({
    required String logroId,
    required double progress,
  }) async {
    try {
      final achievement = await localDataSource.actualizarProgresoLogro(
        logroId: logroId,
        progreso: progress,
      );
      return Right(achievement);
    } on Exception catch (e) {
      return Left(
          CacheFailure(errorMessage: 'Error al actualizar progreso: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Logro>>> checkAchievementsToUnlock(
      Map<String, dynamic> userStats) async {
    try {
      // Lógica para verificar qué logros deben desbloquearse
      // basado en las estadísticas del usuario
      final allAchievements = await localDataSource.obtenerTodosLosLogros();

      final achievementsToUnlock = <Logro>[];

      for (final achievement in allAchievements) {
        if (!achievement.desbloqueado &&
            _shouldUnlockAchievement(achievement, userStats)) {
          final achievementId = achievement.id;
          if (achievementId != null) {
            final unlockedAchievement =
                await localDataSource.desbloquearLogro(achievementId);
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
      final points = await localDataSource.obtenerTotalPuntosLogros();
      return Right(points);
    } on Exception catch (e) {
      return Left(
          CacheFailure(errorMessage: 'Error al obtener puntos totales: $e'));
    }
  }

  @override
  Future<Either<Failure, AchievementStats>> getAchievementStats() async {
    try {
      final stats = await localDataSource.obtenerEstadisticasLogros();
      return Right(stats);
    } on Exception catch (e) {
      return Left(
          CacheFailure(errorMessage: 'Error al obtener estadísticas: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> initializePredefinedAchievements() async {
    try {
      final hasInitialized = await localDataSource.existenLogrosInicializados();

      if (!hasInitialized) {
        final predefinedAchievements = _getPredefinedAchievements();
        await localDataSource
            .inicializarLogrosPredefinidos(predefinedAchievements);
      }

      return const Right(null);
    } on Exception catch (e) {
      return Left(
          CacheFailure(errorMessage: 'Error al inicializar logros: $e'));
    }
  }

  /// Determina si un logro debe desbloquearse basado en las estadísticas del usuario
  bool _shouldUnlockAchievement(
      Logro achievement, Map<String, dynamic> userStats) {
    // Lógica específica para cada tipo de logro usando criterios del achievement
    final criteria = achievement.criterios;

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
  List<Logro> _getPredefinedAchievements() {
    return PlantillasLogro.todosLosLogros;
  }
}
