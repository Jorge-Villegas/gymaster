import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gymaster/core/database/models/rutina_sesion_db.dart';
import 'package:gymaster/core/error/timeout_helper.dart';
import 'package:gymaster/features/routine/domain/entities/ejercicios_por_musculo.dart';
import 'package:gymaster/features/routine/domain/usecases/obtener_ejercicios_rutina_por_musculo_usecase.dart';
import 'package:gymaster/features/routine/domain/usecases/obtener_ejercicios_por_rutina_usecase.dart';
import 'package:gymaster/features/routine/domain/usecases/obtener_ultima_sesion_por_rutina_id_usecase.dart';

part 'ejercicio_state.dart';

class EjercicioCubit extends Cubit<EjercicioState> {
  final ObtenerEjerciciosRutinaPorMusculoUseCase
      getAllEjerciciosByMusculoUseCase;
  final ObtenerEjerciciosPorRutinaUseCase getAllEjerciciosByRutinaUseCase;
  final ObtenerUltimaSesionPorRutinaIdUseCase getLastRoutineSessionByRoutineId;

  EjercicioCubit({
    required this.getLastRoutineSessionByRoutineId,
    required this.getAllEjerciciosByMusculoUseCase,
    required this.getAllEjerciciosByRutinaUseCase,
  }) : super(EjercicioInitial());

  void setEjercicio({
    required String musculoId,
    required String rutinaId,
  }) async {
    emit(EjercicioLoading());

    final ejercicios = await getAllEjerciciosByMusculoUseCase(
      ObtenerEjerciciosRutinaPorMusculoParams(musculoId: musculoId),
    );

    ejercicios.fold((failure) => emit(EjercicioError(failure.errorMessage)), (
      ejercicios,
    ) async {
      RutinaSesionDb? session;

      //obtenermos la ultima session de la rutina
      final resultSession = await runWithTimeout(
        () => getLastRoutineSessionByRoutineId(
          ObtenerUltimaSesionPorRutinaIdParams(idRoutine: rutinaId),
        ),
      );

      resultSession.fold((l) => emit(EjercicioError(l.errorMessage)), (r) {
        session = r;
      });

      final ejerciciosSeleccionadosResult =
          await getAllEjerciciosByRutinaUseCase(
        ObtenerEjerciciosPorRutinaParams(
          id: rutinaId,
          idRoutineSession: session!.id,
        ),
      );
      ejerciciosSeleccionadosResult.fold(
        (failure) => emit(
          const EjercicioError(
            'Error al obtener los ejercicios seleccionados....',
          ),
        ),
        (ejerciciosSeleccionados) {
          final updatedEjercicios = ejercicios.map((ejercicio) {
            final isSelected = ejerciciosSeleccionados.ejercicios.any(
              (ejercicioSeleccionado) =>
                  ejercicioSeleccionado.id == ejercicio.id,
            );
            return ejercicio.copyWith(seleccionado: isSelected);
          }).toList();
          emit(EjercicioGetAllSuccess(ejercicios: updatedEjercicios));
        },
      );
    });
  }

  ejercicioAgregado({required String id}) {
    final currentState = state;
    if (currentState is EjercicioGetAllSuccess) {
      final updatedEjercicios = currentState.ejercicios.map((e) {
        if (e.id == id) {
          return e.copyWith(seleccionado: !e.seleccionado);
        }
        return e;
      }).toList();
      emit(EjercicioGetAllSuccess(ejercicios: updatedEjercicios));
    }
  }
}
