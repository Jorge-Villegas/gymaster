import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/routine/domain/repositories/rutine_repository.dart';

class IniciarSesionRutinaUseCase
    extends UseCase<bool, IniciarSesionRutinaParams> {
  final RoutineRepository repository;

  IniciarSesionRutinaUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(IniciarSesionRutinaParams params) async {
    return await repository.startRoutineSession(
      params.sessionId,
      params.rutinaId,
    );
  }
}

class IniciarSesionRutinaParams {
  final String sessionId;
  final String rutinaId;

  IniciarSesionRutinaParams({required this.sessionId, required this.rutinaId});
}
