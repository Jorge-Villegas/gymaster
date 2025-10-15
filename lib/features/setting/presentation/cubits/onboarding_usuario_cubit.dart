import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/setting/domain/entities/perfil_usuario_completo.dart';
import 'package:gymaster/features/setting/domain/usecases/crear_perfil_completo_usecase.dart';
import 'package:gymaster/features/setting/domain/usecases/obtener_perfil_completo_usecase.dart';
import 'package:gymaster/features/setting/domain/usecases/verificar_perfil_completo_existe_usecase.dart';
import 'package:gymaster/features/setting/presentation/cubits/onboarding_usuario_state.dart';

class OnboardingUsuarioCubit extends Cubit<OnboardingUsuarioState> {
  final VerificarPerfilCompletoExisteUseCase
      verificarPerfilCompletoExisteUseCase;
  final ObtenerPerfilCompletoUseCase obtenerPerfilCompletoUseCase;
  final CrearPerfilCompletoUseCase crearPerfilCompletoUseCase;

  OnboardingUsuarioCubit({
    required this.verificarPerfilCompletoExisteUseCase,
    required this.obtenerPerfilCompletoUseCase,
    required this.crearPerfilCompletoUseCase,
  }) : super(OnboardingUsuarioInitial());

  /// Verificar si el usuario necesita completar el onboarding
  Future<void> verificarOnboardingNecesario() async {
    emit(OnboardingUsuarioVerificando());

    try {
      final result = await verificarPerfilCompletoExisteUseCase(NoParams());

      result.fold(
        (failure) {
          emit(OnboardingUsuarioError(
              'Error al verificar el estado del perfil'));
        },
        (existe) {
          if (existe) {
            emit(OnboardingUsuarioCompleto(
                'Perfil ya existe, no se necesita onboarding'));
          } else {
            emit(OnboardingUsuarioNecesario());
          }
        },
      );
    } catch (e) {
      debugPrint('Error inesperado verificando onboarding: $e');
      emit(OnboardingUsuarioError('Error inesperado al verificar el perfil'));
    }
  }

  /// Obtener el perfil completo del usuario y emitir estado correspondiente
  Future<void> obtenerPerfilCompleto() async {
    emit(OnboardingUsuarioLoading());

    try {
      final result = await obtenerPerfilCompletoUseCase(NoParams());

      result.fold(
        (failure) {
          emit(OnboardingUsuarioError('Error al cargar el perfil del usuario'));
        },
        (perfil) {
          if (perfil != null) {
            emit(OnboardingUsuarioPerfilCargado(perfil));
          } else {
            emit(OnboardingUsuarioError('No se encontró perfil de usuario'));
          }
        },
      );
    } catch (e) {
      emit(OnboardingUsuarioError('Error inesperado al cargar el perfil'));
    }
  }

  /// Obtener el perfil completo del usuario (método helper sin emitir estado)
  Future<PerfilUsuarioCompleto?> obtenerPerfilCompletoSinEstado() async {
    try {
      final result = await obtenerPerfilCompletoUseCase(NoParams());

      return result.fold(
        (failure) {
          debugPrint('Error obteniendo perfil: ${failure.errorMessage}');
          return null;
        },
        (perfil) => perfil,
      );
    } catch (e) {
      return null;
    }
  }

  /// Crear nuevo perfil de usuario completo
  Future<void> crearPerfilCompleto({
    required String nombreUsuario,
    String? correo,
    required String fotoPerfil,
    required String nombreCompleto,
    DateTime? fechaNacimiento,
    required Genero genero,
    required ObjetivoFitness objetivoFitness,
    required NivelExperiencia nivelExperiencia,
    int? alturaCm,
    double? pesoActualKg,
    double? pesoObjetivoKg,
  }) async {
    emit(OnboardingUsuarioCreandoPerfil());

    try {
      final params = CrearPerfilCompletoParams(
        nombreUsuario: nombreUsuario,
        correo: correo,
        fotoPerfil: fotoPerfil,
        nombreCompleto: nombreCompleto,
        fechaNacimiento: fechaNacimiento,
        genero: genero,
        objetivoFitness: objetivoFitness,
        nivelExperiencia: nivelExperiencia,
        alturaCm: alturaCm,
        pesoActualKg: pesoActualKg,
        pesoObjetivoKg: pesoObjetivoKg,
      );

      final result = await crearPerfilCompletoUseCase(params);

      result.fold(
        (failure) {
          emit(OnboardingUsuarioError(failure.errorMessage));
        },
        (perfil) {
          emit(OnboardingUsuarioPerfilCreado(
            '¡Bienvenido ${perfil.nombreCompleto}! Tu perfil ha sido creado exitosamente.',
          ));
        },
      );
    } catch (e) {
      emit(OnboardingUsuarioError('Error inesperado al crear el perfil'));
    }
  }

  /// Resetear el estado a inicial
  void resetear() {
    emit(OnboardingUsuarioInitial());
  }

  /// Verificar si el estado actual requiere onboarding
  bool get necesitaOnboarding => state is OnboardingUsuarioNecesario;

  /// Verificar si el onboarding está completo
  bool get onboardingCompleto => state is OnboardingUsuarioCompleto;

  /// Verificar si hay un error
  bool get tieneError => state is OnboardingUsuarioError;

  /// Obtener mensaje de error si existe
  String? get mensajeError {
    final currentState = state;
    if (currentState is OnboardingUsuarioError) {
      return currentState.mensaje;
    }
    return null;
  }
}
