import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/setting/domain/entities/user_motivation.dart';
import 'package:gymaster/features/setting/domain/repositories/user_emotional_repository.dart';

class SaveUserMotivationUseCase
    implements UseCase<void, SaveUserMotivationParams> {
  final UserEmotionalRepository repository;

  SaveUserMotivationUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SaveUserMotivationParams params) async {
    return await repository.saveUserMotivation(params.motivation);
  }
}

class SaveUserMotivationParams {
  final UserMotivation motivation;

  SaveUserMotivationParams({required this.motivation});
}
