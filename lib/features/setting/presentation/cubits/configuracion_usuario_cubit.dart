import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymaster/features/setting/data/models/configuracion_usuario.dart';
import 'package:gymaster/features/setting/domain/usecases/actualizar_configuracion_usuario_usecase.dart';
import 'package:gymaster/features/setting/domain/usecases/crear_configuracion_usuario_usecase.dart';
import 'package:gymaster/features/setting/presentation/cubits/configuracion_usuario_state.dart';
import 'package:gymaster/features/setting/domain/usecases/obtener_configuracion_por_usuario_id_usecase.dart';

class ConfiguracionUsuarioCubit extends Cubit<ConfiguracionUsuarioState> {
  final ObtenerConfiguracionPorUsuarioIdUseCase obtenerConfiguracionUseCase;
  final CrearConfiguracionUsuarioUseCase crearConfiguracionUseCase;
  final ActualizarConfiguracionUsuarioUseCase actualizarConfiguracionUseCase;

  ConfiguracionUsuarioCubit({
    required this.obtenerConfiguracionUseCase,
    required this.crearConfiguracionUseCase,
    required this.actualizarConfiguracionUseCase,
  }) : super(ConfiguracionUsuarioInitial());

  /// Obtener configuración por ID de usuario
  Future<void> obtenerConfiguracion(String usuarioId) async {
    emit(ConfiguracionUsuarioLoading());

    final result = await obtenerConfiguracionUseCase(
      ObtenerConfiguracionPorUsuarioIdParams(usuarioId: usuarioId),
    );

    result.fold(
      (failure) {
        debugPrint('Error obteniendo configuración: ${failure.errorMessage}');
        emit(ConfiguracionUsuarioError(_getMensajeUsuarioAmigable(failure)));
      },
      (configuracion) {
        if (configuracion != null) {
          emit(ConfiguracionUsuarioLoaded(configuracion));
        } else {
          emit(ConfiguracionUsuarioError(
              'No se encontró configuración para este usuario'));
        }
      },
    );
  }

  /// Crear configuración con valores por defecto
  Future<void> crearConfiguracionDefecto(String usuarioId) async {
    emit(ConfiguracionUsuarioLoading());

    final params = CrearConfiguracionUsuarioParams(usuarioId: usuarioId);
    final result = await crearConfiguracionUseCase(params);

    result.fold(
      (failure) {
        debugPrint('Error creando configuración: ${failure.errorMessage}');
        emit(ConfiguracionUsuarioError(_getMensajeUsuarioAmigable(failure)));
      },
      (configuracion) {
        emit(ConfiguracionUsuarioCreated(configuracion));
      },
    );
  }

  /// Crear configuración personalizada
  Future<void> crearConfiguracionPersonalizada({
    required String usuarioId,
    String unidadPeso = 'kg',
    String unidadLongitud = 'cm',
    String formatoHora = '24h',
    String formatoFecha = 'dd/mm/yyyy',
    String diaInicioSemana = 'lunes',
    String unidadCalorias = 'kcal',
    int tiempoDescansoDefecto = 60,
    bool sonidosHabilitados = true,
    bool vibracionHabilitada = true,
    int volumenSonidos = 80,
    String intensidadVibracion = 'media',
    bool autoSiguienteEjercicio = false,
    bool notificacionesHabilitadas = true,
    bool recordatorioEntrenar = true,
    bool recordatorioRacha = true,
    bool recordatorioDescanso = true,
    String? horaRecordatorioManana = '08:00',
    String? horaRecordatorioTarde = '18:00',
    bool modoOscuro = false,
    String idioma = 'es',
  }) async {
    emit(ConfiguracionUsuarioLoading());

    final params = CrearConfiguracionUsuarioParams(
      usuarioId: usuarioId,
      unidadPeso: unidadPeso,
      unidadLongitud: unidadLongitud,
      formatoHora: formatoHora,
      formatoFecha: formatoFecha,
      diaInicioSemana: diaInicioSemana,
      unidadCalorias: unidadCalorias,
      tiempoDescansoDefecto: tiempoDescansoDefecto,
      sonidosHabilitados: sonidosHabilitados,
      vibracionHabilitada: vibracionHabilitada,
      volumenSonidos: volumenSonidos,
      intensidadVibracion: intensidadVibracion,
      autoSiguienteEjercicio: autoSiguienteEjercicio,
      notificacionesHabilitadas: notificacionesHabilitadas,
      recordatorioEntrenar: recordatorioEntrenar,
      recordatorioRacha: recordatorioRacha,
      recordatorioDescanso: recordatorioDescanso,
      horaRecordatorioManana: horaRecordatorioManana,
      horaRecordatorioTarde: horaRecordatorioTarde,
      modoOscuro: modoOscuro,
      idioma: idioma,
    );

    final result = await crearConfiguracionUseCase(params);

    result.fold(
      (failure) {
        debugPrint(
            'Error creando configuración personalizada: ${failure.errorMessage}');
        emit(ConfiguracionUsuarioError(_getMensajeUsuarioAmigable(failure)));
      },
      (configuracion) {
        emit(ConfiguracionUsuarioCreated(configuracion));
      },
    );
  }

  /// Actualizar configuración existente
  Future<void> actualizarConfiguracion(
      ConfiguracionUsuario configuracion) async {
    emit(ConfiguracionUsuarioLoading());

    final params =
        ActualizarConfiguracionUsuarioParams(configuracion: configuracion);
    final result = await actualizarConfiguracionUseCase(params);

    result.fold(
      (failure) {
        debugPrint('Error actualizando configuración: ${failure.errorMessage}');
        emit(ConfiguracionUsuarioError(_getMensajeUsuarioAmigable(failure)));
      },
      (configuracionActualizada) {
        emit(ConfiguracionUsuarioUpdated(configuracionActualizada));
      },
    );
  }

  /// Resetear estado a inicial
  void resetearEstado() {
    emit(ConfiguracionUsuarioInitial());
  }

  /// Convierte errores técnicos en mensajes amigables para el usuario
  String _getMensajeUsuarioAmigable(failure) {
    switch (failure.runtimeType.toString()) {
      case 'DatabaseFailure':
        return 'Error de base de datos. Intenta de nuevo.';
      case 'NoRecordsFailure':
        return 'No tienes configuración guardada aún.';
      case 'CacheFailure':
        return 'Error de configuración. Verifica los datos ingresados.';
      default:
        return 'Ocurrió un error inesperado. Intenta de nuevo.';
    }
  }
}
