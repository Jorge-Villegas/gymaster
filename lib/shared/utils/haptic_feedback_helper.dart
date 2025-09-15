import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

/// Sistema de feedback háptico emocional para GyMaster
/// Implementa respuestas táctiles que refuerzan emociones positivas
/// Siguiendo principios de diseño visceral
class HapticFeedbackHelper {
  static final HapticFeedbackHelper _instance =
      HapticFeedbackHelper._internal();
  factory HapticFeedbackHelper() => _instance;
  HapticFeedbackHelper._internal();

  static Future<void> vibracionExito() async {
    try {
      await HapticFeedback.mediumImpact();
      await Future.delayed(const Duration(milliseconds: 100));
      await HapticFeedback.lightImpact();
      debugPrint('🎉 FeedbackHaptico: Vibración de éxito activada');
    } catch (e) {
      debugPrint('❌ Error FeedbackHaptico: $e');
    }
  }

  /// Patrón: Vibración fuerte + energética
  static Future<void> vibracionMotivacionalInicioRutina() async {
    try {
      await HapticFeedback.heavyImpact();
      debugPrint('💪 FeedbackHaptico: Vibración motivacional activada');
    } catch (e) {
      debugPrint('❌ Error FeedbackHaptico: $e');
    }
  }

  static Future<void> vibracionLogro() async {
    try {
      // Secuencia de celebración: fuerte-media-ligera-media-fuerte
      await HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(milliseconds: 80));
      await HapticFeedback.mediumImpact();
      await Future.delayed(const Duration(milliseconds: 80));
      await HapticFeedback.lightImpact();
      await Future.delayed(const Duration(milliseconds: 80));
      await HapticFeedback.mediumImpact();
      await Future.delayed(const Duration(milliseconds: 80));
      await HapticFeedback.heavyImpact();
      debugPrint('🏆 FeedbackHaptico: Celebración de logro activada');
    } catch (e) {
      debugPrint('❌ Error FeedbackHaptico: $e');
    }
  }

  static Future<void> vibracionTransicion() async {
    try {
      await HapticFeedback.selectionClick();
      debugPrint('🔄 FeedbackHaptico: Vibración de transición activada');
    } catch (e) {
      debugPrint('❌ HapticFeedback Error: $e');
    }
  }

  static Future<void> vibracionRecordatorio() async {
    try {
      await HapticFeedback.lightImpact();
      await Future.delayed(const Duration(milliseconds: 200));
      await HapticFeedback.lightImpact();
      debugPrint('⏰ FeedbackHaptico: Vibración de recordatorio activada');
    } catch (e) {
      debugPrint('❌ HapticFeedback Error: $e');
    }
  }

  static Future<void> vibracionSeleccion() async {
    try {
      await HapticFeedback.selectionClick();
      debugPrint('👆 FeedbackHaptico: Vibración de selección activada');
    } catch (e) {
      debugPrint('❌ Error FeedbackHaptico: $e');
    }
  }

  static Future<void> vibracionError() async {
    try {
      await HapticFeedback.mediumImpact();
      await Future.delayed(const Duration(milliseconds: 150));
      await HapticFeedback.mediumImpact();
      await Future.delayed(const Duration(milliseconds: 150));
      await HapticFeedback.mediumImpact();
      debugPrint('❌ FeedbackHaptico: Vibración de error activada');
    } catch (e) {
      debugPrint('❌ HapticFeedback Error: $e');
    }
  }

  static Future<void> vibracionPersonalizadaPorIntensidad(
      double intensidad) async {
    try {
      final intensidadAjustada = intensidad.clamp(0.0, 1.0);

      if (intensidadAjustada <= 0.3) {
        await HapticFeedback.lightImpact();
      } else if (intensidadAjustada <= 0.7) {
        await HapticFeedback.mediumImpact();
      } else {
        await HapticFeedback.heavyImpact();
      }

      debugPrint(
          '🎚️ FeedbackHaptico: Intensidad personalizada ($intensidadAjustada) activada');
    } catch (e) {
      debugPrint('❌ HapticFeedback Error: $e');
    }
  }

  static Future<void> vibracionProgreso(double progreso) async {
    try {
      // Vibraciones más intensas conforme se acerca al 100%
      if (progreso >= 0.25 && progreso < 0.5) {
        await HapticFeedback.lightImpact();
      } else if (progreso >= 0.5 && progreso < 0.75) {
        await HapticFeedback.mediumImpact();
      } else if (progreso >= 0.75 && progreso < 1.0) {
        await HapticFeedback.heavyImpact();
      } else if (progreso >= 1.0) {
        await vibracionLogro(); // Celebración completa
      }

      debugPrint(
          '📊 FeedbackHaptico: Vibración de progreso (${(progreso * 100).toInt()}%) activada');
    } catch (e) {
      debugPrint('❌ HapticFeedback Error: $e');
    }
  }
}

enum HapticType {
  exito,
  motivacional,
  logro,
  transicion,
  recordatorio,
  error,
}

extension HapticFeedbackExtension on HapticType {
  Future<void> trigger() async {
    switch (this) {
      case HapticType.exito:
        await HapticFeedbackHelper.vibracionExito();
        break;
      case HapticType.motivacional:
        await HapticFeedbackHelper.vibracionMotivacionalInicioRutina();
        break;
      case HapticType.logro:
        await HapticFeedbackHelper.vibracionLogro();
        break;
      case HapticType.transicion:
        await HapticFeedbackHelper.vibracionTransicion();
        break;
      case HapticType.recordatorio:
        await HapticFeedbackHelper.vibracionRecordatorio();
        break;
      case HapticType.error:
        await HapticFeedbackHelper.vibracionError();
        break;
    }
  }
}
