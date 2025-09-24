import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gymaster/core/theme/app_colors.dart';
import 'package:gymaster/core/theme/emotional_text_styles.dart';
import 'package:gymaster/shared/utils/haptic_feedback_helper.dart';
import 'package:gymaster/shared/utils/audio_feedback_helper.dart';
import 'package:gymaster/features/routine/domain/entities/ejercicios_de_rutina.dart';
import 'package:gymaster/features/routine/presentation/cubits/ejercicios_by_rutina/ejercicios_by_rutina_cubit.dart';
import 'package:gymaster/features/routine/presentation/widgets/custom_cart.dart';
import 'package:gymaster/shared/utils/enum.dart';
import 'package:gymaster/shared/widgets/chiclet_button.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class EjerciciosLlenosWidget extends StatelessWidget {
  const EjerciciosLlenosWidget({super.key});

  Future<void> iniciarRutina(
      BuildContext context, String sessionId, String rutinaId) async {
    await HapticFeedbackHelper.vibracionMotivacionalInicioRutina();
    await AudioFeedbackHelper.reproducirSonidoMotivacional();

    context.read<EjerciciosByRutinaCubit>().iniciarRutina(
          routineSessionId: sessionId,
          rutinaId: rutinaId,
        );
  }

  void mostrarDialogoPararEntrenamiento(
      BuildContext context, String sessionId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => FadeIn(
        duration: const Duration(milliseconds: 300),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          content: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Título emocional
                Text(
                  '¿Pausar entrenamiento?',
                  style: EstilosTextoEmocional.energetico.copyWith(
                    color: AppColors.primary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                // Mensaje motivacional
                Text(
                  '¡No te rindas ahora! Tu progreso se guardará.',
                  style: EstilosTextoEmocional.amigable.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                // Botones con ChicletButton
                Row(
                  children: [
                    Expanded(
                      child: ChicletButton(
                        onPressed: () => context.pop(),
                        texto: 'Continuar',
                        icono: Icons.fitness_center_rounded,
                        tamano: TamanoBotonChiclet.mediano,
                        estilo: EstiloBotonChiclet.contorno,
                        colorBorde: AppColors.successGreen,
                        colorTexto: AppColors.successGreen,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ChicletButton(
                        onPressed: () {
                          context.read<EjerciciosByRutinaCubit>().stopRoutine(
                                routineSessionId: sessionId,
                              );
                          context.pop();
                        },
                        texto: 'Pausar',
                        icono: Icons.pause_rounded,
                        tamano: TamanoBotonChiclet.mediano,
                        estilo: EstiloBotonChiclet.relleno,
                        colorFondo: AppColors.motivationRed,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
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
          return _buildContent(context, state.ejerciciosDeRutina, state);
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    EjerciciosDeRutina ejerciciosDeRutina,
    EjerciciosByRutinaSuccess state,
  ) {
    String getButtonText = 'Estado desconocido';
    IconData getIconPath = Icons.error;
    Color getButtonColor = Colors.grey;

    if (ejerciciosDeRutina.estado == EstadoSesionRutina.pendiente.name ||
        ejerciciosDeRutina.estado == EstadoSesionRutina.completado.name ||
        ejerciciosDeRutina.estado == EstadoSesionRutina.cancelado.name) {
      getButtonText = '¡Iniciar entrenamiento!';
      getIconPath = IconsaxPlusLinear.play;
      getButtonColor = AppColors.successGreen;
    }
    if (ejerciciosDeRutina.estado == EstadoSesionRutina.en_progreso.name) {
      getButtonText = 'Pausar entrenamiento';
      getIconPath = IconsaxPlusLinear.stop;
      getButtonColor = AppColors.motivationRed;
    }

    return Column(
      children: [
        // Botón principal de acción con ChicletButton
        FadeInDown(
          duration: const Duration(milliseconds: 600),
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            child: ChicletButton(
              onPressed: () {
                if (ejerciciosDeRutina.estado ==
                    EstadoSesionRutina.pendiente.name) {
                  iniciarRutina(
                    context,
                    state.ejerciciosDeRutina.session,
                    state.ejerciciosDeRutina.rutinaId,
                  );
                  context.push('/detalle-ejercicio');
                }

                if (ejerciciosDeRutina.estado ==
                    EstadoSesionRutina.en_progreso.name) {
                  mostrarDialogoPararEntrenamiento(
                    context,
                    state.ejerciciosDeRutina.session,
                  );
                }
              },
              texto: getButtonText,
              icono: getIconPath,
              tamano: TamanoBotonChiclet.grande,
              estilo: EstiloBotonChiclet.relleno,
              colorFondo: getButtonColor,
              conSombreado: true,
              grosorSombreado: 6.0,
            ),
          ),
        ),
        // Header de contador de ejercicios
        FadeInUp(
          delay: const Duration(milliseconds: 200),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.successGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.successGreen.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.fitness_center_rounded,
                      color: AppColors.successGreen,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Ejercicios listos',
                      style: EstilosTextoEmocional.amigable.copyWith(
                        color: AppColors.successGreen,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.successGreen,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    ejerciciosDeRutina.ejercicios.length.toString(),
                    style: EstilosTextoEmocional.energetico.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Lista de ejercicios con animaciones
        Expanded(
          child: FadeInUp(
            delay: const Duration(milliseconds: 400),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ReorderableListView.builder(
                onReorder: (oldIndex, newIndex) {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final ejercicio = ejerciciosDeRutina.ejercicios.removeAt(
                    oldIndex,
                  );
                  ejerciciosDeRutina.ejercicios.insert(newIndex, ejercicio);

                  // Actualizar el orden en el Cubit
                  context.read<EjerciciosByRutinaCubit>().updateEjercicioOrder(
                        ejerciciosDeRutina.ejercicios,
                        state.ejerciciosDeRutina.session,
                      );
                },
                itemCount: ejerciciosDeRutina.ejercicios.length,
                buildDefaultDragHandles: false,
                itemBuilder: (context, i) {
                  final ejercicio = ejerciciosDeRutina.ejercicios[i];
                  final pesos =
                      ejercicio.series.map((serie) => serie.peso).toList();
                  return Dismissible(
                    key: ValueKey(ejercicio.id),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (direction) async {
                      // Intentar eliminar del backend
                      final result = await context
                          .read<EjerciciosByRutinaCubit>()
                          .checkCanDeleteEjercicio(
                            ejercicio.id,
                            state.ejerciciosDeRutina.session,
                          );

                      if (result) {
                        // Si se eliminó exitosamente, actualizar la UI a través del Cubit
                        context
                            .read<EjerciciosByRutinaCubit>()
                            .getAllEjercicios(
                              idRutina: state.ejerciciosDeRutina.rutinaId,
                            );
                      }

                      return result; // Solo permite el dismiss si se eliminó exitosamente
                    },
                    onDismissed: (direction) {
                      // Ya no es necesario hacer nada aquí, la eliminación se hizo en confirmDismiss
                      // Solo mostrar feedback al usuario si es necesario
                    },
                    background: Container(
                      decoration: BoxDecoration(
                        color: AppColors.motivationRed,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.delete_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Eliminar',
                            style: EstilosTextoEmocional.amigable.copyWith(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: CustomCard(
                        index: i,
                        colorFondo: Colors.white,
                        ejercicioId: ejercicio.id,
                        estadoEjercicio: ejercicio.estado,
                        nombreEjercicio: ejercicio.nombre,
                        numeroSeries: ejercicio.series.length,
                        imagenDireccion: ejercicio.imagenDireccion,
                        pesos: pesos,
                        onDismissed: () {
                          context
                              .read<EjerciciosByRutinaCubit>()
                              .deleteEjercicio(
                                ejercicio.id,
                                state.ejerciciosDeRutina.session,
                                context,
                              );
                        },
                        onTap: () {
                          if (ejerciciosDeRutina.estado ==
                              EstadoSesionRutina.en_progreso.name) {
                            context.push('/detalle-ejercicio');
                          }
                        },
                        height: 125,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
