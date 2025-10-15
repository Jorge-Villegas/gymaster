import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/estadisticas/domain/entities/progreso_ejercicio.dart';
import 'package:gymaster/features/estadisticas/domain/repositories/estadisticas_repository.dart';

class ObtenerProgresoEjercicioUseCase
    implements UseCase<ProgresoEjercicio, ObtenerProgresoEjercicioParams> {
  final EstadisticasRepository _repository;

  ObtenerProgresoEjercicioUseCase(this._repository);

  @override
  Future<Either<Failure, ProgresoEjercicio>> call(
    ObtenerProgresoEjercicioParams params,
  ) async {
    return await _repository.obtenerProgresoEjercicio(
      ejercicioId: params.ejercicioId,
      fechaInicio: params.fechaInicio,
      fechaFin: params.fechaFin,
    );
  }
}

/// Parámetros para obtener el progreso de un ejercicio.
class ObtenerProgresoEjercicioParams {
  final String ejercicioId;
  final DateTime fechaInicio;
  final DateTime fechaFin;

  ObtenerProgresoEjercicioParams({
    required this.ejercicioId,
    required this.fechaInicio,
    required this.fechaFin,
  });
}
