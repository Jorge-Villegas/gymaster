import 'package:flutter/material.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';
import 'package:gymaster/core/theme/gym_typography.dart';

enum GymButtonVariant { primary, secondary, ghost }

/// Botón 3D presionable (estilo "chiclet" Duolingo), theme-aware.
///
/// Reemplaza a `ChicletButton` y `DuolingoActionButton` (dos botones
/// duplicados que hardcodeaban colores). Usa los tokens del tema.
class GymButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final GymButtonVariant variant;
  final IconData? icon;
  final bool expand;

  const GymButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = GymButtonVariant.primary,
    this.icon,
    this.expand = true,
  });

  @override
  State<GymButton> createState() => _GymButtonState();
}

class _GymButtonState extends State<GymButton> {
  bool _down = false;

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
        onTapDown: enabled ? (_) => setState(() => _down = true) : null,
        onTapUp: enabled ? (_) => setState(() => _down = false) : null,
        onTapCancel: () => setState(() => _down = false),
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 60),
          transform: Matrix4.translationValues(0, _down ? 4 : 0, 0),
          width: widget.expand ? double.infinity : null,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 18),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
            border: border,
            boxShadow: [
              BoxShadow(color: shadow, offset: Offset(0, _down ? 1 : 5)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, color: fg, size: 20),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  widget.label,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: GymType.bodyStrong.copyWith(
                      color: fg, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
