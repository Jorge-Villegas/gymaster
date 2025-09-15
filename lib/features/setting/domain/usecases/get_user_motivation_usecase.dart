import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/setting/domain/entities/user_motivation.dart';
import 'package:gymaster/features/setting/domain/repositories/user_emotional_repository.dart';

class GetUserMotivationUseCase
    implements UseCase<UserMotivation?, GetUserMotivationParams> {
  final UserEmotionalRepository repository;

  GetUserMotivationUseCase(this.repository);

  @override
  Future<Either<Failure, UserMotivation?>> call(
      GetUserMotivationParams params) async {
    return await repository.getUserMotivation(params.userId);
  }
}

class GetUserMotivationParams {
  final String userId;

  GetUserMotivationParams({required this.userId});
}
