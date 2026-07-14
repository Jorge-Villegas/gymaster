import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';
import 'package:gymaster/core/theme/gym_typography.dart';
import 'package:gymaster/shared/utils/haptic_feedback_helper.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

/// Widget de retroalimentación emocional para acciones de rutina
/// Diseñado para mostrar confirmaciones, éxitos y errores de manera emocional
class RoutineActionFeedback extends StatefulWidget {
  final String message;
  final RoutineActionType type;
  final VoidCallback? onUndo;
  final Duration duration;

  const RoutineActionFeedback({
    super.key,
    required this.message,
    required this.type,
    this.onUndo,
    this.duration = const Duration(seconds: 4),
  });

  @override
  State<RoutineActionFeedback> createState() => _RoutineActionFeedbackState();
}

class _RoutineActionFeedbackState extends State<RoutineActionFeedback>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _progressController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _slideController.forward();
    _progressController.forward();

    // Auto-dismiss después de la duración especificada
    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        _slideController.reverse().then((_) {
          if (mounted) Navigator.of(context).pop();
        });
      }
    });

    _triggerHapticFeedback();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  void _triggerHapticFeedback() async {
    switch (widget.type) {
      case RoutineActionType.delete:
        await HapticFeedbackHelper.vibracionError();
        break;
      case RoutineActionType.restore:
        await HapticFeedbackHelper.vibracionExito();
        break;
      case RoutineActionType.success:
        await HapticFeedbackHelper.vibracionExito();
        break;
      case RoutineActionType.error:
        await HapticFeedbackHelper.vibracionError();
        break;
    }
  }

  void _handleUndo() async {
    await HapticFeedbackHelper.vibracionSeleccion();
    if (widget.onUndo != null) {
      widget.onUndo!();
    }
    _slideController.reverse().then((_) {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeOutCubic,
      )),
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                // Icono emocional
                _buildEmotionalIcon(),

                const SizedBox(width: 12),

                // Mensaje
                Expanded(
                  child: Text(
                    widget.message,
                    style: GymType.section.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),

                // Botón deshacer (solo para delete)
                if (widget.type == RoutineActionType.delete &&
                    widget.onUndo != null)
                  _buildUndoButton(),
              ],
            ),

            const SizedBox(height: 12),

            // Barra de progreso
            _buildProgressBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmotionalIcon() {
    return FadeInLeft(
      duration: const Duration(milliseconds: 400),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          _getIcon(),
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildUndoButton() {
    return FadeInRight(
      duration: const Duration(milliseconds: 400),
      child: TextButton(
        onPressed: _handleUndo,
        style: TextButton.styleFrom(
          backgroundColor: Colors.white.withValues(alpha: 0.2),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          'Deshacer',
          style: GymType.label.copyWith(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: AnimatedBuilder(
        animation: _progressController,
        builder: (context, child) {
          return LinearProgressIndicator(
            value: _progressController.value,
            backgroundColor: Colors.white.withValues(alpha: 0.3),
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.white.withValues(alpha: 0.8),
            ),
            minHeight: 3,
          );
        },
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (widget.type) {
      case RoutineActionType.delete:
        return context.gym.danger;
      case RoutineActionType.restore:
        return context.gym.brand;
      case RoutineActionType.success:
        return context.gym.brand;
      case RoutineActionType.error:
        return context.gym.danger;
    }
  }

  IconData _getIcon() {
    switch (widget.type) {
      case RoutineActionType.delete:
        return IconsaxPlusLinear.trash;
      case RoutineActionType.restore:
        return IconsaxPlusLinear.refresh_circle;
      case RoutineActionType.success:
        return IconsaxPlusLinear.tick_circle;
      case RoutineActionType.error:
        return IconsaxPlusLinear.danger;
    }
  }
}

enum RoutineActionType { delete, restore, success, error }
