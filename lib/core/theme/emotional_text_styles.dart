import 'package:flutter/material.dart';
import 'package:gymaster/core/theme/app_colors.dart';

/// Estilos de texto emocionales para GyMaster
/// Implementa diseño visceral siguiendo principios de Donald Norman
/// Utiliza ZonaPro para elementos motivacionales y Montserrat para legibilidad
class EstilosTextoEmocional {
  // === ESTILOS MOTIVACIONALES ===

  /// Estilo para títulos motivacionales principales
  /// Usa: Pantallas de bienvenida, headers inspiradores
  static TextStyle motivacional = TextStyle(
    fontWeight: FontWeight.w600, // SemiBold
    fontSize: 24,
    letterSpacing: 1.5,
    height: 1.2,
    color: AppColors.motivacionPrincipal,
  );

  /// Estilo para celebraciones épicas
  /// Usa: Completar rutinas, logros importantes
  static TextStyle celebracion = TextStyle(
    fontWeight: FontWeight.w600, // SemiBold
    fontSize: 24,
    letterSpacing: 1.5,
    height: 1.1,
    color: AppColors.logroDesbloqueado,
  );

  /// Estilo para mensajes de aliento
  /// Usa: Motivación durante ejercicios, ánimos suaves
  static TextStyle aliento = TextStyle(
    fontWeight: FontWeight.w600, // SemiBold
    fontSize: 18,
    letterSpacing: 0.8,
    height: 1.3,
    color: AppColors.exitoCompletado,
  );

  /// Estilo para logros y achievements
  /// Usa: Insignias, records personales, hitos
  static TextStyle logro = TextStyle(
    fontWeight: FontWeight.w600, // SemiBold
    fontSize: 24,
    letterSpacing: 1.2,
    height: 1.2,
    color: AppColors.logroDesbloqueado,
  );

  // === ESTILOS ENERGÉTICOS ===

  /// Estilo para llamadas a la acción energéticas
  /// Usa: "¡Comencemos!", "¡Dale que puedes!", botones principales
  static TextStyle energetico = TextStyle(
    fontWeight: FontWeight.w600, // SemiBold
    fontSize: 18,
    letterSpacing: 1.2,
    height: 1.1,
    color: AppColors.impulsoEntrenamiento,
  );

  /// Estilo para contadores y números importantes
  /// Usa: Repeticiones, series, tiempo, records
  static TextStyle contador = TextStyle(
    fontWeight: FontWeight.w600, // SemiBold
    fontSize: 24,
    letterSpacing: 0.5,
    height: 1.0,
    color: AppColors.errorAmigable,
  );

  // === ESTILOS CALMADOS ===

  /// Estilo para momentos de descanso
  /// Usa: Temporizadores de descanso, ejercicios de respiración
  static TextStyle descanso = TextStyle(
    fontWeight: FontWeight.w300, // Light
    fontSize: 18,
    letterSpacing: 0.5,
    height: 1.4,
    color: AppColors.descansoActivo,
  );

  /// Estilo para información de recuperación
  /// Usa: Consejos de descanso, hidratación, estiramientos
  static TextStyle recuperacion = TextStyle(
    fontWeight: FontWeight.w300, // Light
    fontSize: 15,
    letterSpacing: 0.3,
    height: 1.5,
    color: AppColors.exitoCompletado,
  );

  // === ESTILOS ESPECIALES ===

  /// Estilo para recordatorios amigables
  /// Usa: "¿Cómo te sientes hoy?", recordatorios suaves
  static TextStyle amigable = TextStyle(
    fontWeight: FontWeight.w300, // Light
    fontSize: 18,
    letterSpacing: 0.4,
    height: 1.3,
    color: AppColors.primario,
  );

  /// Estilo para progress indicators emocionales
  /// Usa: "¡Vas genial!", "50% completado", progress text
  static TextStyle progreso = TextStyle(
    fontWeight: FontWeight.w600, // SemiBold
    fontSize: 15,
    letterSpacing: 1.0,
    height: 1.2,
    color: AppColors.motivacionPrincipal,
  );

  /// Estilo para saludos personalizados
  /// Usa: "¡Hola Jorge!", saludos en homepage
  static TextStyle saludo = TextStyle(
    fontWeight: FontWeight.w600, // SemiBold
    fontSize: 18,
    letterSpacing: 1.0,
    height: 1.2,
    color: AppColors.motivacionPrincipal,
  );

  // === MÉTODOS HELPER PARA PERSONALIZACIÓN ===

  /// Crea variante del estilo motivacional con color personalizado
  static TextStyle motivacionalConColor(Color color) {
    return motivacional.copyWith(color: color);
  }

  /// Crea variante del estilo celebración con tamaño personalizado
  static TextStyle celebracionConTamanio(double fontSize) {
    return celebracion.copyWith(fontSize: fontSize);
  }

  /// Crea variante del estilo aliento con intensidad
  /// intensity: 0.0 (suave) a 1.0 (intenso)
  static TextStyle alientoConIntensidad(double intensity) {
    final color = Color.lerp(AppColors.descansoActivo,
            AppColors.exitoCompletado, intensity.clamp(0.0, 1.0)) ??
        AppColors.exitoCompletado;

    final fontSize = 15 + (3 * intensity.clamp(0.0, 1.0));

    return aliento.copyWith(
      color: color,
      fontSize: fontSize,
    );
  }

  /// Estilo para estado anímico según humor del usuario
  static TextStyle estiloPorEstadoDeAnimo(String mood) {
    switch (mood.toLowerCase()) {
      case 'energético':
      case 'motivado':
        return energetico;
      case 'cansado':
      case 'relajado':
        return descanso;
      case 'feliz':
      case 'celebrando':
        return celebracion;
      default:
        return aliento;
    }
  }
}

/// Extensión para facilitar el uso de estilos emocionales en widgets
extension EstilosTextoEmocionalExtension on TextStyle {
  TextStyle get energetizado => copyWith(
        fontWeight: FontWeight.w600, // SemiBold
        color: AppColors.motivacionPrincipal,
        letterSpacing: 1.2,
      );

  TextStyle get calmado => copyWith(
        fontWeight: FontWeight.w300, // Light
        color: AppColors.descansoActivo,
        letterSpacing: 0.5,
      );
}
