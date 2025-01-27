import 'package:flutter/material.dart';
import 'package:gymaster/core/theme/app_colors.dart';

class AppTheme {
  static TextTheme _applyFontFamily(TextTheme textTheme) {
    return textTheme.apply(
      fontFamily: 'ZonaPro',
    );
  }

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    textTheme: _applyFontFamily(ThemeData.light().textTheme).copyWith(
      bodyLarge: const TextStyle(
        fontSize: 20.0,
        color: AppColors.textLight,
      ),
      bodyMedium: const TextStyle(
        fontSize: 18.0,
        color: AppColors.textLight,
      ),
      bodySmall: const TextStyle(
        fontSize: 16.0,
        color: AppColors.textLight,
      ),
      labelLarge: const TextStyle(
        fontSize: 16.0,
        color: AppColors.textLight,
      ),
      labelMedium: const TextStyle(
        fontSize: 14.0,
        color: AppColors.textLight,
      ),
      labelSmall: const TextStyle(
        fontSize: 12.0,
        color: AppColors.textLight,
      ),
      titleLarge: const TextStyle(
        fontSize: 24.0,
        color: AppColors.textLight,
      ),
      titleMedium: const TextStyle(
        fontSize: 22.0,
        color: AppColors.textLight,
      ),
      titleSmall: const TextStyle(
        fontSize: 20.0,
        color: AppColors.textLight,
      ),
      displayLarge: const TextStyle(
        fontSize: 34.0,
        color: AppColors.textLight,
      ),
      displayMedium: const TextStyle(
        fontSize: 30.0,
        color: AppColors.textLight,
      ),
      displaySmall: const TextStyle(
        fontSize: 26.0,
        color: AppColors.textLight,
      ),
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
      floatingLabelStyle: TextStyle(
        color: AppColors.primary,
      ),
      border: OutlineInputBorder(),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary),
      ),
    ),
  );

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: AppColors.primary,
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(AppColors.textLight),
        overlayColor: WidgetStateProperty.all(
          AppColors.primary.withOpacity(0.1),
        ),
      ),
    ),
    scaffoldBackgroundColor: AppColors.backgroundLight,
    textTheme: _applyFontFamily(ThemeData.light().textTheme).copyWith(
      bodyLarge: const TextStyle(
        fontSize: 20.0,
        color: AppColors.textDark,
      ),
      bodyMedium: const TextStyle(
        fontSize: 18.0,
        color: AppColors.textDark,
      ),
      bodySmall: const TextStyle(
        fontSize: 16.0,
        color: AppColors.textDark,
      ),
      labelLarge: const TextStyle(
        fontSize: 16.0,
        color: AppColors.textDark,
      ),
      labelMedium: const TextStyle(
        fontSize: 14.0,
        color: AppColors.textDark,
      ),
      labelSmall: const TextStyle(
        fontSize: 12.0,
        color: AppColors.textDark,
      ),
      titleLarge: const TextStyle(
        fontSize: 24.0,
        color: AppColors.textDark,
      ),
      titleMedium: const TextStyle(
        fontSize: 22.0,
        color: AppColors.textDark,
      ),
      titleSmall: const TextStyle(
        fontSize: 20.0,
        color: AppColors.textDark,
      ),
      displayLarge: const TextStyle(
        fontSize: 34.0,
        color: AppColors.textDark,
      ),
      displayMedium: const TextStyle(
        fontSize: 30.0,
        color: AppColors.textDark,
      ),
      displaySmall: const TextStyle(
        fontSize: 26.0,
        color: AppColors.textDark,
      ),
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
      floatingLabelStyle: TextStyle(
        color: AppColors.primary,
      ),
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
