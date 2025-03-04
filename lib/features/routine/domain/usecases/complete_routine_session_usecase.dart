import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/routine/domain/repositories/rutine_repository.dart';

class CompleteRoutineSessionUseCase
    implements UseCase<bool, CompleteRoutineSessionParams> {
  final RoutineRepository repository;

  CompleteRoutineSessionUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(
    CompleteRoutineSessionParams params,
  ) async {
    return await repository.completeRoutineSession(params.sessionId);
  }
}

class CompleteRoutineSessionParams {
  final String sessionId;

  CompleteRoutineSessionParams({required this.sessionId});
}
