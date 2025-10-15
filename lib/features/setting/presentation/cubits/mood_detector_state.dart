import 'package:gymaster/features/setting/data/models/user_mood.dart';

/// Estados del MoodDetectorCubit
abstract class MoodDetectorState {}

/// Estado inicial
class MoodDetectorInitial extends MoodDetectorState {}

/// Estado de carga
class MoodDetectorLoading extends MoodDetectorState {}

/// Estado de éxito al guardar mood
class MoodDetectorSaveSuccess extends MoodDetectorState {
  final UserMood savedMood;

  MoodDetectorSaveSuccess(this.savedMood);
}

/// Estado de éxito al obtener último mood
class MoodDetectorGetSuccess extends MoodDetectorState {
  final UserMood? lastMood;

  MoodDetectorGetSuccess(this.lastMood);
}

/// Estado de error
class MoodDetectorError extends MoodDetectorState {
  final String message;

  MoodDetectorError(this.message);
}
