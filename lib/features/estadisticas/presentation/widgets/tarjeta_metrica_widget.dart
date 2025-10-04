import 'package:flutter/material.dart';
import 'package:gymaster/core/theme/app_colors.dart';
import 'package:gymaster/core/theme/espaciado.dart';
import 'package:gymaster/core/theme/tipografia_gymaster.dart';

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
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 220,
      ),
      child: Container(
        padding: Espaciado.rellenoSm,
        decoration: BoxDecoration(
          color: AppColors.fondoTarjetaClaro,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.borde.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: (colorIcono ?? AppColors.primario).withValues(alpha: 0.08),
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
              style: TextStyle(
                fontSize: TipografiaGyMaster.tamanoXs,
                fontWeight: TipografiaGyMaster.pesoRegular,
                color: AppColors.textoSecundarioOscuro,
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
                        style: TextStyle(
                          fontSize: TipografiaGyMaster.tamano3xl,
                          fontWeight: TipografiaGyMaster.pesoSemiBold,
                          color: AppColors.textoPrincipalOscuro,
                          height: 1.0,
                          letterSpacing: -0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (subvalor != null) ...[
                        Text(
                          subvalor!,
                          style: TextStyle(
                            fontSize: TipografiaGyMaster.tamanoXs,
                            fontWeight: TipografiaGyMaster.pesoRegular,
                            color: AppColors.textoTerciarioOscuro,
                            height: 1.2,
                          ),
                        ),
                      ],
                      if (porcentajeCambio != null) ...[
                        SizedBox(height: Espaciado.xs),
                        _buildTendencia(),
                      ],
                    ],
                  ),
                ),
                SizedBox(width: Espaciado.xxs),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: (colorIcono ?? AppColors.primario)
                        .withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icono,
                    color: colorIcono ?? AppColors.primario,
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

  Widget _buildTendencia() {
    final esPositivo = porcentajeCambio! >= 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: esPositivo
            ? AppColors.exito.withValues(alpha: 0.15)
            : AppColors.error.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            esPositivo ? Icons.arrow_upward : Icons.arrow_downward,
            size: 12,
            color: esPositivo ? AppColors.exito : AppColors.error,
          ),
          SizedBox(width: 2),
          Text(
            '${porcentajeCambio!.abs().toStringAsFixed(0)}%',
            style: TextStyle(
              fontSize: TipografiaGyMaster.tamanoXs,
              fontWeight: TipografiaGyMaster.pesoSemiBold,
              color: esPositivo ? AppColors.exito : AppColors.error,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
