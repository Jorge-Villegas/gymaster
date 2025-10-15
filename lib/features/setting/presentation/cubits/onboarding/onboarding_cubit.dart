import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymaster/features/setting/data/models/user_motivation.dart';
import 'package:gymaster/features/setting/presentation/cubits/onboarding/onboarding_state.dart';
import 'package:gymaster/features/setting/domain/usecases/mark_onboarding_completed_usecase.dart';
import 'package:gymaster/features/setting/domain/usecases/save_user_motivation_usecase.dart';
import 'package:gymaster/features/setting/domain/entities/onboarding_config.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final SaveUserMotivationUseCase saveUserMotivationUseCase;
  final MarkOnboardingCompletedUseCase markOnboardingCompletedUseCase;

  late UserMotivation _partialMotivation;

  int _currentPage = 0;

  String? _avatarSeleccionado;
  Map<String, dynamic> _datosPersonales = {};
  String? _objetivoSeleccionado;
  String? _nivelExperiencia;

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
    if (_currentPage < OnboardingConfig.totalPaginas - 1) {
      _currentPage++;
      emit(OnboardingPageChanged(
        currentPage: _currentPage,
        partialMotivation: _partialMotivation,
      ));
    }
  }

  /// Navega a la página anterior
  void previousPage() {
    if (_currentPage > 0) {
      _currentPage--;
      emit(OnboardingPageChanged(
        currentPage: _currentPage,
        partialMotivation: _partialMotivation,
      ));
    }
  }

  /// Navega directamente a una página específica
  void navigateToPage(String pageId) {
    final pageIndex = OnboardingConfig.pages.indexWhere((p) => p.id == pageId);
    if (pageIndex != -1) {
      _currentPage = pageIndex;
      emit(OnboardingPageChanged(
        currentPage: _currentPage,
        partialMotivation: _partialMotivation,
      ));
    }
  }

  void updateAvatarSeleccionado(String avatar) {
    _avatarSeleccionado = avatar;
    emit(OnboardingPageChanged(
      currentPage: _currentPage,
      partialMotivation: _partialMotivation,
    ));
  }

  void updateDatosPersonales(Map<String, dynamic> datos) {
    _datosPersonales = datos;
    emit(OnboardingPageChanged(
      currentPage: _currentPage,
      partialMotivation: _partialMotivation,
    ));
  }

  void updateObjetivo(String objetivo) {
    _objetivoSeleccionado = objetivo;
    emit(OnboardingPageChanged(
      currentPage: _currentPage,
      partialMotivation: _partialMotivation,
    ));
  }

  void updateNivelExperiencia(String nivel) {
    _nivelExperiencia = nivel;
    emit(OnboardingPageChanged(
      currentPage: _currentPage,
      partialMotivation: _partialMotivation,
    ));
  }

  void updateMotivations(List<String> motivations) {
    _partialMotivation = _partialMotivation.copyWith(motivations: motivations);
    emit(OnboardingPageChanged(
      currentPage: _currentPage,
      partialMotivation: _partialMotivation,
    ));
  }

  /// Actualiza los desafíos seleccionados (Página 6)
  void updateChallenges(List<String> challenges) {
    _partialMotivation = _partialMotivation.copyWith(challenges: challenges);
    emit(OnboardingPageChanged(
      currentPage: _currentPage,
      partialMotivation: _partialMotivation,
    ));
  }

  /// Actualiza los sentimientos post-entrenamiento (Página 7)
  void updatePostWorkoutFeelings(List<String> feelings) {
    _partialMotivation =
        _partialMotivation.copyWith(postWorkoutFeelings: feelings);
    emit(OnboardingPageChanged(
      currentPage: _currentPage,
      partialMotivation: _partialMotivation,
    ));
  }

  /// Actualiza las preferencias de notificaciones (Página 8)
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
        (failure) => emit(OnboardingError(_getUserFriendlyMessage(failure))),
        (_) {},
      );
      return;
    }

    final onboardingResult = await markOnboardingCompletedUseCase(
      MarkOnboardingCompletedParams(userId: userId),
    );

    onboardingResult.fold(
      (failure) => emit(OnboardingError(_getUserFriendlyMessage(failure))),
      (_) => emit(OnboardingCompleted(finalMotivation)),
    );
  }

  String _getUserFriendlyMessage(dynamic failure) {
    return 'No pudimos guardar tus preferencias. ¿Intentamos de nuevo?';
  }

  int get currentPage => _currentPage;

  String? get avatarSeleccionado => _avatarSeleccionado;
  Map<String, dynamic> get datosPersonales => _datosPersonales;
  String? get objetivoSeleccionado => _objetivoSeleccionado;
  String? get nivelExperiencia => _nivelExperiencia;

  OnboardingPageConfig get currentPageConfig =>
      OnboardingConfig.pages[_currentPage];

  double get globalProgress =>
      OnboardingConfig.calcularProgresoGlobal(_currentPage);

  int get globalStepNumber =>
      OnboardingConfig.obtenerNumeroPasoGlobal(_currentPage);

  String get currentMotivationalText => currentPageConfig.textoMotivacional;

  /// Verifica si se puede continuar desde la página actual
  bool canContinueFromCurrentPage() {
    final pageConfig = currentPageConfig;

    switch (pageConfig.id) {
      case 'avatar':
        return _avatarSeleccionado != null;
      case 'datos_personales':
        return _datosPersonales.isNotEmpty &&
            _datosPersonales['nombre'] != null &&
            _datosPersonales['genero'] != null &&
            _datosPersonales['fechaNacimiento'] != null;
      case 'objetivos':
        return _objetivoSeleccionado != null;
      case 'nivel_experiencia':
        return _nivelExperiencia != null;
      case 'motivaciones':
        return _partialMotivation.motivations.isNotEmpty;
      case 'desafios':
        return _partialMotivation.challenges.isNotEmpty;
      case 'sentimientos_post_entrenamiento':
        return _partialMotivation.postWorkoutFeelings.isNotEmpty;
      case 'notificaciones':
        return true;
      default:
        return true;
    }
  }

  /// Verifica si estamos en la última página del onboarding
  bool get isLastPage {
    return _currentPage == OnboardingConfig.totalPaginas - 1;
  }
}
