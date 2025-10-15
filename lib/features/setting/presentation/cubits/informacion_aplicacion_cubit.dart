import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/setting/domain/usecases/actualizar_racha_actual_usecase.dart';
import 'package:gymaster/features/setting/presentation/cubits/informacion_aplicacion_state.dart';
import 'package:gymaster/features/setting/domain/usecases/incrementar_contador_inicio_app_usecase.dart';
import 'package:gymaster/features/setting/domain/usecases/obtener_informacion_aplicacion_usecase.dart';

class InformacionAplicacionCubit extends Cubit<InformacionAplicacionState> {
  final ObtenerInformacionAplicacionUseCase obtenerInformacionUseCase;
  final IncrementarContadorInicioAppUseCase incrementarContadorInicioUseCase;
  final ActualizarRachaActualUseCase actualizarRachaUseCase;

  InformacionAplicacionCubit({
    required this.obtenerInformacionUseCase,
    required this.incrementarContadorInicioUseCase,
    required this.actualizarRachaUseCase,
  }) : super(InformacionAplicacionInitial());

  /// Obtener información de la aplicación
  Future<void> obtenerInformacionAplicacion() async {
    emit(InformacionAplicacionLoading());

    final result = await obtenerInformacionUseCase(NoParams());

    result.fold(
      (failure) {
        emit(InformacionAplicacionError(_getMensajeUsuarioAmigable(failure)));
      },
      (informacion) {
        emit(InformacionAplicacionLoaded(informacion));
      },
    );
  }

  /// Incrementar contador de inicio de la aplicación
  Future<void> incrementarContadorInicio() async {
    final result = await incrementarContadorInicioUseCase(NoParams());

    result.fold(
      (failure) {
        debugPrint(
            'Error incrementando contador de inicio: ${failure.errorMessage}');
        // No emitir error aquí ya que es una acción secundaria
      },
      (_) {
        // Recargar la información actualizada
        obtenerInformacionAplicacion();
      },
    );
  }

  /// Actualizar racha actual
  Future<void> actualizarRacha(int nuevaRacha) async {
    final params = ActualizarRachaActualParams(nuevaRacha: nuevaRacha);
    final result = await actualizarRachaUseCase(params);

    result.fold(
      (failure) {
        emit(InformacionAplicacionError(_getMensajeUsuarioAmigable(failure)));
      },
      (_) {
        // Recargar la información actualizada
        obtenerInformacionAplicacion();
      },
    );
  }

  /// Obtener estadísticas básicas para mostrar en UI
  Future<void> obtenerEstadisticasBasicas() async {
    await obtenerInformacionAplicacion();
  }

  /// Resetear estado a inicial
  void resetearEstado() {
    emit(InformacionAplicacionInitial());
  }

  /// Convierte errores técnicos en mensajes amigables para el usuario
  String _getMensajeUsuarioAmigable(dynamic failure) {
    switch (failure.runtimeType.toString()) {
      case 'DatabaseFailure':
        return 'Error de base de datos. Intenta de nuevo.';
      case 'NoRecordsFailure':
        return 'No hay información de la aplicación disponible.';
      case 'CacheFailure':
        return 'Error al procesar la información. Intenta de nuevo.';
      default:
        return 'Ocurrió un error inesperado. Intenta de nuevo.';
    }
  }
}
