import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/exercise/domain/entities/exercise.dart';
import 'package:gymaster/features/exercise/domain/repositories/exercise_repository.dart';

class ObtenerEjerciciosPorMusculoUseCase
    implements UseCase<List<Exercise>, ObtenerEjerciciosPorMusculoParams> {
  final ExerciseRepository repository;

  ObtenerEjerciciosPorMusculoUseCase(this.repository);

  @override
  Future<Either<Failure, List<Exercise>>> call(
    ObtenerEjerciciosPorMusculoParams params,
  ) async {
    return await repository.obtenerEjerciciosPorMusculo(params.muscleId);
  }
}

class ObtenerEjerciciosPorMusculoParams {
  final String muscleId;

  ObtenerEjerciciosPorMusculoParams({required this.muscleId});
}
