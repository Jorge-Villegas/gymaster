import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymaster/core/theme/emotional_text_styles.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';
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
            color: backgroundColor ??
                Theme.of(context).scaffoldBackgroundColor,
            gradient: LinearGradient(
              colors: [
                context.gym.xpInk.withValues(alpha: 0.1),
                (backgroundColor ??
                        Theme.of(context).scaffoldBackgroundColor)
                    .withValues(alpha: 0.95),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                color: context.gym.xpInk.withValues(alpha: 0.1),
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
                  _buildStepCounter(context, cubit),
                  const SizedBox(width: 40),
                ],
              ),
              const SizedBox(height: 16),
              _buildProgressBar(context, cubit),
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
        color: context.gym.surface2,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: context.gym.xpInk.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onBackPressed ?? () => cubit.previousPage(),
        borderRadius: BorderRadius.circular(12),
        child: Icon(
          IconsaxPlusLinear.arrow_left,
          color: context.gym.ink,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildStepCounter(BuildContext context, OnboardingCubit cubit) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: context.gym.xpInk.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: context.gym.xpInk.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Text(
        'Paso ${cubit.globalStepNumber} de ${OnboardingConfig.totalPasos}',
        style: EstilosTextoEmocional.amigable.copyWith(
          color: context.gym.xpInk,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context, OnboardingCubit cubit) {
    return DuolingoProgressBar(
      progress: cubit.globalProgress,
      currentStep: cubit.globalStepNumber,
      totalSteps: OnboardingConfig.totalPasos,
      motivationalText: cubit.currentMotivationalText,
      primaryColor: context.gym.xpInk,
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
          context: context,
          title: pageConfig.titulo,
          subtitle: pageConfig.subtitulo,
        );
      },
    );
  }

  Widget _buildPageInfo({
    required BuildContext context,
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
            color: context.gym.ink,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: EstilosTextoEmocional.amigable.copyWith(
            fontSize: 16,
            color: context.gym.muted,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
