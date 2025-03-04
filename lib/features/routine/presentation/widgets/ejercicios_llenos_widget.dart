import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gymaster/features/routine/domain/entities/ejercicios_de_rutina.dart';
import 'package:gymaster/features/routine/presentation/cubits/ejercicios_by_rutina/ejercicios_by_rutina_cubit.dart';
import 'package:gymaster/features/routine/presentation/widgets/custom_cart.dart';
import 'package:gymaster/shared/utils/enum.dart';
import 'package:gymaster/shared/widgets/show_custom_snack_bar.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class EjerciciosLlenosWidget extends StatelessWidget {
  final EjerciciosDeRutina ejerciciosDeRutina;
  final String rutinaId;
  final String sessionId;

  const EjerciciosLlenosWidget({
    super.key,
    required this.ejerciciosDeRutina,
    required this.rutinaId,
    required this.sessionId,
  });

  iniciarRutina(BuildContext context, String sessionId, String rutinaId) {
    context.read<EjerciciosByRutinaCubit>().iniciarRutina(
      routineSessionId: sessionId,
      rutinaId: rutinaId,
    );
  }

  mostrarDialogoPararEntrenamiento(BuildContext context, String sessionId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Row(
              children: [
                Icon(Icons.warning, color: Colors.red),
                SizedBox(width: 10),
                Text(
                  'Parar entrenamiento',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: const Text(
              '¿Estás seguro de que deseas parar el entrenamiento?',
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  context.pop();
                },
                style: TextButton.styleFrom(foregroundColor: Colors.grey),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<EjerciciosByRutinaCubit>().stopRoutine(
                    routineSessionId: sessionId,
                  );
                  context.pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Aceptar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EjerciciosByRutinaCubit, EjerciciosByRutinaState>(
      builder: (context, state) {
        if (state is EjerciciosByRutinaLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is EjerciciosByRutinaError) {
          return Center(child: Text(state.message));
        } else if (state is EjerciciosByRutinaSuccess) {
          return _buildContent(context, state.ejerciciosDeRutina);
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    EjerciciosDeRutina ejerciciosDeRutina,
  ) {
    print('routine_session = $sessionId');
    final textTheme = Theme.of(context).textTheme;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    String getButtonText = 'Estado desconocido';
    IconData getIconPath = Icons.error;
    Color getButtonColor = Colors.grey;
    Color getBackgroundColor = Colors.grey.withAlpha(25);

    if (ejerciciosDeRutina.estado == RoutineSessionStatus.pending.name ||
        ejerciciosDeRutina.estado == RoutineSessionStatus.completed.name ||
        ejerciciosDeRutina.estado == RoutineSessionStatus.cancelled.name) {
      getButtonText = 'Iniciar entrenamiento';
      getIconPath = IconsaxPlusLinear.play;
      getButtonColor = const Color.fromRGBO(86, 170, 27, 1);
      getBackgroundColor = const Color.fromRGBO(86, 170, 27, 0.1);
    }
    if (ejerciciosDeRutina.estado == RoutineSessionStatus.in_progress.name) {
      getButtonText = 'Parar entrenamiento';
      getIconPath = IconsaxPlusLinear.stop;
      getButtonColor = Colors.red;
      getBackgroundColor = Colors.red.withAlpha(25);
    }

    return Column(
      children: [
        InkWell(
          onTap: () {
            if (ejerciciosDeRutina.estado ==
                RoutineSessionStatus.pending.name) {
              iniciarRutina(context, sessionId, rutinaId);
              context.push('/detalle-ejercicio');
            }

            if (ejerciciosDeRutina.estado ==
                RoutineSessionStatus.completed.name) {
              iniciarRutina(context, sessionId, rutinaId);
              context.push('/detalle-ejercicio');
            }

            if (ejerciciosDeRutina.estado ==
                RoutineSessionStatus.in_progress.name) {
              mostrarDialogoPararEntrenamiento(context, sessionId);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            color: getBackgroundColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: getButtonColor,
                  ),
                  child: Icon(getIconPath, color: Colors.white, size: 15),
                ),
                const SizedBox(width: 10),
                Text(
                  getButtonText,
                  style: textTheme.labelMedium?.copyWith(
                    color: isDarkTheme ? Colors.white : getButtonColor,
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
            child: ReorderableListView.builder(
              onReorder: (oldIndex, newIndex) {
                context.read<EjerciciosByRutinaCubit>().updateEjercicioOrder(
                  ejerciciosDeRutina.ejercicios,
                  sessionId,
                );
              },
              itemCount: ejerciciosDeRutina.ejercicios.length,
              buildDefaultDragHandles: false,
              itemBuilder: (context, i) {
                final ejercicio = ejerciciosDeRutina.ejercicios[i];
                final estadoEjercicio = ejercicio.series.every(
                  (serie) => serie.realizado,
                );
                final pesos =
                    ejercicio.series.map((serie) => serie.peso).toList();
                return Dismissible(
                  key: ValueKey(ejercicio.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    context.read<EjerciciosByRutinaCubit>().deleteEjercicio(
                      ejercicio.id,
                      sessionId,
                    );
                    // Eliminar el ejercicio de la lista y actualizar el estado
                    ejerciciosDeRutina.ejercicios.removeAt(i);
                    // Notificar al framework que el estado ha cambiado
                    (context as Element).markNeedsBuild();
                  },
                  confirmDismiss: (direction) async {
                    final result = await context
                        .read<EjerciciosByRutinaCubit>()
                        .checkCanDeleteEjercicio(ejercicio.id, sessionId);
                    return result;
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: CustomCard(
                    index: i,
                    colorFondo: Colors.white,
                    ejercicioId: ejercicio.id,
                    estadoSerie: estadoEjercicio,
                    nombreEjercicio: ejercicio.nombre,
                    numeroSeries: ejercicio.series.length,
                    imagenDireccion: ejercicio.imagenDireccion,
                    pesos: pesos,
                    onDismissed: () {
                      context.read<EjerciciosByRutinaCubit>().deleteEjercicio(
                        ejercicio.id,
                        sessionId,
                      );
                    },
                    onTap: () {
                      // TODO: Implementar lógica al seleccionar una serie
                    },
                    height: 125,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
