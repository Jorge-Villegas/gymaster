import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/features/setting/data/models/user_mood.dart';
import 'package:gymaster/features/setting/data/models/user_motivation.dart';

abstract class UserEmotionalRepository {
  Future<Either<Failure, void>> saveUserMotivation(UserMotivation motivation);
  Future<Either<Failure, UserMotivation?>> getUserMotivation(String userId);
  Future<Either<Failure, void>> updateUserMotivation(UserMotivation motivation);

  Future<Either<Failure, void>> saveUserMood(UserMood mood);
  Future<Either<Failure, UserMood?>> getLatestUserMood(String userId);
  Future<Either<Failure, List<UserMood>>> getUserMoodHistory(String userId,
      {int limit = 30});
  Future<Either<Failure, void>> markOnboardingCompleted(String userId);
  Future<Either<Failure, bool>> isOnboardingCompleted(String userId);
}
