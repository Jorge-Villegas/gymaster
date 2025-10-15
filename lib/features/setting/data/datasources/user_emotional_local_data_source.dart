import 'package:gymaster/features/setting/data/models/user_mood.dart';
import 'package:gymaster/features/setting/data/models/user_motivation.dart';

abstract class UserEmotionalLocalDataSource {
  Future<void> saveUserMotivation(UserMotivation motivation);
  Future<UserMotivation?> getUserMotivation(String userId);
  Future<void> updateUserMotivation(UserMotivation motivation);
  Future<void> saveUserMood(UserMood mood);
  Future<UserMood?> getLatestUserMood(String userId);
  Future<List<UserMood>> getUserMoodHistory(String userId, {int limit = 30});
  Future<void> markOnboardingCompleted(String userId);
  Future<bool> isOnboardingCompleted(String userId);
}
