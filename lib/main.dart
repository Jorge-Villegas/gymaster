import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gymaster/core/generated/assets.gen.dart';
import 'package:gymaster/features/routine/domain/entities/ejercicios_de_rutina.dart';
import 'package:gymaster/features/routine/presentation/widgets/custom_cart.dart';

class EjerciciosLlenosWidget extends StatefulWidget {
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
  _EjerciciosLlenosWidgetState createState() => _EjerciciosLlenosWidgetState();
}

class _EjerciciosLlenosWidgetState extends State<EjerciciosLlenosWidget> {
  late List<Ejercicio> _ejercicios;

  @override
  void initState() {
    super.initState();
    _ejercicios = List.from(widget.ejerciciosDeRutina.ejercicios);
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final Ejercicio item = _ejercicios.removeAt(oldIndex);
      _ejercicios.insert(newIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        InkWell(
          onTap: () {
            widget.goToIniciarRutina(context, widget.ejerciciosDeRutina);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            color:
                isDarkTheme
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
                    color:
                        Theme.of(context).brightness == Brightness.dark
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
              Text(_ejercicios.length.toString(), style: textTheme.labelMedium),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ReorderableListView.builder(
              onReorder: _onReorder,
              itemBuilder: (context, i) {
                final ejercicio = _ejercicios[i];

                final estadoEjercicio = ejercicio.series.every(
                  (serie) => serie.realizado,
                );
                final pesos =
                    ejercicio.series.map((serie) => serie.peso).toList();
                return CustomCard(
                  key: Key(ejercicio.id), // Necesario para ReorderableListView
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
              itemCount: _ejercicios.length,
            ),
          ),
        ),
      ],
    );
  }
}
