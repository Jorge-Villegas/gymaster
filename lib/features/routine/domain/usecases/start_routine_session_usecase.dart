import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/routine/domain/repositories/rutine_repository.dart';

class StartRoutineSessionUseCase
    extends UseCase<bool, StartRoutineSessionParams> {
  final RoutineRepository repository;

  StartRoutineSessionUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(StartRoutineSessionParams params) async {
    return await repository.startRoutineSession(
      params.sessionId,
      params.rutinaId,
    );
  }
}

class StartRoutineSessionParams {
  final String sessionId;
  final String rutinaId;

  StartRoutineSessionParams({required this.sessionId, required this.rutinaId});
}
