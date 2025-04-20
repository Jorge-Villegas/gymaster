import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/exercise/domain/entities/exercise.dart';
import 'package:gymaster/features/exercise/domain/repositories/exercise_repository.dart';

class GetAllExercisesUseCase implements UseCase<List<Exercise>, NoParams> {
  final ExerciseRepository repository;

  GetAllExercisesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Exercise>>> call(NoParams params) async {
    return await repository.getAllExercises();
  }
}
