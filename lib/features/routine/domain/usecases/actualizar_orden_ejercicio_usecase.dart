import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/routine/domain/repositories/routine_repository.dart';

class ActualizarOrdenEjercicioUseCase
    extends UseCase<void, ActualizarOrdenEjercicioParams> {
  final RoutineRepository repository;

  ActualizarOrdenEjercicioUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ActualizarOrdenEjercicioParams params) {
    return repository.updateExerciseOrder(
      routineId: params.routineId,
      exerciseIds: params.exerciseIds,
    );
  }
}

class ActualizarOrdenEjercicioParams {
  final String routineId;
  final List<String> exerciseIds;

  ActualizarOrdenEjercicioParams({
    required this.routineId,
    required this.exerciseIds,
  });
}
