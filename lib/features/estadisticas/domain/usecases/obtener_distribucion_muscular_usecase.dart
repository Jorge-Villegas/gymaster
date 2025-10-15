import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/estadisticas/domain/entities/distribucion_muscular.dart';
import 'package:gymaster/features/estadisticas/domain/repositories/estadisticas_repository.dart';

class ObtenerDistribucionMuscularUseCase
    implements
        UseCase<List<DistribucionMuscular>, ObtenerDistribucionMuscularParams> {
  final EstadisticasRepository _repository;

  ObtenerDistribucionMuscularUseCase(this._repository);

  @override
  Future<Either<Failure, List<DistribucionMuscular>>> call(
    ObtenerDistribucionMuscularParams params,
  ) async {
    return await _repository.obtenerDistribucionMuscular(
      fechaInicio: params.fechaInicio,
      fechaFin: params.fechaFin,
    );
  }
}

/// Parámetros para obtener la distribución muscular.
class ObtenerDistribucionMuscularParams {
  final DateTime fechaInicio;
  final DateTime fechaFin;

  ObtenerDistribucionMuscularParams({
    required this.fechaInicio,
    required this.fechaFin,
  });
}
