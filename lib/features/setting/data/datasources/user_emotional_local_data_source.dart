import 'package:gymaster/features/setting/domain/entities/user_motivation.dart';
import 'package:gymaster/features/setting/domain/entities/user_mood.dart';

abstract class UserEmotionalLocalDataSource {
  // User Motivation
  Future<void> saveUserMotivation(UserMotivation motivation);
  Future<UserMotivation?> getUserMotivation(String userId);
  Future<void> updateUserMotivation(UserMotivation motivation);

  // User Mood
  Future<void> saveUserMood(UserMood mood);
  Future<UserMood?> getLatestUserMood(String userId);
  Future<List<UserMood>> getUserMoodHistory(String userId, {int limit = 30});

  // Onboarding Status
  Future<void> markOnboardingCompleted(String userId);
  Future<bool> isOnboardingCompleted(String userId);
}
