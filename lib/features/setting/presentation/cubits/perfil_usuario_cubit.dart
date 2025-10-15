import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymaster/features/setting/data/models/perfil_usuario.dart';
import 'package:gymaster/features/setting/domain/usecases/actualizar_perfil_usuario_usecase.dart';
import 'package:gymaster/features/setting/presentation/cubits/perfil_usuario_state.dart';
import 'package:gymaster/features/setting/domain/usecases/obtener_perfil_por_id_usecase.dart';

class PerfilUsuarioCubit extends Cubit<PerfilUsuarioState> {
  final ObtenerPerfilPorIdUseCase obtenerPerfilUseCase;
  final ActualizarPerfilUsuarioUseCase actualizarPerfilUseCase;

  PerfilUsuarioCubit({
    required this.obtenerPerfilUseCase,
    required this.actualizarPerfilUseCase,
  }) : super(PerfilUsuarioInitial());

  /// Obtener perfil por ID de usuario
  Future<void> obtenerPerfil(String usuarioId) async {
    emit(PerfilUsuarioLoading());

    final result = await obtenerPerfilUseCase(
      ObtenerPerfilPorIdParams(usuarioId: usuarioId),
    );

    result.fold(
      (failure) {
        emit(PerfilUsuarioError(_getMensajeUsuarioAmigable(failure)));
      },
      (perfil) {
        if (perfil != null) {
          emit(PerfilUsuarioLoaded(perfil));
        } else {
          emit(PerfilUsuarioError('No se encontró perfil para este usuario'));
        }
      },
    );
  }

  /// Actualizar perfil de usuario
  Future<void> actualizarPerfil(PerfilUsuario perfil) async {
    emit(PerfilUsuarioLoading());

    final params = ActualizarPerfilUsuarioParams(perfil: perfil);
    final result = await actualizarPerfilUseCase(params);

    result.fold(
      (failure) {
        emit(PerfilUsuarioError(_getMensajeUsuarioAmigable(failure)));
      },
      (perfilActualizado) {
        emit(PerfilUsuarioUpdated(perfilActualizado));
      },
    );
  }

  /// Actualizar datos básicos del perfil
  Future<void> actualizarDatosBasicos({
    required String usuarioId,
    required String nombreUsuario,
    required String correo,
    String? nombreCompleto,
    String? fotoPerfil,
  }) async {
    // Primero obtener el perfil actual
    final currentState = state;
    PerfilUsuario? perfilActual;

    if (currentState is PerfilUsuarioLoaded) {
      perfilActual = currentState.perfil;
    } else {
      // Si no tenemos el perfil cargado, lo obtenemos
      final result = await obtenerPerfilUseCase(
        ObtenerPerfilPorIdParams(usuarioId: usuarioId),
      );

      result.fold(
        (failure) {
          emit(PerfilUsuarioError(_getMensajeUsuarioAmigable(failure)));
          return;
        },
        (perfil) {
          perfilActual = perfil;
        },
      );
    }

    if (perfilActual == null) {
      emit(PerfilUsuarioError('No se pudo obtener el perfil actual'));
      return;
    }

    // Actualizar con los nuevos datos
    final perfilActualizado = perfilActual!.copyWith(
      nombreUsuario: nombreUsuario,
      correo: correo,
      nombreCompleto: nombreCompleto,
      fotoPerfil: fotoPerfil,
      fechaActualizacionPerfil: DateTime.now(),
    );

    await actualizarPerfil(perfilActualizado);
  }

  /// Actualizar datos físicos del perfil
  Future<void> actualizarDatosFisicos({
    required String usuarioId,
    DateTime? fechaNacimiento,
    String? genero,
    int? alturaCm,
    double? pesoActualKg,
    double? pesoObjetivoKg,
  }) async {
    // Obtener perfil actual
    final currentState = state;
    PerfilUsuario? perfilActual;

    if (currentState is PerfilUsuarioLoaded) {
      perfilActual = currentState.perfil;
    } else {
      final result = await obtenerPerfilUseCase(
        ObtenerPerfilPorIdParams(usuarioId: usuarioId),
      );

      result.fold(
        (failure) {
          emit(PerfilUsuarioError(_getMensajeUsuarioAmigable(failure)));
          return;
        },
        (perfil) {
          perfilActual = perfil;
        },
      );
    }

    if (perfilActual == null) {
      emit(PerfilUsuarioError('No se pudo obtener el perfil actual'));
      return;
    }

    final perfilActualizado = perfilActual!.copyWith(
      fechaNacimiento: fechaNacimiento,
      genero: genero,
      alturaCm: alturaCm,
      pesoActualKg: pesoActualKg,
      pesoObjetivoKg: pesoObjetivoKg,
      fechaActualizacionPerfil: DateTime.now(),
    );

    await actualizarPerfil(perfilActualizado);
  }

  /// Actualizar objetivos fitness
  Future<void> actualizarObjetivosFitness({
    required String usuarioId,
    String? objetivoFitness,
    String? nivelExperiencia,
  }) async {
    // Obtener perfil actual
    final currentState = state;
    PerfilUsuario? perfilActual;

    if (currentState is PerfilUsuarioLoaded) {
      perfilActual = currentState.perfil;
    } else {
      final result = await obtenerPerfilUseCase(
        ObtenerPerfilPorIdParams(usuarioId: usuarioId),
      );

      result.fold(
        (failure) {
          emit(PerfilUsuarioError(_getMensajeUsuarioAmigable(failure)));
          return;
        },
        (perfil) {
          perfilActual = perfil;
        },
      );
    }

    if (perfilActual == null) {
      emit(PerfilUsuarioError('No se pudo obtener el perfil actual'));
      return;
    }

    final perfilActualizado = perfilActual!.copyWith(
      objetivoFitness: objetivoFitness,
      nivelExperiencia: nivelExperiencia,
      fechaActualizacionPerfil: DateTime.now(),
    );

    await actualizarPerfil(perfilActualizado);
  }

  /// Resetear estado a inicial
  void resetearEstado() {
    emit(PerfilUsuarioInitial());
  }

  /// Convierte errores técnicos en mensajes amigables para el usuario
  String _getMensajeUsuarioAmigable(failure) {
    switch (failure.runtimeType.toString()) {
      case 'DatabaseFailure':
        return 'Error de base de datos. Intenta de nuevo.';
      case 'NoRecordsFailure':
        return 'No tienes perfil creado aún.';
      case 'CacheFailure':
        return 'Error en los datos del perfil. Verifica la información ingresada.';
      default:
        return 'Ocurrió un error inesperado. Intenta de nuevo.';
    }
  }
}
