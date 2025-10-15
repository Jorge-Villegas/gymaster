import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/routine/domain/entities/musculo.dart';
import 'package:gymaster/features/routine/domain/repositories/routine_repository.dart';
import 'package:fpdart/fpdart.dart';

class ObtenerTodosLosMusculosUseCase
    implements UseCase<List<Musculo>, NoParams> {
  final RoutineRepository repository;

  ObtenerTodosLosMusculosUseCase(this.repository);

  @override
  Future<Either<Failure, List<Musculo>>> call(NoParams params) async {
    return await repository.getAllMusculos();
  }
}
