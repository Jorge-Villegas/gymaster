import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/record/domain/entities/record_rutina.dart';
import 'package:gymaster/features/record/domain/usecases/delete_rutina_usecase.dart';
import 'package:gymaster/features/record/domain/usecases/get_all_completed_routines_with_exercises.dart';
import 'package:gymaster/features/record/domain/usecases/get_rutina_by_id_usecase.dart';
import 'package:gymaster/features/record/domain/usecases/save_rutina_usecase.dart';
import 'package:gymaster/features/record/presentation/cubit/record_state.dart';

class RecordCubit extends Cubit<RecordState> {
  final GetAllCompletedRoutinesWithExercises
  getAllCompletedRoutinesWithExercises;
  final GetRutinaByIdUseCase getRutinaByIdUseCase;
  final SaveRutinaUseCase saveRutinaUseCase;
  final DeleteRutinaUseCase deleteRutinaUseCase;

  RecordCubit({
    required this.getAllCompletedRoutinesWithExercises,
    required this.getRutinaByIdUseCase,
    required this.saveRutinaUseCase,
    required this.deleteRutinaUseCase,
  }) : super(RecordInitial());

  Future<void> getAllRutinas() async {
    emit(RecordLoading()); // Emitimos el estado de carga
    final result = await getAllCompletedRoutinesWithExercises(NoParams());
    result.fold(
      (failure) {
        emit(
          RecordError(_mapFailureToMessage(failure)),
        ); // Emitimos error si falla
      },
      (rutinas) {
        if (rutinas.isEmpty) {
          emit(
            RecordLoaded(rutinas: []),
          ); // Emitimos estado vacío si no hay rutinas
        } else {
          emit(RecordLoaded(rutinas: rutinas)); // Emitimos las rutinas cargadas
        }
      },
    );
  }

  Future<void> getRutinaById(String id) async {
    emit(RecordLoading());
    final result = await getRutinaByIdUseCase(GetRutinaByIdParams(id: id));
    result.fold(
      (failure) => emit(RecordError(_mapFailureToMessage(failure))),
      (rutina) => emit(RutinaLoaded(rutina: rutina)),
    );
  }

  Future<void> saveRutina(RecordRutina rutina) async {
    emit(RecordLoading());
    final result = await saveRutinaUseCase(SaveRutinaParams(rutina: rutina));
    result.fold(
      (failure) => emit(RecordError(_mapFailureToMessage(failure))),
      (_) => getAllRutinas(),
    );
  }

  Future<void> deleteRutina(String id) async {
    emit(RecordLoading());
    final result = await deleteRutinaUseCase(DeleteRutinaParams(id: id));
    result.fold(
      (failure) => emit(RecordError(_mapFailureToMessage(failure))),
      (_) => getAllRutinas(),
    );
  }

  void loadRecordRutinas(List<RecordRutina> recordRutinas) {
    emit(RecordLoaded(rutinas: recordRutinas));
  }

  void loadRecordRutina(RecordRutina recordRutina) {
    emit(RutinaLoaded(rutina: recordRutina));
  }

  void incrementSeries(int ejercicioIndex, int seriesIndex) {
    if (state is RutinaLoaded) {
      final rutina = (state as RutinaLoaded).rutina;
      final ejercicios = List<RecordEjercicios>.from(rutina.ejercicios);
      final series = ejercicios[ejercicioIndex].seriesDelEjercicio[seriesIndex];
      ejercicios[ejercicioIndex].seriesDelEjercicio[seriesIndex] = series
          .copyWith(repeticiones: series.repeticiones + 1);
      emit(RutinaLoaded(rutina: rutina.copyWith(ejercicios: ejercicios)));
    }
  }

  void decrementSeries(int ejercicioIndex, int seriesIndex) {
    if (state is RutinaLoaded) {
      final rutina = (state as RutinaLoaded).rutina;
      final ejercicios = List<RecordEjercicios>.from(rutina.ejercicios);
      final series = ejercicios[ejercicioIndex].seriesDelEjercicio[seriesIndex];
      if (series.repeticiones > 0) {
        ejercicios[ejercicioIndex].seriesDelEjercicio[seriesIndex] = series
            .copyWith(repeticiones: series.repeticiones - 1);
        emit(RutinaLoaded(rutina: rutina.copyWith(ejercicios: ejercicios)));
      }
    }
  }

  void incrementPeso(int ejercicioIndex, int seriesIndex) {
    if (state is RutinaLoaded) {
      final rutina = (state as RutinaLoaded).rutina;
      final ejercicios = List<RecordEjercicios>.from(rutina.ejercicios);
      final series = ejercicios[ejercicioIndex].seriesDelEjercicio[seriesIndex];
      ejercicios[ejercicioIndex].seriesDelEjercicio[seriesIndex] = series
          .copyWith(peso: series.peso + 1);
      emit(RutinaLoaded(rutina: rutina.copyWith(ejercicios: ejercicios)));
    }
  }

  void decrementPeso(int ejercicioIndex, int seriesIndex) {
    if (state is RutinaLoaded) {
      final rutina = (state as RutinaLoaded).rutina;
      final ejercicios = List<RecordEjercicios>.from(rutina.ejercicios);
      final series = ejercicios[ejercicioIndex].seriesDelEjercicio[seriesIndex];
      if (series.peso > 0) {
        ejercicios[ejercicioIndex].seriesDelEjercicio[seriesIndex] = series
            .copyWith(peso: series.peso - 1);
        emit(RutinaLoaded(rutina: rutina.copyWith(ejercicios: ejercicios)));
      }
    }
  }

  void incrementReps(int ejercicioIndex, int seriesIndex) {
    if (state is RutinaLoaded) {
      final rutina = (state as RutinaLoaded).rutina;
      final ejercicios = List<RecordEjercicios>.from(rutina.ejercicios);
      final series = ejercicios[ejercicioIndex].seriesDelEjercicio[seriesIndex];
      ejercicios[ejercicioIndex].seriesDelEjercicio[seriesIndex] = series
          .copyWith(repeticiones: series.repeticiones + 1);
      emit(RutinaLoaded(rutina: rutina.copyWith(ejercicios: ejercicios)));
    }
  }

  void decrementReps(int ejercicioIndex, int seriesIndex) {
    if (state is RutinaLoaded) {
      final rutina = (state as RutinaLoaded).rutina;
      final ejercicios = List<RecordEjercicios>.from(rutina.ejercicios);
      final series = ejercicios[ejercicioIndex].seriesDelEjercicio[seriesIndex];
      if (series.repeticiones > 0) {
        ejercicios[ejercicioIndex].seriesDelEjercicio[seriesIndex] = series
            .copyWith(repeticiones: series.repeticiones - 1);
        emit(RutinaLoaded(rutina: rutina.copyWith(ejercicios: ejercicios)));
      }
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure _:
        return 'Error del servidor. Por favor, intenta nuevamente más tarde.';
      case CacheFailure _:
        return 'Error de caché. No se pudieron cargar los datos almacenados.';
      default:
        return 'Ocurrió un error inesperado. Por favor, intenta nuevamente.';
    }
  }
}
