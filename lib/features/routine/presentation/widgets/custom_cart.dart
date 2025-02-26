import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gymaster/shared/utils/text_formatter.dart';
import 'package:gymaster/shared/utils/verificador_tipo_archivo.dart';

class CustomCard extends StatelessWidget {
  final String ejercicioId;
  final String nombreEjercicio;
  final String imagenDireccion;
  final bool estadoSerie;
  final int numeroSeries;
  final Color colorFondo;
  final List<double> pesos;
  final VoidCallback onDismissed;
  final VoidCallback onTap;
  final double? height; // Parámetro opcional para la altura
  final int index; // Añade el índice como parámetro
  // In CustomCard class, add this property:
  final Future<bool> Function()? confirmDismiss;

  const CustomCard({
    super.key,
    required this.ejercicioId,
    required this.nombreEjercicio,
    required this.imagenDireccion,
    required this.estadoSerie,
    required this.numeroSeries,
    required this.onDismissed,
    required this.pesos,
    required this.onTap,
    required this.colorFondo,
    this.height, // Inicializa el parámetro opcional
    required this.index, // Inicializa el índice
    required this.confirmDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Dismissible(
        key: ValueKey(ejercicioId), // Asegúrate de que esta clave sea única
        direction: DismissDirection.endToStart,
        confirmDismiss:
            confirmDismiss != null ? (direction) => confirmDismiss!() : null,
        onDismissed: (direction) => onDismissed(),
        background: Container(
          height: 20,
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        child: SizedBox(
          height: height, // Establece la altura si se proporciona
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              children: [
                SizedBox(
                  height: double.infinity,
                  child: ReorderableDragStartListener(
                    index: index,
                    child: const Icon(Icons.drag_indicator, color: Colors.grey),
                  ),
                ),

                /// Imagen del ejercicio
                Expanded(
                  flex: 1,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(10.0),
                    ),
                    child: Stack(
                      children: [
                        _buildImageWidget(imagenDireccion),
                        if (estadoSerie)
                          Positioned.fill(
                            child: Container(
                              color: Colors.green.withAlpha(
                                (0.5 * 255).toInt(),
                              ), // Reemplaza withOpacity con withAlpha
                              child: const Center(
                                child: Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 50.0,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                /// Nombre del ejercicio y numero de series
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                          _formatoNumeroSeries(
                            numeroSeries,
                            numeroSeries,
                            pesos,
                          ),
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey,
                          ),
                        ),
                        /*
                        Text(
                          estadoSerie ? 'Completado' : 'En proceso',
                          style: TextStyle(
                            fontSize: 12.0,
                            color: estadoSerie ? Colors.grey : Colors.green,
                          ),
                        )
                          */
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatoNumeroSeries(int numeroSeries, int series, List<double> peso) {
    String pesoString = peso.join(', ');
    return 'Series $series, Peso $pesoString';
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
