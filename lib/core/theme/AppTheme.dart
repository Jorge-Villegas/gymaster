import 'package:flutter/material.dart';

class AppTheme {
  static const Color colorPrimario = Colors.blue;

  static final ThemeData darckTheme = ThemeData.dark().copyWith();

  static final ThemeData ligthTheme = ThemeData.light().copyWith(
    //Colors primario
    primaryColor: colorPrimario,
    useMaterial3: true,
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
    ),

    //Themas del boton flotante
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: colorPrimario,
    ),

    //Inputs
    inputDecorationTheme: const InputDecorationTheme(
      floatingLabelStyle: TextStyle(
        color: colorPrimario,
      ),
      border: OutlineInputBorder(),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: colorPrimario),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: colorPrimario),
      ),
    ),
  );
}
