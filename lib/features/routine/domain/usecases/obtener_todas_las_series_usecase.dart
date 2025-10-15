import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/routine/domain/repositories/routine_repository.dart';
import 'package:fpdart/fpdart.dart';

class ObtenerTodasLasSeriesUseCase
    implements UseCase<void, ObtenerTodasLasSeriesParams> {
  final RoutineRepository repository;

  ObtenerTodasLasSeriesUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ObtenerTodasLasSeriesParams params) async {
    return await repository.getAllEjercicioByRutinaId(
      rutinaId: params.id,
      idRoutineSession: params.idRoutineSession,
    );
  }
}

class ObtenerTodasLasSeriesParams {
  final String id;
  final String idRoutineSession;

  ObtenerTodasLasSeriesParams(
      {required this.id, required this.idRoutineSession});
}
