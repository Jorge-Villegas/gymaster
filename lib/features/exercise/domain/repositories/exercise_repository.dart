import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/features/exercise/domain/entities/exercise.dart';

abstract interface class ExerciseRepository {
  Future<Either<Failure, List<Exercise>>> getAllExercises();
  Future<Either<Failure, Exercise>> getExerciseById(String id);
  Future<Either<Failure, List<Exercise>>> getExercisesByMuscle(String muscleId);
  Future<Either<Failure, List<Exercise>>> searchExercises(String query);
  Future<Either<Failure, Exercise>> updateExercise(Exercise exercise);
  Future<Either<Failure, List<Exercise>>> getRecommendedExercises({
    required String muscleGroup,
    required String difficulty,
    String? equipment,
  });
}
