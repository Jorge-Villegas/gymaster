import 'package:flutter/material.dart';

/// Enumeración de los tipos de mensajes que puede mostrar el SnackBar.
enum SnackBarType { success, error, info, warning }

class SnackbarHelper {
  static final SnackbarHelper _instance = SnackbarHelper._internal();
  factory SnackbarHelper() => _instance;
  SnackbarHelper._internal();

  ScaffoldMessengerState? _messenger;

  /// Método estático más seguro para mostrar SnackBars
  static void showSafeSnackBar(
    BuildContext context,
    String message,
    SnackBarType type,
  ) {
    try {
      final messenger = ScaffoldMessenger.maybeOf(context);
      if (messenger == null) {
        debugPrint('SnackBar no mostrado - No hay ScaffoldMessenger: $message');
        return;
      }

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
          backgroundColor = Colors.orange;
          icon = Icons.warning;
          break;
      }

      messenger.clearSnackBars();
      messenger.showSnackBar(
        SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: Card(
            color: backgroundColor,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
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
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      debugPrint('Error al mostrar SnackBar seguro: $e');
    }
  }

  void showCustomSnackBar(
    BuildContext context,
    String message,
    SnackBarType type,
  ) {
    try {
      // Verificar que existe un ScaffoldMessenger en el contexto
      final messenger = ScaffoldMessenger.maybeOf(context);
      if (messenger == null) {
        // Si no hay ScaffoldMessenger, usar un print como fallback
        debugPrint('SnackBar no mostrado - No hay ScaffoldMessenger: $message');
        return;
      }

      _messenger = messenger;

      // Limpia los SnackBars anteriores antes de mostrar uno nuevo
      _messenger!.clearSnackBars();
    } catch (e) {
      debugPrint('Error al mostrar SnackBar: $e');
      return;
    }

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
        backgroundColor = Colors.orange;
        icon = Icons.warning;
        break;
    }

    try {
      _messenger!.showSnackBar(
        SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: Card(
            color: backgroundColor,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
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
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      debugPrint('Error al mostrar SnackBar: $e');
    }
  }
}
