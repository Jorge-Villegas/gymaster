import 'package:flutter/material.dart';
import 'package:gymaster/core/theme/app_colors.dart';

/// Tema de la aplicación GyMaster con diseño emocional
/// Implementa los tres niveles de Norman: Visceral, Conductual y Reflexivo
class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    fontFamily: 'Poppins',
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primario,
      secondary: AppColors.secundario,
      surface: AppColors.fondo,
      error: AppColors.error, // Error emocional
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.textoPrincipal,
      // Colores adicionales emocionales
      tertiary: AppColors.acento,
      onTertiary: Colors.white,
    ),
    scaffoldBackgroundColor: AppColors.fondo,
    textTheme: TextTheme(
      bodyLarge: TextStyle(fontSize: 20.0, color: AppColors.textoPrincipal),
      bodyMedium: TextStyle(fontSize: 18.0, color: AppColors.textoPrincipal),
      bodySmall: TextStyle(fontSize: 16.0, color: AppColors.textoPrincipal),
      labelLarge: TextStyle(fontSize: 16.0, color: AppColors.textoPrincipal),
      labelMedium: TextStyle(fontSize: 14.0, color: AppColors.textoPrincipal),
      labelSmall: TextStyle(fontSize: 12.0, color: AppColors.textoPrincipal),
      titleLarge: TextStyle(fontSize: 24.0, color: AppColors.textoPrincipal),
      titleMedium: TextStyle(fontSize: 22.0, color: AppColors.textoPrincipal),
      titleSmall: TextStyle(fontSize: 20.0, color: AppColors.textoPrincipal),
      displayLarge: TextStyle(fontSize: 34.0, color: AppColors.textoPrincipal),
      displayMedium: TextStyle(fontSize: 30.0, color: AppColors.textoPrincipal),
      displaySmall: TextStyle(fontSize: 26.0, color: AppColors.textoPrincipal),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: AppColors.fondo,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.acento, // FAB emocional
      foregroundColor: Colors.white,
      elevation: 6,
    ),
    inputDecorationTheme: InputDecorationTheme(
      floatingLabelStyle: TextStyle(color: AppColors.primario),
      border: OutlineInputBorder(),
      enabledBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: AppColors.secundarioClaro), // Border emocional
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.acento), // Focus emocional
      ),
    ),
  );

  static final ThemeData lightTheme = ThemeData(
    fontFamily: 'Poppins',
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: AppColors.primario,
      secondary: AppColors.secundario,
      surface: AppColors.fondoPrincipalClaro,
      error: AppColors.error, // Error emocional
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.textoPrincipalOscuro,
      // Colores adicionales emocionales
      tertiary: AppColors.acento,
      onTertiary: Colors.white,
    ),
    scaffoldBackgroundColor: AppColors.fondoPrincipalClaro,
    textTheme: TextTheme(
      bodyLarge:
          TextStyle(fontSize: 20.0, color: AppColors.textoPrincipalOscuro),
      bodyMedium:
          TextStyle(fontSize: 18.0, color: AppColors.textoPrincipalOscuro),
      bodySmall:
          TextStyle(fontSize: 16.0, color: AppColors.textoPrincipalOscuro),
      labelLarge:
          TextStyle(fontSize: 16.0, color: AppColors.textoPrincipalOscuro),
      labelMedium:
          TextStyle(fontSize: 14.0, color: AppColors.textoPrincipalOscuro),
      labelSmall:
          TextStyle(fontSize: 12.0, color: AppColors.textoPrincipalOscuro),
      titleLarge:
          TextStyle(fontSize: 24.0, color: AppColors.textoPrincipalOscuro),
      titleMedium:
          TextStyle(fontSize: 22.0, color: AppColors.textoPrincipalOscuro),
      titleSmall:
          TextStyle(fontSize: 20.0, color: AppColors.textoPrincipalOscuro),
      displayLarge:
          TextStyle(fontSize: 34.0, color: AppColors.textoPrincipalOscuro),
      displayMedium:
          TextStyle(fontSize: 30.0, color: AppColors.textoPrincipalOscuro),
      displaySmall:
          TextStyle(fontSize: 26.0, color: AppColors.textoPrincipalOscuro),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: AppColors.fondoPrincipalClaro,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.acento, // FAB emocional
      foregroundColor: Colors.white,
      elevation: 6,
    ),
    inputDecorationTheme: InputDecorationTheme(
      floatingLabelStyle: TextStyle(color: AppColors.primario),
      border: OutlineInputBorder(),
      enabledBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: AppColors.secundarioClaro), // Border emocional
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.acento), // Focus emocional
      ),
    ),
  );
}
