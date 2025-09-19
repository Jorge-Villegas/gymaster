import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/exceptions.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/features/exercise/data/datasources/exercise_local_data_source.dart';
import 'package:gymaster/features/exercise/domain/entities/exercise.dart';
import 'package:gymaster/features/exercise/domain/repositories/exercise_repository.dart';

class ExerciseRepositoryImpl implements ExerciseRepository {
  final ExerciseLocalDataSource localDataSource;

  ExerciseRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Exercise>>> obtenerTodosLosEjercicios() async {
    try {
      final exercises = await localDataSource.obtenerTodosLosEjercicios();
      return Right(exercises);
    } on ServerException {
      return Left(
        ServerFailure(
          errorMessage: 'Error al obtener los ejercicios del servidor',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Exercise>> obtenerEjercicioPorId(String id) async {
    try {
      final exercise = await localDataSource.obtenerEjercicioPorId(id);
      if (exercise == null) {
        return Left(
          NoRecordsFailure(errorMessage: 'No se encontró el ejercicio'),
        );
      }
      return Right(exercise);
    } on ServerException {
      return Left(
        ServerFailure(
          errorMessage: 'Error al obtener el ejercicio del servidor',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<Exercise>>> obtenerEjerciciosPorMusculo(
      String muscleId) async {
    try {
      final exerciseModels =
          await localDataSource.obtenerEjerciciosPorMusculo(muscleId);
      final exercises = exerciseModels.map((model) => model).toList();

      // ✅ Validación adicional
      if (exercises.isEmpty) {
        return Left(NoRecordsFailure(
            errorMessage: 'No se encontraron ejercicios para este músculo'));
      }

      return Right(exercises);
    } on ServerException catch (e) {
      return Left(
          ServerFailure(errorMessage: 'Error de servidor: ${e.toString()}'));
    } catch (e) {
      return Left(CacheFailure(
          errorMessage:
              'Error inesperado al obtener ejercicios por músculo: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Exercise>>> buscarEjercicios(String query) async {
    try {
      final exercises = await localDataSource.buscarEjercicios(query);
      return Right(exercises);
    } on ServerException {
      return Left(ServerFailure(errorMessage: 'Error al buscar ejercicios'));
    }
  }

  @override
  Future<Either<Failure, Exercise>> actualizarEjercicio(
      Exercise ejercicio) async {
    // TODO: Implementar cuando se necesite la funcionalidad de actualización
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Exercise>>> obtenerEjerciciosRecomendados({
    required String grupoMuscular,
    required String dificultad,
    String? equipo,
  }) async {
    try {
      final exercises =
          await localDataSource.obtenerEjerciciosPorMusculo(grupoMuscular);
      // TODO: Implementar filtros por dificultad y equipamiento
      return Right(exercises);
    } on ServerException {
      return Left(
        ServerFailure(errorMessage: 'Error al obtener ejercicios recomendados'),
      );
    }
  }
}
