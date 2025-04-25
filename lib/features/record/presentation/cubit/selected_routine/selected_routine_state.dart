import 'package:gymaster/features/record/domain/entities/record_rutina.dart';

abstract class SelectedRoutineState {}

class SelectedRoutineInitial extends SelectedRoutineState {}

class SelectedRoutineLoading extends SelectedRoutineState {}

class SelectedRoutineLoaded extends SelectedRoutineState {
  final RecordRutina rutina;

  SelectedRoutineLoaded({required this.rutina});
}

class SelectedRoutineError extends SelectedRoutineState {
  final String message;

  SelectedRoutineError({required this.message});
}
