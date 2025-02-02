import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/routine/domain/entities/routine.dart';
import 'package:gymaster/features/routine/domain/repositories/rutine_repository.dart';
import 'package:fpdart/fpdart.dart';

class AddRoutineUseCase implements UseCase<Routine, AddRoutineParams> {
  final RoutineRepository _routineRepository;

  AddRoutineUseCase(this._routineRepository);

  @override
  Future<Either<Failure, Routine>> call(AddRoutineParams params) async {
    return await _routineRepository.addRoutine(
      name: params.name,
      description: params.description,
      creationDate: params.creationDate,
      done: params.done,
      color: params.color,
      imagenDireccion: params.imagenDireccion,
    );
  }
}

class AddRoutineParams {
  final String name;
  String? description;
  final DateTime creationDate;
  final bool done;
  final int color;
  final String imagenDireccion;

  AddRoutineParams({
    required this.name,
    this.description,
    required this.creationDate,
    required this.done,
    required this.color,
    required this.imagenDireccion,
  });
}
