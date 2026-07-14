import 'package:flutter/material.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';
import 'package:gymaster/core/theme/espaciado.dart';
import 'package:gymaster/core/theme/gym_typography.dart';

/// ChoiceChip reutilizable para GyMaster
///
/// Tamaños disponibles: pequeño, regular (defecto), grande
/// Diseño emocional con feedback visual inmediato
enum TamanoChoiceChip { pequeno, regular, grande }

class GyMasterChoiceChip extends StatelessWidget {
  final String texto;
  final String? emoji;
  final String? descripcion;
  final bool isSelected;
  final VoidCallback onTap;
  final TamanoChoiceChip tamano;

  const GyMasterChoiceChip({
    super.key,
    required this.texto,
    this.emoji,
    this.descripcion,
    required this.isSelected,
    required this.onTap,
    this.tamano = TamanoChoiceChip.regular,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: _getPadding(),
        decoration: BoxDecoration(
          color: isSelected
              ? context.gym.brand.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(_getBorderRadius()),
          border: Border.all(
            color: isSelected
                ? context.gym.brand
                : context.gym.line.withValues(alpha: 0.3),
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: context.gym.brand.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    switch (tamano) {
      case TamanoChoiceChip.pequeno:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (emoji != null) ...[
              Text(emoji!, style: TextStyle(fontSize: 14)),
              SizedBox(width: Espaciado.xs),
            ],
            Text(
              texto,
              style: GymType.label.copyWith(
                color: context.gym.ink,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        );

      case TamanoChoiceChip.regular:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (emoji != null) ...[
              Text(emoji!, style: TextStyle(fontSize: 20)),
              SizedBox(height: Espaciado.xs),
            ],
            Text(
              texto,
              style: GymType.body.copyWith(
                color: context.gym.ink,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            if (descripcion != null) ...[
              SizedBox(height: Espaciado.xs),
              Text(
                descripcion!,
                style: GymType.label.copyWith(
                  fontWeight: FontWeight.w400,
                  color: context.gym.muted,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        );

      case TamanoChoiceChip.grande:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (emoji != null) ...[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected
                      ? context.gym.brand.withValues(alpha: 0.2)
                      : context.gym.faint.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(emoji!, style: TextStyle(fontSize: 20)),
                ),
              ),
              SizedBox(height: Espaciado.xs),
            ],
            Flexible(
              child: Text(
                texto,
                style: GymType.body.copyWith(
                  color: context.gym.ink,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (descripcion != null) ...[
              SizedBox(height: Espaciado.xs),
              Flexible(
                child: Text(
                  descripcion!,
                  style: GymType.label.copyWith(
                    fontWeight: FontWeight.w400,
                    color: context.gym.muted,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        );
    }
  }

  EdgeInsets _getPadding() {
    switch (tamano) {
      case TamanoChoiceChip.pequeno:
        return const EdgeInsets.symmetric(
          horizontal: Espaciado.sm,
          vertical: Espaciado.xs,
        );
      case TamanoChoiceChip.regular:
        return const EdgeInsets.all(Espaciado.md);
      case TamanoChoiceChip.grande:
        return const EdgeInsets.all(Espaciado.lg);
    }
  }

  double _getBorderRadius() {
    switch (tamano) {
      case TamanoChoiceChip.pequeno:
        return Espaciado.sm;
      case TamanoChoiceChip.regular:
        return Espaciado.md;
      case TamanoChoiceChip.grande:
        return Espaciado.lg;
    }
  }
}
