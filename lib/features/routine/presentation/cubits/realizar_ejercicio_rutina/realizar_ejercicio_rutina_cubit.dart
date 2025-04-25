import 'package:gymaster/features/routine/domain/entities/ejercicios_de_rutina.dart';
import 'package:gymaster/features/routine/domain/usecases/update_serie.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gymaster/shared/utils/enum.dart';

part 'realizar_ejercicio_rutina_state.dart';

class RealizarEjercicioRutinaCubit extends Cubit<RealizarEjercicioRutinaState> {
  final UpdateSerieUseCase updateSerieUseCase;

  RealizarEjercicioRutinaCubit(this.updateSerieUseCase)
    : super(RealizarEjercicioRutinaInitial());

  iniciar({required EjerciciosDeRutina ejerciciosDeRutina}) {
    for (var ejercicio in ejerciciosDeRutina.ejercicios) {
      for (var serie in ejercicio.series) {
        if (!(serie.estado == ExerciseSetStatus.completed.name)) {
          _updateData(ejercicio: ejercicio, serie: serie);
          return;
        }
      }
    }
  }

  _updateData({required Ejercicio ejercicio, required Serie serie}) {
    emit(RealizarEjercicioRutinaLoaded(ejercicio: ejercicio, serie: serie));
  }

  void aumentarPeso() {
    if (state is RealizarEjercicioRutinaLoaded) {
      final currentState = state as RealizarEjercicioRutinaLoaded;
      final updatedSerie = currentState.serie.copyWith(
        peso: currentState.serie.peso + 0.5,
      );
      _updateData(ejercicio: currentState.ejercicio, serie: updatedSerie);
      updateSerieUseCase(
        UpdateSerieParams(id: currentState.serie.id, peso: updatedSerie.peso),
      );
    }
  }

  void disminuirPeso() {
    if (state is RealizarEjercicioRutinaLoaded) {
      final currentState = state as RealizarEjercicioRutinaLoaded;
      final newPeso = currentState.serie.peso - 0.5;
      if (newPeso >= 0) {
        final updatedSerie = currentState.serie.copyWith(peso: newPeso);
        _updateData(ejercicio: currentState.ejercicio, serie: updatedSerie);
        updateSerieUseCase(
          UpdateSerieParams(id: currentState.serie.id, peso: updatedSerie.peso),
        );
      }
    }
  }

  void aumentarRepeticiones() {
    if (state is RealizarEjercicioRutinaLoaded) {
      final currentState = state as RealizarEjercicioRutinaLoaded;
      final updatedSerie = currentState.serie.copyWith(
        repeticiones: currentState.serie.repeticiones + 1,
      );
      _updateData(ejercicio: currentState.ejercicio, serie: updatedSerie);
      updateSerieUseCase(
        UpdateSerieParams(
          id: currentState.serie.id,
          repeticiones: updatedSerie.repeticiones,
        ),
      );
    }
  }

  void disminuirRepeticiones() {
    if (state is RealizarEjercicioRutinaLoaded) {
      final currentState = state as RealizarEjercicioRutinaLoaded;
      final newRepeticiones = currentState.serie.repeticiones - 1;
      if (newRepeticiones >= 0) {
        final updatedSerie = currentState.serie.copyWith(
          repeticiones: newRepeticiones,
        );
        _updateData(ejercicio: currentState.ejercicio, serie: updatedSerie);
        updateSerieUseCase(
          UpdateSerieParams(
            id: currentState.serie.id,
            repeticiones: updatedSerie.repeticiones,
          ),
        );
      }
    }
  }
}
