import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/routine/domain/entities/routine.dart';
import 'package:gymaster/features/routine/domain/usecases/agregar_rutina_usecase.dart';
import 'package:gymaster/features/routine/domain/usecases/eliminar_rutina_plantilla_usecase.dart';
import 'package:gymaster/features/routine/domain/usecases/obtener_todas_las_rutinas_usecase.dart';
import 'package:gymaster/features/routine/domain/usecases/restore_routine_usecase.dart';
import 'package:gymaster/features/routine/domain/usecases/get_deleted_routines_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:gymaster/features/routine/domain/usecases/obtener_rutina_por_nombre_usecase.dart';

part 'routine_state.dart';

class RoutineCubit extends Cubit<RoutineState> {
  final AgregarRutinaUseCase addRoutineUseCase;
  final ObtenerTodasLasRutinasUseCase getAllRoutineUseCase;
  final EliminarRutinaPlantillaUseCase deleteRoutineUseCase;
  final RestoreRoutineUseCase? restoreRoutineUseCase;
  final GetDeletedRoutinesUseCase? getDeletedRoutinesUseCase;
  final ObtenerRutinaPorNombreUseCase getRoutineByNameUseCase;

  RoutineCubit({
    required this.addRoutineUseCase,
    required this.getAllRoutineUseCase,
    required this.deleteRoutineUseCase,
    required this.getRoutineByNameUseCase,
    this.restoreRoutineUseCase,
    this.getDeletedRoutinesUseCase,
  }) : super(RoutineInitial()) {
    getAllRoutine();
  }

  Future<void> addRoutine({
    required String name,
    String? description,
    required DateTime creationDate,
    required bool done,
    required int color,
    required String imagenDireccion,
  }) async {
    emit(RoutineLoading());
    final result = await addRoutineUseCase(
      AgregarRutinaParams(
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
      AgregarRutinaParams(
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
    result.fold(
      (l) => emit(RoutineError(l.errorMessage)),
      (r) => emit(RoutineGetAllSuccess(r)),
    );
  }

  /// Elimina lógicamente una rutina
  void deleteRoutine({required String id, String? routineName}) async {
    emit(RoutineLoading());
    final result =
        await deleteRoutineUseCase(EliminarRutinaPlantillaParams(id: id));
    result.fold(
      (failure) => emit(RoutineError(failure.errorMessage)),
      (_) {
        final message = routineName != null
            ? '¡Rutina "$routineName" eliminada exitosamente! 🗑️'
            : '¡Rutina eliminada exitosamente! 🗑️';
        emit(RoutineDeleteSuccess(id, message));
        // Actualizar la lista después de eliminar
        getAllRoutine();
      },
    );
  }

  void searchRoutineByName(String name) async {
    emit(RoutineLoading());
    final result =
        await getRoutineByNameUseCase(ObtenerRutinaPorNombreParams(name: name));
    result.fold(
      (failure) => emit(RoutineError('Error al buscar rutinas')),
      (routines) => emit(RoutineGetByNameSuccess(routines)),
    );
  }

  /// Restaura una rutina eliminada lógicamente
  void restoreRoutine({required String id, String? routineName}) async {
    if (restoreRoutineUseCase == null) {
      emit(RoutineError('Funcionalidad no disponible'));
      return;
    }

    emit(RoutineLoading());
    final result = await restoreRoutineUseCase!(RestoreRoutineParams(id: id));
    result.fold(
      (failure) => emit(RoutineError(failure.errorMessage)),
      (_) {
        final message = routineName != null
            ? '¡Rutina "$routineName" restaurada exitosamente! ✨'
            : '¡Rutina restaurada exitosamente! ✨';
        emit(RoutineRestoreSuccess(id, message));
        // Actualizar la lista después de restaurar
        getAllRoutine();
      },
    );
  }

  /// Obtiene todas las rutinas eliminadas (papelera)
  void getDeletedRoutines() async {
    if (getDeletedRoutinesUseCase == null) {
      emit(RoutineError('Funcionalidad no disponible'));
      return;
    }

    emit(RoutineLoading());
    final result = await getDeletedRoutinesUseCase!(NoParams());
    result.fold(
      (failure) => emit(RoutineError(failure.errorMessage)),
      (deletedRoutines) => emit(RoutineDeletedListSuccess(deletedRoutines)),
    );
  }
}
