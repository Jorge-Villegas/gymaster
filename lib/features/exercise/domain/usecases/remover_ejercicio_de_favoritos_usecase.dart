import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/exercise/domain/repositories/favorito_ejercicio_repository.dart';

/// Caso de uso para remover un ejercicio de favoritos
/// Implementa patrón Command para operaciones de eliminación
class RemoverEjercicioDeFavoritosUseCase
    implements UseCase<bool, RemoverEjercicioDeFavoritosParams> {
  final FavoritoEjercicioRepository repository;

  RemoverEjercicioDeFavoritosUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(
    RemoverEjercicioDeFavoritosParams params,
  ) async {
    return await repository.removerEjercicioDeFavoritos(params.ejercicioId);
  }
}

/// Parámetros para el caso de uso RemoverEjercicioDeFavoritos
class RemoverEjercicioDeFavoritosParams {
  final String ejercicioId;

  RemoverEjercicioDeFavoritosParams({
    required this.ejercicioId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RemoverEjercicioDeFavoritosParams &&
          runtimeType == other.runtimeType &&
          ejercicioId == other.ejercicioId;

  @override
  int get hashCode => ejercicioId.hashCode;
}
