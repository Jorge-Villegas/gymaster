part of 'ejercicios_by_rutina_cubit.dart';

@immutable
abstract class EjerciciosByRutinaState extends Equatable {}

class EjerciciosByRutinaInitial extends EjerciciosByRutinaState {
  @override
  List<Object?> get props => [];
}

class EjerciciosByRutinaLoading extends EjerciciosByRutinaState {
  @override
  List<Object?> get props => [];
}

class EjerciciosByRutinaError extends EjerciciosByRutinaState {
  final String message;

  EjerciciosByRutinaError(this.message);

  @override
  List<Object?> get props => [message];
}

class EjerciciosByRutinaSuccess extends EjerciciosByRutinaState {
  final EjerciciosDeRutina ejerciciosDeRutina;
  final int ejercicioIndex;
  final int serieIndex;

  EjerciciosByRutinaSuccess({
    required this.ejerciciosDeRutina,
    required this.ejercicioIndex,
    required this.serieIndex,
  });

  @override
  List<Object?> get props => [ejerciciosDeRutina, ejercicioIndex, serieIndex];
}

class EjerciciosByRutinaCompleted extends EjerciciosByRutinaState {
  @override
  List<Object?> get props => [];
}
