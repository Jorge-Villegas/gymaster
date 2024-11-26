import 'package:gymaster/features/routine/domain/entities/datos_ejercicios_realizando.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'realizacion_ejercicio_state.dart';

class RealizacionEjercicioCubit extends Cubit<RealizacionEjercicioState> {
  RealizacionEjercicioCubit() : super(RealizacionEjercicioInitial());

  void iniciar() {
    emit(RealizacionEjercicioInitial());
  }

  void reiniciar() {
    emit(RealizacionEjercicioInitial());
  }

  void obtenerDatos() {}

  void aumentarPeso() {
    if (state is RealizacionEjercicioSuccess) {
      final datos =
          (state as RealizacionEjercicioSuccess).datosEjerciciosRealizando;
      final serieActual = datos.serieActual;
      final series = List<SeriesDelEjercicio>.from(datos.seriesDelEjercicio);
      series[serieActual - 1] = series[serieActual - 1].copyWith(
        peso: series[serieActual - 1].peso + 0.5,
      );
      emit(RealizacionEjercicioSuccess(
          datos.copyWith(seriesDelEjercicio: series)));
    }
  }

  void disminuirPeso() {
    if (state is RealizacionEjercicioSuccess) {
      final datos =
          (state as RealizacionEjercicioSuccess).datosEjerciciosRealizando;
      final serieActual = datos.serieActual;
      final series = List<SeriesDelEjercicio>.from(datos.seriesDelEjercicio);
      if (series[serieActual - 1].peso > 0) {
        series[serieActual - 1] = series[serieActual - 1].copyWith(
          peso: series[serieActual - 1].peso - 0.5,
        );
      }
      emit(RealizacionEjercicioSuccess(
          datos.copyWith(seriesDelEjercicio: series)));
    }
  }

  void aumentarRepeticiones() {
    if (state is RealizacionEjercicioSuccess) {
      final datos =
          (state as RealizacionEjercicioSuccess).datosEjerciciosRealizando;
      final serieActual = datos.serieActual;
      final series = List<SeriesDelEjercicio>.from(datos.seriesDelEjercicio);
      series[serieActual - 1] = series[serieActual - 1].copyWith(
        repeticiones: series[serieActual - 1].repeticiones + 1,
      );
      emit(RealizacionEjercicioSuccess(
          datos.copyWith(seriesDelEjercicio: series)));
    }
  }

  void disminuirRepeticiones() {
    if (state is RealizacionEjercicioSuccess) {
      final datos =
          (state as RealizacionEjercicioSuccess).datosEjerciciosRealizando;
      final serieActual = datos.serieActual;
      final series = List<SeriesDelEjercicio>.from(datos.seriesDelEjercicio);
      if (series[serieActual - 1].repeticiones > 0) {
        series[serieActual - 1] = series[serieActual - 1].copyWith(
          repeticiones: series[serieActual - 1].repeticiones - 1,
        );
      }
      emit(RealizacionEjercicioSuccess(
          datos.copyWith(seriesDelEjercicio: series)));
    }
  }

  void avanzarSerie() {
    if (state is RealizacionEjercicioSuccess) {
      final datos =
          (state as RealizacionEjercicioSuccess).datosEjerciciosRealizando;
      if (datos.serieActual < datos.seriesDelEjercicio.length) {
        final nuevaSerieActual = datos.serieActual + 1;
        emit(RealizacionEjercicioSuccess(
            datos.copyWith(serieActual: nuevaSerieActual)));
      }
    }
  }
}
