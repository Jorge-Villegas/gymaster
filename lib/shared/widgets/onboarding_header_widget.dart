import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymaster/core/theme/app_colors.dart';
import 'package:gymaster/core/theme/emotional_text_styles.dart';
import 'package:gymaster/features/setting/presentation/cubits/onboarding/onboarding_cubit.dart';
import 'package:gymaster/features/setting/domain/entities/onboarding_config.dart';
import 'package:gymaster/shared/widgets/duolingo_components.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class OnboardingHeaderWidget extends StatelessWidget {
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;

  const OnboardingHeaderWidget({
    super.key,
    this.showBackButton = true,
    this.onBackPressed,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, dynamic>(
      builder: (context, state) {
        final cubit = context.read<OnboardingCubit>();

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.fondoPrincipal,
            gradient: LinearGradient(
              colors: [
                AppColors.acento.withValues(alpha: 0.1),
                (backgroundColor ?? AppColors.fondoPrincipal)
                    .withValues(alpha: 0.95),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.acento.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildBackButton(context, cubit),
                  _buildStepCounter(cubit),
                  const SizedBox(width: 40),
                ],
              ),
              const SizedBox(height: 16),
              _buildProgressBar(cubit),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBackButton(BuildContext context, OnboardingCubit cubit) {
    // Mostrar botón atrás solo si no estamos en la primera página
    final showBack = showBackButton && cubit.currentPage > 0;

    if (!showBack) {
      return const SizedBox(width: 40);
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.fondoSecundario,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.acento.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onBackPressed ?? () => cubit.previousPage(),
        borderRadius: BorderRadius.circular(12),
        child: const Icon(
          IconsaxPlusLinear.arrow_left,
          color: AppColors.textoPrincipal,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildStepCounter(OnboardingCubit cubit) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: AppColors.acento.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.acento.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Text(
        'Paso ${cubit.globalStepNumber} de ${OnboardingConfig.totalPasos}',
        style: EstilosTextoEmocional.amigable.copyWith(
          color: AppColors.acento,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildProgressBar(OnboardingCubit cubit) {
    return DuolingoProgressBar(
      progress: cubit.globalProgress,
      currentStep: cubit.globalStepNumber,
      totalSteps: OnboardingConfig.totalPasos,
      motivationalText: cubit.currentMotivationalText,
      primaryColor: AppColors.acento,
    );
  }
}

/// Widget específico para mostrar información de la página actual
class OnboardingPageInfoWidget extends StatelessWidget {
  const OnboardingPageInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, dynamic>(
      builder: (context, state) {
        final cubit = context.read<OnboardingCubit>();
        final pageConfig = cubit.currentPageConfig;

        return _buildPageInfo(
          title: pageConfig.titulo,
          subtitle: pageConfig.subtitulo,
        );
      },
    );
  }

  Widget _buildPageInfo({
    required String title,
    required String subtitle,
  }) {
    return Column(
      children: [
        Text(
          title,
          style: EstilosTextoEmocional.celebracion.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textoPrincipal,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: EstilosTextoEmocional.amigable.copyWith(
            fontSize: 16,
            color: AppColors.textoSecundario,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
