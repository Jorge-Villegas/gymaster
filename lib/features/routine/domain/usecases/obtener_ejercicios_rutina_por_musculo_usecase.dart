import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/routine/domain/entities/ejercicios_por_musculo.dart';
import 'package:gymaster/features/routine/domain/repositories/rutine_repository.dart';

class ObtenerEjerciciosRutinaPorMusculoUseCase
    implements
        UseCase<List<EjerciciosPorMusculo>,
            ObtenerEjerciciosRutinaPorMusculoParams> {
  final RoutineRepository repository;

  ObtenerEjerciciosRutinaPorMusculoUseCase(this.repository);

  @override
  Future<Either<Failure, List<EjerciciosPorMusculo>>> call(
    ObtenerEjerciciosRutinaPorMusculoParams params,
  ) async {
    return await repository.getAllEjerciciosByMusculo(
      musculoId: params.musculoId,
    );
  }
}

class ObtenerEjerciciosRutinaPorMusculoParams {
  final String musculoId;

  ObtenerEjerciciosRutinaPorMusculoParams({required this.musculoId});
}
