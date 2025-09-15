import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/setting/domain/repositories/user_emotional_repository.dart';

class MarkOnboardingCompletedUseCase
    implements UseCase<void, MarkOnboardingCompletedParams> {
  final UserEmotionalRepository repository;

  MarkOnboardingCompletedUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(
      MarkOnboardingCompletedParams params) async {
    return await repository.markOnboardingCompleted(params.userId);
  }
}

class MarkOnboardingCompletedParams {
  final String userId;

  MarkOnboardingCompletedParams({required this.userId});
}
