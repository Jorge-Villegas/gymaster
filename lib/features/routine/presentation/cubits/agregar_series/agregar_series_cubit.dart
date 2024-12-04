import 'package:gymaster/features/routine/domain/usecases/add_ejercicio_rutina_usecase.dart';
import 'package:gymaster/features/routine/presentation/cubits/agregar_series/agregar_series_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

class AgregarSeriesCubit extends Cubit<AgregarSeriesState> {
  final AddEjercicioRutinaUsecase _addEjercicioRutinaUsecase;

  AgregarSeriesCubit(this._addEjercicioRutinaUsecase)
      : super(AgregarSeriesLoaded.initial());

  void iniciar() {
    emit(AgregarSeriesLoaded.initial());
  }

  void incrementarSeries() {
    final currentState = state;
    if (currentState is AgregarSeriesLoaded) {
      if (currentState.cantidadSeries < 10) {
        emit(currentState.copyWith(
            cantidadSeries: currentState.cantidadSeries + 1));
      }
    }
  }

  void decrementarSeries() {
    final currentState = state;
    if (currentState is AgregarSeriesLoaded) {
      if (currentState.cantidadSeries > 0) {
        emit(
          currentState.copyWith(
              cantidadSeries: currentState.cantidadSeries - 1),
        );
      }
    }
  }

  void almacenarPesoDeSerie(int index, double peso) {
    final currentState = state;
    if (currentState is AgregarSeriesLoaded) {
      final nuevosPesos = List<double>.from(currentState.pesos);
      nuevosPesos[index] = peso;
      emit(currentState.copyWith(pesos: nuevosPesos));
    }
  }

  void almacenarRepeticionDeSerie(int index, int repeticion) {
    final currentState = state;
    if (currentState is AgregarSeriesLoaded) {
      final nuevasRepeticiones = List<int>.from(currentState.repeticiones);
      nuevasRepeticiones[index] = repeticion;
      emit(currentState.copyWith(repeticiones: nuevasRepeticiones));
    }
  }

  Future<bool> guardarDatos({
    required String rutinaId,
    required String ejercicioId,
    required List<double> pesos,
    required List<int> repeticiones,
  }) async {
    final currentState = state;
    if (currentState is AgregarSeriesLoaded) {
      // Crear una lista de DataSerie a partir de las listas de pesos y repeticiones
      List<DataSerie> dataSeries = [];
      for (int i = 0; i < pesos.length; i++) {
        dataSeries.add(DataSerie(
          peso: pesos[i],
          numeroRepeticon: repeticiones[i],
        ));
      }

      // Crear una nueva instancia de EjercicioRutina
      final ejercicioRutina = AddEjercicioRutinaParams(
        idRutina: rutinaId,
        idEjercicio: ejercicioId,
        dataSeries: dataSeries,
      );

      final resul = await _addEjercicioRutinaUsecase(ejercicioRutina);
    
      return resul.fold((l) => true, (r) => false);
    }
    return false;
  }
}
