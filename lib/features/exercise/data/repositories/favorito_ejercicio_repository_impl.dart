import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/features/exercise/data/datasources/favorito_ejercicio_local_data_source.dart';
import 'package:gymaster/features/exercise/domain/entities/favorito_ejercicio.dart';
import 'package:gymaster/features/exercise/domain/entities/exercise.dart';
import 'package:gymaster/features/exercise/domain/repositories/favorito_ejercicio_repository.dart';
import 'package:gymaster/features/exercise/domain/repositories/exercise_repository.dart';

/// Implementación concreta del repository de ejercicios favoritos
/// Maneja la lógica de persistencia mixta (SQLite + SharedPreferences)
class FavoritoEjercicioRepositoryImpl implements FavoritoEjercicioRepository {
  final FavoritoEjercicioLocalDataSource localDataSource;
  final ExerciseRepository exerciseRepository;

  FavoritoEjercicioRepositoryImpl({
    required this.localDataSource,
    required this.exerciseRepository,
  });

  @override
  Future<Either<Failure, FavoritoEjercicio>> agregarEjercicioAFavoritos(
    String ejercicioId,
  ) async {
    try {
      // Verificar si ya está en favoritos para evitar duplicados
      final yaEsFavorito =
          await localDataSource.esEjercicioFavorito(ejercicioId);
      if (yaEsFavorito) {
        return Left(CacheFailure(
          errorMessage: 'El ejercicio ya está en tu lista de favoritos',
        ));
      }

      final favorito =
          await localDataSource.agregarEjercicioAFavoritos(ejercicioId);
      return Right(favorito);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(
        errorMessage: 'Error de base de datos: ${e.message}',
      ));
    } catch (e) {
      return Left(CacheFailure(
        errorMessage: 'Error inesperado al agregar a favoritos: $e',
      ));
    }
  }

  @override
  Future<Either<Failure, bool>> removerEjercicioDeFavoritos(
    String ejercicioId,
  ) async {
    try {
      final resultado =
          await localDataSource.removerEjercicioDeFavoritos(ejercicioId);

      if (!resultado) {
        return Left(NoRecordsFailure(
          errorMessage: 'El ejercicio no se encontraba en favoritos',
        ));
      }

      return Right(resultado);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(
        errorMessage: 'Error de base de datos: ${e.message}',
      ));
    } catch (e) {
      return Left(CacheFailure(
        errorMessage: 'Error inesperado al remover de favoritos: $e',
      ));
    }
  }

  @override
  Future<Either<Failure, bool>> esEjercicioFavorito(
    String ejercicioId,
  ) async {
    try {
      final esFavorito = await localDataSource.esEjercicioFavorito(ejercicioId);
      return Right(esFavorito);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(
        errorMessage: 'Error de base de datos: ${e.message}',
      ));
    } catch (e) {
      return Left(CacheFailure(
        errorMessage: 'Error inesperado al verificar favorito: $e',
      ));
    }
  }

  @override
  Future<Either<Failure, List<FavoritoEjercicio>>>
      obtenerTodosLosFavoritos() async {
    try {
      final favoritos = await localDataSource.obtenerTodosLosFavoritos();

      if (favoritos.isEmpty) {
        return Left(NoRecordsFailure(
          errorMessage: 'No tienes ejercicios favoritos guardados aún',
        ));
      }

      return Right(favoritos);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(
        errorMessage: 'Error de base de datos: ${e.message}',
      ));
    } catch (e) {
      return Left(CacheFailure(
        errorMessage: 'Error inesperado al obtener favoritos: $e',
      ));
    }
  }

  @override
  Future<Either<Failure, List<String>>> obtenerIdsFavoritos() async {
    try {
      final idsFavoritos = await localDataSource.obtenerIdsFavoritos();
      return Right(idsFavoritos);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(
        errorMessage: 'Error de base de datos: ${e.message}',
      ));
    } catch (e) {
      return Left(CacheFailure(
        errorMessage: 'Error inesperado al obtener IDs de favoritos: $e',
      ));
    }
  }

  @override
  Future<Either<Failure, int>> obtenerCantidadFavoritos() async {
    try {
      final cantidad = await localDataSource.obtenerCantidadFavoritos();
      return Right(cantidad);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(
        errorMessage: 'Error de base de datos: ${e.message}',
      ));
    } catch (e) {
      return Left(CacheFailure(
        errorMessage: 'Error inesperado al obtener cantidad de favoritos: $e',
      ));
    }
  }

  @override
  Future<Either<Failure, bool>> limpiarTodosLosFavoritos() async {
    try {
      final resultado = await localDataSource.limpiarTodosLosFavoritos();
      return Right(resultado);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(
        errorMessage: 'Error de base de datos: ${e.message}',
      ));
    } catch (e) {
      return Left(CacheFailure(
        errorMessage: 'Error inesperado al limpiar favoritos: $e',
      ));
    }
  }

  @override
  Future<Either<Failure, List<Exercise>>> obtenerEjerciciosFavoritos() async {
    try {
      // Obtener IDs de ejercicios favoritos
      final idsFavoritos =
          await localDataSource.obtenerIdsFavoritosParaEjercicios();

      if (idsFavoritos.isEmpty) {
        // Devolver lista vacía en lugar de error cuando no hay favoritos
        return const Right([]);
      }

      // Obtener datos completos de cada ejercicio
      final List<Exercise> ejerciciosFavoritos = [];

      for (final id in idsFavoritos) {
        final ejercicioResult =
            await exerciseRepository.obtenerEjercicioPorId(id);
        ejercicioResult.fold(
          (failure) {
            // Log el error, pero continúa con los otros ejercicios
            print(
                'Warning: No se pudo obtener ejercicio $id: ${failure.errorMessage}');
          },
          (ejercicio) => ejerciciosFavoritos.add(ejercicio),
        );
      }

      if (ejerciciosFavoritos.isEmpty) {
        return Left(NoRecordsFailure(
          errorMessage: 'No se pudieron cargar los ejercicios favoritos',
        ));
      }

      return Right(ejerciciosFavoritos);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(
        errorMessage: 'Error de base de datos: ${e.message}',
      ));
    } catch (e) {
      return Left(CacheFailure(
        errorMessage: 'Error inesperado al obtener ejercicios favoritos: $e',
      ));
    }
  }
}
