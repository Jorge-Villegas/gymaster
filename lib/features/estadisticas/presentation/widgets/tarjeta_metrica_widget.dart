import 'package:flutter/material.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';
import 'package:gymaster/core/theme/gym_typography.dart';
import 'package:gymaster/core/theme/espaciado.dart';

/// Tarjeta de métrica con icono, valor principal y cambio porcentual.
///
/// Diseñada siguiendo el sistema de colores HSB y tipografía de GyMaster.
class TarjetaMetricaWidget extends StatelessWidget {
  final IconData icono;
  final String valor;
  final String etiqueta;
  final Color? colorIcono;
  final double? porcentajeCambio;
  final String? subvalor;

  const TarjetaMetricaWidget({
    super.key,
    required this.icono,
    required this.valor,
    required this.etiqueta,
    this.colorIcono,
    this.porcentajeCambio,
    this.subvalor,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.gym;
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 220,
      ),
      child: Container(
        padding: Espaciado.rellenoSm,
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: c.line,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: (colorIcono ?? c.brand).withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          spacing: Espaciado.sm,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              etiqueta,
              style: GymType.label.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: c.muted,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Etiqueta arriba
                      SizedBox(height: Espaciado.xxs),
                      Text(
                        valor,
                        style: GymType.number.copyWith(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: c.ink,
                          height: 1.0,
                          letterSpacing: -0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (subvalor != null) ...[
                        Text(
                          subvalor!,
                          style: GymType.label.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: c.faint,
                            height: 1.2,
                          ),
                        ),
                      ],
                      if (porcentajeCambio != null) ...[
                        SizedBox(height: Espaciado.xs),
                        _buildTendencia(context),
                      ],
                    ],
                  ),
                ),
                SizedBox(width: Espaciado.xxs),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: (colorIcono ?? c.brand).withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icono,
                    color: colorIcono ?? c.brand,
                    size: 28,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTendencia(BuildContext context) {
    final c = context.gym;
    final esPositivo = porcentajeCambio! >= 0;
    final color = esPositivo ? c.brand : c.danger;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            esPositivo ? Icons.arrow_upward : Icons.arrow_downward,
            size: 12,
            color: color,
          ),
          SizedBox(width: 2),
          Text(
            '${porcentajeCambio!.abs().toStringAsFixed(0)}%',
            style: GymType.label.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
