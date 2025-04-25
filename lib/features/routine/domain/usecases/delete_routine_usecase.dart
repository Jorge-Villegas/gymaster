import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/routine/domain/repositories/rutine_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeleteRoutineUseCase extends UseCase<void, DeleteRoutineParams> {
  final RoutineRepository repository;

  DeleteRoutineUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteRoutineParams params) async {
    return await repository.deleteRoutine(id: params.id);
  }
}

class DeleteRoutineParams {
  final String id;

  DeleteRoutineParams({
    required this.id,
  });
}
