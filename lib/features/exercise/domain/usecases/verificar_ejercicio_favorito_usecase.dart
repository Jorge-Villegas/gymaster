import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/exercise/domain/repositories/favorito_ejercicio_repository.dart';

/// Caso de uso para verificar si un ejercicio está en favoritos
/// Implementa patrón Query para consultas de verificación
class VerificarEjercicioFavoritoUseCase
    implements UseCase<bool, VerificarEjercicioFavoritoParams> {
  final FavoritoEjercicioRepository repository;

  VerificarEjercicioFavoritoUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(
    VerificarEjercicioFavoritoParams params,
  ) async {
    return await repository.esEjercicioFavorito(params.ejercicioId);
  }
}

/// Parámetros para el caso de uso VerificarEjercicioFavorito
class VerificarEjercicioFavoritoParams {
  final String ejercicioId;

  VerificarEjercicioFavoritoParams({
    required this.ejercicioId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VerificarEjercicioFavoritoParams &&
          runtimeType == other.runtimeType &&
          ejercicioId == other.ejercicioId;

  @override
  int get hashCode => ejercicioId.hashCode;
}
