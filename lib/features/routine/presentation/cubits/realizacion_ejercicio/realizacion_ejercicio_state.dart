part of 'realizacion_ejercicio_cubit.dart';

sealed class RealizacionEjercicioState extends Equatable {
  const RealizacionEjercicioState();
}

final class RealizacionEjercicioInitial extends RealizacionEjercicioState {
  @override
  List<Object> get props => [];
}

final class RealizacionEjercicioLoading extends RealizacionEjercicioState {
  @override
  List<Object> get props => [];
}

final class RealizacionEjercicioSuccess extends RealizacionEjercicioState {
  final DatosEjerciciosRealizando datosEjerciciosRealizando;
  const RealizacionEjercicioSuccess(this.datosEjerciciosRealizando);
  @override
  List<Object> get props => [datosEjerciciosRealizando];
}

final class RealizacionEjercicioError extends RealizacionEjercicioState {
  final String message;
  const RealizacionEjercicioError(this.message);
  @override
  List<Object> get props => [message];
}
