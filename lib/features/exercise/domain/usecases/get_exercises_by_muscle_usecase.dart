import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/exercise/domain/entities/exercise.dart';
import 'package:gymaster/features/exercise/domain/repositories/exercise_repository.dart';

class GetExercisesByMuscleUseCase
    implements UseCase<List<Exercise>, GetExercisesByMuscleParams> {
  final ExerciseRepository repository;

  GetExercisesByMuscleUseCase(this.repository);

  @override
  Future<Either<Failure, List<Exercise>>> call(
    GetExercisesByMuscleParams params,
  ) async {
    return await repository.getExercisesByMuscle(params.muscleId);
  }
}

class GetExercisesByMuscleParams {
  final String muscleId;

  GetExercisesByMuscleParams({required this.muscleId});
}
