import 'package:gymaster/features/routine/domain/entities/serie.dart';
import 'package:gymaster/features/routine/domain/usecases/get_all_serie_usecase.dart';
import 'package:bloc/bloc.dart';

part 'serie_state.dart';

class SerieCubit extends Cubit<SerieState> {
  final GetAllSerieUseCase getAllSerieUseCase;

  SerieCubit({
    required this.getAllSerieUseCase,
  }) : super(SerieInitial());

  void getAllSerie({
    required String id,
  }) async {}
}
