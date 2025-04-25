import 'package:flutter/material.dart';

/// Enumeración de los tipos de mensajes que puede mostrar el SnackBar.
enum SnackBarType { success, error, info, warning }

/// Muestra un SnackBar personalizado.
///
/// El color de fondo del SnackBar cambia dependiendo del [type].
/// - [SnackBarType.success]: Verde
/// - [SnackBarType.error]: Rojo
/// - [SnackBarType.info]: Azul
/// - [SnackBarType.warning]: Amarillo
void showCustomSnackBar({
  required BuildContext context,
  required String message,
  required SnackBarType type,
  int duration = 3, // Cambiar a int
}) {
  Color backgroundColor;
  IconData icon;

  switch (type) {
    case SnackBarType.success:
      backgroundColor = Colors.green;
      icon = Icons.check;
      break;
    case SnackBarType.error:
      backgroundColor = Colors.red;
      icon = Icons.error;
      break;
    case SnackBarType.info:
      backgroundColor = Colors.blue;
      icon = Icons.info;
      break;
    case SnackBarType.warning:
      backgroundColor = Colors.yellow;
      icon = Icons.warning;
      break;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Card(
        // Agregar Card
        color: backgroundColor,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            children: [
              Icon(icon, size: 20, color: Colors.white),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      duration: Duration(seconds: duration),
    ),
  );
}
