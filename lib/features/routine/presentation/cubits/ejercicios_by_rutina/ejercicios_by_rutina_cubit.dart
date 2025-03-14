import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gymaster/core/database/database_helper.dart';
import 'package:gymaster/core/database/models/routine_session.dart';
import 'package:gymaster/core/error/timeout_helper.dart';
import 'package:gymaster/features/routine/domain/entities/ejercicios_de_rutina.dart';
import 'package:gymaster/features/routine/domain/usecases/complete_routine_session_usecase.dart';
import 'package:gymaster/features/routine/domain/usecases/delete_ejercicio_rutina_usecase.dart';
import 'package:gymaster/features/routine/domain/usecases/get_all_ejercicios_by_rutina.dart';
import 'package:gymaster/features/routine/domain/usecases/get_last_routine_session_by_routine_id_usecase.dart';
import 'package:gymaster/features/routine/domain/usecases/start_routine_session_usecase.dart';
import 'package:gymaster/features/routine/domain/usecases/stop_routine_session_usecase.dart';
import 'package:gymaster/features/routine/domain/usecases/update_exercise_status_usecase.dart';
import 'package:gymaster/features/routine/domain/usecases/update_serie.dart';
import 'package:gymaster/shared/utils/enum.dart';

part 'ejercicios_by_rutina_state.dart';

class EjerciciosByRutinaCubit extends Cubit<EjerciciosByRutinaState> {
  final GetAllEjerciciosByRutinaUseCase getAllEjerciciosByRutinaUseCase;
  final UpdateSerieUseCase updateSerieUseCase;
  final DeleteEjercicioRutinaUseCase deleteEjercicioRutinaUseCase;
  final GetLastRoutineSessionByRoutineId getLastRoutineSessionByRoutineId;
  final StartRoutineSessionUseCase startRoutineSessionUseCase;
  final StopRoutineSessionUseCase stopRoutineSessionUseCase;
  final CompleteRoutineSessionUseCase completeRoutineSessionUseCase;
  final UpdateExerciseStatusUseCase updateExerciseStatusUseCase;

  EjerciciosByRutinaCubit(
    this.deleteEjercicioRutinaUseCase,
    this.getLastRoutineSessionByRoutineId,
    this.getAllEjerciciosByRutinaUseCase,
    this.updateSerieUseCase,
    this.startRoutineSessionUseCase,
    this.stopRoutineSessionUseCase,
    this.completeRoutineSessionUseCase,
    this.updateExerciseStatusUseCase,
  ) : super(EjerciciosByRutinaInitial());

  void aumentarPeso() => _updatePeso(2.5);

  void disminuirPeso() => _updatePeso(-2.5);

  void aumentarRepeticiones() => _updateRepeticiones(1);

  void disminuirRepeticiones() => _updateRepeticiones(-1);

  void _updatePeso(double increment) {
    if (state is! EjerciciosByRutinaSuccess) return;
    final currentState = state as EjerciciosByRutinaSuccess;
    final ejercicio = currentState.ejerciciosDeRutina.ejercicios.firstWhere(
      (e) => e.id == currentState.ejercicioIndex,
    );
    final serie = ejercicio.series.firstWhere(
      (s) => s.id == currentState.serieIndex,
    );
    final newPeso = serie.peso + increment;
    if (newPeso >= 0) {
      final updatedSerie = serie.copyWith(peso: newPeso);
      _updateSerie(currentState, updatedSerie);
      updateSerieUseCase(
        UpdateSerieParams(id: updatedSerie.id, peso: updatedSerie.peso),
      );
    }
  }

  void _updateRepeticiones(int increment) {
    if (state is! EjerciciosByRutinaSuccess) return;
    final currentState = state as EjerciciosByRutinaSuccess;
    final ejercicio = currentState.ejerciciosDeRutina.ejercicios.firstWhere(
      (e) => e.id == currentState.ejercicioIndex,
    );
    final serie = ejercicio.series.firstWhere(
      (s) => s.id == currentState.serieIndex,
    );
    final newRepeticiones = serie.repeticiones + increment;
    if (newRepeticiones >= 0) {
      final updatedSerie = serie.copyWith(repeticiones: newRepeticiones);
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
        print('getAllEjercicios cubit: ${ejerciciosDeRutinaModelToJson(r)}');
        _handleEjerciciosResult(r);
      });
    } catch (e) {
      emit(EjerciciosByRutinaError(e.toString()));
    }
  }

  void _handleEjerciciosResult(EjerciciosDeRutina r) {
    if (r.estado == RoutineSessionStatus.cancelled.name) {
      emit(EjerciciosByRutinaError("La rutina ha sido cancelada"));
      return;
    }

    if (r.ejercicios.isEmpty) {
      emit(
        EjerciciosByRutinaSuccess(
          ejerciciosDeRutina: r,
          ejercicioIndex: '',
          serieIndex: '',
        ),
      );
      return;
    }

    // Emitir el estado con los ejercicios en el orden original
    emit(
      EjerciciosByRutinaSuccess(
        ejerciciosDeRutina: r,
        ejercicioIndex: r.ejercicios.first.id,
        serieIndex: r.ejercicios.first.series.first.id,
      ),
    );
  }

  void avanzarSerie() async {
    if (state is! EjerciciosByRutinaSuccess) return;
    final currentState = state as EjerciciosByRutinaSuccess;
    final updatedSerie = await _markSerieAsCompleted(currentState);
    _updateSerie(currentState, updatedSerie);

    // Verificar si estamos en la última serie del ejercicio actual
    final ejercicios = currentState.ejerciciosDeRutina.ejercicios;
    final ejercicioIndex = ejercicios.indexWhere(
      (e) => e.id == currentState.ejercicioIndex,
    );
    final serieIndex = ejercicios[ejercicioIndex].series.indexWhere(
      (s) => s.id == currentState.serieIndex,
    );

    // Si no es la última serie del ejercicio actual, avanzar a la siguiente serie
    if (serieIndex + 1 < ejercicios[ejercicioIndex].series.length) {
      _emitNextSerieState();
    }
    // Si es la última serie, no hacemos nada aquí para permitir que la UI muestre los botones expandibles
  }

  // Método para avanzar explícitamente al siguiente ejercicio (usado por el botón de avanzar)
  void avanzarAlSiguienteEjercicio() async {
    if (state is! EjerciciosByRutinaSuccess) return;
    _emitNextSerieState();
  }

  Future<Serie> _markSerieAsCompleted(
    EjerciciosByRutinaSuccess currentState,
  ) async {
    final ejercicio = currentState.ejerciciosDeRutina.ejercicios.firstWhere(
      (e) => e.id == currentState.ejercicioIndex,
    );
    final serie = ejercicio.series.firstWhere(
      (s) => s.id == currentState.serieIndex,
    );

    final updatedSerie = serie.copyWith(
      estado: ExerciseSetStatus.completed.name,
    );

    final updatedEjercicio = ejercicio.copyWith(
      estado:
          ejercicio.estado == ExerciseStatus.completed.name
              ? ExerciseStatus.completed.name
              : ExerciseStatus.in_progress.name,
    );

    await updateExerciseStatusUseCase(
      UpdateExerciseStatusParams(
        exerciseId: updatedEjercicio.id,
        statusExercise: updatedEjercicio.estado,
        routineSessionId: currentState.ejerciciosDeRutina.session,
      ),
    );

    final updatedSeries =
        ejercicio.series.map((s) {
          return s.id == updatedSerie.id ? updatedSerie : s;
        }).toList();

    final updatedEjercicios =
        currentState.ejerciciosDeRutina.ejercicios.map((e) {
          return e.id == updatedEjercicio.id
              ? updatedEjercicio.copyWith(series: updatedSeries)
              : e;
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

    updateSerieUseCase(UpdateSerieParams(id: serie.id, realizado: true));

    return updatedSerie;
  }

  void _emitNextSerieState() async {
    if (state is! EjerciciosByRutinaSuccess) return;
    final currentState = state as EjerciciosByRutinaSuccess;
    final ejercicios = currentState.ejerciciosDeRutina.ejercicios;
    final ejercicioIndex = ejercicios.indexWhere(
      (e) => e.id == currentState.ejercicioIndex,
    );
    final serieIndex = ejercicios[ejercicioIndex].series.indexWhere(
      (s) => s.id == currentState.serieIndex,
    );

    if (serieIndex + 1 < ejercicios[ejercicioIndex].series.length) {
      // Avanza a la siguiente serie del ejercicio actual
      emit(
        EjerciciosByRutinaSuccess(
          ejerciciosDeRutina: currentState.ejerciciosDeRutina,
          ejercicioIndex: currentState.ejercicioIndex,
          serieIndex: ejercicios[ejercicioIndex].series[serieIndex + 1].id,
        ),
      );
      return;
    } else if (ejercicioIndex + 1 < ejercicios.length) {
      // Avanza al siguiente ejercicio y reinicia el índice de la serie
      final updatedEjercicio = ejercicios[ejercicioIndex].copyWith(
        estado: ExerciseStatus.completed.name,
      );
      // Actualizar la lista de ejercicios con el ejercicio completado
      final updatedEjercicios = List<Ejercicio>.from(ejercicios)
        ..[ejercicioIndex] = updatedEjercicio;

      emit(
        EjerciciosByRutinaSuccess(
          ejerciciosDeRutina: currentState.ejerciciosDeRutina.copyWith(
            ejercicios: updatedEjercicios,
          ),
          ejercicioIndex: ejercicios[ejercicioIndex + 1].id,
          serieIndex: ejercicios[ejercicioIndex + 1].series.first.id,
        ),
      );
      return;
    } else {
      // Si no hay más series ni ejercicios, emite el estado de rutina completada
      final result = await completeRoutineSessionUseCase(
        CompleteRoutineSessionParams(
          sessionId: currentState.ejerciciosDeRutina.session,
        ),
      );

      result.fold((l) => emit(EjerciciosByRutinaError(l.errorMessage)), (r) {
        emit(EjerciciosByRutinaCompleted());
      });
      return;
    }
  }

  void _updateSerie(
    EjerciciosByRutinaSuccess currentState,
    Serie updatedSerie,
  ) {
    // Mapea la lista de ejercicios actual para encontrar el ejercicio que coincide con el índice actual
    final updatedEjercicios =
        currentState.ejerciciosDeRutina.ejercicios.map((ejercicio) {
          if (ejercicio.id == currentState.ejercicioIndex) {
            // Si el ejercicio coincide, mapea sus series para encontrar la serie que coincide con la serie actual
            final updatedSeries =
                ejercicio.series.map((serie) {
                  // Si la serie coincide, la reemplaza con la serie actualizada
                  return serie.id == updatedSerie.id ? updatedSerie : serie;
                }).toList();
            // Retorna el ejercicio con las series actualizadas y el estado del ejercicio como 'in_progress' solo si no está completado
            return ejercicio.copyWith(
              series: updatedSeries,
              estado:
                  ejercicio.estado == ExerciseStatus.completed.name
                      ? ExerciseStatus.completed.name
                      : ExerciseStatus.in_progress.name,
            );
          }
          // Si el ejercicio no coincide, lo retorna sin cambios
          return ejercicio;
        }).toList();

    // Emite un nuevo estado con la lista de ejercicios actualizada
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

    return result.fold((failure) => false, (success) => success);
  }

  Future<bool> iniciarRutina({
    required String routineSessionId,
    required String rutinaId,
  }) async {
    emit(EjerciciosByRutinaLoading());

    // 1. Intentar iniciar la rutina
    final result = await startRoutineSessionUseCase(
      StartRoutineSessionParams(
        sessionId: routineSessionId,
        rutinaId: rutinaId,
      ),
    );

    return await result.fold(
      (failure) {
        // Si hay un error, emitir el estado de error y devolver false
        emit(EjerciciosByRutinaError(failure.errorMessage));
        return false;
      },
      (success) async {
        if (!success) {
          // Si no se pudo iniciar la rutina, emitir un mensaje de error y devolver false
          emit(EjerciciosByRutinaError("No se pudo iniciar la rutina"));
          return false;
        }

        // 2. Obtener la sesión actualizada
        RoutineSession? updatedSession;
        final sessionResult = await getLastRoutineSessionByRoutineId(
          GetLastRoutineSessionByRoutineIdParams(idRoutine: rutinaId),
        );

        final hasSession = sessionResult.fold(
          (failure) {
            emit(EjerciciosByRutinaError(failure.errorMessage));
            return false;
          },
          (session) {
            updatedSession = session;
            return true;
          },
        );

        if (!hasSession || updatedSession == null) {
          return false;
        }

        // 3. Obtener los ejercicios de la sesión actualizada
        final ejerciciosResult = await getAllEjerciciosByRutinaUseCase(
          GetAllEjerciciosByRutinaParams(
            id: rutinaId,
            idRoutineSession: updatedSession!.id,
          ),
        );

        return ejerciciosResult.fold(
          (failure) {
            emit(EjerciciosByRutinaError(failure.errorMessage));
            return false;
          },
          (ejerciciosDeRutina) {
            // Asegurarse de que el estado refleje correctamente que la rutina está en progreso
            final updatedEjerciciosDeRutina = ejerciciosDeRutina.copyWith(
              estado: RoutineSessionStatus.in_progress.name,
            );

            emit(
              EjerciciosByRutinaSuccess(
                ejerciciosDeRutina: updatedEjerciciosDeRutina,
                ejercicioIndex: updatedEjerciciosDeRutina.ejercicios.first.id,
                serieIndex:
                    updatedEjerciciosDeRutina.ejercicios.first.series.first.id,
              ),
            );
            return true;
          },
        );
      },
    );
  }

  Future<bool> stopRoutine({required String routineSessionId}) async {
    final currentState = state as EjerciciosByRutinaSuccess;
    final result = await stopRoutineSessionUseCase(
      StopRoutineSessionParams(sessionId: routineSessionId),
    );

    return result.fold((failure) => false, (success) {
      if (success) {
        final updatedEjerciciosDeRutina = currentState.ejerciciosDeRutina
            .copyWith(estado: RoutineSessionStatus.cancelled.name);

        emit(
          EjerciciosByRutinaSuccess(
            ejerciciosDeRutina: updatedEjerciciosDeRutina,
            ejercicioIndex: currentState.ejercicioIndex,
            serieIndex: currentState.serieIndex,
          ),
        );
      }

      return success;
    });
  }

  Future<bool> completeRoutine({required String routineSessionId}) async {
    final currentState = state as EjerciciosByRutinaSuccess;
    final result = await completeRoutineSessionUseCase(
      CompleteRoutineSessionParams(sessionId: routineSessionId),
    );

    return result.fold((failure) => false, (success) {
      if (success) {
        final updatedEjerciciosDeRutina = currentState.ejerciciosDeRutina
            .copyWith(estado: RoutineSessionStatus.completed.name);

        emit(
          EjerciciosByRutinaSuccess(
            ejerciciosDeRutina: updatedEjerciciosDeRutina,
            ejercicioIndex: currentState.ejercicioIndex,
            serieIndex: currentState.serieIndex,
          ),
        );
      }
      return success;
    });
  }
}
