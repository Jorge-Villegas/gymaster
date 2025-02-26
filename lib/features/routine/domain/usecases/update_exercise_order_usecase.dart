// In a new file: update_exercise_order_usecase.dart
import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/routine/domain/repositories/rutine_repository.dart';

class UpdateExerciseOrderUseCase
    extends UseCase<void, UpdateExerciseOrderParams> {
  final RoutineRepository repository;

  UpdateExerciseOrderUseCase(this.repository);

  Future<Either<Failure, void>> call(UpdateExerciseOrderParams params) {
    return repository.updateExerciseOrder(
      routineId: params.routineId,
      exerciseIds: params.exerciseIds,
    );
  }
}

class UpdateExerciseOrderParams {
  final String routineId;
  final List<String> exerciseIds;

  UpdateExerciseOrderParams({
    required this.routineId,
    required this.exerciseIds,
  });
}
