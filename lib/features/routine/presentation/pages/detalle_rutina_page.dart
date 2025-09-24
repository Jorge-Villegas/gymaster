import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gymaster/core/theme/app_colors.dart';
import 'package:gymaster/core/theme/emotional_text_styles.dart';
import 'package:gymaster/features/routine/presentation/cubits/ejercicios_by_rutina/ejercicios_by_rutina_cubit.dart';
import 'package:gymaster/features/routine/presentation/widgets/ejercicios_llenos_widget.dart';
import 'package:gymaster/features/routine/presentation/widgets/ejercicios_vacios_widget.dart';
import 'package:gymaster/features/routine/presentation/widgets/rutina_completada_widget.dart';
import 'package:gymaster/shared/utils/text_formatter.dart';
import 'package:gymaster/features/routine/presentation/widgets/rutina_cancelada_widget.dart';
import 'package:gymaster/shared/widgets/chiclet_button.dart';
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

        return Scaffold(
          backgroundColor: AppColors.backgroundLight,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.backgroundLight,
                  Colors.white,
                  AppColors.backgroundLight.withOpacity(0.8),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.3, 1.0],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Header personalizado con diseño emocional
                  _buildEmotionalHeader(context, state),
                  // Cuerpo de la rutina
                  Expanded(
                    child: _buildBody(context, state),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmotionalHeader(
      BuildContext context, EjerciciosByRutinaState state) {
    return FadeInDown(
      duration: const Duration(milliseconds: 800),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Botón de volver minimalista
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.celebrationPurple.withValues(alpha: 0.1),
                    offset: const Offset(0, 2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () => context.go('/'),
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: AppColors.celebrationPurple,
                  size: 20,
                ),
                padding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(width: 16),
            // Título emocional simple
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state is EjerciciosByRutinaSuccess)
                    Text(
                      TextFormatter.capitalize(state.ejerciciosDeRutina.nombre),
                      style: EstilosTextoEmocional.energetico.copyWith(
                        color: AppColors.primary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  else
                    Text(
                      'Mi Rutina',
                      style: EstilosTextoEmocional.energetico.copyWith(
                        color: AppColors.primary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    '¡Hora de brillar! 💪',
                    style: EstilosTextoEmocional.amigable.copyWith(
                      color: AppColors.celebrationPurple,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            // Botón de agregar ejercicios minimalista
            if (state is EjerciciosByRutinaSuccess &&
                state is! EjerciciosByRutinaCompleted)
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.energyOrange,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.energyOrange.withValues(alpha: 0.3),
                      offset: const Offset(0, 4),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () {
                    final sessionId = state.ejerciciosDeRutina.session;
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
                  icon: const Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ),
          ],
        ),
      ),
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
                gradient: LinearGradient(
                  colors: [
                    AppColors.calmBlue.withOpacity(0.1),
                    AppColors.peacefulBlue.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.fitness_center,
                    color: AppColors.calmBlue,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Preparando tu rutina perfecta...',
                    style: EstilosTextoEmocional.amigable.copyWith(
                      color: AppColors.calmBlue,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            // Shimmer loading mejorado
            Expanded(
              child: Shimmer.fromColors(
                baseColor: AppColors.calmBlue.withOpacity(0.1),
                highlightColor: AppColors.peacefulBlue.withOpacity(0.3),
                period: const Duration(milliseconds: 1200),
                child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.calmBlue.withOpacity(0.2),
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
                gradient: LinearGradient(
                  colors: [
                    AppColors.motivationRed.withOpacity(0.1),
                    AppColors.fireRed.withOpacity(0.05),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    color: AppColors.motivationRed,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Ops, algo salió mal',
                    style: EstilosTextoEmocional.motivacional.copyWith(
                      fontSize: 20,
                      color: AppColors.motivationRed,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: EstilosTextoEmocional.amigable.copyWith(
                      color: AppColors.textDark,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ChicletButton(
              texto: 'Reintentar',
              icono: Icons.refresh_rounded,
              tamano: TamanoBotonChiclet.grande,
              estilo: EstiloBotonChiclet.relleno,
              colorFondo: AppColors.primary,
              radioBorde: 16,
              conSombreado: true,
              grosorSombreado: 4.0,
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
            Icons.fitness_center_outlined,
            size: 64,
            color: AppColors.calmBlue.withOpacity(0.6),
          ),
          const SizedBox(height: 16),
          Text(
            'Cargando tu rutina...',
            style: EstilosTextoEmocional.amigable.copyWith(
              color: AppColors.calmBlue,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
