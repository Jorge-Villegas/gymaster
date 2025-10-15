import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/estadisticas/domain/repositories/estadisticas_repository.dart';

class ObtenerResumenGeneralUseCase
    implements UseCase<Map<String, dynamic>, ObtenerResumenGeneralParams> {
  final EstadisticasRepository _repository;

  ObtenerResumenGeneralUseCase(this._repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(
    ObtenerResumenGeneralParams params,
  ) async {
    return await _repository.obtenerResumenGeneral(
      fechaInicio: params.fechaInicio,
      fechaFin: params.fechaFin,
    );
  }
}

/// Parámetros para obtener el resumen general.
class ObtenerResumenGeneralParams {
  final DateTime fechaInicio;
  final DateTime fechaFin;

  ObtenerResumenGeneralParams({
    required this.fechaInicio,
    required this.fechaFin,
  });
}
