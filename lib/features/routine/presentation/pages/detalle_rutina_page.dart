import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';
import 'package:gymaster/core/theme/gym_typography.dart';

import 'package:gymaster/features/routine/presentation/cubits/ejercicios_by_rutina/ejercicios_by_rutina_cubit.dart';
import 'package:gymaster/features/routine/presentation/widgets/ejercicios_llenos_widget.dart';
import 'package:gymaster/features/routine/presentation/widgets/ejercicios_vacios_widget.dart';
import 'package:gymaster/features/routine/presentation/widgets/rutina_completada_widget.dart';
import 'package:gymaster/features/routine/presentation/widgets/rutina_cancelada_widget.dart';
import 'package:gymaster/shared/widgets/gym/gym.dart';
import 'package:animate_do/animate_do.dart';
import 'package:shimmer/shimmer.dart';

class DetalleRutinaScreen extends StatelessWidget {
  // Identificador de la rutina.
  final String rutinaId;

  // Constructor de la clase, requiere el identificador de la rutina.
  const DetalleRutinaScreen({super.key, required this.rutinaId});

  // Método que construye la interfaz de usuario de la pantalla.
  @override
  Widget build(BuildContext context) {
    // Siempre recarga los ejercicios al entrar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<EjerciciosByRutinaCubit>(context, listen: false)
          .getAllEjercicios(idRutina: rutinaId);
    });

    return BlocBuilder<EjerciciosByRutinaCubit, EjerciciosByRutinaState>(
      builder: (context, state) {
        if (state is EjerciciosByRutinaCancelled) {
          return RutinaCanceladaWidget(
            rutinaName: state.rutinaName,
            rutinaId: state.rutinaId,
            sessionId: state.sessionId,
            totalEjercicios: state.totalEjercicios,
            fechaCancelada: state.fechaCancelada,
          );
        }

        final puedeAgregar = state is EjerciciosByRutinaSuccess &&
            state is! EjerciciosByRutinaCompleted;
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          // Acción principal (agregar ejercicios) como FAB en la zona del pulgar.
          floatingActionButton: puedeAgregar
              ? FloatingActionButton(
                  // Hero desactivado: esta pantalla puede coexistir consigo
                  // misma en la pila y un tag compartido colisionaría.
                  heroTag: null,
                  backgroundColor: context.gym.brand,
                  foregroundColor: Colors.white,
                  tooltip: 'Agregar ejercicios',
                  onPressed: () {
                    final sessionId = (state).ejerciciosDeRutina.session;
                    context
                        .push('/agregar-ejercicios/$rutinaId/$sessionId')
                        .then((_) {
                      if (context.mounted) {
                        BlocProvider.of<EjerciciosByRutinaCubit>(
                          context,
                          listen: false,
                        ).getAllEjercicios(idRutina: rutinaId);
                      }
                    });
                  },
                  child: const Icon(IconsaxPlusLinear.add),
                )
              : null,
          body: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: SafeArea(
              child: Column(
                children: [
                  // Encabezado simple: volver + nombre de la rutina.
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 6, 12, 6),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(IconsaxPlusLinear.arrow_left_1),
                          color: context.gym.ink,
                          tooltip: 'Volver',
                          onPressed: () => context.go('/main?tab=1'),
                        ),
                        Expanded(
                          child: Text(
                            state is EjerciciosByRutinaSuccess
                                ? state.ejerciciosDeRutina.nombre
                                : 'Mi Rutina',
                            textAlign: TextAlign.center,
                            style: GymType.title.copyWith(color: context.gym.ink),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                  Expanded(child: _buildBody(context, state)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, EjerciciosByRutinaState state) {
    if (state is EjerciciosByRutinaSuccess) {
      if (state.ejerciciosDeRutina.ejercicios.isEmpty) {
        return FadeInUp(
          child: EjerciciosVaciosWidget(
            rutinaId: rutinaId,
            sessionId: state.ejerciciosDeRutina.session,
          ),
        );
      } else {
        return FadeInUp(
          child: const EjerciciosLlenosWidget(),
        );
      }
    }

    if (state is EjerciciosByRutinaLoading) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Mensaje motivacional de carga
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: context.gym.info.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    IconsaxPlusLinear.weight,
                    color: context.gym.info,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Preparando tu rutina perfecta...',
                    style: GymType.section.copyWith(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            // Shimmer loading mejorado
            Expanded(
              child: Shimmer.fromColors(
                baseColor: context.gym.info.withValues(alpha: 0.1),
                highlightColor: context.gym.brand.withValues(alpha: 0.3),
                period: const Duration(milliseconds: 1200),
                child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: context.gym.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color:
                              context.gym.info.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      height: 100,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (state is EjerciciosByRutinaError) {
      return Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: context.gym.xpInk.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(
                    IconsaxPlusLinear.close_circle,
                    color: context.gym.xpInk,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Ops, algo salió mal',
                    style: GymType.title,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: GymType.body.copyWith(
                      fontWeight: FontWeight.w300,
                      color: context.gym.ink,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            GymButton(
              label: 'Reintentar',
              icon: IconsaxPlusLinear.refresh,
              size: GymButtonSize.large,
              variant: GymButtonVariant.primary,
              expand: false,
              onPressed: () {
                BlocProvider.of<EjerciciosByRutinaCubit>(context)
                    .getAllEjercicios(idRutina: rutinaId);
              },
            ),
          ],
        ),
      );
    }

    if (state is EjerciciosByRutinaCompleted) {
      return FadeInUp(
        child: RutinaCompletadaWidget(state: state),
      );
    }

    // Estado por defecto
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            IconsaxPlusLinear.weight,
            size: 64,
            color: context.gym.info.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 16),
          Text(
            'Cargando tu rutina...',
            style: GymType.section.copyWith(
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}
