import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/routine/domain/repositories/rutine_repository.dart';
import 'package:fpdart/fpdart.dart';

class EliminarRutinaPlantillaUseCase
    extends UseCase<void, EliminarRutinaPlantillaParams> {
  final RoutineRepository repository;

  EliminarRutinaPlantillaUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(
      EliminarRutinaPlantillaParams params) async {
    return await repository.deleteRoutine(id: params.id);
  }
}

class EliminarRutinaPlantillaParams {
  final String id;

  EliminarRutinaPlantillaParams({
    required this.id,
  });
}
