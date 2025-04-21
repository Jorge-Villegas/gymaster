import 'package:flutter/material.dart';
import 'package:gymaster/core/theme/app_colors.dart';

class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    fontFamily: 'Montserrat',
    useMaterial3: true,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    textTheme: const TextTheme(
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
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: AppColors.backgroundDark,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      floatingLabelStyle: TextStyle(color: AppColors.primary),
      border: OutlineInputBorder(),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary),
      ),
    ),
  );

  static final ThemeData lightTheme = ThemeData(
    fontFamily: 'Montserrat',
    useMaterial3: true,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    textTheme: const TextTheme(
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
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: AppColors.backgroundLight,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      floatingLabelStyle: TextStyle(color: AppColors.primary),
      border: OutlineInputBorder(),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary),
      ),
    ),
  );
}
