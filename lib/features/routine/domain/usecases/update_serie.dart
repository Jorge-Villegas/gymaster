import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/routine/domain/entities/serie.dart';
import 'package:gymaster/features/routine/domain/repositories/rutine_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateSerieUseCase implements UseCase<void, UpdateSerieParams> {
  final RoutineRepository repository;

  UpdateSerieUseCase(this.repository);

  @override
  Future<Either<Failure, Serie>> call(UpdateSerieParams params) async {
    return await repository.updateSerie(
      id: params.id,
      peso: params.peso,
      repeticiones: params.repeticiones,
      realizado: params.realizado,
      tiempoDescanso: params.tiempoDescanso,
    );
  }
}

class UpdateSerieParams {
  final String id;
  double? peso;
  int? repeticiones;
  bool? realizado;
  int? tiempoDescanso;

  UpdateSerieParams({
    required this.id,
    this.peso,
    this.repeticiones,
    this.realizado,
    this.tiempoDescanso,
  });
}
