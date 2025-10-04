import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/estadisticas/domain/entities/recomendacion_muscular.dart';
import 'package:gymaster/features/estadisticas/domain/repositories/estadisticas_repository.dart';

/// UseCase para obtener músculos olvidados y recomendaciones.
///
/// Encapsula la lógica para identificar grupos musculares que no han
/// sido trabajados en un periodo determinado y generar recomendaciones.
class ObtenerMusculosOlvidadosUseCase
    implements
        UseCase<List<RecomendacionMuscular>, ObtenerMusculosOlvidadosParams> {
  final EstadisticasRepository _repository;

  ObtenerMusculosOlvidadosUseCase(this._repository);

  @override
  Future<Either<Failure, List<RecomendacionMuscular>>> call(
    ObtenerMusculosOlvidadosParams params,
  ) async {
    return await _repository.obtenerMusculosOlvidados(
      diasLimite: params.diasLimite,
    );
  }
}

/// Parámetros para obtener músculos olvidados.
class ObtenerMusculosOlvidadosParams {
  final int diasLimite;

  ObtenerMusculosOlvidadosParams({
    this.diasLimite = 7,
  });
}
