import 'package:gymaster/features/record/domain/entities/record_rutina.dart';

abstract class RecordState {}

class RecordInitial extends RecordState {}

class RecordLoading extends RecordState {}

class RecordLoaded extends RecordState {
  final List<RecordRutina> rutinas;

  RecordLoaded({required this.rutinas});
}

class RutinaLoaded extends RecordState {
  final RecordRutina rutina;

  RutinaLoaded({required this.rutina});
}

class RecordError extends RecordState {
  final String message;

  RecordError(this.message);
}
