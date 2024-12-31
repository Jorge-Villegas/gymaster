import 'package:gymaster/core/error/timeout_helper.dart';
import 'package:gymaster/features/routine/domain/entities/ejercicios_de_rutina.dart';
import 'package:gymaster/features/routine/domain/usecases/get_all_ejercicios_by_rutina.dart';
import 'package:gymaster/features/routine/domain/usecases/update_serie.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'ejercicios_by_rutina_state.dart';

class EjerciciosByRutinaCubit extends Cubit<EjerciciosByRutinaState> {
  final GetAllEjerciciosByRutinaUseCase getAllEjerciciosByRutinaUseCase;
  final UpdateSerieUseCase updateSerieUseCase;

  EjerciciosByRutinaCubit(
    this.getAllEjerciciosByRutinaUseCase,
    this.updateSerieUseCase,
  ) : super(EjerciciosByRutinaInitial());

  void aumentarPeso() => _updatePeso(2.5);

  void disminuirPeso() => _updatePeso(-2.5);

  void aumentarRepeticiones() => _updateRepeticiones(1);

  void disminuirRepeticiones() => _updateRepeticiones(-1);

  void _updatePeso(double increment) {
    if (state is! EjerciciosByRutinaSuccess) return;
    final currentState = state as EjerciciosByRutinaSuccess;
    final ejercicio =
        currentState.ejerciciosDeRutina.ejercicios[currentState.ejercicioIndex];
    final newPeso = ejercicio.series[currentState.serieIndex].peso + increment;
    if (newPeso >= 0) {
      final updatedSerie =
          ejercicio.series[currentState.serieIndex].copyWith(peso: newPeso);
      _updateSerie(currentState, updatedSerie);
      updateSerieUseCase(
        UpdateSerieParams(
          id: updatedSerie.id,
          peso: updatedSerie.peso,
        ),
      );
    }
  }

  void _updateRepeticiones(int increment) {
    if (state is! EjerciciosByRutinaSuccess) return;
    final currentState = state as EjerciciosByRutinaSuccess;
    final ejercicio =
        currentState.ejerciciosDeRutina.ejercicios[currentState.ejercicioIndex];
    final newRepeticiones =
        ejercicio.series[currentState.serieIndex].repeticiones + increment;
    if (newRepeticiones >= 0) {
      final updatedSerie = ejercicio.series[currentState.serieIndex]
          .copyWith(repeticiones: newRepeticiones);

      _updateSerie(currentState, updatedSerie);
      updateSerieUseCase(
        UpdateSerieParams(
          id: updatedSerie.id,
          repeticiones: updatedSerie.repeticiones,
        ),
      );
    }
  }

  void getAllEjercicios({required String idRutina}) async {
    try {
      emit(EjerciciosByRutinaLoading());
      final result = await runWithTimeout(
        () => getAllEjerciciosByRutinaUseCase(
            GetAllEjerciciosByRutinaParams(id: idRutina)),
      );

      result.fold(
        (l) => emit(EjerciciosByRutinaError('Error al obtener los ejercicios')),
        (r) {
          print('Ejercicios obtenidos: $r');
          _handleEjerciciosResult(r);
        },
      );
    } catch (e) {
      emit(EjerciciosByRutinaError(e.toString()));
    }
  }

  void _handleEjerciciosResult(EjerciciosDeRutina r) {
    if (r.ejercicios.isEmpty) {
      emit(EjerciciosByRutinaSuccess(
        ejerciciosDeRutina: r,
        ejercicioIndex: 0,
        serieIndex: 0,
      ));
      return;
    }
    for (int i = 0; i < r.ejercicios.length; i++) {
      for (int j = 0; j < r.ejercicios[i].series.length; j++) {
        if (!r.ejercicios[i].series[j].realizado) {
          emit(EjerciciosByRutinaSuccess(
            ejerciciosDeRutina: r,
            ejercicioIndex: i,
            serieIndex: j,
          ));
          return;
        }
      }
    }
    emit(EjerciciosByRutinaError("La rutina ha sido finalizada"));
  }

  void avanzarSerie() {
    if (state is! EjerciciosByRutinaSuccess) return;
    final currentState = state as EjerciciosByRutinaSuccess;
    final updatedSerie = _markSerieAsCompleted(currentState);
    _updateSerie(currentState, updatedSerie);
    _emitNextSerieState();
    print(currentState.ejerciciosDeRutina.ejercicios);
  }

  Serie _markSerieAsCompleted(EjerciciosByRutinaSuccess currentState) {
    final ejercicio =
        currentState.ejerciciosDeRutina.ejercicios[currentState.ejercicioIndex];
    final serie = ejercicio.series[currentState.serieIndex];
    updateSerieUseCase(UpdateSerieParams(id: serie.id, realizado: true));
    serie.copyWith(realizado: true);
    print('Serie realizada: $serie');
    return serie.copyWith(realizado: true);
  }

  void _emitNextSerieState() {
    if (state is! EjerciciosByRutinaSuccess) return;
    final currentState = state as EjerciciosByRutinaSuccess;
    final ejercicios = currentState.ejerciciosDeRutina.ejercicios;
    int ejercicioIndex = currentState.ejercicioIndex;
    int serieIndex = currentState.serieIndex;

    if (serieIndex + 1 < ejercicios[ejercicioIndex].series.length) {
      serieIndex++;
    } else if (ejercicioIndex + 1 < ejercicios.length) {
      ejercicioIndex++;
      serieIndex = 0;
    } else {
      emit(EjerciciosByRutinaCompleted());
      return;
    }

    emit(EjerciciosByRutinaSuccess(
      ejerciciosDeRutina: currentState.ejerciciosDeRutina,
      ejercicioIndex: ejercicioIndex,
      serieIndex: serieIndex,
    ));
  }

  void _updateSerie(
    EjerciciosByRutinaSuccess currentState,
    Serie updatedSerie,
  ) {
    final updatedEjercicios = currentState.ejerciciosDeRutina.ejercicios.map(
      (ejercicio) {
        if (ejercicio.id ==
            currentState.ejerciciosDeRutina
                .ejercicios[currentState.ejercicioIndex].id) {
          final updatedSeries = ejercicio.series.map((serie) {
            return serie.id == updatedSerie.id ? updatedSerie : serie;
          }).toList();
          return ejercicio.copyWith(series: updatedSeries);
        }
        return ejercicio;
      },
    ).toList();

    emit(EjerciciosByRutinaSuccess(
      ejerciciosDeRutina: currentState.ejerciciosDeRutina
          .copyWith(ejercicios: updatedEjercicios),
      ejercicioIndex: currentState.ejercicioIndex,
      serieIndex: currentState.serieIndex,
    ));
  }
}
