import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/exercise/domain/entities/exercise.dart';
import 'package:gymaster/features/exercise/domain/repositories/favorito_ejercicio_repository.dart';

/// Caso de uso para obtener todos los ejercicios favoritos del usuario
/// Implementa patrón Query para obtener listas de datos
class ObtenerEjerciciosFavoritosUseCase
    implements UseCase<List<Exercise>, NoParams> {
  final FavoritoEjercicioRepository repository;

  ObtenerEjerciciosFavoritosUseCase(this.repository);

  @override
  Future<Either<Failure, List<Exercise>>> call(NoParams params) async {
    return await repository.obtenerEjerciciosFavoritos();
  }
}
