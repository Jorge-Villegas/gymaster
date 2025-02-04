import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/routine/domain/entities/routine.dart';
import 'package:gymaster/features/routine/domain/usecases/add_routine_usecase.dart';
import 'package:gymaster/features/routine/domain/usecases/delete_routine_usecase.dart';
import 'package:gymaster/features/routine/domain/usecases/get_all_routine_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:gymaster/features/routine/domain/usecases/get_routine_by_name_usecase.dartget_routine_by_name_usecase.dart';

part 'routine_state.dart';

class RoutineCubit extends Cubit<RoutineState> {
  final AddRoutineUseCase addRoutineUseCase;
  final GetAllRoutineUsecase getAllRoutineUseCase;
  final DeleteRoutineUseCase deleteRoutineUseCase;
  final GetRoutineByNameUseCase getRoutineByNameUseCase;

  RoutineCubit({
    required this.addRoutineUseCase,
    required this.getAllRoutineUseCase,
    required this.deleteRoutineUseCase,
    required this.getRoutineByNameUseCase,
  }) : super(RoutineInitial()) {
    getAllRoutine();
  }

  addRoutine({
    required String name,
    String? description,
    required DateTime creationDate,
    required bool done,
    required int color,
    required String imagenDireccion,
  }) async {
    emit(RoutineLoading());
    final result = await addRoutineUseCase(
      AddRoutineParams(
        name: name,
        description: description,
        creationDate: creationDate,
        done: done,
        color: color,
        imagenDireccion: imagenDireccion,
      ),
    );
    result.fold(
      (l) => emit(RoutineError('Error al agregar rutina')),
      (r) => emit(RoutineAddSuccess(r)),
    );
  }

  void getRoutines({
    required String name,
    required String description,
    required DateTime creationDate,
    required bool done,
    required int color,
    required String imagenDireccion,
  }) async {
    emit(RoutineLoading());

    final result = await addRoutineUseCase(
      AddRoutineParams(
        name: name,
        description: description,
        creationDate: creationDate,
        done: done,
        color: color,
        imagenDireccion: imagenDireccion,
      ),
    );
    result.fold(
      (l) => emit(RoutineError('Error al obtener rutinas')),
      (r) => emit(RoutineAddSuccess(r)),
    );
  }

  void getAllRoutine() async {
    emit(RoutineLoading());

    final result = await getAllRoutineUseCase(NoParams());
    debugPrint(result.toString());
    result.fold(
      (l) => emit(RoutineError('Error al obtener las rutinas')),
      (r) => emit(RoutineGetAllSuccess(r)),
    );
  }

  void deleteRoutine({required String id}) async {
    emit(RoutineLoading());
    final result = await deleteRoutineUseCase(DeleteRoutineParams(id: id));
    result.fold(
      (l) => emit(RoutineError('Error al eliminar rutina')),
      (r) => emit(RoutineDeleteSuccess()),
    );
  }

  void searchRoutineByName(String name) async {
    emit(RoutineLoading());
    final result = await getRoutineByNameUseCase(RoutineNameParams(name: name));
    result.fold(
      (failure) => emit(RoutineError('Error al buscar rutinas')),
      (routines) => emit(RoutineGetByNameSuccess(routines)),
    );
  }
}
