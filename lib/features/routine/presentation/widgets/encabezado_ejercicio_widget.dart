import 'package:gymaster/core/utils/text_formatter.dart';
import 'package:gymaster/core/utils/verificador_tipo_archivo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EncabezadoEjercicioWidget extends StatelessWidget {
  final String nombreEjercicio;
  final int cantidadSeries;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final String urlImage;

  const EncabezadoEjercicioWidget({
    super.key,
    required this.nombreEjercicio,
    required this.cantidadSeries,
    required this.onIncrement,
    required this.onDecrement,
    required this.urlImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: _buildImageWidget(urlImage),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          TextFormatter.capitalize(nombreEjercicio),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Series: ',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              width: 40,
              child: Text(
                cantidadSeries.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              onPressed: onIncrement,
              icon: const Icon(Icons.add_circle),
              color: Colors.green,
              iconSize: 30,
            ),
            IconButton(
              onPressed: onDecrement,
              icon: const Icon(Icons.remove_circle),
              color: Colors.red,
              iconSize: 30,
            ),
          ],
        ),
      ],
    );
  }

  /// Método que construye un widget de imagen.
  Widget _buildImageWidget(String urlImage) {
    if (VerificadorTipoArchivo.esSvg(urlImage)) {
      return SvgPicture.asset(
        urlImage,
        height: 150,
        fit: BoxFit.cover,
      );
    } else if (VerificadorTipoArchivo.esImagen(urlImage)) {
      return Image.asset(
        urlImage,
        height: 150,
        fit: BoxFit.cover,
      );
    } else {
      return const Icon(
        Icons.error,
        size: 150,
      );
    }
  }
}
