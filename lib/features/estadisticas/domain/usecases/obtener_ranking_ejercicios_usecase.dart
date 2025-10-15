import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/estadisticas/domain/entities/ranking_ejercicio.dart';
import 'package:gymaster/features/estadisticas/domain/repositories/estadisticas_repository.dart';

class ObtenerRankingEjerciciosUseCase
    implements UseCase<List<RankingEjercicio>, ObtenerRankingEjerciciosParams> {
  final EstadisticasRepository _repository;

  ObtenerRankingEjerciciosUseCase(this._repository);

  @override
  Future<Either<Failure, List<RankingEjercicio>>> call(
    ObtenerRankingEjerciciosParams params,
  ) async {
    return await _repository.obtenerRankingEjercicios(
      fechaInicio: params.fechaInicio,
      fechaFin: params.fechaFin,
      limite: params.limite,
    );
  }
}

/// Parámetros para obtener el ranking de ejercicios.
class ObtenerRankingEjerciciosParams {
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final int limite;

  ObtenerRankingEjerciciosParams({
    required this.fechaInicio,
    required this.fechaFin,
    this.limite = 10,
  });
}
