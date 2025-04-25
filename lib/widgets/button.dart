import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  // Parámetros del botón
  final Color backgroundColor;
  final double height;
  final double width;
  final String text;
  final Color textColor;
  final double borderRadius;
  final VoidCallback onPressed;

  // Constructor del botón
  const Button({
    super.key,
    required this.backgroundColor,
    required this.height,
    required this.width,
    required this.text,
    required this.textColor,
    required this.borderRadius,
    required this.onPressed,
  });

//Observacion. Si el boton se esta llamado dentro de un contenidor donde
//se le asigna un tamaño, el boton se va a adaptar al tamaño del contenedor
//por lo que no se veran reflejado el ancho o alto que se le asigna al boton
  @override
  Widget build(BuildContext context) {
    // Retornar un widget ElevatedButton con los parámetros dados
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        fixedSize: Size(width, height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        // Texto del botón
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ), // Acción del botón
    );
  }
}
