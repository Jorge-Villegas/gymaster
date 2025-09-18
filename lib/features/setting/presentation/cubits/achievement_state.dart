part of 'achievement_cubit.dart';

@immutable
sealed class AchievementState {}

final class AchievementInitial extends AchievementState {}

final class AchievementLoading extends AchievementState {}

final class AchievementLoaded extends AchievementState {
  final List<Logro> achievements;

  AchievementLoaded(this.achievements);
}

final class AchievementUnlocked extends AchievementState {
  final Logro achievement;

  AchievementUnlocked(this.achievement);
}

final class MultipleAchievementsUnlocked extends AchievementState {
  final List<Logro> achievements;

  MultipleAchievementsUnlocked(this.achievements);
}

final class AchievementStatsLoaded extends AchievementState {
  final AchievementStats stats;

  AchievementStatsLoaded(this.stats);
}

final class AchievementError extends AchievementState {
  final String message;

  AchievementError(this.message);
}
