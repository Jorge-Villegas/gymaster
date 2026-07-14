import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';
import 'package:gymaster/core/theme/gym_typography.dart';
import 'package:gymaster/core/theme/espaciado.dart';
import 'package:gymaster/shared/widgets/gym/gym.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class OnboardingBienvenidaPage extends StatelessWidget {
  const OnboardingBienvenidaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: context.gym.brand.withValues(alpha: 0.1),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Espaciado.lg),
            child: Column(
              spacing: Espaciado.sm,
              children: [
                _construirLogoAnimado(size),
                _construirMensajeCelebracion(context),
                _construirListaBeneficiosGamificada(context),
                GymButton(
                  label: '¡Empezar mi Aventura!',
                  icon: Icons.rocket_launch,
                  variant: GymButtonVariant.primary,
                  size: GymButtonSize.large,
                  expand: true,
                  onPressed: () => _iniciarOnboarding(context),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Espaciado.md,
                    vertical: Espaciado.xs,
                  ),
                  decoration: BoxDecoration(
                    color: context.gym.info.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(Espaciado.lg),
                    border: Border.all(
                      color: context.gym.info.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        size: 16,
                        color: context.gym.info,
                      ),
                      const SizedBox(width: Espaciado.xs),
                      Flexible(
                        child: Text(
                          'Solo 2 minutos para personalizar',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: context.gym.info,
                                    fontWeight: FontWeight.w600,
                                  ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _construirLogoAnimado(Size size) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1200),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: size.width * 0.35,
            height: size.width * 0.35,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  context.gym.brand,
                  context.gym.info,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(size.width * 0.1),
              boxShadow: [
                BoxShadow(
                  color: context.gym.brand.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: context.gym.info.withValues(alpha: 0.2),
                  blurRadius: 15,
                  offset: const Offset(5, 5),
                ),
              ],
            ),
            child: const Icon(
              Icons.fitness_center,
              size: 90,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  Widget _construirMensajeCelebracion(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: Column(
              children: [
                // Título con colores vibrantes
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                    children: [
                      TextSpan(
                        text: '¡Bienvenido a ',
                        style: TextStyle(color: context.gym.ink),
                      ),
                      TextSpan(
                        text: 'GyMaster',
                        style: TextStyle(
                          color: context.gym.brand,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: '!',
                        style: TextStyle(color: context.gym.info),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: Espaciado.md),

                // Badge motivacional
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Espaciado.md,
                    vertical: Espaciado.xs,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        context.gym.xpInk.withValues(alpha: 0.2),
                        context.gym.xpInk.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(Espaciado.lg),
                    border: Border.all(
                      color: context.gym.xpInk,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.stars,
                        color: context.gym.xpInk,
                        size: 20,
                      ),
                      const SizedBox(width: Espaciado.xs),
                      Flexible(
                        child: Text(
                          'Tu aventura fitness comienza aquí',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: context.gym.xpInk,
                                    fontWeight: FontWeight.w600,
                                  ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _construirListaBeneficiosGamificada(BuildContext context) {
    final beneficios = [
      {
        'icono': IconsaxPlusLinear.activity,
        'titulo': 'Seguimiento Inteligente',
        'descripcion': 'Rutinas que se adaptan a tu progreso',
        'emoji': '🎯',
        'color': context.gym.brand,
      },
      {
        'icono': IconsaxPlusLinear.medal,
        'titulo': 'Logros y Recompensas',
        'descripcion': 'Celebra cada victoria, por pequeña que sea',
        'emoji': '🏆',
        'color': context.gym.xpInk,
      },
      {
        'icono': IconsaxPlusLinear.trend_up,
        'titulo': 'Progreso Visual',
        'descripcion': 'Ve tu transformación en tiempo real',
        'emoji': '📈',
        'color': context.gym.info,
      },
    ];

    return Column(
      children: beneficios.asMap().entries.map((entry) {
        final index = entry.key;
        final beneficio = entry.value;

        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 600 + (index * 200)),
          tween: Tween<double>(begin: 0.0, end: 1.0),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(30 * (1 - value), 0),
              child: Opacity(
                opacity: value.clamp(0.0, 1.0),
                child: Container(
                  margin: const EdgeInsets.only(bottom: Espaciado.md),
                  padding: const EdgeInsets.all(Espaciado.md),
                  decoration: BoxDecoration(
                    color:
                        (beneficio['color'] as Color).withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(Espaciado.md),
                    border: Border.all(
                      color:
                          (beneficio['color'] as Color).withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: beneficio['color'] as Color,
                          borderRadius: BorderRadius.circular(Espaciado.md),
                          boxShadow: [
                            BoxShadow(
                              color: (beneficio['color'] as Color)
                                  .withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              beneficio['icono'] as IconData,
                              color: Colors.white,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: Espaciado.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              beneficio['titulo'] as String,
                              style: GymType.section.copyWith(
                                color: context.gym.ink,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: Espaciado.xxs),
                            Text(
                              beneficio['descripcion'] as String,
                              style: GymType.label.copyWith(
                                fontWeight: FontWeight.w400,
                                color: context.gym.muted,
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  void _iniciarOnboarding(BuildContext context) {
    context.push('/onboarding_unificado');
  }
}
