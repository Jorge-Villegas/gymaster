import 'package:flutter/foundation.dart';
import 'package:gymaster/features/setting/data/models/configuracion_usuario.dart';

abstract class NotificationServiceInterface {
  Future<bool> inicializarNotificaciones();
  Future<bool> solicitarPermisos();
  Future<void> programarRecordatorioEntrenar(String hora, bool habilitado);
  Future<void> programarRecordatorioRacha(bool habilitado);
  Future<void> programarRecordatorioDescanso(
      int tiempoSegundos, bool habilitado);
  Future<void> cancelarTodasLasNotificaciones();
  Future<void> cancelarNotificacionPorTipo(String tipo);
  Future<void> aplicarConfiguracionNotificaciones(
      ConfiguracionUsuario configuracion);
}

class NotificationService implements NotificationServiceInterface {
  static const String _recordatorioEntrenarId = 'recordatorio_entrenar';
  static const String _recordatorioRachaId = 'recordatorio_racha';
  static const String _recordatorioDescansoId = 'recordatorio_descanso';

  @override
  Future<bool> inicializarNotificaciones() async {
    try {
      // TODO: Implementar inicialización real con flutter_local_notifications
      // await flutterLocalNotificationsPlugin.initialize(initializationSettings);
      return true;
    } catch (e) {
      debugPrint('Error inicializando notificaciones: $e');
      return false;
    }
  }

  @override
  Future<bool> solicitarPermisos() async {
    try {
      // TODO: Implementar solicitud real de permisos
      // final permiso = await flutterLocalNotificationsPlugin
      //     .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      //     ?.requestPermission();
      return true;
    } catch (e) {
      debugPrint('Error solicitando permisos: $e');
      return false;
    }
  }

  @override
  Future<void> programarRecordatorioEntrenar(
      String hora, bool habilitado) async {
    try {
      if (!habilitado) {
        await cancelarNotificacionPorTipo(_recordatorioEntrenarId);
        return;
      }

      // TODO: Implementar programación real de notificación diaria
      final partesHora = hora.split(':');
      if (partesHora.length != 2) return;

      final horas = int.tryParse(partesHora[0]);
      final minutos = int.tryParse(partesHora[1]);

      if (horas == null ||
          minutos == null ||
          horas < 0 ||
          horas > 23 ||
          minutos < 0 ||
          minutos > 59) {
        return;
      }

      // TODO: Programar notificación diaria recurrente
    } catch (e) {
      debugPrint('Error programando recordatorio entrenar: $e');
    }
  }

  @override
  Future<void> programarRecordatorioRacha(bool habilitado) async {
    try {
      if (!habilitado) {
        await cancelarNotificacionPorTipo(_recordatorioRachaId);
        return;
      }

      // TODO: Implementar notificación de racha (ej: cada 3 días sin entrenar)
    } catch (e) {
      debugPrint('Error programando recordatorio racha: $e');
    }
  }

  @override
  Future<void> programarRecordatorioDescanso(
      int tiempoSegundos, bool habilitado) async {
    try {
      if (!habilitado) {
        await cancelarNotificacionPorTipo(_recordatorioDescansoId);
        return;
      }

      // TODO: Implementar notificación de descanso durante entrenamientos
    } catch (e) {
      debugPrint('Error programando recordatorio descanso: $e');
    }
  }

  @override
  Future<void> cancelarTodasLasNotificaciones() async {
    try {
      // TODO: Implementar cancelación real
      // await flutterLocalNotificationsPlugin.cancelAll();
    } catch (e) {
      debugPrint('Error cancelando notificaciones: $e');
    }
  }

  @override
  Future<void> cancelarNotificacionPorTipo(String tipo) async {
    try {
      debugPrint('🚫 Cancelando notificación tipo: $tipo');

      // TODO: Implementar cancelación específica por ID
      // await flutterLocalNotificationsPlugin.cancel(id);

      debugPrint('✅ Notificación $tipo cancelada');
    } catch (e) {
      debugPrint('❌ Error cancelando notificación $tipo: $e');
    }
  }

  @override
  Future<void> aplicarConfiguracionNotificaciones(
      ConfiguracionUsuario configuracion) async {
    try {
      debugPrint('⚙️ Aplicando configuración de notificaciones...');

      if (!configuracion.notificacionesHabilitadas) {
        debugPrint('🔕 Notificaciones deshabilitadas, cancelando todas');
        await cancelarTodasLasNotificaciones();
        return;
      }

      // Programar recordatorios según configuración
      if (configuracion.recordatorioEntrenar &&
          configuracion.horaRecordatorioManana.isNotEmpty) {
        await programarRecordatorioEntrenar(
            configuracion.horaRecordatorioManana, true);
      }

      if (configuracion.recordatorioEntrenar &&
          configuracion.horaRecordatorioTarde.isNotEmpty) {
        await programarRecordatorioEntrenar(
            configuracion.horaRecordatorioTarde, true);
      }

      if (configuracion.recordatorioRacha) {
        await programarRecordatorioRacha(true);
      }

      if (configuracion.recordatorioDescanso) {
        await programarRecordatorioDescanso(
            configuracion.tiempoDescansoDefecto, true);
      }

      debugPrint('✅ Configuración de notificaciones aplicada');
    } catch (e) {
      debugPrint('❌ Error aplicando configuración de notificaciones: $e');
    }
  }
}
