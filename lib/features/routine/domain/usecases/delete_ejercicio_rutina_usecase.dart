import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/routine/domain/repositories/rutine_repository.dart';

class DeleteEjercicioRutinaUseCase
    implements UseCase<void, DeleteEjercicioRutinaParams> {
  final RoutineRepository repository;

  DeleteEjercicioRutinaUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(DeleteEjercicioRutinaParams params) async {
    return await repository.deleteEjercicioRutina(
      params.idEjercicio,
      params.idSesion,
    );
  }
}

class DeleteEjercicioRutinaParams {
  final String idEjercicio;
  final String idSesion;

  DeleteEjercicioRutinaParams({
    required this.idEjercicio,
    required this.idSesion,
  });
}
