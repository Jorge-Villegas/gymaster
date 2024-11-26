import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/routine/domain/entities/routine.dart';
import 'package:gymaster/features/routine/domain/repositories/rutine_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetAllRoutineUsecase implements UseCase<List<Routine>, NoParams> {
  final RoutineRepository repository;

  GetAllRoutineUsecase(this.repository);

  @override
  Future<Either<Failure, List<Routine>>> call(NoParams params) async {
    return await repository.getAllRoutine();
  }
}
