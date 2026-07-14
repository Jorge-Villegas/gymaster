import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';
import 'package:gymaster/core/theme/gym_typography.dart';
import 'package:gymaster/shared/utils/haptic_feedback_helper.dart';
import 'package:gymaster/shared/utils/audio_feedback_helper.dart';
import 'package:gymaster/features/routine/domain/entities/ejercicios_de_rutina.dart';
import 'package:gymaster/features/routine/presentation/cubits/ejercicios_by_rutina/ejercicios_by_rutina_cubit.dart';
import 'package:gymaster/features/routine/presentation/widgets/custom_cart.dart';
import 'package:gymaster/shared/utils/enum.dart';
import 'package:gymaster/shared/widgets/gym/gym.dart';
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

  /// Construye el botón de iniciar entrenamiento cuando está pendiente
  Widget _buildBotonIniciar(
    BuildContext context,
    EjerciciosByRutinaSuccess state,
    EjerciciosDeRutina ejerciciosDeRutina,
  ) {
    return SizedBox(
      width: double.infinity,
      child: GymButton(
        onPressed: () {
          iniciarRutina(
            context,
            state.ejerciciosDeRutina.session,
            state.ejerciciosDeRutina.rutinaId,
          );
          context.push('/detalle-ejercicio');
        },
        label: '¡Iniciar entrenamiento!',
        icon: IconsaxPlusLinear.play,
        size: GymButtonSize.large,
        variant: GymButtonVariant.primary,
        expand: true,
      ),
    );
  }

  Widget _buildBotonesEnProgreso(
    BuildContext context,
    EjerciciosByRutinaSuccess state,
  ) {
    return Row(
      children: [
        // Botón de Continuar Entrenamiento
        Expanded(
          flex: 5,
          child: GymButton(
            onPressed: () {
              HapticFeedbackHelper.vibracionSeleccion();
              context.push('/detalle-ejercicio');
            },
            label: 'Continuar',
            icon: IconsaxPlusLinear.play,
            size: GymButtonSize.large,
            variant: GymButtonVariant.primary,
            expand: true,
          ),
        ),
        const SizedBox(width: 12),
        // Botón de Pausar Entrenamiento
        Expanded(
          flex: 4,
          child: GymButton(
            onPressed: () {
              mostrarDialogoPararEntrenamiento(
                context,
                state.ejerciciosDeRutina.session,
              );
            },
            label: 'Pausar',
            icon: IconsaxPlusLinear.pause,
            size: GymButtonSize.large,
            variant: GymButtonVariant.secondary,
            expand: true,
          ),
        ),
      ],
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
          backgroundColor: context.gym.surface,
          elevation: 0,
          content: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Título emocional
                Text(
                  '¿Pausar entrenamiento?',
                  style: GymType.title.copyWith(height: 1.1),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                // Mensaje motivacional
                Text(
                  '¡No te rindas ahora! Tu progreso se guardará.',
                  style: GymType.body.copyWith(
                    color: context.gym.faint,
                    fontWeight: FontWeight.w300,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                // Botones de acción
                Row(
                  children: [
                    Expanded(
                      child: GymButton(
                        onPressed: () => context.pop(),
                        label: 'Continuar',
                        size: GymButtonSize.small,
                        variant: GymButtonVariant.ghost,
                        expand: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GymButton(
                        onPressed: () {
                          context.read<EjerciciosByRutinaCubit>().stopRoutine(
                                routineSessionId: sessionId,
                              );
                          context.pop();
                        },
                        label: 'Pausar',
                        size: GymButtonSize.small,
                        variant: GymButtonVariant.secondary,
                        expand: true,
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
    final bool enProgreso =
        ejerciciosDeRutina.estado == EstadoSesionRutina.en_progreso.name;

    return Column(
      children: [
        // Botones de acción (uno o dos según el estado)
        FadeInDown(
          duration: const Duration(milliseconds: 600),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: enProgreso
                ? _buildBotonesEnProgreso(context, state)
                : _buildBotonIniciar(context, state, ejerciciosDeRutina),
          ),
        ),
        // Header de contador de ejercicios
        FadeInUp(
          delay: const Duration(milliseconds: 200),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: context.gym.brand.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: context.gym.brand.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      IconsaxPlusLinear.weight,
                      color: context.gym.brand,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Ejercicios listos',
                      style: GymType.section.copyWith(
                        letterSpacing: 0.4,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: context.gym.brand,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    ejerciciosDeRutina.ejercicios.length.toString(),
                    style: GymType.section.copyWith(
                      color: Colors.white,
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
                        color: context.gym.xpInk,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            IconsaxPlusLinear.trash,
                            color: Colors.white,
                            size: 28,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Eliminar',
                            style: GymType.label.copyWith(
                              color: Colors.white,
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
                        colorFondo: context.gym.surface,
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
