import 'package:flutter/material.dart';
import 'package:gymaster/core/theme/app_colors.dart';
import 'package:gymaster/core/theme/espaciado.dart';
import 'package:gymaster/core/theme/tipografia_gymaster.dart';
import 'package:gymaster/features/estadisticas/domain/entities/ranking_ejercicio.dart';
import 'package:gymaster/shared/utils/string_utils.dart';

/// Widget que muestra el ranking de ejercicios más realizados con podio visual.
///
/// Destaca los top 3 con emojis de medallas y muestra estadísticas detalladas.
class RankingEjerciciosWidget extends StatelessWidget {
  final List<RankingEjercicio> ranking;
  final VoidCallback? onVerMas;

  const RankingEjerciciosWidget({
    super.key,
    required this.ranking,
    this.onVerMas,
  });

  @override
  Widget build(BuildContext context) {
    if (ranking.isEmpty) {
      return _buildEmptyState();
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ejercicios Favoritos',
                style: TipografiaGyMaster.textoPrincipal.copyWith(
                  fontSize: TipografiaGyMaster.tamanoLg,
                  fontWeight: TipografiaGyMaster.pesoSemiBold,
                  color: AppColors.textoPrincipal,
                ),
              ),
              if (onVerMas != null && ranking.length > 5)
                TextButton(
                  onPressed: onVerMas,
                  child: Text(
                    'Ver más',
                    style: TipografiaGyMaster.textoPrincipal.copyWith(
                      fontSize: TipografiaGyMaster.tamanoSm,
                      color: AppColors.primario,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: Espaciado.md),
          ...ranking.take(10).map((ejercicio) {
            return Padding(
              padding: EdgeInsets.only(bottom: Espaciado.sm),
              child: _buildRankingItem(ejercicio),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRankingItem(RankingEjercicio ejercicio) {
    final esTopTres = ejercicio.posicion <= 3;
    final colorPosicion = _getColorPorPosicion(ejercicio.posicion);

    return Container(
      padding: Espaciado.rellenoSm,
      decoration: BoxDecoration(
        color: esTopTres
            ? colorPosicion.withValues(alpha: 0.1)
            : AppColors.fondoSecundario,
        borderRadius: BorderRadius.circular(Espaciado.sm),
        border: esTopTres
            ? Border.all(color: colorPosicion.withValues(alpha: 0.3), width: 1)
            : null,
      ),
      child: Row(
        children: [
          // Posición con emoji o número
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: esTopTres ? colorPosicion : AppColors.fondoSecundario,
              shape: BoxShape.circle,
              boxShadow: esTopTres
                  ? [
                      BoxShadow(
                        color: colorPosicion.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                ejercicio.emojiPosicion,
                style: TextStyle(
                  fontSize: esTopTres
                      ? TipografiaGyMaster.tamanoLg
                      : TipografiaGyMaster.tamanoMd,
                ),
              ),
            ),
          ),
          SizedBox(width: Espaciado.sm),

          // Información del ejercicio
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  capitalizarPrimeraLetra(ejercicio.nombreEjercicio),
                  style: TipografiaGyMaster.textoPrincipal.copyWith(
                    fontSize: TipografiaGyMaster.tamanoMd,
                    fontWeight: TipografiaGyMaster.pesoSemiBold,
                    color: AppColors.textoPrincipal,
                  ),
                ),
                SizedBox(height: Espaciado.xxs),
                Text(
                  ejercicio.resumenCompacto,
                  style: TipografiaGyMaster.textoSecundario.copyWith(
                    fontSize: TipografiaGyMaster.tamanoXs,
                    color: AppColors.textoSecundario,
                  ),
                ),
              ],
            ),
          ),

          // Badge de frecuencia
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primario.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  '${ejercicio.vecesRealizado}x',
                  style: TipografiaGyMaster.textoPrincipal.copyWith(
                    fontSize: TipografiaGyMaster.tamanoLg,
                    fontWeight: TipografiaGyMaster.pesoSemiBold,
                    color: AppColors.primario,
                  ),
                ),
                Text(
                  'veces',
                  style: TipografiaGyMaster.textoSecundario.copyWith(
                    fontSize: TipografiaGyMaster.tamanoXs,
                    color: AppColors.textoSecundario,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorPorPosicion(int posicion) {
    switch (posicion) {
      case 1:
        return Colors.amber.shade300;
      case 2:
        return Colors.blueGrey.shade300;
      case 3:
        return const Color(0xFFCD7F32);
      default:
        return AppColors.primario;
    }
  }

  Widget _buildEmptyState() {
    return Container(
      padding: Espaciado.rellenoXl,
      decoration: BoxDecoration(
        color: AppColors.fondoTarjeta,
        borderRadius: BorderRadius.circular(Espaciado.md),
        border:
            Border.all(color: AppColors.borde.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_events_outlined,
            size: 64,
            color: AppColors.textoTerciario,
          ),
          SizedBox(height: Espaciado.md),
          Text(
            'Sin ranking aún',
            style: TipografiaGyMaster.textoPrincipal.copyWith(
              fontSize: TipografiaGyMaster.tamanoLg,
              fontWeight: TipografiaGyMaster.pesoSemiBold,
              color: AppColors.textoSecundario,
            ),
          ),
          SizedBox(height: Espaciado.xs),
          Text(
            'Completa entrenamientos para ver tus ejercicios favoritos',
            style: TipografiaGyMaster.textoSecundario.copyWith(
              fontSize: TipografiaGyMaster.tamanoSm,
              color: AppColors.textoTerciario,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
