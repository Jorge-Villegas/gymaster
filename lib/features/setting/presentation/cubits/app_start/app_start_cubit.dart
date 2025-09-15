import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/features/setting/domain/usecases/is_onboarding_completed_usecase.dart';

part 'app_start_state.dart';

class AppStartCubit extends Cubit<AppStartState> {
  final IsOnboardingCompletedUseCase isOnboardingCompletedUseCase;

  AppStartCubit({
    required this.isOnboardingCompletedUseCase,
  }) : super(AppStartInitial());

  /// Verifica el estado inicial de la aplicación
  Future<void> checkAppStartState() async {
    emit(AppStartLoading());

    const userId = 'default_user'; // TODO: Obtener del usuario actual

    final result = await isOnboardingCompletedUseCase(
      IsOnboardingCompletedParams(userId: userId),
    );

    result.fold(
      (failure) {
        debugPrint('❌ Error verificando onboarding: ${failure.errorMessage}');
        // En caso de error, mostrar onboarding por seguridad
        emit(AppStartShowOnboarding());
      },
      (isCompleted) {
        debugPrint('✅ Onboarding completado: $isCompleted');
        if (isCompleted) {
          emit(AppStartShowMainApp());
        } else {
          emit(AppStartShowOnboarding());
        }
      },
    );
  }
}
