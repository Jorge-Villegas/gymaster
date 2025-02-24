import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/routine/domain/entities/routine.dart';
import 'package:gymaster/features/routine/domain/repositories/rutine_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetRoutineByNameUseCase
    implements UseCase<List<Routine>, RoutineNameParams> {
  final RoutineRepository repository;

  GetRoutineByNameUseCase(this.repository);

  @override
  Future<Either<Failure, List<Routine>>> call(RoutineNameParams params) async {
    return await repository.getRoutineByName(name: params.name);
  }
}

class RoutineNameParams {
  final String name;

  RoutineNameParams({required this.name});
}
