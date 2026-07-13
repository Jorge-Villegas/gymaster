import 'package:flutter/material.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';
import 'package:gymaster/core/theme/gym_typography.dart';

/// =============================================================================
/// TEMA — GyMaster (claro / oscuro)
/// -----------------------------------------------------------------------------
/// Construye el [ThemeData] a partir de los tokens [GymColors], con colores de
/// texto CORRECTOS para cada tema (arregla el dark mode roto de `AppTheme`,
/// donde el texto era casi negro sobre fondo casi negro).
///
/// Registra [GymColors] como extensión, así los widgets acceden con
/// `context.gym.brand` y siempre obtienen el color del tema activo.
/// =============================================================================
class GymTheme {
  const GymTheme._();

  static ThemeData get light => _build(GymColors.light, Brightness.light);
  static ThemeData get dark => _build(GymColors.dark, Brightness.dark);

  static ThemeData _build(GymColors c, Brightness brightness) {
    final baseText = TextTheme(
      displayLarge: GymType.display,
      titleLarge: GymType.title,
      titleMedium: GymType.section,
      bodyLarge: GymType.bodyStrong,
      bodyMedium: GymType.body,
      bodySmall: GymType.label,
      labelSmall: GymType.micro,
    ).apply(
      // Color de texto correcto por tema — la clave del arreglo.
      bodyColor: c.ink,
      displayColor: c.ink,
      fontFamily: GymType.familia,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: GymType.familia,
      scaffoldBackgroundColor: c.bg,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: c.brand,
        onPrimary: Colors.white,
        secondary: c.coral,
        onSecondary: Colors.white,
        tertiary: c.xp,
        onTertiary: c.ink,
        surface: c.surface,
        onSurface: c.ink,
        surfaceContainerHighest: c.surface2,
        error: c.danger,
        onError: Colors.white,
        outline: c.line,
      ),
      textTheme: baseText,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: c.bg,
        foregroundColor: c.ink,
        titleTextStyle: GymType.title.copyWith(color: c.ink),
      ),
      dividerTheme: DividerThemeData(color: c.line, thickness: 1, space: 1),
      iconTheme: IconThemeData(color: c.muted),
      extensions: [c],
    );
  }
}
