import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymaster/features/setting/domain/entities/user_motivation.dart';
import 'package:gymaster/features/setting/domain/usecases/mark_onboarding_completed_usecase.dart';
import 'package:gymaster/features/setting/domain/usecases/save_user_motivation_usecase.dart';
import 'package:gymaster/features/setting/presentation/cubits/onboarding/onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final SaveUserMotivationUseCase saveUserMotivationUseCase;
  final MarkOnboardingCompletedUseCase markOnboardingCompletedUseCase;

  // Estado temporal durante el onboarding
  late UserMotivation _partialMotivation;
  int _currentPage = 0;

  OnboardingCubit({
    required this.saveUserMotivationUseCase,
    required this.markOnboardingCompletedUseCase,
  }) : super(OnboardingInitial()) {
    _initializePartialMotivation();
    // Emitir el estado inicial
    emit(OnboardingPageChanged(
      currentPage: _currentPage,
      partialMotivation: _partialMotivation,
    ));
  }

  void _initializePartialMotivation() {
    _partialMotivation = UserMotivation(
      userId: 'default_user', // TODO: Obtener del usuario actual
      motivations: [],
      challenges: [],
      postWorkoutFeelings: [],
      notificationPreferences: const NotificationPreferences(
        enabled: true,
        preferredHours: [18, 19, 20], // Default: 6-8 PM
        tone: MotivationTone.energetico,
        frequencyDays: 2,
      ),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Navega a la siguiente página del onboarding
  void nextPage() {
    debugPrint('🚀 Intentando ir a la siguiente página desde $_currentPage');
    if (_currentPage < 3) {
      _currentPage++;
      debugPrint('✅ Navegando a página $_currentPage');
      emit(OnboardingPageChanged(
        currentPage: _currentPage,
        partialMotivation: _partialMotivation,
      ));
    } else {
      debugPrint('⚠️ Ya estás en la última página');
    }
  }

  /// Navega a la página anterior del onboarding
  void previousPage() {
    if (_currentPage > 0) {
      _currentPage--;
      emit(OnboardingPageChanged(
        currentPage: _currentPage,
        partialMotivation: _partialMotivation,
      ));
    }
  }

  /// Actualiza las motivaciones seleccionadas (Página 1)
  void updateMotivations(List<String> motivations) {
    debugPrint('🔄 Actualizando motivaciones: $motivations');
    _partialMotivation = _partialMotivation.copyWith(motivations: motivations);
    debugPrint(
        '✅ Motivaciones actualizadas. Total: ${_partialMotivation.motivations.length}');
    emit(OnboardingPageChanged(
      currentPage: _currentPage,
      partialMotivation: _partialMotivation,
    ));
  }

  /// Actualiza los desafíos seleccionados (Página 2)
  void updateChallenges(List<String> challenges) {
    _partialMotivation = _partialMotivation.copyWith(challenges: challenges);
    emit(OnboardingPageChanged(
      currentPage: _currentPage,
      partialMotivation: _partialMotivation,
    ));
  }

  /// Actualiza los sentimientos post-entrenamiento (Página 3)
  void updatePostWorkoutFeelings(List<String> feelings) {
    _partialMotivation =
        _partialMotivation.copyWith(postWorkoutFeelings: feelings);
    emit(OnboardingPageChanged(
      currentPage: _currentPage,
      partialMotivation: _partialMotivation,
    ));
  }

  /// Actualiza las preferencias de notificaciones (Página 4)
  void updateNotificationPreferences(NotificationPreferences preferences) {
    _partialMotivation =
        _partialMotivation.copyWith(notificationPreferences: preferences);
    emit(OnboardingPageChanged(
      currentPage: _currentPage,
      partialMotivation: _partialMotivation,
    ));
  }

  /// Completa el onboarding y guarda toda la información
  Future<void> completeOnboarding() async {
    emit(OnboardingLoading());

    const userId = 'default_user'; // TODO: Obtener del usuario actual
    final finalMotivation =
        _partialMotivation.copyWith(updatedAt: DateTime.now());

    // 1. Guardar motivación del usuario
    final motivationResult = await saveUserMotivationUseCase(
      SaveUserMotivationParams(motivation: finalMotivation),
    );

    if (motivationResult.isLeft()) {
      motivationResult.fold(
        (failure) {
          debugPrint('❌ Error guardando motivación: ${failure.errorMessage}');
          emit(OnboardingError(_getUserFriendlyMessage(failure)));
        },
        (_) {},
      );
      return;
    }

    // 2. Marcar onboarding como completado
    final onboardingResult = await markOnboardingCompletedUseCase(
      MarkOnboardingCompletedParams(userId: userId),
    );

    onboardingResult.fold(
      (failure) {
        debugPrint('❌ Error marcando onboarding: ${failure.errorMessage}');
        emit(OnboardingError(_getUserFriendlyMessage(failure)));
      },
      (_) {
        debugPrint('✅ OnboardingCubit: Onboarding completado exitosamente');
        emit(OnboardingCompleted(finalMotivation));
      },
    );
  }

  /// Convierte errores técnicos en mensajes amigables
  String _getUserFriendlyMessage(failure) {
    return 'No pudimos guardar tus preferencias. ¿Intentamos de nuevo?';
  }

  /// Obtiene el progreso actual (0.0 a 1.0)
  double get progress => (_currentPage + 1) / 4;

  /// Verifica si se puede continuar desde la página actual
  bool canContinueFromCurrentPage() {
    debugPrint('🔍 Verificando si puede continuar desde página $_currentPage');

    bool canContinue = false;
    switch (_currentPage) {
      case 0: // Motivaciones
        canContinue = _partialMotivation.motivations.isNotEmpty;
        debugPrint(
            '📋 Página 0 (Motivaciones): ${_partialMotivation.motivations.length} seleccionadas - Puede continuar: $canContinue');
        break;
      case 1: // Desafíos
        canContinue = _partialMotivation.challenges.isNotEmpty;
        debugPrint(
            '📋 Página 1 (Desafíos): ${_partialMotivation.challenges.length} seleccionados - Puede continuar: $canContinue');
        break;
      case 2: // Sentimientos post-entrenamiento
        canContinue = _partialMotivation.postWorkoutFeelings.isNotEmpty;
        debugPrint(
            '📋 Página 2 (Sentimientos): ${_partialMotivation.postWorkoutFeelings.length} seleccionados - Puede continuar: $canContinue');
        break;
      case 3: // Notificaciones
        canContinue = true; // Siempre se puede continuar
        debugPrint('📋 Página 3 (Notificaciones): Siempre puede continuar');
        break;
      default:
        canContinue = false;
        debugPrint('❌ Página desconocida: $_currentPage');
        break;
    }

    return canContinue;
  }
}
