part of 'routine_cubit.dart';

@immutable
sealed class RoutineState {}

final class RoutineInitial extends RoutineState {}

final class RoutineLoading extends RoutineState {}

final class RoutineAddSuccess extends RoutineState {
  final Routine rutina;

  RoutineAddSuccess(this.rutina);
}

final class RoutineUpdateSuccess extends RoutineState {}

final class RoutineDeleteSuccess extends RoutineState {}

final class RoutineGetAllSuccess extends RoutineState {
  final List<Routine> routines;

  RoutineGetAllSuccess(this.routines);
}

final class RoutineGetByIdSuccess extends RoutineState {
  final Routine routine;

  RoutineGetByIdSuccess(this.routine);
}

final class RoutineError extends RoutineState {
  final String message;

  RoutineError(this.message);
}
