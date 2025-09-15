import '../../domain/entities/achievement.dart';
import '../../domain/repositories/achievement_repository.dart';

/// Data source abstracto para el manejo de logros en base de datos local
abstract class AchievementLocalDataSource {
  /// Obtiene todos los logros almacenados localmente
  Future<List<Achievement>> getAllAchievements();

  /// Obtiene logros por tipo específico
  Future<List<Achievement>> getAchievementsByType(AchievementType type);

  /// Obtiene logros desbloqueados
  Future<List<Achievement>> getUnlockedAchievements();

  /// Obtiene logros por rareza
  Future<List<Achievement>> getAchievementsByRarity(AchievementRarity rarity);

  /// Inserta un nuevo logro en la base de datos
  Future<Achievement> insertAchievement(Achievement achievement);

  /// Actualiza un logro existente
  Future<Achievement> updateAchievement(Achievement achievement);

  /// Desbloquea un logro específico
  Future<Achievement> unlockAchievement(String achievementId);

  /// Actualiza el progreso de un logro
  Future<Achievement> updateAchievementProgress({
    required String achievementId,
    required double progress,
  });

  /// Obtiene un logro por su ID
  Future<Achievement?> getAchievementById(String id);

  /// Obtiene el total de puntos de logros desbloqueados
  Future<int> getTotalAchievementPoints();

  /// Obtiene estadísticas de logros
  Future<AchievementStats> getAchievementStats();

  /// Verifica si existen logros inicializados
  Future<bool> hasInitializedAchievements();

  /// Inicializa logros predefinidos
  Future<void> initializePredefinedAchievements(List<Achievement> achievements);

  /// Elimina todos los logros (para testing/reset)
  Future<void> deleteAllAchievements();
}
