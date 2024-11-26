
import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/routine/domain/entities/ejercicios_por_musculo.dart';
import 'package:gymaster/features/routine/domain/repositories/rutine_repository.dart';

class GetAllEjerciciosByMusculoUseCase
    implements UseCase<List<EjerciciosPorMusculo>, GetAllEjerciciosByMusculoParams> {
  final RoutineRepository repository;

  GetAllEjerciciosByMusculoUseCase(this.repository);

  @override
  Future<Either<Failure, List<EjerciciosPorMusculo>>> call(
    GetAllEjerciciosByMusculoParams params,
  ) async {
    return await repository.getAllEjerciciosByMusculo(
      musculoId: params.musculoId,
    );
  }
}

class GetAllEjerciciosByMusculoParams {
  final String musculoId;

  GetAllEjerciciosByMusculoParams({required this.musculoId});
}
