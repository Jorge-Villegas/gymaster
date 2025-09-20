import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/routine/domain/entities/serie.dart';
import 'package:gymaster/features/routine/domain/repositories/rutine_repository.dart';
import 'package:fpdart/fpdart.dart';

class ActualizarSerieUseCase implements UseCase<void, ActualizarSerieParams> {
  final RoutineRepository repository;

  ActualizarSerieUseCase(this.repository);

  @override
  Future<Either<Failure, Serie>> call(ActualizarSerieParams params) async {
    return await repository.updateSerie(
      id: params.id,
      peso: params.peso,
      repeticiones: params.repeticiones,
      realizado: params.realizado,
      tiempoDescanso: params.tiempoDescanso,
    );
  }
}

class ActualizarSerieParams {
  final String id;
  double? peso;
  int? repeticiones;
  bool? realizado;
  int? tiempoDescanso;

  ActualizarSerieParams({
    required this.id,
    this.peso,
    this.repeticiones,
    this.realizado,
    this.tiempoDescanso,
  });
}
