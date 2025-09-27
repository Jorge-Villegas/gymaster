import 'package:flutter/material.dart';
import 'package:gymaster/core/theme/espaciado.dart';
import 'package:gymaster/core/theme/tipografia_gymaster.dart';
import 'package:gymaster/core/theme/app_colors.dart';

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
      backgroundColor = AppColors.exitoCompletado;
      icon = Icons.check;
      break;
    case SnackBarType.error:
      backgroundColor = AppColors.errorAmigable;
      icon = Icons.error;
      break;
    case SnackBarType.info:
      backgroundColor = AppColors.informacionUtil;
      icon = Icons.info;
      break;
    case SnackBarType.warning:
      backgroundColor = AppColors.advertenciaSutil;
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
          padding: EdgeInsets.symmetric(
            horizontal: Espaciado.md,
            vertical: Espaciado.sm,
          ),
          child: Row(
            children: [
              Icon(icon, size: Espaciado.md, color: Colors.white),
              Espaciado.separacionHorizontalMd,
              Expanded(
                child: Text(
                  message,
                  style: TipografiaGyMaster.textoPrincipal.copyWith(
                    color: Colors.white,
                  ),
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
