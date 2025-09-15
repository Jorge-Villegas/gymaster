import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymaster/features/setting/domain/entities/user_motivation.dart';
import 'package:gymaster/features/setting/domain/entities/user_mood.dart';
import 'package:gymaster/features/setting/domain/usecases/save_user_motivation_usecase.dart';
import 'package:gymaster/features/setting/domain/usecases/save_user_mood_usecase.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final SaveUserMotivationUseCase saveUserMotivationUseCase;
  final SaveUserMoodUseCase saveUserMoodUseCase;

  OnboardingCubit({
    required this.saveUserMotivationUseCase,
    required this.saveUserMoodUseCase,
  }) : super(OnboardingInitial());

  int _currentStep = 0;
  UserMotivation? _selectedMotivation;
  UserMood? _selectedMood;

  int get currentStep => _currentStep;
  UserMotivation? get selectedMotivation => _selectedMotivation;
  UserMood? get selectedMood => _selectedMood;

  void nextStep() {
    if (_currentStep < 2) {
      _currentStep++;
      emit(OnboardingStepChanged(_currentStep));
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      emit(OnboardingStepChanged(_currentStep));
    }
  }

  void selectMotivation(UserMotivation motivation) {
    _selectedMotivation = motivation;
    emit(OnboardingMotivationSelected(motivation));
  }

  void selectMood(UserMood mood) {
    _selectedMood = mood;
    emit(OnboardingMoodSelected(mood));
  }

  Future<void> completeOnboarding() async {
    if (_selectedMotivation == null || _selectedMood == null) {
      emit(OnboardingError('Por favor completa todos los pasos'));
      return;
    }

    emit(OnboardingLoading());

    try {
      // Guardar motivación
      final motivationResult = await saveUserMotivationUseCase(
        SaveUserMotivationParams(
          motivation: _selectedMotivation!,
        ),
      );

      if (motivationResult.isLeft()) {
        emit(OnboardingError('Error al guardar motivación'));
        return;
      }

      // Guardar estado de ánimo
      final moodResult = await saveUserMoodUseCase(
        SaveUserMoodParams(
          mood: _selectedMood!,
        ),
      );

      if (moodResult.isLeft()) {
        emit(OnboardingError('Error al guardar estado de ánimo'));
        return;
      }

      emit(OnboardingCompleted());
    } catch (e) {
      emit(OnboardingError('Error inesperado: ${e.toString()}'));
    }
  }

  void resetOnboarding() {
    _currentStep = 0;
    _selectedMotivation = null;
    _selectedMood = null;
    emit(OnboardingInitial());
  }

  void skipOnboarding() {
    emit(OnboardingSkipped());
  }
}
