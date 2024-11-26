part of 'ejercicio_cubit.dart';

sealed class EjercicioState extends Equatable {
  const EjercicioState();
}

final class EjercicioInitial extends EjercicioState {
  @override
  List<Object> get props => [];
}

final class EjercicioGetAllSuccess extends EjercicioState {
  final List<EjerciciosPorMusculo> ejercicios;

  const EjercicioGetAllSuccess({required this.ejercicios});

  @override
  List<Object> get props => [ejercicios];
}

final class EjercicioError extends EjercicioState {
  final String message;

  const EjercicioError(this.message);

  @override
  List<Object> get props => [message];
}

final class EjercicioLoading extends EjercicioState {
  @override
  List<Object> get props => [];
}
