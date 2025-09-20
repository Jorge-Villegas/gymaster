import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/routine/domain/entities/routine.dart';
import 'package:gymaster/features/routine/domain/repositories/rutine_repository.dart';
import 'package:fpdart/fpdart.dart';

class ObtenerRutinaPorNombreUseCase
    implements UseCase<List<Routine>, ObtenerRutinaPorNombreParams> {
  final RoutineRepository repository;

  ObtenerRutinaPorNombreUseCase(this.repository);

  @override
  Future<Either<Failure, List<Routine>>> call(
      ObtenerRutinaPorNombreParams params) async {
    return await repository.getRoutineByName(name: params.name);
  }
}

class ObtenerRutinaPorNombreParams {
  final String name;

  ObtenerRutinaPorNombreParams({required this.name});
}
