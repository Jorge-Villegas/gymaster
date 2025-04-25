import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/routine/domain/repositories/rutine_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateExerciseStatusUseCase
    implements UseCase<void, UpdateExerciseStatusParams> {
  final RoutineRepository repository;

  UpdateExerciseStatusUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateExerciseStatusParams params) async {
    return await repository.updateExerciseStatusById(
      exerciseId: params.exerciseId,
      routineSessionId: params.routineSessionId,
      statusExercise: params.statusExercise,
    );
  }
}

class UpdateExerciseStatusParams {
  final String exerciseId;
  final String routineSessionId;
  final String statusExercise;

  UpdateExerciseStatusParams({
    required this.exerciseId,
    required this.routineSessionId,
    required this.statusExercise,
  });
}
