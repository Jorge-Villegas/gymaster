import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/database/models/routine_session_db_model.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/routine/domain/repositories/rutine_repository.dart';

class GetLastRoutineSessionByRoutineId
    implements
        UseCase<RoutineSessionDbModel, GetLastRoutineSessionByRoutineIdParams> {
  final RoutineRepository repository;

  GetLastRoutineSessionByRoutineId(this.repository);

  @override
  Future<Either<Failure, RoutineSessionDbModel>> call(
    GetLastRoutineSessionByRoutineIdParams params,
  ) async {
    return await repository.getLastRoutineSessionByRoutineId(params.idRoutine);
  }
}

class GetLastRoutineSessionByRoutineIdParams {
  final String idRoutine;

  GetLastRoutineSessionByRoutineIdParams({required this.idRoutine});
}
