import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/setting/domain/repositories/user_emotional_repository.dart';

class IsOnboardingCompletedUseCase
    implements UseCase<bool, IsOnboardingCompletedParams> {
  final UserEmotionalRepository repository;

  IsOnboardingCompletedUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(IsOnboardingCompletedParams params) async {
    return await repository.isOnboardingCompleted(params.userId);
  }
}

class IsOnboardingCompletedParams {
  final String userId;

  IsOnboardingCompletedParams({required this.userId});
}
