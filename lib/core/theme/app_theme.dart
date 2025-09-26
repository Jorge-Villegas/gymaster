import 'package:flutter/material.dart';
import 'package:gymaster/core/theme/app_colors.dart';

/// Tema de la aplicación GyMaster con diseño emocional
/// Implementa los tres niveles de Norman: Visceral, Conductual y Reflexivo
class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    fontFamily: 'Poppins',
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.backgroundDark,
      error: AppColors.errorAmigable, // Error emocional
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.textLight,
      // Colores adicionales emocionales
      tertiary: AppColors.motivacionPrincipal,
      onTertiary: Colors.white,
    ),
    scaffoldBackgroundColor: AppColors.backgroundDark,
    textTheme: TextTheme(
      bodyLarge: TextStyle(fontSize: 20.0, color: AppColors.textLight),
      bodyMedium: TextStyle(fontSize: 18.0, color: AppColors.textLight),
      bodySmall: TextStyle(fontSize: 16.0, color: AppColors.textLight),
      labelLarge: TextStyle(fontSize: 16.0, color: AppColors.textLight),
      labelMedium: TextStyle(fontSize: 14.0, color: AppColors.textLight),
      labelSmall: TextStyle(fontSize: 12.0, color: AppColors.textLight),
      titleLarge: TextStyle(fontSize: 24.0, color: AppColors.textLight),
      titleMedium: TextStyle(fontSize: 22.0, color: AppColors.textLight),
      titleSmall: TextStyle(fontSize: 20.0, color: AppColors.textLight),
      displayLarge: TextStyle(fontSize: 34.0, color: AppColors.textLight),
      displayMedium: TextStyle(fontSize: 30.0, color: AppColors.textLight),
      displaySmall: TextStyle(fontSize: 26.0, color: AppColors.textLight),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: AppColors.backgroundDark,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.motivacionPrincipal, // FAB emocional
      foregroundColor: Colors.white,
      elevation: 6,
    ),
    inputDecorationTheme: InputDecorationTheme(
      floatingLabelStyle: TextStyle(color: AppColors.primary),
      border: OutlineInputBorder(),
      enabledBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: AppColors.descansoActivo), // Border emocional
      ),
      focusedBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: AppColors.motivacionPrincipal), // Focus emocional
      ),
    ),
  );

  static final ThemeData lightTheme = ThemeData(
    fontFamily: 'Poppins',
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.backgroundLight,
      error: AppColors.errorAmigable, // Error emocional
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.textDark,
      // Colores adicionales emocionales
      tertiary: AppColors.motivacionPrincipal,
      onTertiary: Colors.white,
    ),
    scaffoldBackgroundColor: AppColors.backgroundLight,
    textTheme: TextTheme(
      bodyLarge: TextStyle(fontSize: 20.0, color: AppColors.textDark),
      bodyMedium: TextStyle(fontSize: 18.0, color: AppColors.textDark),
      bodySmall: TextStyle(fontSize: 16.0, color: AppColors.textDark),
      labelLarge: TextStyle(fontSize: 16.0, color: AppColors.textDark),
      labelMedium: TextStyle(fontSize: 14.0, color: AppColors.textDark),
      labelSmall: TextStyle(fontSize: 12.0, color: AppColors.textDark),
      titleLarge: TextStyle(fontSize: 24.0, color: AppColors.textDark),
      titleMedium: TextStyle(fontSize: 22.0, color: AppColors.textDark),
      titleSmall: TextStyle(fontSize: 20.0, color: AppColors.textDark),
      displayLarge: TextStyle(fontSize: 34.0, color: AppColors.textDark),
      displayMedium: TextStyle(fontSize: 30.0, color: AppColors.textDark),
      displaySmall: TextStyle(fontSize: 26.0, color: AppColors.textDark),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: AppColors.backgroundLight,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.motivacionPrincipal, // FAB emocional
      foregroundColor: Colors.white,
      elevation: 6,
    ),
    inputDecorationTheme: InputDecorationTheme(
      floatingLabelStyle: TextStyle(color: AppColors.primary),
      border: OutlineInputBorder(),
      enabledBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: AppColors.descansoActivo), // Border emocional
      ),
      focusedBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: AppColors.motivacionPrincipal), // Focus emocional
      ),
    ),
  );
}
