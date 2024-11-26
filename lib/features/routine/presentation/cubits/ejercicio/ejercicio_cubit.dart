import 'package:gymaster/features/routine/domain/entities/ejercicios_por_musculo.dart';
import 'package:gymaster/features/routine/domain/usecases/get_all_ejercicios_by_musculo_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'ejercicio_state.dart';

class EjercicioCubit extends Cubit<EjercicioState> {
  final GetAllEjerciciosByMusculoUseCase getAllEjerciciosByMusculoUseCase;

  EjercicioCubit({
    required this.getAllEjerciciosByMusculoUseCase,
  }) : super(EjercicioInitial());

  void setEjercicio({required String musculoId}) async {
    emit(EjercicioLoading());

    final ejercicios = await getAllEjerciciosByMusculoUseCase(
        GetAllEjerciciosByMusculoParams(musculoId: musculoId));

    ejercicios.fold(
      (failure) => emit(const EjercicioError('Error al obtener los ejercicios....')),
      (ejercicios) => emit(EjercicioGetAllSuccess(ejercicios: ejercicios)),
    );
  }
}
