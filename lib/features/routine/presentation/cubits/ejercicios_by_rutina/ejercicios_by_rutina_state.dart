part of 'ejercicios_by_rutina_cubit.dart';

class EjerciciosByRutinaCancelled extends EjerciciosByRutinaState {
  final String rutinaName;
  final int totalEjercicios;
  final DateTime fechaCancelada;

  EjerciciosByRutinaCancelled({
    required this.rutinaName,
    required this.totalEjercicios,
    required this.fechaCancelada,
  });

  @override
  List<Object?> get props => [rutinaName, totalEjercicios, fechaCancelada];
}

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
  final String ejercicioIndex;
  final String serieIndex;

  EjerciciosByRutinaSuccess({
    required this.ejerciciosDeRutina,
    required this.ejercicioIndex,
    required this.serieIndex,
  });

  @override
  List<Object?> get props => [ejerciciosDeRutina, ejercicioIndex, serieIndex];
}

class EjerciciosByRutinaCompleted extends EjerciciosByRutinaState {
  final String rutinaName;
  final int totalEjercicios;
  final int totalSeries;
  final Duration tiempoTotal;
  final DateTime fechaCompletado;

  EjerciciosByRutinaCompleted({
    required this.rutinaName,
    required this.totalEjercicios,
    required this.totalSeries,
    required this.tiempoTotal,
    required this.fechaCompletado,
  });

  @override
  List<Object?> get props => [
        rutinaName,
        totalEjercicios,
        totalSeries,
        tiempoTotal,
        fechaCompletado,
      ];
}
