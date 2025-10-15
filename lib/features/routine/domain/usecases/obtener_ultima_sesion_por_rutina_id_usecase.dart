import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/database/models/rutina_sesion_db.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/routine/domain/repositories/routine_repository.dart';

class ObtenerUltimaSesionPorRutinaIdUseCase
    implements UseCase<RutinaSesionDb, ObtenerUltimaSesionPorRutinaIdParams> {
  final RoutineRepository repository;

  ObtenerUltimaSesionPorRutinaIdUseCase(this.repository);

  @override
  Future<Either<Failure, RutinaSesionDb>> call(
    ObtenerUltimaSesionPorRutinaIdParams params,
  ) async {
    return await repository.getLastRoutineSessionByRoutineId(params.idRoutine);
  }
}

class ObtenerUltimaSesionPorRutinaIdParams {
  final String idRoutine;

  ObtenerUltimaSesionPorRutinaIdParams({required this.idRoutine});
}
