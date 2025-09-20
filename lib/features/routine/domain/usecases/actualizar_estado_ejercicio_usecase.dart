import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/routine/domain/repositories/rutine_repository.dart';
import 'package:fpdart/fpdart.dart';

class ActualizarEstadoEjercicioUseCase
    implements UseCase<void, ActualizarEstadoEjercicioParams> {
  final RoutineRepository repository;

  ActualizarEstadoEjercicioUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(
      ActualizarEstadoEjercicioParams params) async {
    return await repository.updateExerciseStatusById(
      exerciseId: params.exerciseId,
      routineSessionId: params.routineSessionId,
      statusExercise: params.statusExercise,
    );
  }
}

class ActualizarEstadoEjercicioParams {
  final String exerciseId;
  final String routineSessionId;
  final String statusExercise;

  ActualizarEstadoEjercicioParams({
    required this.exerciseId,
    required this.routineSessionId,
    required this.statusExercise,
  });
}
