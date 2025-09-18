import 'package:flutter/material.dart';

class AppColors {
  // Colores primarios
  static const Color primary = Color(0xFF675BE0); // Morado
  static const Color secondary = Color(0xFF4B0082); // Morado oscuro

  // Colores de fondo
  static const Color backgroundLight = Color.fromRGBO(244, 248, 252, 1);
  static const Color backgroundDark = Color.fromRGBO(14, 18, 22, 1);

  // Colores de texto
  static const Color textLight = Color.fromRGBO(255, 255, 255, 1); // Blanco
  static const Color textDark = Color.fromRGBO(0, 0, 0, 1); // Negro
  static const Color textSecondary = Color(0xFF7F7F7F);

  // Colores para botones
  static const Color buttonPrimary = Color(0xFF675BE0); // Morado
  static const Color buttonSecondary = Color(0xFF4B0082); // Morado oscuro

  // Additional colors for variations
  static const Color lightPink = Color(0xFFFFC1E3); // Light Pink
  static const Color darkPurple = Color(0xFF3700B3); // Dark Purple
  static const Color navyBlue = Color(0xFF0D47A1); // Navy Blue

  static const Color purpura = Color(0xFF9C27B0); // Purple
  static const Color lavanda = Color(0xFFE1BEE7); // Lavender

  // === COLORES EMOCIONALES - DISEÑO VISCERAL ===

  // Energía y motivación (para botones de acción)
  static const Color energyOrange = Color(0xFFFF6B35); // Naranja energético
  static const Color motivationRed = Color(0xFFE74C3C); // Rojo motivacional
  static const Color fireRed = Color(0xFFFF4757); // Rojo fuego para rachas

  // Logro y éxito (para completar ejercicios)
  static const Color successGreen = Color(0xFF27AE60); // Verde éxito
  static const Color achievementGold = Color(0xFFF39C12); // Dorado logros
  static const Color victoryGreen = Color(0xFF2ECC71); // Verde victoria

  // Calma y recuperación (para descansos)
  static const Color calmBlue = Color(0xFF3498DB); // Azul calmado
  static const Color restTeal = Color(0xFF1ABC9C); // Teal descanso
  static const Color peacefulBlue = Color(0xFF74B9FF); // Azul paz

  // Elementos especiales
  static const Color celebrationPurple =
      Color(0xFF9B59B6); // Morado celebración
  static const Color warmOrange = Color(0xFFE67E22); // Naranja cálido
  static const Color inspirationPink = Color(0xFFE91E63); // Rosa inspiración

  // Estados emocionales
  static const Color happyYellow = Color(0xFFF1C40F); // Amarillo feliz
  static const Color energeticCoral = Color(0xFFFF7675); // Coral energético
  static const Color focusIndigo = Color(0xFF6C5CE7); // Índigo concentración

  // === ALIAS PARA BOTONES (facilita uso en ChicletButtonVariants) ===
  static const Color success = successGreen;
  static const Color error = motivationRed;
  static const Color warning = energyOrange;
  static const Color info = calmBlue;
}
