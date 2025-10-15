import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymaster/features/setting/domain/usecases/verificar_perfil_completo_existe_usecase.dart';
import 'package:gymaster/core/usecase/usecase.dart';

part 'app_start_state.dart';

class AppStartCubit extends Cubit<AppStartState> {
  final VerificarPerfilCompletoExisteUseCase
      verificarPerfilCompletoExisteUseCase;

  AppStartCubit({
    required this.verificarPerfilCompletoExisteUseCase,
  }) : super(AppStartInitial());

  /// Verifica el estado inicial de la aplicación
  Future<void> checkAppStartState() async {
    emit(AppStartLoading());

    final result = await verificarPerfilCompletoExisteUseCase(NoParams());

    result.fold(
      (failure) {
        debugPrint(
            '❌ Error verificando perfil completo: ${failure.errorMessage}');
        // En caso de error, mostrar onboarding por seguridad
        emit(AppStartShowOnboarding());
      },
      (perfilExiste) {
        debugPrint('✅ Perfil completo existe: $perfilExiste');
        if (perfilExiste) {
          emit(AppStartShowMainApp());
        } else {
          emit(AppStartShowOnboarding());
        }
      },
    );
  }
}
