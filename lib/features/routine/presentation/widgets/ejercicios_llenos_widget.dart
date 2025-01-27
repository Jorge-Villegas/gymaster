import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gymaster/core/generated/assets.gen.dart';
import 'package:gymaster/features/routine/domain/entities/ejercicios_de_rutina.dart';
import 'package:gymaster/features/routine/presentation/widgets/custom_cart.dart';

class EjerciciosLlenosWidget extends StatelessWidget {
  final EjerciciosDeRutina ejerciciosDeRutina;
  final String rutinaId;
  final Future<void> Function(BuildContext, EjerciciosDeRutina)
      goToIniciarRutina;

  const EjerciciosLlenosWidget({
    super.key,
    required this.ejerciciosDeRutina,
    required this.rutinaId,
    required this.goToIniciarRutina,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        InkWell(
          onTap: () {
            goToIniciarRutina(context, ejerciciosDeRutina);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            color: isDarkTheme
                ? const Color.fromRGBO(40, 44, 48, 1)
                : const Color.fromRGBO(216, 235, 224, 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(86, 170, 27, 1),
                  ),
                  child: SvgPicture.asset(
                    Assets.icons.iconsax.play.path,
                    width: 15,
                    height: 15,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Iniciar entrenamiento',
                  style: textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : const Color.fromRGBO(86, 170, 27, 1),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ejercicios',
                style: textTheme.bodyMedium?.copyWith(
                  color: isDarkTheme ? Colors.white : Colors.black,
                ),
              ),
              Text(
                ejerciciosDeRutina.ejercicios.length.toString(),
                style: textTheme.labelMedium,
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 5.0, // Espacio vertical entre las columnas
                mainAxisSpacing: 10.0, // Espacio horizontal entre las filas
                mainAxisExtent: 125, // Altura fija para cada tarjeta
              ),
              itemBuilder: (context, i) {
                final ejercicio = ejerciciosDeRutina.ejercicios[i];

                final estadoEjercicio =
                    ejercicio.series.every((serie) => serie.realizado);
                final pesos =
                    ejercicio.series.map((serie) => serie.peso).toList();
                return CustomCard(
                  colorFondo: Colors.white,
                  ejercicioId: ejercicio.id,
                  estadoSerie: estadoEjercicio,
                  nombreEjercicio: ejercicio.nombre,
                  numeroSeries: ejercicio.series.length,
                  imagenDireccion: ejercicio.imagenDireccion,
                  pesos: pesos,
                  onDismissed: () {
                    // TODO: Implementar lógica al eliminar una serie
                  },
                  onTap: () {
                    // TODO: Implementar lógica al seleccionar una serie
                  },
                );
              },
              itemCount: ejerciciosDeRutina.ejercicios.length,
            ),
          ),
        ),
      ],
    );
  }
}
