import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/setting/data/models/user_mood.dart';
import 'package:gymaster/features/setting/domain/repositories/user_emotional_repository.dart';

class GetLatestUserMoodUseCase
    implements UseCase<UserMood?, GetLatestUserMoodParams> {
  final UserEmotionalRepository repository;

  GetLatestUserMoodUseCase(this.repository);

  @override
  Future<Either<Failure, UserMood?>> call(
      GetLatestUserMoodParams params) async {
    return await repository.getLatestUserMood(params.userId);
  }
}

class GetLatestUserMoodParams {
  final String userId;

  GetLatestUserMoodParams({required this.userId});
}
