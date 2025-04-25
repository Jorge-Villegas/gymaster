import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/routine/domain/repositories/rutine_repository.dart';

class StopRoutineSessionUseCase
    implements UseCase<bool, StopRoutineSessionParams> {
  final RoutineRepository repository;

  StopRoutineSessionUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(StopRoutineSessionParams params) async {
    return await repository.stopRoutineSession(params.sessionId);
  }
}

class StopRoutineSessionParams {
  final String sessionId;

  StopRoutineSessionParams({required this.sessionId});
}
