import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/logro.dart';

/// Repositorio abstracto para el manejo de logros (achievements) en GyMaster
abstract class AchievementRepository {
  /// Obtiene todos los logros del usuario
  Future<Either<Failure, List<Logro>>> getAllAchievements();

  /// Obtiene logros por tipo específico
  Future<Either<Failure, List<Logro>>> getAchievementsByType(TipoLogro type);

  /// Obtiene logros desbloqueados
  Future<Either<Failure, List<Logro>>> getUnlockedAchievements();

  /// Obtiene logros por rareza
  Future<Either<Failure, List<Logro>>> getAchievementsByRarity(
      RarezaLogro rarity);

  /// Desbloquea un logro específico
  Future<Either<Failure, Logro>> unlockAchievement(String achievementId);

  /// Actualiza el progreso de un logro
  Future<Either<Failure, Logro>> updateAchievementProgress({
    required String logroId,
    required double progress,
  });

  /// Verifica si un logro debe desbloquearse basado en criterios
  Future<Either<Failure, List<Logro>>> checkAchievementsToUnlock(
      Map<String, dynamic> userStats);

  /// Obtiene el total de puntos de logros del usuario
  Future<Either<Failure, int>> getTotalAchievementPoints();

  /// Obtiene estadísticas de logros (total, desbloqueados, por rareza)
  Future<Either<Failure, AchievementStats>> getAchievementStats();

  /// Inicializa logros predefinidos en la base de datos
  Future<Either<Failure, void>> initializePredefinedAchievements();
}

/// Estadísticas de logros del usuario
class AchievementStats {
  /// Total de logros disponibles
  final int totalAchievements;

  /// Logros desbloqueados
  final int unlockedAchievements;

  /// Puntos totales obtenidos
  final int totalPoints;

  /// Estadísticas por rareza
  final Map<RarezaLogro, int> achievementsByRarity;

  /// Estadísticas por tipo
  final Map<TipoLogro, int> achievementsByType;

  /// Porcentaje de completitud
  final double completionPercentage;

  const AchievementStats({
    required this.totalAchievements,
    required this.unlockedAchievements,
    required this.totalPoints,
    required this.achievementsByRarity,
    required this.achievementsByType,
    required this.completionPercentage,
  });

  AchievementStats copyWith({
    int? totalAchievements,
    int? unlockedAchievements,
    int? totalPoints,
    Map<RarezaLogro, int>? achievementsByRarity,
    Map<TipoLogro, int>? achievementsByType,
    double? completionPercentage,
  }) =>
      AchievementStats(
        totalAchievements: totalAchievements ?? this.totalAchievements,
        unlockedAchievements: unlockedAchievements ?? this.unlockedAchievements,
        totalPoints: totalPoints ?? this.totalPoints,
        achievementsByRarity: achievementsByRarity ?? this.achievementsByRarity,
        achievementsByType: achievementsByType ?? this.achievementsByType,
        completionPercentage: completionPercentage ?? this.completionPercentage,
      );

  factory AchievementStats.fromJson(Map<String, dynamic> json) =>
      AchievementStats(
        totalAchievements: json["totalAchievements"],
        unlockedAchievements: json["unlockedAchievements"],
        totalPoints: json["totalPoints"],
        achievementsByRarity: Map<RarezaLogro, int>.from(
          json["achievementsByRarity"].map((key, value) => MapEntry(
                RarezaLogro.values.firstWhere(
                  (e) => e.toString().split('.').last == key,
                ),
                value,
              )),
        ),
        achievementsByType: Map<TipoLogro, int>.from(
          json["achievementsByType"].map((key, value) => MapEntry(
                TipoLogro.values.firstWhere(
                  (e) => e.toString().split('.').last == key,
                ),
                value,
              )),
        ),
        completionPercentage: (json["completionPercentage"] ?? 0.0).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "totalAchievements": totalAchievements,
        "unlockedAchievements": unlockedAchievements,
        "totalPoints": totalPoints,
        "achievementsByRarity": achievementsByRarity.map(
          (key, value) => MapEntry(key.toString().split('.').last, value),
        ),
        "achievementsByType": achievementsByType.map(
          (key, value) => MapEntry(key.toString().split('.').last, value),
        ),
        "completionPercentage": completionPercentage,
      };
}
