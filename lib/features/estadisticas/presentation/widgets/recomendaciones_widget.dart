import 'package:flutter/material.dart';
import 'package:gymaster/core/theme/app_colors.dart';
import 'package:gymaster/core/theme/espaciado.dart';
import 'package:gymaster/core/theme/tipografia_gymaster.dart';
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
    if (recomendaciones.isEmpty) {
      return _buildBalanceadoState();
    }

    return Container(
      padding: Espaciado.rellenoMd,
      decoration: BoxDecoration(
        color: AppColors.fondoTarjeta,
        borderRadius: BorderRadius.circular(Espaciado.md),
        border:
            Border.all(color: AppColors.borde.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: AppColors.acento,
                size: 24,
              ),
              SizedBox(width: Espaciado.xs),
              Text(
                'Recomendaciones',
                style: TipografiaGyMaster.textoPrincipal.copyWith(
                  fontSize: TipografiaGyMaster.tamanoLg,
                  fontWeight: TipografiaGyMaster.pesoSemiBold,
                  color: AppColors.textoPrincipal,
                ),
              ),
            ],
          ),
          SizedBox(height: Espaciado.md),
          ...recomendaciones.map((recomendacion) {
            return Padding(
              padding: EdgeInsets.only(bottom: Espaciado.sm),
              child: _buildRecomendacionCard(recomendacion),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRecomendacionCard(RecomendacionMuscular recomendacion) {
    final prioridad = recomendacion.nivelPrioridad;
    final colorAlerta = _getColorPorPrioridad(prioridad);
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
                style: TextStyle(fontSize: TipografiaGyMaster.tamano2xl),
              ),
              SizedBox(width: Espaciado.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      capitalizarPrimeraLetra(recomendacion.nombreMusculo),
                      style: TipografiaGyMaster.textoPrincipal.copyWith(
                        fontSize: TipografiaGyMaster.tamanoLg,
                        fontWeight: TipografiaGyMaster.pesoSemiBold,
                        color: colorAlerta,
                      ),
                    ),
                    SizedBox(height: Espaciado.xxs),
                    Text(
                      recomendacion.mensajeTiempo,
                      style: TipografiaGyMaster.textoSecundario.copyWith(
                        fontSize: TipografiaGyMaster.tamanoSm,
                        color: AppColors.textoPrincipal,
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
              color: AppColors.fondoSecundario.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.tips_and_updates,
                  size: 18,
                  color: AppColors.acento,
                ),
                SizedBox(width: Espaciado.xs),
                Expanded(
                  child: Text(
                    recomendacion.mensajeRecomendacion,
                    style: TipografiaGyMaster.textoPrincipal.copyWith(
                      fontSize: TipografiaGyMaster.tamanoSm,
                      color: AppColors.textoPrincipal,
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
                  style: TipografiaGyMaster.textoPrincipal.copyWith(
                    fontSize: TipografiaGyMaster.tamanoSm,
                    fontWeight: TipografiaGyMaster.pesoSemiBold,
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
        style: TextStyle(fontSize: TipografiaGyMaster.tamanoSm),
      ),
    );
  }

  Color _getColorPorPrioridad(int prioridad) {
    switch (prioridad) {
      case 5:
        return AppColors.error; // Máxima prioridad
      case 4:
        return AppColors.advertencia; // Alta prioridad
      case 3:
        return AppColors.acento; // Media prioridad
      case 2:
        return AppColors.informacion; // Baja prioridad
      default:
        return AppColors.exito; // Mínima prioridad
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

  Widget _buildBalanceadoState() {
    return Container(
      padding: Espaciado.rellenoXl,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.exito.withValues(alpha: 0.2),
            AppColors.exito.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(Espaciado.md),
        border: Border.all(
          color: AppColors.exito.withValues(alpha: 0.3),
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
            style: TipografiaGyMaster.textoPrincipal.copyWith(
              fontSize: TipografiaGyMaster.tamanoXl,
              fontWeight: TipografiaGyMaster.pesoSemiBold,
              color: AppColors.exito,
            ),
          ),
          SizedBox(height: Espaciado.xs),
          Text(
            'Estás trabajando todos los grupos musculares de manera equilibrada',
            style: TipografiaGyMaster.textoSecundario.copyWith(
              fontSize: TipografiaGyMaster.tamanoMd,
              color: AppColors.textoPrincipal,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: Espaciado.md),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.fondoSecundario.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: AppColors.exito, size: 20),
                SizedBox(width: Espaciado.xs),
                Text(
                  'Mantén esta consistencia',
                  style: TipografiaGyMaster.textoPrincipal.copyWith(
                    fontSize: TipografiaGyMaster.tamanoSm,
                    color: AppColors.textoPrincipal,
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
