import 'package:gymaster/core/utils/text_formatter.dart';
import 'package:gymaster/core/utils/verificador_tipo_archivo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomCard extends StatelessWidget {
  final String ejercicioId;
  final String nombreEjercicio;
  final String imagenDireccion;
  final bool estadoSerie;
  final int numeroSeries;
  final Color colorFondo;
  final VoidCallback onDismissed;
  final VoidCallback onTap;

  const CustomCard({
    super.key,
    required this.ejercicioId,
    required this.nombreEjercicio,
    required this.imagenDireccion,
    required this.estadoSerie,
    required this.numeroSeries,
    required this.onDismissed,
    required this.onTap,
    required this.colorFondo,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Dismissible(
        key: Key(ejercicioId),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) => onDismissed(),
        background: Container(
          height: 20,
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ///
              /// Imagen del ejercicio
              ///
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10.0),
                  ),
                  child: _buildImageWidget(imagenDireccion),
                ),
              ),

              ///
              /// Nombre del ejercicio y numero de series
              ///
              Container(
                height: 100,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      TextFormatter.capitalize(nombreEjercicio),
                      style: const TextStyle(
                        fontSize: 14.0,
                        //fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      _formatoNumeroSeries(numeroSeries),
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      estadoSerie ? 'Completado' : 'En proceso',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: estadoSerie ? Colors.grey : Colors.green,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatoNumeroSeries(int numeroSeries) {
    return numeroSeries == 1 ? '1 serie' : '$numeroSeries series';
  }

  // Método privado para construir el widget de imagen
  Widget _buildImageWidget(String imagenDireccion) {
    if (VerificadorTipoArchivo.esSvg(imagenDireccion)) {
      return SvgPicture.asset(imagenDireccion);
    }
    if (VerificadorTipoArchivo.esImagen(imagenDireccion)) {
      return Image.asset(imagenDireccion);
    }
    return const Icon(Icons.error);
  }
}
