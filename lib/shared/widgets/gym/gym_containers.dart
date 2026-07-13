import 'package:flutter/material.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';
import 'package:gymaster/core/theme/gym_typography.dart';

/// Tarjeta base: superficie + borde + radio consistentes con el tema.
class GymCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const GymCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.gym;
    final content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: GymRadius.rMd,
        border: Border.all(color: c.line),
      ),
      child: child,
    );
    if (onTap == null) return content;
    return Material(
      color: Colors.transparent,
      child: InkWell(borderRadius: GymRadius.rMd, onTap: onTap, child: content),
    );
  }
}

/// Tono semántico para pills (define fondo suave + texto).
enum GymTone { brand, coral, xp, info, plum, neutral }

/// Pastilla/etiqueta de estado (racha, XP, "nuevo"…).
class GymPill extends StatelessWidget {
  final String label;
  final GymTone tone;

  const GymPill(this.label, {super.key, this.tone = GymTone.neutral});

  @override
  Widget build(BuildContext context) {
    final c = context.gym;
    final (Color bg, Color fg) = switch (tone) {
      GymTone.brand => (c.brandSoft, c.brandInk),
      GymTone.coral => (c.coralSoft, c.coralInk),
      GymTone.xp => (c.xpSoft, c.xpInk),
      GymTone.info => (c.infoSoft, c.info),
      GymTone.plum => (c.plumSoft, c.plum),
      GymTone.neutral => (c.surface2, c.muted),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: GymRadius.rSm),
      child: Text(label,
          style: GymType.label.copyWith(color: fg, fontWeight: FontWeight.w800)),
    );
  }
}

/// Chip pequeño neutro (etiquetas de músculo, tags).
class GymChip extends StatelessWidget {
  final String label;
  const GymChip(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.gym;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: c.surface2,
        borderRadius: const BorderRadius.all(Radius.circular(999)),
        border: Border.all(color: c.line),
      ),
      child: Text(label,
          style: GymType.label
              .copyWith(color: c.muted, fontSize: 11, fontWeight: FontWeight.w700)),
    );
  }
}

/// Encabezado de sección con acción opcional a la derecha.
class GymSectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;

  const GymSectionHeader(this.title, {super.key, this.action, this.onAction});

  @override
  Widget build(BuildContext context) {
    final c = context.gym;
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 22, 2, 12),
      child: Row(
        children: [
          Text(title, style: GymType.section.copyWith(color: c.ink)),
          const Spacer(),
          if (action != null)
            GestureDetector(
              onTap: onAction,
              child: Text(action!,
                  style: GymType.label.copyWith(color: c.brand)),
            ),
        ],
      ),
    );
  }
}

/// Tarjeta-métrica compacta (número grande + etiqueta). Pensada para ir dentro
/// de un [Row] con [Expanded].
class GymMetricCard extends StatelessWidget {
  final String value;
  final String label;
  final Color? valueColor;

  const GymMetricCard(this.value, this.label, {super.key, this.valueColor});

  @override
  Widget build(BuildContext context) {
    final c = context.gym;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: GymRadius.rSm,
        border: Border.all(color: c.line),
      ),
      child: Column(
        children: [
          Text(value,
              style: GymType.number.copyWith(color: valueColor ?? c.ink)),
          const SizedBox(height: 2),
          Text(label,
              textAlign: TextAlign.center,
              style: GymType.label.copyWith(color: c.muted)),
        ],
      ),
    );
  }
}
