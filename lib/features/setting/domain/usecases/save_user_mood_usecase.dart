import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/setting/data/models/user_mood.dart';
import 'package:gymaster/features/setting/domain/repositories/user_emotional_repository.dart';

class SaveUserMoodUseCase implements UseCase<void, SaveUserMoodParams> {
  final UserEmotionalRepository repository;

  SaveUserMoodUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SaveUserMoodParams params) async {
    return await repository.saveUserMood(params.mood);
  }
}

class SaveUserMoodParams {
  final UserMood mood;

  SaveUserMoodParams({required this.mood});
}
