import 'package:flutter/material.dart';

class TarjetaEstado extends StatelessWidget {
  final String titulo;
  final String textoCuerpo;
  final IconData? icono;
  final Color colorFondo;
  static const double anchoPorcentaje = 175.0;
  static const double altoTarjeta = 100.0;
  static const double radioEsquina = 15.0;
  static const double tamanoIcono = 24.0;
  static const double tamanoTextoTitulo = 12.0;
  static const double tamanoTextoCuerpo = 20.0;
  static const Color colorTarjeta = Colors.white;

  const TarjetaEstado({
    super.key,
    required this.titulo,
    required this.textoCuerpo,
    required this.colorFondo,
    this.icono,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: anchoPorcentaje,
      height: altoTarjeta,
      decoration: BoxDecoration(
        border: Border.all(color: colorFondo, width: 3),
        borderRadius: BorderRadius.circular(radioEsquina), // Radio estándar
      ),
      child: Stack(
        children: [
          // Fondo completo con el color del título
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: colorFondo,
              borderRadius: BorderRadius.circular(radioEsquina - 3),
            ),
          ),
          /**
           * Sección del contenido superpuesta con esquinas redondeadas
           */
          Positioned(
            top: -7.5,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Text(
                titulo.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: tamanoTextoTitulo,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          /**
           * Sección del cuerpo de la tarjeta
           */
          Positioned(
            top: 22,
            left: 0.2,
            right: 0.2,
            bottom: 0.2,
            child: Container(
              decoration: BoxDecoration(
                color: colorTarjeta,
                borderRadius: BorderRadius.circular(radioEsquina),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icono != null)
                    Icon(
                      icono,
                      color: colorFondo,
                      size: tamanoIcono,
                    ),
                  const SizedBox(width: 8),
                  Text(
                    textoCuerpo,
                    style: TextStyle(
                      color: colorFondo,
                      fontSize: tamanoTextoCuerpo,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
