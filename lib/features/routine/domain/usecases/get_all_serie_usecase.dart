import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/routine/domain/repositories/rutine_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetAllSerieUseCase implements UseCase<void, SerieParams> {
  final RoutineRepository repository;

  GetAllSerieUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SerieParams params) async {
    return await repository.getAllEjercicioByRutinaId(
      rutinaId: params.id,
      idRoutineSession: params.idRoutineSession,
    );
  }
}

class SerieParams {
  final String id;
  final String idRoutineSession;

  SerieParams({required this.id, required this.idRoutineSession});
}
