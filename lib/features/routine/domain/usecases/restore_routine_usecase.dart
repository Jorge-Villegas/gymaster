import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/routine/domain/repositories/rutine_repository.dart';

class RestoreRoutineUseCase implements UseCase<void, RestoreRoutineParams> {
  final RoutineRepository repository;

  RestoreRoutineUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(RestoreRoutineParams params) async {
    return await repository.restoreRoutine(id: params.id);
  }
}

class RestoreRoutineParams {
  final String id;

  RestoreRoutineParams({required this.id});
}
