import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/routine/domain/entities/musculo.dart';
import 'package:gymaster/features/routine/domain/repositories/rutine_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetAllMusculoUsecase implements UseCase<List<Musculo>, NoParams> {
  final RoutineRepository repository;

  GetAllMusculoUsecase(this.repository);

  @override
  Future<Either<Failure, List<Musculo>>> call(NoParams params) async {
    return await repository.getAllMusculos();
  }
}
