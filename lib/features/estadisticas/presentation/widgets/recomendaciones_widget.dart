import 'package:flutter/material.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';
import 'package:gymaster/core/theme/gym_typography.dart';
import 'package:gymaster/core/theme/espaciado.dart';
import 'package:gymaster/features/estadisticas/domain/entities/recomendacion_muscular.dart';
import 'package:gymaster/shared/utils/string_utils.dart';

class RecomendacionesWidget extends StatelessWidget {
  final List<RecomendacionMuscular> recomendaciones;
  final VoidCallback? onEntrenarMusculo;

  const RecomendacionesWidget({
    super.key,
    required this.recomendaciones,
    this.onEntrenarMusculo,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.gym;
    if (recomendaciones.isEmpty) {
      return _buildBalanceadoState(context);
    }

    return Container(
      padding: Espaciado.rellenoMd,
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(Espaciado.md),
        border: Border.all(color: c.line, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: c.xpInk,
                size: 24,
              ),
              SizedBox(width: Espaciado.xs),
              Text(
                'Recomendaciones',
                style: GymType.body.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: c.ink,
                ),
              ),
            ],
          ),
          SizedBox(height: Espaciado.md),
          ...recomendaciones.map((recomendacion) {
            return Padding(
              padding: EdgeInsets.only(bottom: Espaciado.sm),
              child: _buildRecomendacionCard(context, recomendacion),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRecomendacionCard(
      BuildContext context, RecomendacionMuscular recomendacion) {
    final c = context.gym;
    final prioridad = recomendacion.nivelPrioridad;
    final colorAlerta = _getColorPorPrioridad(context, prioridad);
    final intensidadAlerta = _getIntensidadPorPrioridad(prioridad);

    return Container(
      padding: Espaciado.rellenoMd,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorAlerta.withValues(alpha: intensidadAlerta),
            colorAlerta.withValues(alpha: intensidadAlerta * 0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(Espaciado.sm),
        border: Border.all(
          color: colorAlerta.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                recomendacion.emojiAlerta,
                style: const TextStyle(fontSize: 24),
              ),
              SizedBox(width: Espaciado.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      capitalizarPrimeraLetra(recomendacion.nombreMusculo),
                      style: GymType.body.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: c.ink,
                      ),
                    ),
                    SizedBox(height: Espaciado.xxs),
                    Text(
                      recomendacion.mensajeTiempo,
                      style: GymType.label.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: c.ink,
                      ),
                    ),
                  ],
                ),
              ),
              _buildPrioridadBadge(prioridad, colorAlerta),
            ],
          ),
          SizedBox(height: Espaciado.sm),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: c.surface2.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.tips_and_updates,
                  size: 18,
                  color: c.xpInk,
                ),
                SizedBox(width: Espaciado.xs),
                Expanded(
                  child: Text(
                    recomendacion.mensajeRecomendacion,
                    style: GymType.body.copyWith(
                      fontSize: 14,
                      color: c.ink,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (onEntrenarMusculo != null) ...[
            SizedBox(height: Espaciado.sm),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onEntrenarMusculo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorAlerta,
                  padding: EdgeInsets.symmetric(vertical: Espaciado.sm),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.fitness_center, size: 20),
                label: Text(
                  'Entrenar ${recomendacion.nombreMusculo}',
                  style: GymType.body.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPrioridadBadge(int prioridad, Color color) {
    final estrellas = '⭐' * prioridad;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        estrellas,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }

  Color _getColorPorPrioridad(BuildContext context, int prioridad) {
    final c = context.gym;
    switch (prioridad) {
      case 5:
        return c.danger; // Máxima prioridad
      case 4:
        return c.coral; // Alta prioridad
      case 3:
        return c.xpInk; // Media prioridad
      case 2:
        return c.info; // Baja prioridad
      default:
        return c.brand; // Mínima prioridad
    }
  }

  double _getIntensidadPorPrioridad(int prioridad) {
    switch (prioridad) {
      case 5:
        return 0.3;
      case 4:
        return 0.25;
      case 3:
        return 0.2;
      case 2:
        return 0.15;
      default:
        return 0.1;
    }
  }

  Widget _buildBalanceadoState(BuildContext context) {
    final c = context.gym;
    return Container(
      padding: Espaciado.rellenoXl,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            c.brand.withValues(alpha: 0.2),
            c.brand.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(Espaciado.md),
        border: Border.all(
          color: c.brand.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '💪',
            style: TextStyle(fontSize: 64),
          ),
          SizedBox(height: Espaciado.md),
          Text(
            '¡Entrenamiento Balanceado!',
            style: GymType.body.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: c.brandInk,
            ),
          ),
          SizedBox(height: Espaciado.xs),
          Text(
            'Estás trabajando todos los grupos musculares de manera equilibrada',
            style: GymType.label.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: c.ink,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: Espaciado.md),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: c.surface2.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: c.brand, size: 20),
                SizedBox(width: Espaciado.xs),
                Text(
                  'Mantén esta consistencia',
                  style: GymType.body.copyWith(
                    fontSize: 14,
                    color: c.ink,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
