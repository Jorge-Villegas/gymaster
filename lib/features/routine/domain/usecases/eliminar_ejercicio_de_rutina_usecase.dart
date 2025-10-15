import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/routine/domain/repositories/routine_repository.dart';

class EliminarEjercicioDeRutinaUseCase
    implements UseCase<void, EliminarEjercicioDeRutinaParams> {
  final RoutineRepository repository;

  EliminarEjercicioDeRutinaUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(
      EliminarEjercicioDeRutinaParams params) async {
    return await repository.deleteEjercicioRutina(
      params.idEjercicio,
      params.idSesion,
    );
  }
}

class EliminarEjercicioDeRutinaParams {
  final String idEjercicio;
  final String idSesion;

  EliminarEjercicioDeRutinaParams({
    required this.idEjercicio,
    required this.idSesion,
  });
}
