import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gymaster/core/generated/assets.gen.dart';
import 'package:gymaster/features/routine/domain/entities/ejercicios_de_rutina.dart';
import 'package:gymaster/features/routine/presentation/cubits/ejercicios_by_rutina/ejercicios_by_rutina_cubit.dart';
import 'package:gymaster/features/routine/presentation/widgets/custom_cart.dart';

class EjerciciosLlenosWidget extends StatefulWidget {
  final EjerciciosDeRutina ejerciciosDeRutina;
  final String rutinaId;
  final String sessionId;
  final Future<void> Function(BuildContext, EjerciciosDeRutina)
  goToIniciarRutina;

  const EjerciciosLlenosWidget({
    super.key,
    required this.ejerciciosDeRutina,
    required this.rutinaId,
    required this.goToIniciarRutina,
    required this.sessionId,
  });

  @override
  _EjerciciosLlenosWidgetState createState() => _EjerciciosLlenosWidgetState();
}

class _EjerciciosLlenosWidgetState extends State<EjerciciosLlenosWidget> {
  late List<Ejercicio> _ejercicios;

  void _onDismissed(int index) {
    final ejercicio = _ejercicios[index];
    setState(() {
      _ejercicios.removeAt(index);
    });
    BlocProvider.of<EjerciciosByRutinaCubit>(
      context,
    ).deleteEjercicio(ejercicio.id, widget.sessionId);
  }

  @override
  void initState() {
    super.initState();
    _ejercicios = widget.ejerciciosDeRutina.ejercicios;
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = _ejercicios.removeAt(oldIndex);
      _ejercicios.insert(newIndex, item);

      // Get the current session ID
      BlocProvider.of<EjerciciosByRutinaCubit>(
        context,
      ).updateEjercicioOrder(_ejercicios, widget.sessionId);
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
                        isDarkTheme
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
              itemCount: _ejercicios.length,
              buildDefaultDragHandles: false,
              itemBuilder: (context, i) {
                final ejercicio = _ejercicios[i];

                final estadoEjercicio = ejercicio.series.every(
                  (serie) => serie.realizado,
                );
                final pesos =
                    ejercicio.series.map((serie) => serie.peso).toList();
                return CustomCard(
                  index: i,
                  key: ValueKey(ejercicio.id),
                  colorFondo: Colors.white,
                  ejercicioId: ejercicio.id,
                  estadoSerie: estadoEjercicio,
                  nombreEjercicio: ejercicio.nombre,
                  numeroSeries: ejercicio.series.length,
                  imagenDireccion: ejercicio.imagenDireccion,
                  pesos: pesos,
                  onDismissed: () {
                    _onDismissed(i);
                  },
                  confirmDismiss: () async {
                    // Call the delete operation and return its result
                    final cubit = BlocProvider.of<EjerciciosByRutinaCubit>(
                      context,
                    );
                    final result = await cubit.checkCanDeleteEjercicio(
                      ejercicio.id,
                      widget.sessionId,
                    );
                    return result;
                  },
                  onTap: () {
                    // TODO: Implementar lógica al seleccionar una serie
                  },
                  height: 125,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
