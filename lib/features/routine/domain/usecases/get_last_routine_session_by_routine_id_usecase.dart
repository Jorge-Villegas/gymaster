import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/database/models/rutina_sesion_db.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/routine/domain/repositories/rutine_repository.dart';

class GetLastRoutineSessionByRoutineId
    implements UseCase<RutinaSesionDb, GetLastRoutineSessionByRoutineIdParams> {
  final RoutineRepository repository;

  GetLastRoutineSessionByRoutineId(this.repository);

  @override
  Future<Either<Failure, RutinaSesionDb>> call(
    GetLastRoutineSessionByRoutineIdParams params,
  ) async {
    return await repository.getLastRoutineSessionByRoutineId(params.idRoutine);
  }
}

class GetLastRoutineSessionByRoutineIdParams {
  final String idRoutine;

  GetLastRoutineSessionByRoutineIdParams({required this.idRoutine});
}
