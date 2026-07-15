import 'package:flutter/material.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';
import 'package:gymaster/core/theme/gym_typography.dart';

enum GymButtonVariant { primary, secondary, ghost }

/// Tamaño del botón. Mapea a las alturas del antiguo `ChicletButton`
/// (pequeño ≈ 40, mediano ≈ 48, grande ≈ 56) para que la migración
/// preserve el layout de los botones chicos (p.ej. los +/− del entreno).
enum GymButtonSize { small, medium, large }

/// Botón 3D presionable (estilo "chiclet" Duolingo), theme-aware.
///
/// Sistema ÚNICO de botones: reemplaza a `ChicletButton`,
/// `DuolingoActionButton` y `CustomElevatedButton` (que hardcodeaban colores
/// y duplicaban la sombra/animación). Usa los tokens del tema.
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

class _GymButtonState extends State<GymButton> {
  bool _down = false;

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
          padding: EdgeInsets.symmetric(vertical: _vPad, horizontal: _hPad),
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
              if (widget.icon != null)
                Icon(widget.icon, color: fg, size: _iconSize),
              // Solo reservamos hueco + texto si hay label (botones icono-solo
              // como los +/− no deben ensanchar la caja).
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
    );
  }
}
