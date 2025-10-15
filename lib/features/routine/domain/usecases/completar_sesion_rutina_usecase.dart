import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/routine/domain/repositories/routine_repository.dart';

class CompletarSesionRutinaUseCase
    implements UseCase<bool, CompletarSesionRutinaParams> {
  final RoutineRepository repository;

  CompletarSesionRutinaUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(
    CompletarSesionRutinaParams params,
  ) async {
    return await repository.completeRoutineSession(params.sessionId);
  }
}

class CompletarSesionRutinaParams {
  final String sessionId;

  CompletarSesionRutinaParams({required this.sessionId});
}
