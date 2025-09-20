import 'package:gymaster/features/routine/domain/entities/serie.dart';
import 'package:gymaster/features/routine/domain/usecases/obtener_todas_las_series_usecase.dart';
import 'package:bloc/bloc.dart';

part 'serie_state.dart';

class SerieCubit extends Cubit<SerieState> {
  final ObtenerTodasLasSeriesUseCase getAllSerieUseCase;

  SerieCubit({
    required this.getAllSerieUseCase,
  }) : super(SerieInitial());

  void getAllSerie({
    required String id,
  }) async {}
}
