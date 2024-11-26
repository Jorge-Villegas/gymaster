import 'package:equatable/equatable.dart';

abstract class AgregarSeriesState extends Equatable {
  const AgregarSeriesState();

  @override
  List<Object> get props => [];
}

class AgregarSeriesInitial extends AgregarSeriesState {}

class AgregarSeriesLoaded extends AgregarSeriesState {
  final List<double> pesos;
  final List<int> repeticiones;
  final int cantidadSeries;

  const AgregarSeriesLoaded({
    required this.pesos,
    required this.repeticiones,
    required this.cantidadSeries,
  });

  factory AgregarSeriesLoaded.initial() {
    return AgregarSeriesLoaded(
      pesos: List.filled(10, 0.0),
      repeticiones: List.filled(10, 0),
      cantidadSeries: 0,
    );
  }

  AgregarSeriesLoaded copyWith({
    List<double>? pesos,
    List<int>? repeticiones,
    int? cantidadSeries,
  }) {
    return AgregarSeriesLoaded(
      pesos: pesos ?? this.pesos,
      repeticiones: repeticiones ?? this.repeticiones,
      cantidadSeries: cantidadSeries ?? this.cantidadSeries,
    );
  }

  @override
  List<Object> get props => [
        pesos,
        repeticiones,
        cantidadSeries,
      ];
}

class AgregarSeriesError extends AgregarSeriesState {
  final String message;

  const AgregarSeriesError(this.message);

  @override
  List<Object> get props => [message];
}
