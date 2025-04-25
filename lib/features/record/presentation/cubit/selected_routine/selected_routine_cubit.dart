import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymaster/features/record/domain/entities/record_rutina.dart';
import 'package:gymaster/features/record/presentation/cubit/selected_routine/selected_routine_state.dart';

class SelectedRoutineCubit extends Cubit<SelectedRoutineState> {
  SelectedRoutineCubit() : super(SelectedRoutineInitial());

  void incrementSeries(int ejercicioIndex, int seriesIndex) {
    if (state is SelectedRoutineLoaded) {
      final rutina = (state as SelectedRoutineLoaded).rutina;
      final ejercicios = List<RecordEjercicios>.from(rutina.ejercicios);
      final series = ejercicios[ejercicioIndex].seriesDelEjercicio[seriesIndex];
      ejercicios[ejercicioIndex].seriesDelEjercicio[seriesIndex] = series
          .copyWith(repeticiones: series.repeticiones + 1);
      emit(
        SelectedRoutineLoaded(rutina: rutina.copyWith(ejercicios: ejercicios)),
      );
    }
  }

  void decrementSeries(int ejercicioIndex, int seriesIndex) {
    if (state is SelectedRoutineLoaded) {
      final rutina = (state as SelectedRoutineLoaded).rutina;
      final ejercicios = List<RecordEjercicios>.from(rutina.ejercicios);
      final series = ejercicios[ejercicioIndex].seriesDelEjercicio[seriesIndex];
      if (series.repeticiones > 0) {
        ejercicios[ejercicioIndex].seriesDelEjercicio[seriesIndex] = series
            .copyWith(repeticiones: series.repeticiones - 1);
        emit(
          SelectedRoutineLoaded(
            rutina: rutina.copyWith(ejercicios: ejercicios),
          ),
        );
      }
    }
  }

  void incrementPeso(int ejercicioIndex, int seriesIndex) {
    if (state is SelectedRoutineLoaded) {
      final rutina = (state as SelectedRoutineLoaded).rutina;
      final ejercicios = List<RecordEjercicios>.from(rutina.ejercicios);
      final series = ejercicios[ejercicioIndex].seriesDelEjercicio[seriesIndex];
      ejercicios[ejercicioIndex].seriesDelEjercicio[seriesIndex] = series
          .copyWith(peso: series.peso + 1);
      emit(
        SelectedRoutineLoaded(rutina: rutina.copyWith(ejercicios: ejercicios)),
      );
    }
  }

  void decrementPeso(int ejercicioIndex, int seriesIndex) {
    if (state is SelectedRoutineLoaded) {
      final rutina = (state as SelectedRoutineLoaded).rutina;
      final ejercicios = List<RecordEjercicios>.from(rutina.ejercicios);
      final series = ejercicios[ejercicioIndex].seriesDelEjercicio[seriesIndex];
      if (series.peso > 0) {
        ejercicios[ejercicioIndex].seriesDelEjercicio[seriesIndex] = series
            .copyWith(peso: series.peso - 1);
        emit(
          SelectedRoutineLoaded(
            rutina: rutina.copyWith(ejercicios: ejercicios),
          ),
        );
      }
    }
  }

  void incrementReps(int ejercicioIndex, int seriesIndex) {
    if (state is SelectedRoutineLoaded) {
      final rutina = (state as SelectedRoutineLoaded).rutina;
      final ejercicios = List<RecordEjercicios>.from(rutina.ejercicios);
      final series = ejercicios[ejercicioIndex].seriesDelEjercicio[seriesIndex];
      ejercicios[ejercicioIndex].seriesDelEjercicio[seriesIndex] = series
          .copyWith(repeticiones: series.repeticiones + 1);
      emit(
        SelectedRoutineLoaded(rutina: rutina.copyWith(ejercicios: ejercicios)),
      );
    }
  }

  void decrementReps(int ejercicioIndex, int seriesIndex) {
    if (state is SelectedRoutineLoaded) {
      final rutina = (state as SelectedRoutineLoaded).rutina;
      final ejercicios = List<RecordEjercicios>.from(rutina.ejercicios);
      final series = ejercicios[ejercicioIndex].seriesDelEjercicio[seriesIndex];
      if (series.repeticiones > 0) {
        ejercicios[ejercicioIndex].seriesDelEjercicio[seriesIndex] = series
            .copyWith(repeticiones: series.repeticiones - 1);
        emit(
          SelectedRoutineLoaded(
            rutina: rutina.copyWith(ejercicios: ejercicios),
          ),
        );
      }
    }
  }

  void saveChanges(RecordRutina rutina) {
    emit(SelectedRoutineLoaded(rutina: rutina));
  }
}
