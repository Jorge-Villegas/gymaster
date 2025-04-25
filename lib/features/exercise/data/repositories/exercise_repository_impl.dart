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
  Future<Either<Failure, List<Exercise>>> getAllExercises() async {
    try {
      final exercises = await localDataSource.getAllExercises();
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
  Future<Either<Failure, Exercise>> getExerciseById(String id) async {
    try {
      final exercise = await localDataSource.getExerciseById(id);
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
  Future<Either<Failure, List<Exercise>>> getExercisesByMuscle(
    String muscleId,
  ) async {
    try {
      final exercises = await localDataSource.getExercisesByMuscle(muscleId);
      return Right(exercises);
    } on ServerException {
      return Left(
        ServerFailure(
          errorMessage: 'Error al obtener los ejercicios por músculo',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<Exercise>>> searchExercises(String query) async {
    try {
      final exercises = await localDataSource.searchExercises(query);
      return Right(exercises);
    } on ServerException {
      return Left(ServerFailure(errorMessage: 'Error al buscar ejercicios'));
    }
  }

  @override
  Future<Either<Failure, Exercise>> updateExercise(Exercise exercise) async {
    // TODO: Implementar cuando se necesite la funcionalidad de actualización
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Exercise>>> getRecommendedExercises({
    required String muscleGroup,
    required String difficulty,
    String? equipment,
  }) async {
    try {
      final exercises = await localDataSource.getExercisesByMuscle(muscleGroup);
      // TODO: Implementar filtros por dificultad y equipamiento
      return Right(exercises);
    } on ServerException {
      return Left(
        ServerFailure(errorMessage: 'Error al obtener ejercicios recomendados'),
      );
    }
  }
}
