import 'package:flutter/material.dart';

/// =============================================================================
/// TIPOGRAFÍA ÚNICA — GyMaster
/// -----------------------------------------------------------------------------
/// UN solo sistema tipográfico (reemplaza a `TipografiaGyMaster` +
/// `EstilosTextoEmocional`, que competían y se contradecían).
///
/// Define SOLO tamaño / peso / alto de línea. El COLOR lo aporta el tema
/// (DefaultTextStyle / textTheme) para que reaccione a claro/oscuro. Si
/// necesitas otro color puntual: `GymType.title.copyWith(color: ...)`.
/// =============================================================================
class GymType {
  const GymType._();

  static const String familia = 'Nunito';

  /// Hero / números grandes (24, w800)
  static const TextStyle display = TextStyle(
    fontFamily: familia,
    fontSize: 24,
    fontWeight: FontWeight.w800,
    height: 1.15,
    letterSpacing: -0.3,
  );

  /// Título de pantalla (20, w800)
  static const TextStyle title = TextStyle(
    fontFamily: familia,
    fontSize: 20,
    fontWeight: FontWeight.w800,
    height: 1.2,
    letterSpacing: -0.2,
  );

  /// Encabezado de tarjeta / sección fuerte (16, w800)
  static const TextStyle section = TextStyle(
    fontFamily: familia,
    fontSize: 16,
    fontWeight: FontWeight.w800,
    height: 1.25,
  );

  /// Cuerpo destacado (15, w600)
  static const TextStyle bodyStrong = TextStyle(
    fontFamily: familia,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.35,
  );

  /// Cuerpo base (14, w500)
  static const TextStyle body = TextStyle(
    fontFamily: familia,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  /// Etiqueta / chip (12, w700)
  static const TextStyle label = TextStyle(
    fontFamily: familia,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  /// Micro (10, w700) — badges de nav, ayudas mínimas
  static const TextStyle micro = TextStyle(
    fontFamily: familia,
    fontSize: 10,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: 0.2,
  );

  /// Números que se alinean en columnas (tabular)
  static const TextStyle number = TextStyle(
    fontFamily: familia,
    fontSize: 22,
    fontWeight: FontWeight.w800,
    height: 1.0,
    fontFeatures: [FontFeature.tabularFigures()],
  );
}
