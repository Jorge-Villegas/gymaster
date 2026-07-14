import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gymaster/shared/utils/text_formatter.dart';
import 'package:gymaster/shared/utils/verificador_tipo_archivo.dart';
import 'package:gymaster/shared/widgets/gym/gym.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class EncabezadoEjercicioWidget extends StatelessWidget {
  final String nombreEjercicio;
  final int cantidadSeries;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final String urlImage;
  final String heroTag;

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
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            TextFormatter.capitalize(nombreEjercicio),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 45,
              height: 45,
              child: GymButton(
                label: '',
                icon: IconsaxPlusLinear.minus,
                variant: GymButtonVariant.ghost,
                size: GymButtonSize.small,
                expand: false,
                onPressed: onDecrement,
              ),
            ),
            const SizedBox(width: 15),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Series',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  cantidadSeries.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.065,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 15),
            SizedBox(
              width: 45,
              height: 45,
              child: GymButton(
                label: '',
                icon: IconsaxPlusLinear.add,
                variant: GymButtonVariant.ghost,
                size: GymButtonSize.medium,
                expand: false,
                onPressed: onIncrement,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Método que construye un widget de imagen.
  Widget _buildImageWidget(String urlImage, double imageSize) {
    debugPrint('🖼️ Intentando cargar imagen: $urlImage');

    if (urlImage.isEmpty) {
      debugPrint('❌ URL de imagen vacía');
      return _buildFallbackImage(imageSize);
    }

    if (VerificadorTipoArchivo.esSvg(urlImage)) {
      return SvgPicture.asset(
        urlImage,
        height: imageSize,
        fit: BoxFit.cover,
        placeholderBuilder: (context) => _buildFallbackImage(imageSize),
      );
    } else if (VerificadorTipoArchivo.esImagen(urlImage)) {
      return Image.asset(
        urlImage,
        height: imageSize,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('❌ Error cargando imagen: $error');
          return _buildFallbackImage(imageSize);
        },
      );
    } else {
      debugPrint('❌ Tipo de archivo no reconocido: $urlImage');
      return _buildFallbackImage(imageSize);
    }
  }

  /// Widget de fallback cuando no se puede cargar la imagen
  Widget _buildFallbackImage(double imageSize) {
    return Container(
      height: imageSize,
      width: imageSize,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[300]!, width: 2),
      ),
      child: Icon(
        IconsaxPlusLinear.weight,
        size: imageSize * 0.4,
        color: Colors.grey[500],
      ),
    );
  }
}
