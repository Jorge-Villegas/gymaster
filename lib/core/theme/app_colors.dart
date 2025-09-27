import 'package:flutter/material.dart';

/// Paleta de colores HSB-optimizada para aplicación de gimnasio
/// Implementa principios del sistema HSB para máxima flexibilidad y armonía visual
/// Diseñada para público joven (17-25 años) con enfoque en pesas y fuerza
class AppColors {
  // === COLORES PRIMARIOS (BASE HSB: H=258°, S=65%, B=76%) ===

  /// Color principal - Púrpura base (HSB: 258°, 65%, 76%)
  static const Color primario = Color(0xFF6B46C1);

  /// Variación cálida del primario - Movido -15° hacia magenta (HSB: 243°, 65%, 76%)
  static const Color primarioCalido = Color(0xFF8B46C1);

  /// Variación fría del primario - Movido +15° hacia azul (HSB: 273°, 65%, 76%)
  static const Color primarioFrio = Color(0xFF464BC1);

  /// Primario claro - Menor saturación para visibilidad controlada (HSB: 258°, 35%, 85%)
  static const Color primarioClaro = Color(0xFF9B7FDB);

  /// Primario oscuro RICO - "Removiendo blanco" (HSB: 258°, 80%, 55%)
  static const Color primarioOscuro = Color(0xFF4A2B8C);

  /// Primario muy oscuro RICO - Máxima riqueza (HSB: 258°, 85%, 40%)
  static const Color primarioProfundo = Color(0xFF2F1B5C);

  // ===============================================================
  // === COLORES SECUNDARIOS (BASE HSB: H=191°, S=92%, B=70%) ===
  // ===============================================================

  /// Color secundario - Teal base (HSB: 191°, 92%, 70%)
  static const Color secundario = Color(0xFF0891B2);

  /// Variación cálida del secundario - Hacia cyan (HSB: 176°, 92%, 70%)
  static const Color secundarioCalido = Color(0xFF08B29F);

  /// Variación fría del secundario - Hacia azul (HSB: 206°, 92%, 70%)
  static const Color secundarioFrio = Color(0xFF0865B2);

  /// Secundario claro - Reducida saturación (HSB: 191°, 50%, 80%)
  static const Color secundarioClaro = Color(0xFF66B8CC);

  /// Secundario oscuro RICO - "Removiendo blanco" (HSB: 191°, 95%, 50%)
  static const Color secundarioOscuro = Color(0xFF046680);

  /// Secundario muy oscuro RICO (HSB: 191°, 95%, 35%)
  static const Color secundarioProfundo = Color(0xFF024759);

  // ===============================================================
  // === COLORES DE ACENTO CON VARIACIONES HSB ===
  // ===============================================================

  /// Acento dorado principal (HSB: 38°, 93%, 96%)
  static const Color acento = Color(0xFFF59E0B);

  /// Acento cálido - Hacia naranja (HSB: 28°, 93%, 96%)
  static const Color acentoCalido = Color(0xFFF5730B);

  /// Acento frío - Hacia amarillo (HSB: 48°, 93%, 96%)
  static const Color acentoFrio = Color(0xFFF5C80B);

  /// Acento suave - Baja saturación para elementos sutiles (HSB: 38°, 40%, 90%)
  static const Color acentoSuave = Color(0xFFE5C582);

  // ===============================================================
  // === ESTADOS CON VARIACIONES RICAS ===
  // ===============================================================

  /// Éxito verde esmeralda (HSB: 158°, 89%, 73%)
  static const Color exito = Color(0xFF10B981);

  /// Éxito oscuro RICO - "Removiendo blanco" (HSB: 158°, 92%, 50%)
  static const Color exitoOscuro = Color(0xFF0A6B47);

  /// Advertencia coral (HSB: 0°, 58%, 100%)
  static const Color advertencia = Color(0xFFFF6B6B);

  /// Advertencia oscura RICA (HSB: 0°, 75%, 70%)
  static const Color advertenciaOscura = Color(0xFFB82C2C);

  /// Error rojo profesional (HSB: 0°, 81%, 86%)
  static const Color error = Color(0xFFDC2626);

  /// Error oscuro RICO (HSB: 0°, 90%, 60%)
  static const Color errorOscuro = Color(0xFF991B1B);

  /// Información azul (HSB: 217°, 76%, 96%)
  static const Color informacion = Color(0xFF3B82F6);

  /// Información oscura RICA (HSB: 217°, 85%, 65%)
  static const Color informacionOscura = Color(0xFF1E3A8A);

  // ===============================================================
  // === NEUTROS CON MATICES SUTILES ===
  // ===============================================================

  /// Fondo principal - Gris azulado con matiz frío (HSB: 222°, 65%, 11%)
  static const Color fondo = Color(0xFF0F172A);

  /// Fondo secundario - Matiz consistente (HSB: 222°, 58%, 18%)
  static const Color fondoSecundario = Color(0xFF1E293B);

  /// Fondo terciario - Progresión armónica (HSB: 222°, 50%, 25%)
  static const Color fondoTerciario = Color(0xFF334155);

  /// Superficie principal manteniendo armonía de matiz
  static const Color superficie = Color(0xFF1E293B);

  /// Superficie elevada con mayor luminosidad
  static const Color superficieElevada = Color(0xFF334155);

  // ===============================================================
  // === TEXTO CON VARIACIONES CONTROLADAS ===
  // ===============================================================

  /// Texto principal - Máximo contraste
  static const Color textoPrincipal = Color(0xFFFFFFFF);

  /// Texto secundario - Saturación reducida para jerarquía (HSB: 222°, 15%, 82%)
  static const Color textoSecundario = Color(0xFFCBD5E1);

  /// Texto terciario - Mayor reducción de saturación (HSB: 222°, 20%, 65%)
  static const Color textoTerciario = Color(0xFF94A3B8);

  /// Texto deshabilitado - Mínima saturación (HSB: 222°, 25%, 45%)
  static const Color textoDeshabilitado = Color(0xFF64748B);

  /// Texto sobre primario - Calculado para contraste óptimo
  static const Color textoSobrePrimario = Color(0xFFFFFFFF);

  /// Texto sobre secundario
  static const Color textoSobreSecundario = Color(0xFFFFFFFF);

  // ===============================================================
  // === BORDES Y DIVISORES CON MATICES ===
  // ===============================================================

  /// Borde principal con matiz sutil (HSB: 222°, 35%, 35%)
  static const Color borde = Color(0xFF475569);

  /// Divisor con menor saturación para sutileza (HSB: 222°, 40%, 28%)
  static const Color divisor = Color(0xFF374151);

  /// Borde activo/foco - Usando primario con menor saturación
  static const Color bordeActivo = Color(0xFF9B7FDB);

  // === COLORES ESPECÍFICOS PARA GYM CON VARIACIONES HSB ===

  /// Peso/carga - Azul acero con matiz armónico (HSB: 210°, 35%, 55%)
  static const Color peso = Color(0xFF64748B);

  /// Series completadas - Verde mint rico (HSB: 158°, 75%, 85%)
  static const Color serieCompletada = Color(0xFF34D399);

  /// Series pendientes - Verde desaturado (HSB: 158°, 25%, 70%)
  static const Color seriePendiente = Color(0xFF9CB3A3);

  /// Repeticiones - Púrpura con variación de matiz (HSB: 270°, 65%, 85%)
  static const Color repeticiones = Color(0xFFA855F7);

  /// Tiempo/descanso - Lavanda con matiz ajustado (HSB: 280°, 45%, 75%)
  static const Color tiempoDescanso = Color(0xFF9F7FBF);

  /// Progreso activo - Dorado con alta saturación (HSB: 38°, 93%, 96%)
  static const Color progresoActivo = Color(0xFFF59E0B);

  /// Progreso completado - Dorado desaturado para sutileza (HSB: 38°, 50%, 85%)
  static const Color progresoCompletado = Color(0xFFD4B574);

  // ===============================================================
  // === GRADIENTES OPTIMIZADOS CON HSB ===
  // ===============================================================

  /// Gradiente primario con variaciones armónicas de matiz
  static const LinearGradient gradientePrimario = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      primarioCalido, // Matiz -15°
      primario, // Matiz base
      primarioFrio, // Matiz +15°
    ],
    stops: [0.0, 0.5, 1.0],
  );

  /// Gradiente secundario con progresión HSB
  static const LinearGradient gradienteSecundario = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      secundarioCalido,
      secundario,
      secundarioFrio,
    ],
    stops: [0.0, 0.5, 1.0],
  );

  /// Gradiente de fondo con "remoción de blanco" progresiva
  static const LinearGradient gradienteFondo = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      fondo, // Más oscuro, más saturado
      fondoSecundario, // Progresión media
      fondoTerciario, // Más claro, menos saturado
    ],
  );

  /// Gradiente de progreso con matices cálidos
  static const LinearGradient gradienteProgreso = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      acentoFrio, // Amarillo (matiz +10°)
      acento, // Dorado base
      acentoCalido, // Naranja (matiz -10°)
    ],
  );

  // ===============================================================
  // === FUNCIONES AUXILIARES PARA GENERAR VARIACIONES HSB ===
  // ===============================================================

  /// Genera una variación de matiz de un color base
  /// [baseColor] Color base en hex
  /// [hueDelta] Cambio en grados del matiz (-180 a 180)
  static Color generateHueVariation(Color baseColor, double hueDelta) {
    // Nota: En Flutter, necesitarías una librería como 'hsv_color' para manipular HSV
    // Esta es una implementación conceptual
    return baseColor; // Placeholder - implementar con librería HSV
  }

  /// Genera una variación "removiendo blanco" (más saturado y menos brillante)
  /// [baseColor] Color base
  /// [factor] Factor de intensidad (0.0 a 1.0)
  static Color generateRichDark(Color baseColor, double factor) {
    // Implementación conceptual para "remover blanco"
    return baseColor; // Placeholder - implementar con librería HSV
  }

  // ===============================================================
  // === SOMBRAS CON COLORES TINTADOS ===
  // ===============================================================

  /// Sombra suave con tinte primario sutil
  static const List<BoxShadow> sombraSuave = [
    BoxShadow(
      color: Color(0x1A6B46C1), // Primario con 10% opacidad
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  /// Sombra fuerte con tinte secundario
  static const List<BoxShadow> sombraFuerte = [
    BoxShadow(
      color: Color(0x260891B2), // Secundario con 15% opacidad
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];

  /// Sombra de éxito
  static const List<BoxShadow> sombraExito = [
    BoxShadow(
      color: Color(0x1A10B981), // Verde éxito con opacidad
      blurRadius: 12,
      offset: Offset(0, 3),
    ),
  ];

  // ===============================================================
  // === ALIAS PARA COMPATIBILIDAD CON CÓDIGO EXISTENTE ===
  // ===============================================================

  // Mapeo de nombres antiguos a nuevos colores para compatibilidad
  static Color get motivacionPrincipal => acento;
  static Color get energiaActiva => acentoCalido;
  static Color get impulsoEntrenamiento => primarioCalido;
  static Color get exitoCompletado => exito;
  static Color get logroDesbloqueado => acento;
  static Color get metaAlcanzada => serieCompletada;
  static Color get descansoActivo => secundarioClaro;
  static Color get recuperacionCompleta => tiempoDescanso;
  static Color get relajacionProfunda => primarioClaro;
  static Color get advertenciaSutil => advertencia;
  static Color get errorAmigable => error;
  static Color get informacionUtil => informacion;
  static Color get nivelPrincipiante => exito;
  static Color get nivelIntermedio => acento;
  static Color get nivelAvanzado => error;

  // Fondos
  static Color get fondoPrincipalClaro => Color(0xFFF8FAFC);
  static Color get fondoSecundarioClaro => Color(0xFFF1F5F9);
  static Color get fondoTarjetaClaro => Color(0xFFFFFFFF);
  static Color get fondoPrincipalOscuro => fondo;
  static Color get fondoSecundarioOscuro => fondoSecundario;
  static Color get fondoTarjetaOscuro => superficie;
  static Color get menuLateralOscuro => fondoTerciario;

  // Textos
  static Color get textoPrincipalClaro => Color(0xFF0F172A);
  static Color get textoSecundarioClaro => textoTerciario;
  static Color get textoTerciarioClaro => textoDeshabilitado;
  static Color get textoPrincipalOscuro => textoPrincipal;
  static Color get textoSecundarioOscuro => textoSecundario;
  static Color get textoTerciarioOscuro => textoTerciario;

  // Tablas
  static Color get tablaFondoClaro => Color(0xFFF8FAFC);
  static Color get tablaSeleccionClaro => primarioClaro.withValues(alpha: 0.1);
  static Color get tablaEncabezadoClaro => primarioClaro;
  static Color get tablaDivisorClaro => divisor;

  // Getters de compatibilidad (manteniendo inglés para APIs externas)
  static Color get primary => primario;
  static Color get secondary => secundario;
  static Color get success => exito;
  static Color get warning => advertencia;
  static Color get info => informacion;
  static Color get backgroundLight => fondoPrincipalClaro;
  static Color get backgroundDark => fondoPrincipalOscuro;
  static Color get textLight => textoPrincipalOscuro;
  static Color get textDark => textoPrincipalClaro;
  static Color get textSecondary => textoSecundarioClaro;
  static Color get textMedium => textoTerciarioClaro;
  static Color get buttonPrimary => primario;
  static Color get buttonSecondary => secundario;
  static Color get beginnerColor => nivelPrincipiante;
  static Color get intermediateColor => nivelIntermedio;
  static Color get advancedColor => nivelAvanzado;
  static Color get tableBackgroundColor => tablaFondoClaro;
  static Color get tableSelectionColor => tablaSeleccionClaro;
  static Color get tableHeaderColor => tablaEncabezadoClaro;
  static Color get tableDividerColor => tablaDivisorClaro;
  static Color get menuDarkBlue => menuLateralOscuro;
}
