import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/record/domain/entities/record_rutina.dart';
import 'package:gymaster/features/record/domain/usecases/delete_rutina_usecase.dart';
import 'package:gymaster/features/record/domain/usecases/get_all_completed_routines_with_exercises.dart';
import 'package:gymaster/features/record/domain/usecases/get_all_rutinas_usecase.dart';
import 'package:gymaster/features/record/domain/usecases/get_rutina_by_id_usecase.dart';
import 'package:gymaster/features/record/domain/usecases/save_rutina_usecase.dart';
import 'package:gymaster/features/record/presentation/cubit/record_state.dart';

/// `RecordCubit` es una clase que extiende `Cubit<RecordState>` y maneja
/// la lógica de negocio para la gestión de rutinas de ejercicios.
///
/// Esta clase se comunica con los casos de uso para obtener, guardar y eliminar
/// rutinas, y emite estados correspondientes para actualizar la UI.
class RecordCubit extends Cubit<RecordState> {
  final GetAllCompletedRoutinesWithExercises
      getAllCompletedRoutinesWithExercises;
  final GetAllRutinasUseCase getAllRutinasUseCase;
  final GetRutinaByIdUseCase getRutinaByIdUseCase;
  final SaveRutinaUseCase saveRutinaUseCase;
  final DeleteRutinaUseCase deleteRutinaUseCase;

  /// Constructor para `RecordCubit`.
  ///
  /// Requiere los casos de uso necesarios para manejar las rutinas.
  RecordCubit({
    required this.getAllCompletedRoutinesWithExercises,
    required this.getAllRutinasUseCase,
    required this.getRutinaByIdUseCase,
    required this.saveRutinaUseCase,
    required this.deleteRutinaUseCase,
  }) : super(RecordInitial());

  /// Obtiene todas las rutinas y emite el estado correspondiente.
  ///
  /// Emite `RecordLoading` mientras se obtienen las rutinas.
  /// Si la operación es exitosa, emite `RecordLoaded` con las rutinas obtenidas.
  /// Si ocurre un error, emite `RecordError` con un mensaje de error.
  Future<void> fetchAllRutinas() async {
    emit(RecordLoading());
    final result = await getAllCompletedRoutinesWithExercises(NoParams());
    result.fold(
      (failure) => emit(RecordError(_mapFailureToMessage(failure))),
      (rutinas) => emit(RecordLoaded(rutinas: rutinas)),
    );
  }

  /// Obtiene una rutina por su ID y emite el estado correspondiente.
  ///
  /// Emite `RecordLoading` mientras se obtiene la rutina.
  /// Si la operación es exitosa, emite `RutinaLoaded` con la rutina obtenida.
  /// Si ocurre un error, emite `RecordError` con un mensaje de error.
  Future<void> fetchRutinaById(String id) async {
    emit(RecordLoading());
    final result = await getRutinaByIdUseCase(GetRutinaByIdParams(id: id));
    result.fold(
      (failure) => emit(RecordError(_mapFailureToMessage(failure))),
      (rutina) => emit(RutinaLoaded(rutina: rutina)),
    );
  }

  /// Guarda una rutina y emite el estado correspondiente.
  ///
  /// Emite `RecordLoading` mientras se guarda la rutina.
  /// Si la operación es exitosa, vuelve a obtener todas las rutinas.
  /// Si ocurre un error, emite `RecordError` con un mensaje de error.
  Future<void> saveRutina(RecordRutina rutina) async {
    emit(RecordLoading());
    final result = await saveRutinaUseCase(SaveRutinaParams(rutina: rutina));
    result.fold(
      (failure) => emit(RecordError(_mapFailureToMessage(failure))),
      (_) => fetchAllRutinas(),
    );
  }

  /// Elimina una rutina por su ID y emite el estado correspondiente.
  ///
  /// Emite `RecordLoading` mientras se elimina la rutina.
  /// Si la operación es exitosa, vuelve a obtener todas las rutinas.
  /// Si ocurre un error, emite `RecordError` con un mensaje de error.
  Future<void> deleteRutina(String id) async {
    emit(RecordLoading());
    final result = await deleteRutinaUseCase(DeleteRutinaParams(id: id));
    result.fold(
      (failure) => emit(RecordError(_mapFailureToMessage(failure))),
      (_) => fetchAllRutinas(),
    );
  }

  /// Mapea un `Failure` a un mensaje de error.
  ///
  /// Este método convierte un objeto `Failure` en un mensaje de error
  /// legible para el usuario.
  String _mapFailureToMessage(Failure failure) {
    // Implement mapping of Failure to error message here
    return 'An error occurred';
  }
}
