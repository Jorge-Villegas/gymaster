import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gymaster/shared/utils/text_formatter.dart';
import 'package:gymaster/shared/utils/verificador_tipo_archivo.dart';

class EncabezadoEjercicioWidget extends StatelessWidget {
  final String nombreEjercicio;
  final int cantidadSeries;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final String urlImage;
  final String heroTag; // Añadir parámetro heroTag

  const EncabezadoEjercicioWidget({
    super.key,
    required this.nombreEjercicio,
    required this.cantidadSeries,
    required this.onIncrement,
    required this.onDecrement,
    required this.urlImage,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Hero(
            tag: heroTag,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: _buildImageWidget(urlImage, screenWidth * 0.4),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          TextFormatter.capitalize(nombreEjercicio),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            height: screenHeight * 0.08,
            color: const Color.fromRGBO(232, 238, 241, 1.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Series: ',
                  style: TextStyle(fontSize: screenWidth * 0.045),
                ),
                SizedBox(
                  width: screenWidth * 0.1,
                  child: Text(
                    cantidadSeries.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onIncrement,
                  icon: const Icon(Icons.add_circle),
                  color: Colors.green,
                  iconSize: screenWidth * 0.08,
                ),
                IconButton(
                  onPressed: onDecrement,
                  icon: const Icon(Icons.remove_circle),
                  color: Colors.red,
                  iconSize: screenWidth * 0.08,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Método que construye un widget de imagen.
  Widget _buildImageWidget(String urlImage, double imageSize) {
    if (VerificadorTipoArchivo.esSvg(urlImage)) {
      return SvgPicture.asset(urlImage, height: imageSize, fit: BoxFit.cover);
    } else if (VerificadorTipoArchivo.esImagen(urlImage)) {
      return Image.asset(urlImage, height: imageSize, fit: BoxFit.cover);
    } else {
      return Icon(Icons.error, size: imageSize);
    }
  }
}
