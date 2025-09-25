import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/features/exercise/domain/entities/favorito_ejercicio.dart';
import 'package:gymaster/features/exercise/domain/entities/exercise.dart';

/// Repository abstracto para manejo de ejercicios favoritos
/// Define la interfaz que debe implementar el repository concreto
abstract class FavoritoEjercicioRepository {
  /// Agrega un ejercicio a la lista de favoritos
  /// Retorna Either con el favorito creado o un Failure si ocurre error
  Future<Either<Failure, FavoritoEjercicio>> agregarEjercicioAFavoritos(
    String ejercicioId,
  );

  /// Remueve un ejercicio de la lista de favoritos
  /// Retorna Either con true si se removió exitosamente o Failure si ocurre error
  Future<Either<Failure, bool>> removerEjercicioDeFavoritos(
    String ejercicioId,
  );

  /// Verifica si un ejercicio específico está en favoritos
  /// Retorna Either con true/false o Failure si ocurre error
  Future<Either<Failure, bool>> esEjercicioFavorito(
    String ejercicioId,
  );

  /// Obtiene todos los ejercicios favoritos del usuario
  /// Retorna Either con la lista de favoritos o Failure si ocurre error
  Future<Either<Failure, List<FavoritoEjercicio>>> obtenerTodosLosFavoritos();

  /// Obtiene solo los IDs de los ejercicios favoritos
  /// Útil para verificaciones rápidas en listas
  Future<Either<Failure, List<String>>> obtenerIdsFavoritos();

  /// Obtiene la cantidad total de ejercicios favoritos
  /// Útil para estadísticas y badges en UI
  Future<Either<Failure, int>> obtenerCantidadFavoritos();

  /// Limpia todos los ejercicios favoritos
  /// Para casos de reset o limpieza completa
  Future<Either<Failure, bool>> limpiarTodosLosFavoritos();

  /// Obtiene los ejercicios favoritos completos con sus datos
  /// Útil para mostrar detalles en páginas de favoritos
  Future<Either<Failure, List<Exercise>>> obtenerEjerciciosFavoritos();
}
