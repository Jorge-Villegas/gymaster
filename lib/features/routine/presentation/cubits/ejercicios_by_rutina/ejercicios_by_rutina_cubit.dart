import 'package:gymaster/core/database/database_helper.dart';
import 'package:gymaster/core/database/models/routine_session.dart';
import 'package:gymaster/core/error/timeout_helper.dart';
import 'package:gymaster/features/routine/domain/entities/ejercicios_de_rutina.dart';
import 'package:gymaster/features/routine/domain/usecases/delete_ejercicio_rutina_usecase.dart';
import 'package:gymaster/features/routine/domain/usecases/get_all_ejercicios_by_rutina.dart';
import 'package:gymaster/features/routine/domain/usecases/get_last_routine_session_by_routine_id_usecase.dart';
import 'package:gymaster/features/routine/domain/usecases/update_serie.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'ejercicios_by_rutina_state.dart';

class EjerciciosByRutinaCubit extends Cubit<EjerciciosByRutinaState> {
  final GetAllEjerciciosByRutinaUseCase getAllEjerciciosByRutinaUseCase;
  final UpdateSerieUseCase updateSerieUseCase;
  final DeleteEjercicioRutinaUseCase deleteEjercicioRutinaUseCase;
  final GetLastRoutineSessionByRoutineId getLastRoutineSessionByRoutineId;

  EjerciciosByRutinaCubit(
    this.deleteEjercicioRutinaUseCase,
    this.getLastRoutineSessionByRoutineId,
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
      final updatedSerie = ejercicio.series[currentState.serieIndex].copyWith(
        peso: newPeso,
      );
      _updateSerie(currentState, updatedSerie);
      updateSerieUseCase(
        UpdateSerieParams(id: updatedSerie.id, peso: updatedSerie.peso),
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
      final updatedSerie = ejercicio.series[currentState.serieIndex].copyWith(
        repeticiones: newRepeticiones,
      );

      _updateSerie(currentState, updatedSerie);
      updateSerieUseCase(
        UpdateSerieParams(
          id: updatedSerie.id,
          repeticiones: updatedSerie.repeticiones,
        ),
      );
    }
  }

  Future<String> getRoutineSessionByRoutineId(String idRutina) async {
    RoutineSession? session;

    //obtenermos la ultima session de la rutina
    final resultSession = await runWithTimeout(
      () => getLastRoutineSessionByRoutineId(
        GetLastRoutineSessionByRoutineIdParams(idRoutine: idRutina),
      ),
    );

    resultSession.fold((l) => emit(EjerciciosByRutinaError(l.errorMessage)), (
      r,
    ) {
      session = r;
    });

    print('CUBIT -> sessionId: ${session!.id}');

    return session!.id;
  }

  void getAllEjercicios({required String idRutina}) async {
    try {
      emit(EjerciciosByRutinaLoading());

      RoutineSession? session;

      //obtenermos la ultima session de la rutina
      final resultSession = await runWithTimeout(
        () => getLastRoutineSessionByRoutineId(
          GetLastRoutineSessionByRoutineIdParams(idRoutine: idRutina),
        ),
      );

      resultSession.fold((l) => emit(EjerciciosByRutinaError(l.errorMessage)), (
        r,
      ) {
        session = r;
      });

      final result = await runWithTimeout(
        () => getAllEjerciciosByRutinaUseCase(
          GetAllEjerciciosByRutinaParams(
            id: idRutina,
            idRoutineSession: session!.id,
          ),
        ),
      );

      result.fold((l) => emit(EjerciciosByRutinaError(l.errorMessage)), (r) {
        print('Ejercicios obtenidos: $r');
        _handleEjerciciosResult(r);
      });
    } catch (e) {
      emit(EjerciciosByRutinaError(e.toString()));
    }
  }

  void _handleEjerciciosResult(EjerciciosDeRutina r) {
    if (r.ejercicios.isEmpty) {
      emit(
        EjerciciosByRutinaSuccess(
          ejerciciosDeRutina: r,
          ejercicioIndex: 0,
          serieIndex: 0,
        ),
      );
      return;
    }
    for (int i = 0; i < r.ejercicios.length; i++) {
      for (int j = 0; j < r.ejercicios[i].series.length; j++) {
        if (!r.ejercicios[i].series[j].realizado) {
          emit(
            EjerciciosByRutinaSuccess(
              ejerciciosDeRutina: r,
              ejercicioIndex: i,
              serieIndex: j,
            ),
          );
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
      // Avanza a la siguiente serie del ejercicio actual
      serieIndex++;
    } else if (ejercicioIndex + 1 < ejercicios.length) {
      // Avanza al siguiente ejercicio y reinicia el índice de la serie
      ejercicioIndex++;
      serieIndex = 0;
    } else {
      // Si no hay más series ni ejercicios, emite el estado de rutina completada
      emit(EjerciciosByRutinaCompleted());
      return;
    }

    // Emite el nuevo estado con los índices actualizados
    emit(
      EjerciciosByRutinaSuccess(
        ejerciciosDeRutina: currentState.ejerciciosDeRutina,
        ejercicioIndex: ejercicioIndex,
        serieIndex: serieIndex,
      ),
    );
  }

  void _updateSerie(
    EjerciciosByRutinaSuccess currentState,
    Serie updatedSerie,
  ) {
    final updatedEjercicios =
        currentState.ejerciciosDeRutina.ejercicios.map((ejercicio) {
          if (ejercicio.id ==
              currentState
                  .ejerciciosDeRutina
                  .ejercicios[currentState.ejercicioIndex]
                  .id) {
            final updatedSeries =
                ejercicio.series.map((serie) {
                  return serie.id == updatedSerie.id ? updatedSerie : serie;
                }).toList();
            return ejercicio.copyWith(series: updatedSeries);
          }
          return ejercicio;
        }).toList();

    emit(
      EjerciciosByRutinaSuccess(
        ejerciciosDeRutina: currentState.ejerciciosDeRutina.copyWith(
          ejercicios: updatedEjercicios,
        ),
        ejercicioIndex: currentState.ejercicioIndex,
        serieIndex: currentState.serieIndex,
      ),
    );
  }

  void updateEjercicioOrder(
    List<Ejercicio> newOrder,
    String routineSessionId,
  ) async {
    if (state is! EjerciciosByRutinaSuccess) return;
    final currentState = state as EjerciciosByRutinaSuccess;

    // Update the state with the new order
    final updatedEjerciciosDeRutina = currentState.ejerciciosDeRutina.copyWith(
      ejercicios: newOrder,
    );

    emit(
      EjerciciosByRutinaSuccess(
        ejerciciosDeRutina: updatedEjerciciosDeRutina,
        ejercicioIndex: currentState.ejercicioIndex,
        serieIndex: currentState.serieIndex,
      ),
    );

    // Now persist the changes to the database
    try {
      final db = await DatabaseHelper.instance.database;

      // Use a transaction to ensure all updates succeed or fail together
      await db.transaction((txn) async {
        for (int i = 0; i < newOrder.length; i++) {
          final ejercicio = newOrder[i];

          // Find the session_exercise_id for this exercise
          final sessionExerciseRows = await txn.query(
            DatabaseHelper.tbSessionExercise,
            where: 'session_id = ? AND exercise_id = ?',
            whereArgs: [routineSessionId, ejercicio.id],
          );

          if (sessionExerciseRows.isNotEmpty) {
            final sessionExerciseId = sessionExerciseRows.first['id'] as String;

            // Update the order_index
            await txn.update(
              DatabaseHelper.tbSessionExercise,
              {'order_index': i},
              where: 'id = ?',
              whereArgs: [sessionExerciseId],
            );
          }
        }
      });

      print('Successfully updated exercise order in database');
    } catch (e) {
      print('Error updating exercise order: $e');
    }
  }

  //eliminar un ejercicio de la rutina
  void deleteEjercicio(String idEjercicio, String idSesion) async {
    if (state is! EjerciciosByRutinaSuccess) return;
    final currentState = state as EjerciciosByRutinaSuccess;

    //Verificar si el ejercicio puede ser eliminado
    final canDelete = await checkCanDeleteEjercicio(idEjercicio, idSesion);

    if (canDelete) {
      // Actualice el estado solo si la eliminación fue exitosa
      final updatedEjercicios =
          currentState.ejerciciosDeRutina.ejercicios
              .where((ejercicio) => ejercicio.id != idEjercicio)
              .toList();

      final updatedEjerciciosDeRutina = currentState.ejerciciosDeRutina
          .copyWith(ejercicios: updatedEjercicios);

      emit(
        EjerciciosByRutinaSuccess(
          ejerciciosDeRutina: updatedEjerciciosDeRutina,
          ejercicioIndex: currentState.ejercicioIndex,
          serieIndex: currentState.serieIndex,
        ),
      );
    }
  }

  Future<bool> checkCanDeleteEjercicio(
    String idEjercicio,
    String idSesion,
  ) async {
    final result = await deleteEjercicioRutinaUseCase(
      DeleteEjercicioRutinaParams(idEjercicio: idEjercicio, idSesion: idSesion),
    );

    return result.fold((failure) {
      debugPrint('Error checking if can delete exercise: $failure');
      return false;
    }, (success) => success);
  }
}
