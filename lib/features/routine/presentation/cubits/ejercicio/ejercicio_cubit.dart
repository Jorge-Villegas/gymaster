import 'package:gymaster/features/routine/domain/entities/ejercicios_por_musculo.dart';
import 'package:gymaster/features/routine/domain/usecases/get_all_ejercicios_by_musculo_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gymaster/features/routine/domain/usecases/get_all_ejercicios_by_rutina.dart';

part 'ejercicio_state.dart';

class EjercicioCubit extends Cubit<EjercicioState> {
  final GetAllEjerciciosByMusculoUseCase getAllEjerciciosByMusculoUseCase;
   final GetAllEjerciciosByRutinaUseCase getAllEjerciciosByRutinaUseCase;

  EjercicioCubit({
    required this.getAllEjerciciosByMusculoUseCase,
    required this.getAllEjerciciosByRutinaUseCase,
  }) : super(EjercicioInitial());

  void setEjercicio({required String musculoId, required String rutinaId}) async {
    emit(EjercicioLoading());

    final ejercicios = await getAllEjerciciosByMusculoUseCase(
        GetAllEjerciciosByMusculoParams(musculoId: musculoId));

    ejercicios.fold(
      (failure) => emit(const EjercicioError('Error al obtener los ejercicios....')),
      (ejercicios) async {
        final ejerciciosSeleccionadosResult = await getAllEjerciciosByRutinaUseCase(
            GetAllEjerciciosByRutinaParams(id: rutinaId));
        ejerciciosSeleccionadosResult.fold(
          (failure) => emit(const EjercicioError('Error al obtener los ejercicios seleccionados....')),
          (ejerciciosSeleccionados) {
            final updatedEjercicios = ejercicios.map((ejercicio) {
              final isSelected = ejerciciosSeleccionados.ejercicios.any(
                (ejercicioSeleccionado) => ejercicioSeleccionado.id == ejercicio.id,
              );
              return ejercicio.copyWith(seleccionado: isSelected);
            }).toList();
            emit(EjercicioGetAllSuccess(ejercicios: updatedEjercicios));
          },
        );
      },
    );
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