import 'package:flutter/material.dart';

class AppColors {
  // ==============================================
  // PALETA PRINCIPAL HSB - MOTIVACIÓN Y ENERGÍA
  // ==============================================

  // COLOR PRIMARIO - Naranja motivacional (HSB: 15°, 75%, 95%)
  // Transmite energía, motivación y acción sin ser agresivo
  static final Color primario = HSVColor.fromAHSV(1, 15, 0.75, 0.95).toColor();
  static final Color primarioHover =
      HSVColor.fromAHSV(1, 18, 0.80, 0.98).toColor(); // Más saturado
  static final Color primarioDisabled =
      HSVColor.fromAHSV(1, 15, 0.35, 0.75).toColor(); // Menos saturado

  // COLOR SECUNDARIO - Azul confianza (HSB: 210°, 65%, 85%)
  // Para elementos de apoyo y navegación
  static final Color secundario =
      HSVColor.fromAHSV(1, 210, 0.65, 0.85).toColor();
  static final Color secundarioHover =
      HSVColor.fromAHSV(1, 215, 0.70, 0.90).toColor();
  static final Color secundarioDisabled =
      HSVColor.fromAHSV(1, 210, 0.30, 0.65).toColor();

  // ==============================================
  // COLORES EMOCIONALES - ESTADOS DEL GIMNASIO
  // ==============================================

  // MOTIVACIÓN Y ENERGÍA - Tonos cálidos sutiles
  static final Color motivacionPrincipal =
      HSVColor.fromAHSV(1, 12, 0.70, 0.92).toColor(); // Naranja coral suave
  static final Color energiaActiva =
      HSVColor.fromAHSV(1, 25, 0.68, 0.88).toColor(); // Naranja dorado
  static final Color impulsoEntrenamiento =
      HSVColor.fromAHSV(1, 8, 0.72, 0.90).toColor(); // Rojo anaranjado suave

  // ÉXITO Y LOGROS - Verdes naturales y dorados
  static final Color exitoCompletado =
      HSVColor.fromAHSV(1, 140, 0.60, 0.80).toColor(); // Verde bosque suave
  static final Color logroDesbloqueado =
      HSVColor.fromAHSV(1, 45, 0.75, 0.88).toColor(); // Dorado cálido
  static final Color metaAlcanzada =
      HSVColor.fromAHSV(1, 150, 0.55, 0.85).toColor(); // Verde esmeralda claro

  // CALMA Y RECUPERACIÓN - Azules y turquesas relajantes
  static final Color descansoActivo =
      HSVColor.fromAHSV(1, 195, 0.50, 0.82).toColor(); // Azul cielo suave
  static final Color recuperacionCompleta =
      HSVColor.fromAHSV(1, 180, 0.55, 0.78).toColor(); // Turquesa calmante
  static final Color relajacionProfunda =
      HSVColor.fromAHSV(1, 205, 0.45, 0.85).toColor(); // Azul pacífico

  // ADVERTENCIA Y ERRORES - Sutiles pero claros
  static final Color advertenciaSutil =
      HSVColor.fromAHSV(1, 35, 0.65, 0.90).toColor(); // Amarillo cálido
  static final Color errorAmigable =
      HSVColor.fromAHSV(1, 5, 0.60, 0.88).toColor(); // Rojo coral suave
  static final Color informacionUtil =
      HSVColor.fromAHSV(1, 200, 0.55, 0.80).toColor(); // Azul información

  // NIVELES DE DIFICULTAD - Graduación natural
  static final Color nivelPrincipiante =
      HSVColor.fromAHSV(1, 145, 0.58, 0.82).toColor(); // Verde amigable
  static final Color nivelIntermedio =
      HSVColor.fromAHSV(1, 38, 0.70, 0.90).toColor(); // Naranja cálido
  static final Color nivelAvanzado =
      HSVColor.fromAHSV(1, 8, 0.65, 0.85).toColor(); // Rojo coral desafío

  // COMPONENTES UI - TABLAS Y ELEMENTOS ESPECÍFICOS
  static final Color tablaFondoClaro =
      HSVColor.fromAHSV(1, 210, 0.12, 0.96).toColor(); // Azul muy claro
  static final Color tablaSeleccionClaro = HSVColor.fromAHSV(1, 205, 0.20, 0.92)
      .toColor(); // Azul claro seleccionado
  static final Color tablaEncabezadoClaro =
      HSVColor.fromAHSV(1, 210, 0.70, 0.75).toColor(); // Azul encabezado
  static final Color tablaDivisorClaro =
      HSVColor.fromAHSV(1, 0, 0, 0.88).toColor(); // Gris divisor

  // ==============================================
  // FONDOS Y SUPERFICIES
  // ==============================================

  // Fondos modo claro
  static final Color fondoPrincipalClaro =
      HSVColor.fromAHSV(1, 0, 0, 0.98).toColor(); // Blanco cálido
  static final Color fondoSecundarioClaro =
      HSVColor.fromAHSV(1, 210, 0.08, 0.96).toColor(); // Gris azulado muy claro
  static final Color fondoTarjetaClaro =
      HSVColor.fromAHSV(1, 0, 0, 1.0).toColor(); // Blanco puro

  // Fondos modo oscuro
  static final Color fondoPrincipalOscuro =
      HSVColor.fromAHSV(1, 220, 0.15, 0.08).toColor(); // Azul muy oscuro
  static final Color fondoSecundarioOscuro =
      HSVColor.fromAHSV(1, 215, 0.12, 0.12).toColor(); // Gris azulado oscuro
  static final Color fondoTarjetaOscuro =
      HSVColor.fromAHSV(1, 220, 0.10, 0.15).toColor(); // Gris oscuro cálido

  // Menú lateral
  static final Color menuLateralOscuro =
      HSVColor.fromAHSV(1, 225, 0.35, 0.22).toColor(); // Azul profundo

  // ==============================================
  // TEXTOS Y TIPOGRAFÍA
  // ==============================================

  // Textos modo claro
  static final Color textoPrincipalClaro =
      HSVColor.fromAHSV(1, 220, 0.08, 0.15).toColor(); // Gris muy oscuro
  static final Color textoSecundarioClaro =
      HSVColor.fromAHSV(1, 215, 0.05, 0.45).toColor(); // Gris medio
  static final Color textoTerciarioClaro =
      HSVColor.fromAHSV(1, 210, 0.03, 0.65).toColor(); // Gris claro

  // Textos modo oscuro
  static final Color textoPrincipalOscuro =
      HSVColor.fromAHSV(1, 0, 0, 0.95).toColor(); // Blanco cálido
  static final Color textoSecundarioOscuro =
      HSVColor.fromAHSV(1, 210, 0.05, 0.75).toColor(); // Gris claro
  static final Color textoTerciarioOscuro =
      HSVColor.fromAHSV(1, 215, 0.08, 0.55).toColor(); // Gris medio

  // ==============================================
  // ALIAS PARA COMPATIBILIDAD
  // ==============================================

  // Colores principales (para compatibilidad con código existente)
  static Color get primary => primario;
  static Color get secondary => secundario;

  // Estados de botones
  static Color get success => exitoCompletado;
  static Color get error => errorAmigable;
  static Color get warning => advertenciaSutil;
  static Color get info => informacionUtil;

  // Fondos
  static Color get backgroundLight => fondoPrincipalClaro;
  static Color get backgroundDark => fondoPrincipalOscuro;
  static Color get menuDarkBlue => menuLateralOscuro;

  // Textos
  static Color get textLight => textoPrincipalOscuro;
  static Color get textDark => textoPrincipalClaro;
  static Color get textSecondary => textoSecundarioClaro;
  static Color get textMedium => textoTerciarioClaro;

  // Botones (para compatibilidad)
  static Color get buttonPrimary => primario;
  static Color get buttonSecondary => secundario;

  // Niveles de ejercicios (para compatibilidad)
  static Color get beginnerColor => nivelPrincipiante;
  static Color get intermediateColor => nivelIntermedio;
  static Color get advancedColor => nivelAvanzado;

  // Tablas (para componentes UI)
  static Color get tableBackgroundColor => tablaFondoClaro;
  static Color get tableSelectionColor => tablaSeleccionClaro;
  static Color get tableHeaderColor => tablaEncabezadoClaro;
  static Color get tableDividerColor => tablaDivisorClaro;

  // ==============================================
  // COLORES LEGACY (MANTENER TEMPORALMENTE)
  // ==============================================

  @Deprecated('Use motivacionPrincipal instead')
  static const Color energyOrange = Color(0xFFFF6B35);
  @Deprecated('Use motivacionPrincipal instead')
  static const Color motivationRed = Color(0xFFE74C3C);
  @Deprecated('Use exitoCompletado instead')
  static const Color successGreen = Color(0xFF27AE60);
  @Deprecated('Use descansoActivo instead')
  static const Color calmBlue = Color(0xFF3498DB);
}
