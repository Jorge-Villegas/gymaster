import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/routine/domain/repositories/routine_repository.dart';

class FinalizarSesionRutinaUseCase
    implements UseCase<bool, FinalizarSesionRutinaParams> {
  final RoutineRepository repository;

  FinalizarSesionRutinaUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(FinalizarSesionRutinaParams params) async {
    return await repository.stopRoutineSession(params.sessionId);
  }
}

class FinalizarSesionRutinaParams {
  final String sessionId;

  FinalizarSesionRutinaParams({required this.sessionId});
}
