import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gymaster/core/generated/assets.gen.dart';
import 'package:gymaster/features/routine/presentation/cubits/ejercicios_by_rutina/ejercicios_by_rutina_cubit.dart';
import 'package:gymaster/shared/utils/text_formatter.dart';
import 'package:gymaster/shared/utils/verificador_tipo_archivo.dart';
import 'package:gymaster/shared/widgets/custom_icon_button.dart';
import 'package:gymaster/shared/widgets/reusable_table.dart';

class DetalleEjercicioScreen extends StatelessWidget {
  const DetalleEjercicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EjerciciosByRutinaCubit, EjerciciosByRutinaState>(
      builder: (context, state) {
        if (state is EjerciciosByRutinaLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is EjerciciosByRutinaError) {
          return Center(child: Text(state.message));
        }
        if (state is EjerciciosByRutinaCompleted) {
          Future.microtask(() => context.go('/'));
          return const Center(child: CircularProgressIndicator());
        }
        if (state is EjerciciosByRutinaSuccess) {
          // Verificar si hay ejercicios antes de intentar acceder a ellos
          if (state.ejerciciosDeRutina.ejercicios.isEmpty) {
            // Redirigir al usuario a la página principal
            Future.microtask(() => context.go('/'));
            return const Center(child: Text('No hay ejercicios disponibles'));
          }

          final ejercicio =
              state.ejerciciosDeRutina.ejercicios[state.ejercicioIndex];
          final serie = ejercicio.series[state.serieIndex];
          final serieActualIndex = state.serieIndex + 1;

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title:
                  BlocBuilder<EjerciciosByRutinaCubit, EjerciciosByRutinaState>(
                    builder: (context, state) {
                      if (state is EjerciciosByRutinaSuccess) {
                        return Text(
                          TextFormatter.capitalize(
                            state.ejerciciosDeRutina.nombre,
                          ),
                        );
                      }
                      return const Text('RUTINA');
                    },
                  ),
              centerTitle: true,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.black),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    _construirDetallesEjercicio(
                      context,
                      state: state,
                      imagenDireccion: ejercicio.imagenDireccion,
                    ),
                    const SizedBox(height: 20),
                    _construirEstadisticasEjercicio(
                      nombreEjercicio: ejercicio.nombre,
                      context: context,
                      repeticiones: serie.repeticiones,
                      peso: serie.peso,
                      totalSeries: ejercicio.cantidadSeries,
                      serieActual: serieActualIndex,
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton(
                onPressed: () {
                  context.read<EjerciciosByRutinaCubit>().avanzarSerie();
                },
                backgroundColor: Colors.green,
                child: const Icon(Icons.check, color: Colors.white),
              ),
            ),
          );
        }
        return const Center(
          //volver al home con gorouter
          child: Text('Ha ocurrido un error inesperado'),
        );
      },
    );
  }

  Widget _construirDetallesEjercicio(
    BuildContext context, {
    required EjerciciosByRutinaSuccess state,
    required String imagenDireccion,
  }) {
    final state = context.watch<EjerciciosByRutinaCubit>().state;

    if (state is! EjerciciosByRutinaSuccess) {
      return Container();
    }

    final ejercicios = state.ejerciciosDeRutina.ejercicios;
    final ejercicioIndex = state.ejercicioIndex;
    final ejercicio = state.ejerciciosDeRutina.ejercicios[state.ejercicioIndex];
    final textTheme = Theme.of(context).textTheme;

    // Preparar los datos para la tabla genérica
    final tableData =
        ejercicio.series.map((serie) {
          return [
            '${ejercicio.series.indexOf(serie) + 1}', // Serie
            '${serie.peso} kg', // Peso
            '${serie.repeticiones} x', // Repeticiones
          ];
        }).toList();

    return Container(
      color: const Color.fromARGB(255, 240, 240, 240),
      height: 300, // Altura fija para el contenedor
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextButton.icon(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    Assets.icons.iconsax.timer.path,
                    colorFilter: const ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                    height: 15,
                    width: 15,
                  ),
                  label: Text(
                    '120 seg',
                    style: textTheme.bodySmall!.copyWith(color: Colors.black),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    Assets.icons.iconsax.timer1.path,
                    colorFilter: const ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                    height: 15,
                    width: 15,
                  ),
                  label: Text(
                    '20 min',
                    style: textTheme.bodySmall!.copyWith(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 8, // Ocupa la mayor parte del espacio disponible
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Contenedor para la imagen
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 30,
                  ),
                  child: _construirWidgetImagen(imagenDireccion),
                ),
                // Contenedor para la tabla
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: CustomDataTable(
                      headers: const ['Serie', 'Peso', 'Reps'],
                      data: tableData,
                      showActions: false,
                      backgroundColor: Colors.transparent,
                      headerColor: Colors.transparent,
                      bodyTextColor: Colors.black,
                      headerTextColor: Colors.black,
                      cellTextAlign: TextAlign.center,
                      rowHeight: 20.0,
                      rowColors:
                          ejercicio.series
                              .map(
                                (serie) =>
                                    serie.realizado
                                        ? Colors.black
                                        : Colors.grey,
                              )
                              .toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(ejercicios.length, (index) {
                final ejercicio = ejercicios[index];
                final isRealizado = ejercicio.series.every(
                  (serie) => serie.realizado,
                );
                final isCurrent = index == ejercicioIndex;
                final color =
                    isRealizado
                        ? Colors.green
                        : (isCurrent ? Colors.indigo : Colors.white);
                final radius = isCurrent ? 4.0 : 3.5;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.5),
                  child: CircleAvatar(radius: radius, backgroundColor: color),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // Método privado para construir el widget de imagen
  Widget _construirWidgetImagen(String direccionImagen) {
    if (VerificadorTipoArchivo.esSvg(direccionImagen)) {
      return SvgPicture.asset(
        direccionImagen,
        width: 150,
        height: 150,
        semanticsLabel: 'Ejercicio de pectoral',
      );
    }
    if (VerificadorTipoArchivo.esImagen(direccionImagen)) {
      return Image.asset(
        direccionImagen,
        width: 150,
        height: 150,
        semanticLabel: 'Ejercicio de pectoral',
      );
    }
    return const Icon(
      Icons.error,
      size: 100,
      color: Colors.red,
      semanticLabel: 'Error al cargar la imagen',
    );
  }

  Widget _construirEstadisticasEjercicio({
    required String nombreEjercicio,
    required BuildContext context,
    required int repeticiones,
    required double peso,
    required int totalSeries,
    required int serieActual,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Serie : ', style: textTheme.bodyMedium!.copyWith()),
              Text(
                serieActual.toString(),
                style: textTheme.titleLarge!.copyWith(),
              ),
              const Text(' / ', style: TextStyle(color: Colors.grey)),
              Text(
                totalSeries.toString(),
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          Text(
            TextFormatter.capitalize(nombreEjercicio),
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium!.copyWith(),
          ),
          const SizedBox(height: 20),
          _construirFilaPeso(context: context, peso: peso),
          const SizedBox(height: 20),
          _construirFilaRepeticiones(
            context: context,
            repeticiones: repeticiones,
          ),
        ],
      ),
    );
  }

  Widget _construirFilaPeso({
    required BuildContext context,
    required double peso,
  }) {
    return Row(
      children: <Widget>[
        const Expanded(
          child: Text('Peso : ', style: TextStyle(color: Colors.grey)),
        ),
        Expanded(
          flex: 2,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Text(
              '$peso',
              key: ValueKey<double>(peso),
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ),
        Expanded(
          child: CustomIconButton(
            icon: SvgPicture.asset(Assets.icons.iconsax.minus.path),
            // icon: FontAwesomeIcons.minus,
            borderColor: Colors.grey,
            backgroundColor: Colors.white,
            onPressed: () {
              context.read<EjerciciosByRutinaCubit>().disminuirPeso();
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: CustomIconButton(
            icon: SvgPicture.asset(Assets.icons.iconsax.add.path),
            borderColor: Colors.grey,
            backgroundColor: Colors.white,
            onPressed: () {
              context.read<EjerciciosByRutinaCubit>().aumentarPeso();
            },
          ),
        ),
      ],
    );
  }

  Widget _construirFilaRepeticiones({
    required BuildContext context,
    required int repeticiones,
  }) {
    return Row(
      children: <Widget>[
        const Expanded(
          child: Text('Reps : ', style: TextStyle(color: Colors.grey)),
        ),
        Expanded(
          flex: 2,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Text(
              '$repeticiones',
              key: ValueKey<int>(repeticiones),
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ),
        Expanded(
          child: CustomIconButton(
            icon: SvgPicture.asset(Assets.icons.iconsax.minus.path),
            borderColor: Colors.grey,
            backgroundColor: Colors.white,
            onPressed: () {
              context.read<EjerciciosByRutinaCubit>().disminuirRepeticiones();
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: CustomIconButton(
            icon: SvgPicture.asset(Assets.icons.iconsax.add.path),
            borderColor: Colors.grey,
            backgroundColor: Colors.white,
            onPressed: () {
              context.read<EjerciciosByRutinaCubit>().aumentarRepeticiones();
            },
          ),
        ),
      ],
    );
  }
}
