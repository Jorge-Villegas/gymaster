import 'package:flutter/material.dart';
import 'package:gymaster/core/theme/app_colors.dart';
import 'package:gymaster/core/theme/emotional_text_styles.dart';
import 'package:gymaster/core/theme/tipografia_gymaster.dart';
import 'package:gymaster/shared/utils/haptic_feedback_helper.dart';

/// Custom elevated button con diseño emocional
/// Implementa feedback háptico y colores emocionales
class CustomElevatedButton extends StatefulWidget {
  final String? text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final Icon? icon;
  final double? width;
  final double? height;
  final double? borderRadius;
  final EmotionalButtonType emotionalType;
  final bool enableHapticFeedback;
  final bool enablePressAnimation;

  const CustomElevatedButton({
    super.key,
    this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.width,
    this.height = 40,
    this.borderRadius = 10,
    this.emotionalType = EmotionalButtonType.neutral,
    this.enableHapticFeedback = true,
    this.enablePressAnimation = true,
  });

  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _rippleController;
  late AnimationController _loadingController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rippleAnimation;
  late Animation<double> _rotationAnimation;
  bool _isPressed = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Animación principal de escala
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Animación de ripple
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOut,
    ));

    // Animación de loading
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _loadingController,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _rippleController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  void _handleTapDown() {
    if (widget.enablePressAnimation) {
      setState(() => _isPressed = true);
      _animationController.forward();
    }
    if (widget.enableHapticFeedback) {
      _triggerEmotionalHapticFeedback();
    }
    _rippleController.forward().then((_) => _rippleController.reset());
  }

  void _handleTapUp() {
    if (widget.enablePressAnimation) {
      setState(() => _isPressed = false);
      _animationController.reverse();
    }
    widget.onPressed();
  }

  void _handleTapCancel() {
    if (widget.enablePressAnimation) {
      setState(() => _isPressed = false);
      _animationController.reverse();
    }
  }

  void startLoading() {
    setState(() => _isLoading = true);
    _loadingController.repeat();
  }

  void stopLoading() {
    setState(() => _isLoading = false);
    _loadingController.stop();
  }

  /// Obtiene el color de fondo basado en el tipo emocional
  Color _getEmotionalBackgroundColor(BuildContext context) {
    if (widget.backgroundColor != null) return widget.backgroundColor!;

    switch (widget.emotionalType) {
      case EmotionalButtonType.energetic:
        return AppColors.acento;
      case EmotionalButtonType.success:
        return AppColors.exito;
      case EmotionalButtonType.achievement:
        return AppColors.acento;
      case EmotionalButtonType.motivation:
        return AppColors.error;
      case EmotionalButtonType.calm:
        return AppColors.secundarioClaro;
      case EmotionalButtonType.warning:
        return AppColors.advertencia;
      case EmotionalButtonType.neutral:
        return Theme.of(context).colorScheme.primary;
    }
  }

  /// Obtiene el estilo de texto basado en el tipo emocional
  TextStyle _getEmotionalTextStyle() {
    final baseColor = widget.textColor ?? Colors.white;

    switch (widget.emotionalType) {
      case EmotionalButtonType.energetic:
        return EstilosTextoEmocional.energetico.copyWith(
          color: baseColor,
          fontSize: TipografiaGyMaster.textoPrincipal.fontSize,
        );
      case EmotionalButtonType.success:
        return EstilosTextoEmocional.aliento.copyWith(
          color: baseColor,
          fontSize: TipografiaGyMaster.textoPrincipal.fontSize,
        );
      case EmotionalButtonType.achievement:
        return EstilosTextoEmocional.logro.copyWith(
          color: baseColor,
          fontSize: TipografiaGyMaster.textoPrincipal.fontSize,
        );
      case EmotionalButtonType.motivation:
        return EstilosTextoEmocional.motivacional.copyWith(
          color: baseColor,
          fontSize: TipografiaGyMaster.textoPrincipal.fontSize,
        );
      case EmotionalButtonType.calm:
        return EstilosTextoEmocional.descanso.copyWith(
          color: baseColor,
          fontSize: TipografiaGyMaster.textoPrincipal.fontSize,
        );
      case EmotionalButtonType.warning:
      case EmotionalButtonType.neutral:
        return TextStyle(
          color: baseColor,
          fontSize: TipografiaGyMaster.textoPrincipal.fontSize,
          fontWeight: TipografiaGyMaster.pesoSemiBold,
        );
    }
  }

  /// Maneja el feedback háptico emocional específico para botones
  Future<void> _triggerEmotionalHapticFeedback() async {
    if (!widget.enableHapticFeedback) return;

    switch (widget.emotionalType) {
      case EmotionalButtonType.success:
      case EmotionalButtonType.achievement:
        await HapticFeedbackHelper.vibracionExito();
        break;
      case EmotionalButtonType.energetic:
      case EmotionalButtonType.motivation:
        await HapticFeedbackHelper.vibracionMotivacionalInicioRutina();
        break;
      case EmotionalButtonType.calm:
        await HapticFeedbackHelper.vibracionTransicion();
        break;
      case EmotionalButtonType.warning:
        await HapticFeedbackHelper.vibracionRecordatorio();
        break;
      case EmotionalButtonType.neutral:
        await HapticFeedbackHelper.vibracionSeleccion();
        break;
    }
  }

  /// Maneja el feedback háptico básico (para compatibilidad)
  Future<void> _handleHapticFeedback() async {
    await _triggerEmotionalHapticFeedback();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _getEmotionalBackgroundColor(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        double buttonWidth = widget.width ?? constraints.maxWidth * 0.8;
        double buttonHeight = widget.height ?? constraints.maxHeight * 0.1;

        Widget buttonChild = Stack(
          alignment: Alignment.center,
          children: [
            // Ripple effect
            AnimatedBuilder(
              animation: _rippleAnimation,
              builder: (context, child) {
                return Container(
                  width: buttonWidth * (1 + (_rippleAnimation.value * 0.3)),
                  height: buttonHeight * (1 + (_rippleAnimation.value * 0.3)),
                  decoration: BoxDecoration(
                    color: backgroundColor
                        .withOpacity(0.3 * (1 - _rippleAnimation.value)),
                    borderRadius: BorderRadius.circular(
                        (widget.borderRadius ?? 15) *
                            (1 + (_rippleAnimation.value * 0.3))),
                  ),
                );
              },
            ),
            // Botón principal
            SizedBox(
              width: buttonWidth,
              height: buttonHeight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: backgroundColor,
                  foregroundColor: widget.textColor ?? Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(widget.borderRadius ?? 15),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  elevation: _isPressed ? 2 : 4,
                  shadowColor: backgroundColor.withOpacity(0.3),
                ),
                onPressed: () async {
                  await _handleHapticFeedback();
                  widget.onPressed();
                },
                child: _isLoading
                    ? _buildLoadingIndicator()
                    : _buildButtonContent(),
              ),
            ),
          ],
        );

        // Aplicar animación de presión mejorada si está habilitada
        if (widget.enablePressAnimation) {
          return GestureDetector(
            onTapDown: (_) => _handleTapDown(),
            onTapUp: (_) => _handleTapUp(),
            onTapCancel: _handleTapCancel,
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: buttonChild,
                );
              },
            ),
          );
        }

        return buttonChild;
      },
    );
  }

  /// Construye el contenido del botón (texto e icono)
  Widget _buildButtonContent() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.icon != null)
          Icon(
            widget.icon!.icon,
            color: widget.textColor ?? Colors.white,
            size: 20,
          ),
        if (widget.icon != null && widget.text != null)
          const SizedBox(width: 8),
        if (widget.text != null)
          Text(widget.text!, style: _getEmotionalTextStyle()),
      ],
    );
  }

  /// Construye el indicador de loading animado
  Widget _buildLoadingIndicator() {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationAnimation.value * 3.14159, // π radianes para rotación
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                widget.textColor ?? Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Tipos emocionales para botones
enum EmotionalButtonType {
  neutral, // Gris/azul estándar
  energetic, // Naranja energético
  success, // Verde éxito
  achievement, // Dorado logro
  motivation, // Rojo motivacional
  calm, // Azul calmado
  warning, // Naranja advertencia
}
