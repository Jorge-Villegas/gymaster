import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/exercise/domain/entities/exercise.dart';
import 'package:gymaster/features/exercise/domain/repositories/exercise_repository.dart';

class BuscarEjerciciosUseCase
    implements UseCase<List<Exercise>, BuscarEjerciciosParams> {
  final ExerciseRepository repository;

  BuscarEjerciciosUseCase(this.repository);

  @override
  Future<Either<Failure, List<Exercise>>> call(
    BuscarEjerciciosParams params,
  ) async {
    // Validación de entrada - término de búsqueda no vacío
    if (params.query.trim().isEmpty) {
      return Left(CacheFailure(
          errorMessage: 'El término de búsqueda no puede estar vacío'));
    }

    // Validación de longitud mínima para evitar búsquedas muy genéricas
    if (params.query.trim().length < 2) {
      return Left(CacheFailure(
          errorMessage: 'Ingresa al menos 2 caracteres para buscar'));
    }

    return await repository.buscarEjercicios(params.query.trim());
  }
}

class BuscarEjerciciosParams {
  final String query;

  BuscarEjerciciosParams({required this.query});
}
