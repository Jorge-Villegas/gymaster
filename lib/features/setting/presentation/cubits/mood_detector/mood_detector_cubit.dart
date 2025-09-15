import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/user_mood.dart';
import '../../../domain/usecases/save_user_mood_usecase.dart';
import '../../../domain/usecases/get_latest_user_mood_usecase.dart';
import 'mood_detector_state.dart';

/// Cubit para manejar la detección y guardado de estados de ánimo
class MoodDetectorCubit extends Cubit<MoodDetectorState> {
  final SaveUserMoodUseCase saveUserMoodUseCase;
  final GetLatestUserMoodUseCase getLatestUserMoodUseCase;

  MoodDetectorCubit({
    required this.saveUserMoodUseCase,
    required this.getLatestUserMoodUseCase,
  }) : super(MoodDetectorInitial());

  /// Guarda el estado de ánimo del usuario
  Future<void> saveMood(MoodType moodType) async {
    emit(MoodDetectorLoading());

    try {
      final userMood = UserMood(
        userId: 'current_user', // Por ahora usuario fijo
        mood: moodType,
        intensity: _getIntensityForMoodType(moodType),
        timestamp: DateTime.now(),
        notes: null,
      );

      final result =
          await saveUserMoodUseCase(SaveUserMoodParams(mood: userMood));

      result.fold(
        (failure) {
          emit(
              MoodDetectorError(_getUserFriendlyMessage(failure.errorMessage)));
        },
        (_) {
          // El use case retorna void, creamos el UserMood para el estado
          emit(MoodDetectorSaveSuccess(userMood));
        },
      );
    } catch (e) {
      emit(MoodDetectorError('Error inesperado al guardar estado de ánimo'));
    }
  }

  /// Obtiene el último estado de ánimo registrado
  Future<void> getLatestMood() async {
    emit(MoodDetectorLoading());

    try {
      final result = await getLatestUserMoodUseCase(
          GetLatestUserMoodParams(userId: 'current_user'));

      result.fold(
        (failure) {
          // Si no hay registros, no es un error crítico
          emit(MoodDetectorGetSuccess(null));
        },
        (lastMood) {
          emit(MoodDetectorGetSuccess(lastMood));
        },
      );
    } catch (e) {
      emit(MoodDetectorError(
          'Error inesperado al obtener último estado de ánimo'));
    }
  }

  /// Reinicia el estado del cubit
  void reset() {
    emit(MoodDetectorInitial());
  }

  /// Obtiene la intensidad por defecto según el tipo de estado de ánimo
  int _getIntensityForMoodType(MoodType moodType) {
    switch (moodType) {
      case MoodType.cansado:
        return 3; // Baja intensidad
      case MoodType.motivado:
        return 7; // Alta intensidad positiva
      case MoodType.energetico:
        return 9; // Muy alta intensidad
      case MoodType.estresado:
        return 6; // Intensidad media-alta negativa
    }
  }

  /// Convierte errores técnicos en mensajes amigables para el usuario
  String _getUserFriendlyMessage(String technicalMessage) {
    if (technicalMessage.toLowerCase().contains('database')) {
      return 'Error al guardar en la base de datos. Intenta de nuevo.';
    } else if (technicalMessage.toLowerCase().contains('connection')) {
      return 'Sin conexión. Verifica tu conexión a internet.';
    } else {
      return 'Ocurrió un error inesperado. Intenta de nuevo.';
    }
  }
}
