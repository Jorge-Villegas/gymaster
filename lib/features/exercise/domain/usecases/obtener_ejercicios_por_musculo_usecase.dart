import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/exercise/domain/entities/exercise.dart';
import 'package:gymaster/features/exercise/domain/repositories/exercise_repository.dart';

class ObtenerEjerciciosCatalogoPorMusculoUseCase
    implements
        UseCase<List<Exercise>, ObtenerEjerciciosCatalogoPorMusculoParams> {
  final ExerciseRepository repository;

  ObtenerEjerciciosCatalogoPorMusculoUseCase(this.repository);

  @override
  Future<Either<Failure, List<Exercise>>> call(
    ObtenerEjerciciosCatalogoPorMusculoParams params,
  ) async {
    return await repository.obtenerEjerciciosPorMusculo(params.muscleId);
  }
}

class ObtenerEjerciciosCatalogoPorMusculoParams {
  final String muscleId;

  ObtenerEjerciciosCatalogoPorMusculoParams({required this.muscleId});
}
