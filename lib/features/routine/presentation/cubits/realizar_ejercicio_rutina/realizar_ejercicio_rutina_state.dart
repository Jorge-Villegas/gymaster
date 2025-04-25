part of 'realizar_ejercicio_rutina_cubit.dart';

sealed class RealizarEjercicioRutinaState extends Equatable {}

final class RealizarEjercicioRutinaInitial
    extends RealizarEjercicioRutinaState {
  @override
  List<Object?> get props => [];
}

final class RealizarEjercicioRutinaLoading
    extends RealizarEjercicioRutinaState {
  @override
  List<Object?> get props => [];
}

final class RealizarEjercicioRutinaLoaded extends RealizarEjercicioRutinaState {
  final Ejercicio ejercicio;
  final Serie serie;

  RealizarEjercicioRutinaLoaded({
    required this.ejercicio,
    required this.serie,
  });

  @override
  List<Object?> get props => [ejercicio, serie];
}

final class RealizarEjercicioRutinaError extends RealizarEjercicioRutinaState {
  final String message;

  RealizarEjercicioRutinaError(this.message);
  @override
  List<Object?> get props => [message];
}
