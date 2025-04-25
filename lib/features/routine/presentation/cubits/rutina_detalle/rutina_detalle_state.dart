part of 'rutina_detalle_cubit.dart';

@immutable
sealed class RutinaDetalleState {}

final class RutinaDetalleInitial extends RutinaDetalleState {}

final class RutinaDetalleLoading extends RutinaDetalleState {}

final class RutinaDetalleLoaded extends RutinaDetalleState {
  final RutinaData rutina;
  final int ejercicioIndex;
  final int serieIndex;

  RutinaDetalleLoaded({
    required this.rutina,
    required this.ejercicioIndex,
    required this.serieIndex,
  });
}

final class RutinaDetalleError extends RutinaDetalleState {
  final String message;

  RutinaDetalleError(this.message);
}
