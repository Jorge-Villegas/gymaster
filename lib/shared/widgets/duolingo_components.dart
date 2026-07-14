import 'package:flutter/material.dart';
import 'package:gymaster/core/theme/espaciado.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';

/// Widget reutilizable que emula el estilo de progreso de Duolingo
/// con animaciones y colores vibrantes para aumentar la motivación
class DuolingoProgressBar extends StatefulWidget {
  final double progress; // 0.0 a 1.0
  final int currentStep;
  final int totalSteps;
  final String? motivationalText;
  final Color? primaryColor;
  final Color? backgroundColor;

  const DuolingoProgressBar({
    super.key,
    required this.progress,
    required this.currentStep,
    required this.totalSteps,
    this.motivationalText,
    this.primaryColor,
    this.backgroundColor,
  });

  @override
  State<DuolingoProgressBar> createState() => _DuolingoProgressBarState();
}

class _DuolingoProgressBarState extends State<DuolingoProgressBar>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _bounceController;
  late Animation<double> _progressAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.progress,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeOutCubic,
    ));

    _bounceAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticOut,
    ));

    // Iniciar animaciones
    _progressController.forward();
    _bounceController.forward();
  }

  @override
  void didUpdateWidget(DuolingoProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _progressAnimation = Tween<double>(
        begin: oldWidget.progress,
        end: widget.progress,
      ).animate(CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeOutCubic,
      ));
      _progressController.forward(from: 0.0);
      _bounceController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.primaryColor ?? context.gym.brand;
    final backgroundColor = widget.backgroundColor ?? context.gym.surface2;

    return AnimatedBuilder(
      animation: Listenable.merge([_progressAnimation, _bounceAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _bounceAnimation.value,
          child: Column(
            children: [
              // Texto motivacional estilo Duolingo
              if (widget.motivationalText != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: Espaciado.sm),
                  child: Text(
                    widget.motivationalText!,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),

              // Barra de progreso principal
              Container(
                width: double.infinity,
                height: 12,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Barra de fondo con brillo interno
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [
                            backgroundColor.withValues(alpha: 0.3),
                            backgroundColor,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),

                    // Barra de progreso con gradiente vibrante
                    FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: _progressAnimation.value,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [
                              primaryColor.withValues(alpha: 0.8),
                              primaryColor,
                              primaryColor,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withValues(alpha: 0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withValues(alpha: 0.3),
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.1),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: Espaciado.sm),

              // Indicador de pasos estilo Duolingo
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Texto de progreso
                  Text(
                    'Paso ${widget.currentStep} de ${widget.totalSteps}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: context.gym.muted,
                          fontWeight: FontWeight.w500,
                        ),
                  ),

                  // Porcentaje con estilo vibrante
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Espaciado.xs,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${(_progressAnimation.value * 100).round()}%',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: primaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Widget de celebración al completar un paso (estilo Duolingo)
class DuolingoSuccessAnimation extends StatefulWidget {
  final String message;
  final IconData icon;
  final Color? color;
  final VoidCallback? onComplete;

  const DuolingoSuccessAnimation({
    super.key,
    required this.message,
    this.icon = Icons.check_circle,
    this.color,
    this.onComplete,
  });

  @override
  State<DuolingoSuccessAnimation> createState() =>
      _DuolingoSuccessAnimationState();
}

class _DuolingoSuccessAnimationState extends State<DuolingoSuccessAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
    ));

    _controller.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 800), () {
        widget.onComplete?.call();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? context.gym.brand;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(Espaciado.lg),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Espaciado.lg),
                border: Border.all(
                  color: color,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    widget.icon,
                    size: 48,
                    color: color,
                  ),
                  const SizedBox(height: Espaciado.sm),
                  Text(
                    widget.message,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
