import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gymaster/core/database/models/routine_session_db_model.dart';
import 'package:gymaster/core/error/timeout_helper.dart';
import 'package:gymaster/features/routine/domain/entities/ejercicios_por_musculo.dart';
import 'package:gymaster/features/routine/domain/usecases/get_all_ejercicios_by_musculo_usecase.dart';
import 'package:gymaster/features/routine/domain/usecases/get_all_ejercicios_by_rutina.dart';
import 'package:gymaster/features/routine/domain/usecases/get_last_routine_session_by_routine_id_usecase.dart';

part 'ejercicio_state.dart';

class EjercicioCubit extends Cubit<EjercicioState> {
  final GetAllEjerciciosByMusculoUseCase getAllEjerciciosByMusculoUseCase;
  final GetAllEjerciciosByRutinaUseCase getAllEjerciciosByRutinaUseCase;
  final GetLastRoutineSessionByRoutineId getLastRoutineSessionByRoutineId;

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
      GetAllEjerciciosByMusculoParams(musculoId: musculoId),
    );

    ejercicios.fold((failure) => emit(EjercicioError(failure.errorMessage)), (
      ejercicios,
    ) async {
      RoutineSessionDbModel? session;

      //obtenermos la ultima session de la rutina
      final resultSession = await runWithTimeout(
        () => getLastRoutineSessionByRoutineId(
          GetLastRoutineSessionByRoutineIdParams(idRoutine: rutinaId),
        ),
      );

      resultSession.fold((l) => emit(EjercicioError(l.errorMessage)), (r) {
        session = r;
      });

      final ejerciciosSeleccionadosResult =
          await getAllEjerciciosByRutinaUseCase(
        GetAllEjerciciosByRutinaParams(
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
