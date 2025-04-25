import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/routine/domain/entities/musculo.dart';
import 'package:gymaster/features/routine/domain/usecases/get_all_musculos_usecase.dart';
import 'package:bloc/bloc.dart';

part 'musculo_state.dart';

class MusculoCubit extends Cubit<MusculoState> {
  final GetAllMusculoUsecase getAllMusculoUsecase;

  MusculoCubit({
    required this.getAllMusculoUsecase,
  }) : super(MusculoInitial());

  getAllMusculo() async {
    emit(MusculoLoading());

    final result = await getAllMusculoUsecase(NoParams());

    result.fold(
      (failure) => emit(MusculoError('Error al obtener los musculos')),
      (musculos) => emit(MusculoLoaded(musculos)),
    );
  }
}
