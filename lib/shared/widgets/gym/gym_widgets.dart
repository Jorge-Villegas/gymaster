import 'package:flutter/material.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';
import 'package:gymaster/core/theme/gym_typography.dart';

/// Barra de XP / progreso (relleno degradado dorado).
class GymXpBar extends StatelessWidget {
  final double value; // 0.0 – 1.0
  final double height;

  const GymXpBar({super.key, required this.value, this.height = 14});

  @override
  Widget build(BuildContext context) {
    final c = context.gym;
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(999)),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: c.surface2,
          border: Border.all(color: c.line),
          borderRadius: const BorderRadius.all(Radius.circular(999)),
        ),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: value.clamp(0.0, 1.0),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [c.xp, c.xpInk]),
              borderRadius: const BorderRadius.all(Radius.circular(999)),
            ),
          ),
        ),
      ),
    );
  }
}

/// Chip de filtro seleccionable (grupos musculares, categorías).
class GymFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const GymFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.gym;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: selected ? c.brand : c.surface,
          borderRadius: const BorderRadius.all(Radius.circular(999)),
          border: Border.all(color: selected ? c.brand : c.line, width: 1.5),
          boxShadow: selected
              ? [BoxShadow(color: c.brandInk, offset: const Offset(0, 3))]
              : null,
        ),
        child: Text(label,
            style: GymType.label.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: selected ? Colors.white : c.muted)),
      ),
    );
  }
}

/// Stepper +/− grande para registrar peso y reps en vivo (dedos, gym).
class GymStepper extends StatelessWidget {
  final int value;
  final int step;
  final ValueChanged<int> onChanged;
  final int min;

  const GymStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.step = 1,
    this.min = 0,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.gym;
    return Container(
      decoration: BoxDecoration(
        color: c.surface2,
        borderRadius: const BorderRadius.all(Radius.circular(11)),
        border: Border.all(color: c.line),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _btn(c, '−', () => onChanged((value - step).clamp(min, 99999))),
          Text('$value',
              style: GymType.bodyStrong
                  .copyWith(fontSize: 15, fontWeight: FontWeight.w800, color: c.ink)),
          _btn(c, '+', () => onChanged(value + step)),
        ],
      ),
    );
  }

  Widget _btn(GymColors c, String s, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 32,
        height: 36,
        child: Center(
          child: Text(s,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: c.brandInk)),
        ),
      ),
    );
  }
}
