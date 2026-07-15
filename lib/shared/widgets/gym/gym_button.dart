import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';
import 'package:gymaster/core/theme/gym_typography.dart';

enum GymButtonVariant { primary, secondary, ghost }

/// Tamaño del botón. Mapea a las alturas del antiguo `ChicletButton`
/// (pequeño ≈ 40, mediano ≈ 48, grande ≈ 56) para que la migración
/// preserve el layout de los botones chicos (p.ej. los +/− del entreno).
enum GymButtonSize { small, medium, large }

/// Botón único de la app, theme-aware. Al presionar se encoge y al soltar
/// rebota con física real (`SpringSimulation`), con háptica en capas: contacto
/// al presionar + confirmación al soltar según el peso de la acción.
class GymButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final GymButtonVariant variant;
  final GymButtonSize size;
  final IconData? icon;
  final bool expand;

  const GymButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = GymButtonVariant.primary,
    this.size = GymButtonSize.medium,
    this.icon,
    this.expand = true,
  });

  @override
  State<GymButton> createState() => _GymButtonState();
}

class _GymButtonState extends State<GymButton>
    with SingleTickerProviderStateMixin {
  /// `value` ES la escala del botón (1.0 en reposo). Unbounded para que el
  /// resorte pueda sobrepasar 1.0 y asentarse (rebote gomoso).
  late final AnimationController _scale =
      AnimationController.unbounded(vsync: this, value: 1.0);

  static const double _pressedScale = 0.93;

  static const SpringDescription _spring =
      SpringDescription(mass: 1, stiffness: 520, damping: 17);

  @override
  void dispose() {
    _scale.dispose();
    super.dispose();
  }

  double get _vPad => switch (widget.size) {
        GymButtonSize.small => 9,
        GymButtonSize.medium => 15,
        GymButtonSize.large => 18,
      };

  double get _hPad => switch (widget.size) {
        GymButtonSize.small => 14,
        GymButtonSize.medium => 18,
        GymButtonSize.large => 22,
      };

  double get _fontSize => switch (widget.size) {
        GymButtonSize.small => 14,
        GymButtonSize.medium => 15,
        GymButtonSize.large => 17,
      };

  double get _iconSize => switch (widget.size) {
        GymButtonSize.small => 16,
        GymButtonSize.medium => 20,
        GymButtonSize.large => 22,
      };

  void _hapticTouch() => HapticFeedback.selectionClick();

  /// Confirmación al soltar, más intensa cuanto mayor es el peso de la acción.
  void _hapticConfirm() {
    final esPrimaria = widget.variant == GymButtonVariant.primary;
    if (esPrimaria && widget.size == GymButtonSize.large) {
      HapticFeedback.heavyImpact();
    } else if (esPrimaria || widget.size == GymButtonSize.large) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.lightImpact();
    }
  }

  void _pressDown() {
    _hapticTouch();
    _scale.animateTo(_pressedScale,
        duration: const Duration(milliseconds: 90), curve: Curves.easeOutCubic);
  }

  void _springBack() {
    _scale.animateWith(
      SpringSimulation(_spring, _scale.value, 1.0, _scale.velocity),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.gym;
    final enabled = widget.onPressed != null;

    late Color bg;
    late Color shadow;
    late Color fg;
    Border? border;

    switch (widget.variant) {
      case GymButtonVariant.primary:
        bg = c.brand;
        shadow = c.brandInk;
        fg = Colors.white;
        break;
      case GymButtonVariant.secondary:
        bg = c.coral;
        shadow = c.coralInk;
        fg = Colors.white;
        break;
      case GymButtonVariant.ghost:
        bg = c.surface;
        shadow = c.lineStrong;
        fg = c.brand;
        border = Border.all(color: c.brand, width: 2);
        break;
    }

    if (!enabled) {
      bg = c.surface2;
      shadow = c.line;
      fg = c.faint;
      border = null;
    }

    return Opacity(
      opacity: enabled ? 1 : 0.7,
      child: GestureDetector(
        onTapDown: enabled ? (_) => _pressDown() : null,
        onTapUp: enabled
            ? (_) {
                _springBack();
                _hapticConfirm();
                widget.onPressed?.call();
              }
            : null,
        onTapCancel: enabled ? _springBack : null,
        child: AnimatedBuilder(
          animation: _scale,
          builder: (context, child) => Transform.scale(
            scale: _scale.value,
            child: child,
          ),
          child: Container(
            width: widget.expand ? double.infinity : null,
            padding: EdgeInsets.symmetric(vertical: _vPad, horizontal: _hPad),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(16),
              border: border,
              boxShadow: enabled
                  ? [
                      BoxShadow(
                        color: shadow.withValues(alpha: 0.38),
                        blurRadius: 16,
                        spreadRadius: -3,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null)
                  Icon(widget.icon, color: fg, size: _iconSize),
                // Sin label (icono-solo) no reservamos hueco ni texto.
                if (widget.icon != null && widget.label.isNotEmpty)
                  const SizedBox(width: 8),
                if (widget.label.isNotEmpty)
                  Flexible(
                    child: Text(
                      widget.label,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: GymType.bodyStrong.copyWith(
                          color: fg,
                          fontSize: _fontSize,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
