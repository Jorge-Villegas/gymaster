import 'package:flutter_svg/flutter_svg.dart';
import 'package:gymaster/core/generated/assets.gen.dart';
import 'package:gymaster/features/routine/domain/entities/ejercicios_de_rutina.dart';
import 'package:gymaster/features/routine/presentation/widgets/custom_cart.dart';
import 'package:flutter/material.dart';

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

    print('Ejercicios de rutina: ${ejerciciosDeRutina.ejercicios.length}');
    return Column(
      children: [
        InkWell(
          onTap: () {
            goToIniciarRutina(context, ejerciciosDeRutina);
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            color: const Color(0xFFE2EAE1), // Fondo color E2EAE1
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF57AD1C),
                  ),
                  child: SvgPicture.asset(
                    Assets.icons.iconsax.play.path,
                    width: 15,
                    height: 15,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Iniciar entrenamiento',
                  style: TextStyle(
                    color: Color(0xFF57AD1C),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Ejercicios',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              Text(ejerciciosDeRutina.ejercicios.length.toString()),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 10.0, // Espacio vertical entre las columnas
                mainAxisSpacing: 10.0, // Espacio horizontal entre las filas
                mainAxisExtent: 150, // Altura fija para cada tarjeta
              ),
              itemBuilder: (context, i) {
                

                print('Ejercicio $i ---> ${ejerciciosDeRutina.ejercicios[i].nombre}');
                final ejercicio = ejerciciosDeRutina.ejercicios[i];

                // Verificar si el ejercicio está completado a través de sus series y si está completado cambiar el estado de la serie
                final estadoEjercicio =
                    ejercicio.series.every((serie) => serie.realizado);
                final pesos = ejercicio.series.map((serie) => serie.peso).toList();
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
