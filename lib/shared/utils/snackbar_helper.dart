import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:gymaster/core/theme/gym_typography.dart';
import 'package:gymaster/core/theme/espaciado.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';

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
          backgroundColor = context.gym.brand;
          icon = IconsaxPlusLinear.tick_square;
          break;
        case SnackBarType.error:
          backgroundColor = context.gym.danger;
          icon = IconsaxPlusLinear.close_circle;
          break;
        case SnackBarType.info:
          backgroundColor = context.gym.info;
          icon = IconsaxPlusLinear.info_circle;
          break;
        case SnackBarType.warning:
          backgroundColor = context.gym.coral;
          icon = IconsaxPlusLinear.danger;
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
              padding: EdgeInsets.symmetric(
                horizontal: Espaciado.md, // 24px
                vertical: Espaciado.sm, // 16px
              ),
              child: Row(
                children: [
                  Icon(icon, size: Espaciado.md, color: Colors.white), // 24px
                  Espaciado.separacionHorizontalMd, // 24px
                  Expanded(
                    child: Text(
                      message,
                      style: GymType.body.copyWith(
                        color: Colors.white,
                      ),
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
        backgroundColor = context.gym.brand;
        icon = IconsaxPlusLinear.tick_square;
        break;
      case SnackBarType.error:
        backgroundColor = context.gym.danger;
        icon = IconsaxPlusLinear.close_circle;
        break;
      case SnackBarType.info:
        backgroundColor = context.gym.info;
        icon = IconsaxPlusLinear.info_circle;
        break;
      case SnackBarType.warning:
        backgroundColor = context.gym.coral;
        icon = IconsaxPlusLinear.danger;
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
              padding: EdgeInsets.symmetric(
                horizontal: Espaciado.md, // 24px
                vertical: Espaciado.sm, // 16px
              ),
              child: Row(
                children: [
                  Icon(icon, size: Espaciado.md, color: Colors.white), // 24px
                  Espaciado.separacionHorizontalMd, // 24px
                  Expanded(
                    child: Text(
                      message,
                      style: GymType.body.copyWith(
                        color: Colors.white,
                      ),
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
