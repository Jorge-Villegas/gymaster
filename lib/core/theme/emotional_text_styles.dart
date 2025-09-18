import 'package:flutter/material.dart';
import 'package:gymaster/core/theme/app_colors.dart';

/// Estilos de texto emocionales para GyMaster
/// Implementa diseño visceral siguiendo principios de Donald Norman
/// Utiliza ZonaPro para elementos motivacionales y Montserrat para legibilidad
class EmotionalTextStyles {
  // === ESTILOS MOTIVACIONALES ===

  /// Estilo para títulos motivacionales principales
  /// Usa: Pantallas de bienvenida, headers inspiradores
  static const TextStyle motivational = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 28,
    letterSpacing: 1.5,
    height: 1.2,
    color: AppColors.energyOrange,
  );

  /// Estilo para celebraciones épicas
  /// Usa: Completar rutinas, logros importantes
  static const TextStyle celebration = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 34,
    letterSpacing: 2.5,
    height: 1.1,
    color: AppColors.achievementGold,
  );

  /// Estilo para mensajes de aliento
  /// Usa: Motivación durante ejercicios, ánimos suaves
  static const TextStyle encouragement = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 20,
    letterSpacing: 0.8,
    height: 1.3,
    color: AppColors.successGreen,
  );

  /// Estilo para logros y achievements
  /// Usa: Insignias, records personales, hitos
  static const TextStyle achievement = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 1.8,
    height: 1.2,
    color: AppColors.achievementGold,
  );

  // === ESTILOS ENERGÉTICOS ===

  /// Estilo para llamadas a la acción energéticas
  /// Usa: "¡Comencemos!", "¡Dale que puedes!", botones principales
  static const TextStyle energetic = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 22,
    letterSpacing: 1.2,
    height: 1.1,
    color: AppColors.fireRed,
  );

  /// Estilo para contadores y números importantes
  /// Usa: Repeticiones, series, tiempo, records
  static const TextStyle counter = TextStyle(
    fontWeight: FontWeight.w800,
    fontSize: 48,
    letterSpacing: 0.5,
    height: 1.0,
    color: AppColors.motivationRed,
  );

  // === ESTILOS CALMADOS ===

  /// Estilo para momentos de descanso
  /// Usa: Temporizadores de descanso, ejercicios de respiración
  static const TextStyle restful = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 18,
    letterSpacing: 0.5,
    height: 1.4,
    color: AppColors.calmBlue,
  );

  /// Estilo para información de recuperación
  /// Usa: Consejos de descanso, hidratación, estiramientos
  static const TextStyle recovery = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: 0.3,
    height: 1.5,
    color: AppColors.restTeal,
  );

  // === ESTILOS ESPECIALES ===

  /// Estilo para recordatorios amigables
  /// Usa: "¿Cómo te sientes hoy?", recordatorios suaves
  static const TextStyle friendly = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 18,
    letterSpacing: 0.4,
    height: 1.3,
    color: AppColors.inspirationPink,
  );

  /// Estilo para progress indicators emocionales
  /// Usa: "¡Vas genial!", "50% completado", progress text
  static const TextStyle progress = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 16,
    letterSpacing: 1.0,
    height: 1.2,
    color: AppColors.energeticCoral,
  );

  /// Estilo para saludos personalizados
  /// Usa: "¡Hola Jorge!", saludos en homepage
  static const TextStyle greeting = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 26,
    letterSpacing: 1.0,
    height: 1.2,
    color: AppColors.warmOrange,
  );

  // === MÉTODOS HELPER PARA PERSONALIZACIÓN ===

  /// Crea variante del estilo motivacional con color personalizado
  static TextStyle motivationalWithColor(Color color) {
    return motivational.copyWith(color: color);
  }

  /// Crea variante del estilo celebración con tamaño personalizado
  static TextStyle celebrationWithSize(double fontSize) {
    return celebration.copyWith(fontSize: fontSize);
  }

  /// Crea variante del estilo aliento con intensidad
  /// intensity: 0.0 (suave) a 1.0 (intenso)
  static TextStyle encouragementWithIntensity(double intensity) {
    final color = Color.lerp(AppColors.calmBlue, AppColors.successGreen,
            intensity.clamp(0.0, 1.0)) ??
        AppColors.successGreen;

    final fontSize = 16 + (8 * intensity.clamp(0.0, 1.0));

    return encouragement.copyWith(
      color: color,
      fontSize: fontSize,
    );
  }

  /// Estilo para estado anímico según humor del usuario
  static TextStyle moodBasedStyle(String mood) {
    switch (mood.toLowerCase()) {
      case 'energético':
      case 'motivado':
        return energetic;
      case 'cansado':
      case 'relajado':
        return restful;
      case 'feliz':
      case 'celebrando':
        return celebration;
      default:
        return encouragement;
    }
  }
}

/// Extensión para facilitar el uso de estilos emocionales en widgets
extension EmotionalTextStylesExtension on TextStyle {
  /// Convierte cualquier TextStyle a versión emocional energética
  TextStyle get energized => copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.energyOrange,
        letterSpacing: 1.2,
      );

  /// Convierte cualquier TextStyle a versión emocional calmada
  TextStyle get calmed => copyWith(
        fontWeight: FontWeight.w500,
        color: AppColors.calmBlue,
        letterSpacing: 0.5,
      );
}
