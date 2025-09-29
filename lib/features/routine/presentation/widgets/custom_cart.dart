import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gymaster/core/theme/app_colors.dart';
import 'package:gymaster/core/theme/tipografia_gymaster.dart';
import 'package:gymaster/features/exercise/presentation/cubits/favorito_ejercicio_cubit.dart';
import 'package:gymaster/features/exercise/presentation/cubits/favorito_ejercicio_state.dart';
import 'package:gymaster/shared/utils/enum.dart';
import 'package:gymaster/shared/utils/text_formatter.dart';
import 'package:gymaster/shared/utils/verificador_tipo_archivo.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class CustomCard extends StatelessWidget {
  final String ejercicioId;
  final String nombreEjercicio;
  final String imagenDireccion;
  final String estadoEjercicio;
  final int numeroSeries;
  final Color colorFondo;
  final List<double> pesos;
  final VoidCallback onDismissed;
  final VoidCallback onTap;
  final double? height; // Parámetro opcional para la altura
  final int index; // Añade el índice como parámetro
  // In CustomCard class, add this property:
  // final Future<bool> Function()? confirmDismiss;

  const CustomCard({
    super.key,
    required this.ejercicioId,
    required this.nombreEjercicio,
    required this.imagenDireccion,
    required this.estadoEjercicio,
    required this.numeroSeries,
    required this.onDismissed,
    required this.pesos,
    required this.onTap,
    required this.colorFondo,
    this.height, // Inicializa el parámetro opcional
    required this.index, // Inicializa el índice
    // required this.confirmDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Dismissible(
        key: ValueKey(ejercicioId), // Asegúrate de que esta clave sea única
        direction: DismissDirection.endToStart,
        // confirmDismiss:
        //     confirmDismiss != null ? (direction) => confirmDismiss!() : null,
        onDismissed: (direction) => onDismissed(),
        background: Container(
          height: 20,
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        child: SizedBox(
          height: height,
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
                        if (estadoEjercicio ==
                            EstadoSesionRutina.completado.name)
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
                        if (estadoEjercicio ==
                            EstadoSesionRutina.en_progreso.name)
                          Positioned.fill(
                            child: Container(
                              color: Colors.orange.withAlpha(
                                (0.5 * 255).toInt(),
                              ), // Reemplaza withOpacity con withAlpha
                              child: const Center(
                                child: Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 50.0,
                                ),
                              ),
                            ),
                          ),
                        // Indicador sutil de favorito
                        _buildFavoriteIndicator(),
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
                          style: TextStyle(
                            fontSize: TipografiaGyMaster.tamanoSm,
                            fontWeight: TipografiaGyMaster.pesoRegular,
                            color: AppColors.textoPrincipalOscuro,
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

  /// Indicador sutil de favorito superpuesto en la esquina inferior derecha
  Widget _buildFavoriteIndicator() {
    return BlocBuilder<FavoritoEjercicioCubit, FavoritoEjercicioState>(
      builder: (context, state) {
        final favoritosCubit = context.read<FavoritoEjercicioCubit>();
        final esFavorito = favoritosCubit.esEjercicioFavoritoSync(ejercicioId);

        // Solo mostrar si es favorito
        if (!esFavorito) return const SizedBox.shrink();

        return Positioned(
          bottom: 4,
          right: 4,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.red.shade600,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.3 * 255).toInt()),
                  offset: const Offset(0, 1),
                  blurRadius: 3,
                ),
              ],
            ),
            child: Icon(
              IconsaxPlusBold.heart,
              color: Colors.white,
              size: 12,
            ),
          ),
        );
      },
    );
  }
}
