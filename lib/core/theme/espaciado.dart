import 'package:flutter/material.dart';

/// Sistema de Espaciado de 8 Puntos para GyMaster
///
/// Implementa la regla obligatoria de espaciado usando múltiplos de 8
/// para mantener una interfaz ordenada, consistente y fácil de escalar.
///
/// Uso:
/// - Márgenes: `Espaciado.margen16`
/// - Paddings: `Espaciado.relleno24`
/// - Separaciones: `Espaciado.separacion32`
class Espaciado {
  // ==============================================
  // ESPACIADOS BÁSICOS (múltiplos de 8)
  // ==============================================

  static const double cero = 0;
  static const double xs = 8; // Extra pequeño
  static const double sm = 16; // Pequeño
  static const double md = 24; // Mediano
  static const double lg = 32; // Grande
  static const double xl = 40; // Extra grande
  static const double xxl = 48; // Extra extra grande
  static const double xxxl = 56; // Triple extra grande

  // ==============================================
  // PADDING PRE-CONFIGURADOS
  // ==============================================

  /// Padding pequeño para elementos compactos
  static const EdgeInsets rellenoXs = EdgeInsets.all(xs);
  static const EdgeInsets rellenoSm = EdgeInsets.all(sm);
  static const EdgeInsets rellenoMd = EdgeInsets.all(md);
  static const EdgeInsets rellenoLg = EdgeInsets.all(lg);
  static const EdgeInsets rellenoXl = EdgeInsets.all(xl);

  /// Padding horizontal para contenedores principales
  static const EdgeInsets rellenoHorizontalSm =
      EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets rellenoHorizontalMd =
      EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets rellenoHorizontalLg =
      EdgeInsets.symmetric(horizontal: lg);

  /// Padding vertical para separaciones
  static const EdgeInsets rellenoVerticalXs =
      EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets rellenoVerticalSm =
      EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets rellenoVerticalMd =
      EdgeInsets.symmetric(vertical: md);

  /// Padding asimétrico común
  static const EdgeInsets relleno16y8 =
      EdgeInsets.symmetric(horizontal: sm, vertical: xs);
  static const EdgeInsets relleno24y16 =
      EdgeInsets.symmetric(horizontal: md, vertical: sm);
  static const EdgeInsets relleno32y24 =
      EdgeInsets.symmetric(horizontal: lg, vertical: md);

  // ==============================================
  // SEPARADORES (SizedBox)
  // ==============================================

  /// Separadores verticales
  static const Widget separacionVerticalXs = SizedBox(height: xs);
  static const Widget separacionVerticalSm = SizedBox(height: sm);
  static const Widget separacionVerticalMd = SizedBox(height: md);
  static const Widget separacionVerticalLg = SizedBox(height: lg);
  static const Widget separacionVerticalXl = SizedBox(height: xl);

  /// Separadores horizontales
  static const Widget separacionHorizontalXs = SizedBox(width: xs);
  static const Widget separacionHorizontalSm = SizedBox(width: sm);
  static const Widget separacionHorizontalMd = SizedBox(width: md);
  static const Widget separacionHorizontalLg = SizedBox(width: lg);

  // ==============================================
  // MÉTODOS HELPER
  // ==============================================

  /// Crea padding personalizado manteniendo múltiplos de 8
  static EdgeInsets rellenoPersonalizado({
    double? superior,
    double? inferior,
    double? izquierda,
    double? derecha,
  }) {
    assert(superior == null || superior % 8 == 0,
        'Superior debe ser múltiplo de 8');
    assert(inferior == null || inferior % 8 == 0,
        'Inferior debe ser múltiplo de 8');
    assert(izquierda == null || izquierda % 8 == 0,
        'Izquierda debe ser múltiplo de 8');
    assert(
        derecha == null || derecha % 8 == 0, 'Derecha debe ser múltiplo de 8');

    return EdgeInsets.only(
      top: superior ?? 0,
      bottom: inferior ?? 0,
      left: izquierda ?? 0,
      right: derecha ?? 0,
    );
  }

  /// Crea separación vertical personalizada (múltiplo de 8)
  static Widget separacionVertical(double altura) {
    assert(altura % 8 == 0, 'La altura debe ser múltiplo de 8');
    return SizedBox(height: altura);
  }

  /// Crea separación horizontal personalizada (múltiplo de 8)
  static Widget separacionHorizontal(double ancho) {
    assert(ancho % 8 == 0, 'El ancho debe ser múltiplo de 8');
    return SizedBox(width: ancho);
  }
}

/// Extensión para facilitar el uso de espaciado en widgets
extension EspaciadoExtension on Widget {
  /// Aplica padding usando el sistema de espaciado
  Widget conRelleno(EdgeInsets padding) =>
      Padding(padding: padding, child: this);

  /// Padding pequeño (8px)
  Widget conRellenoXs() => Padding(padding: Espaciado.rellenoXs, child: this);

  /// Padding mediano (16px)
  Widget conRellenoSm() => Padding(padding: Espaciado.rellenoSm, child: this);

  /// Padding grande (24px)
  Widget conRellenoMd() => Padding(padding: Espaciado.rellenoMd, child: this);

  /// Padding horizontal mediano
  Widget conRellenoHorizontal() =>
      Padding(padding: Espaciado.rellenoHorizontalSm, child: this);
}
