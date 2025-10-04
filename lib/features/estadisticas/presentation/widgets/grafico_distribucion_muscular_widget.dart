import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gymaster/core/theme/app_colors.dart';
import 'package:gymaster/core/theme/espaciado.dart';
import 'package:gymaster/core/theme/tipografia_gymaster.dart';
import 'package:gymaster/features/estadisticas/domain/entities/distribucion_muscular.dart';
import 'package:gymaster/shared/utils/string_utils.dart';

/// Gráfico de pastel para mostrar la distribución del volumen de entrenamiento
/// por grupo muscular.
///
/// Incluye interactividad con touch para expandir secciones y leyenda con colores.
class GraficoDistribucionMuscularWidget extends StatefulWidget {
  final List<DistribucionMuscular> distribucion;
  final bool mostrarLeyenda;

  const GraficoDistribucionMuscularWidget({
    super.key,
    required this.distribucion,
    this.mostrarLeyenda = true,
  });

  @override
  State<GraficoDistribucionMuscularWidget> createState() =>
      _GraficoDistribucionMuscularWidgetState();
}

class _GraficoDistribucionMuscularWidgetState
    extends State<GraficoDistribucionMuscularWidget> {
  int? _touchedIndex;

  static const List<Color> _coloresMusculares = [
    AppColors.primario,
    AppColors.acento,
    AppColors.secundario,
    AppColors.exito,
    AppColors.error,
    AppColors.advertencia,
    AppColors.informacion,
    AppColors.primarioCalido,
  ];

  @override
  Widget build(BuildContext context) {
    if (widget.distribucion.isEmpty) {
      return _buildEmptyState();
    }

    return SingleChildScrollView(
      child: Container(
        padding: Espaciado.rellenoMd,
        decoration: BoxDecoration(
          color: AppColors.fondoTarjeta,
          borderRadius: BorderRadius.circular(Espaciado.md),
          border: Border.all(
              color: AppColors.borde.withValues(alpha: 0.2), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Distribución por Grupo Muscular',
              style: TipografiaGyMaster.textoPrincipal.copyWith(
                fontSize: TipografiaGyMaster.tamanoLg,
                fontWeight: TipografiaGyMaster.pesoSemiBold,
                color: AppColors.textoPrincipal,
              ),
            ),
            SizedBox(height: Espaciado.md),
            AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                _buildPieChartData(),
                swapAnimationDuration: const Duration(milliseconds: 300),
                swapAnimationCurve: Curves.easeInOutQuart,
              ),
            ),
            if (widget.mostrarLeyenda) ...[
              SizedBox(height: Espaciado.md),
              _buildLeyenda(),
            ],
          ],
        ),
      ),
    );
  }

  PieChartData _buildPieChartData() {
    return PieChartData(
      pieTouchData: PieTouchData(
        touchCallback: (FlTouchEvent event, pieTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                pieTouchResponse == null ||
                pieTouchResponse.touchedSection == null) {
              _touchedIndex = null;
              return;
            }
            _touchedIndex =
                pieTouchResponse.touchedSection!.touchedSectionIndex;
          });
        },
      ),
      borderData: FlBorderData(show: false),
      sectionsSpace: 2,
      centerSpaceRadius: 40,
      sections: _buildSections(),
    );
  }

  List<PieChartSectionData> _buildSections() {
    return List.generate(widget.distribucion.length, (index) {
      final isTouched = index == _touchedIndex;
      final musculo = widget.distribucion[index];
      final color = _coloresMusculares[index % _coloresMusculares.length];

      final fontSize =
          isTouched ? TipografiaGyMaster.tamanoMd : TipografiaGyMaster.tamanoSm;
      final radius = isTouched ? 65.0 : 55.0;
      final widgetSize = isTouched ? 55.0 : 45.0;

      return PieChartSectionData(
        color: color,
        value: musculo.porcentajeDistribucion,
        title: '${musculo.porcentajeDistribucion.toStringAsFixed(1)}%',
        radius: radius,
        titleStyle: TipografiaGyMaster.textoPrincipal.copyWith(
          fontSize: fontSize,
          fontWeight: TipografiaGyMaster.pesoSemiBold,
          color: AppColors.fondoTarjeta,
        ),
        badgeWidget:
            isTouched ? _buildBadge(musculo.nombreMusculo, widgetSize) : null,
        badgePositionPercentageOffset: 1.3,
      );
    });
  }

  Widget _buildBadge(String nombreMusculo, double size) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.fondoTarjeta,
        borderRadius: BorderRadius.circular(8),
        border:
            Border.all(color: AppColors.borde.withValues(alpha: 0.3), width: 1),
      ),
      child: Text(
        nombreMusculo,
        style: TipografiaGyMaster.textoPrincipal.copyWith(
          fontSize: TipografiaGyMaster.tamanoXs,
          fontWeight: TipografiaGyMaster.pesoSemiBold,
          color: AppColors.textoPrincipal,
        ),
      ),
    );
  }

  Widget _buildLeyenda() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 3.5,
      ),
      itemCount: widget.distribucion.length,
      itemBuilder: (context, index) {
        final musculo = widget.distribucion[index];
        final color = _coloresMusculares[index % _coloresMusculares.length];
        return Padding(
          padding: EdgeInsets.only(bottom: Espaciado.xs),
          child: _buildLeyendaItem(
            musculo.nombreMusculo,
            musculo.porcentajeDistribucion,
            musculo.volumenFormateado,
            musculo.categoriaIntensidad,
            color,
          ),
        );
      },
    );
  }

  Widget _buildLeyendaItem(
    String nombreMusculo,
    double porcentaje,
    String volumenFormateado,
    String categoriaIntensidad,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: Espaciado.xs),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                capitalizarPrimeraLetra(nombreMusculo),
                style: TipografiaGyMaster.textoPrincipal.copyWith(
                  fontSize: TipografiaGyMaster.tamanoSm,
                  fontWeight: TipografiaGyMaster.pesoSemiBold,
                  color: AppColors.textoPrincipal,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Text(
                '$volumenFormateado • $categoriaIntensidad',
                style: TipografiaGyMaster.textoSecundario.copyWith(
                  fontSize: TipografiaGyMaster.tamanoXs,
                  color: AppColors.textoSecundario,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ],
    );
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
            Icons.pie_chart_outline_outlined,
            size: 64,
            color: AppColors.textoTerciario,
          ),
          SizedBox(height: Espaciado.md),
          Text(
            'Sin datos de distribución',
            style: TipografiaGyMaster.textoPrincipal.copyWith(
              fontSize: TipografiaGyMaster.tamanoLg,
              fontWeight: TipografiaGyMaster.pesoSemiBold,
              color: AppColors.textoSecundario,
            ),
          ),
          SizedBox(height: Espaciado.xs),
          Text(
            'Entrena diferentes grupos musculares para ver la distribución',
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
