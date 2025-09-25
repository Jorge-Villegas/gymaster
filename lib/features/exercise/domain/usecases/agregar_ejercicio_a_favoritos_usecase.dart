import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/exercise/domain/entities/favorito_ejercicio.dart';
import 'package:gymaster/features/exercise/domain/repositories/favorito_ejercicio_repository.dart';

/// Caso de uso para agregar un ejercicio a favoritos
/// Sigue el patrón Command y Single Responsibility Principle
class AgregarEjercicioAFavoritosUseCase
    implements UseCase<FavoritoEjercicio, AgregarEjercicioAFavoritosParams> {
  final FavoritoEjercicioRepository repository;

  AgregarEjercicioAFavoritosUseCase(this.repository);

  @override
  Future<Either<Failure, FavoritoEjercicio>> call(
    AgregarEjercicioAFavoritosParams params,
  ) async {
    return await repository.agregarEjercicioAFavoritos(params.ejercicioId);
  }
}

/// Parámetros para el caso de uso AgregarEjercicioAFavoritos
class AgregarEjercicioAFavoritosParams {
  final String ejercicioId;

  AgregarEjercicioAFavoritosParams({
    required this.ejercicioId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AgregarEjercicioAFavoritosParams &&
          runtimeType == other.runtimeType &&
          ejercicioId == other.ejercicioId;

  @override
  int get hashCode => ejercicioId.hashCode;
}
