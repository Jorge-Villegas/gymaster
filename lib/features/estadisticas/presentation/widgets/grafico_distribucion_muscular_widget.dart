import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';
import 'package:gymaster/core/theme/gym_typography.dart';
import 'package:gymaster/core/theme/espaciado.dart';
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

  // Paleta candy categórica para las porciones del gráfico.
  static const List<Color> _coloresMusculares = [
    Color(0xFF3D5AFE), // cobalto marca
    Color(0xFFFFC531), // dorado XP
    Color(0xFF38B6FF), // azul info
    Color(0xFFFF5470), // coral
    Color(0xFF7B61FF), // plum
    Color(0xFF2FBF5B), // verde éxito
    Color(0xFFE0A800), // dorado oscuro
    Color(0xFF54BEFF), // azul claro
  ];

  @override
  Widget build(BuildContext context) {
    final c = context.gym;
    if (widget.distribucion.isEmpty) {
      return _buildEmptyState();
    }

    return SingleChildScrollView(
      child: Container(
        padding: Espaciado.rellenoMd,
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(Espaciado.md),
          border: Border.all(color: c.line, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Distribución por Grupo Muscular',
              style: GymType.body.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: c.ink,
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

      final fontSize = isTouched ? 16.0 : 14.0;
      final radius = isTouched ? 65.0 : 55.0;
      final widgetSize = isTouched ? 55.0 : 45.0;

      return PieChartSectionData(
        color: color,
        value: musculo.porcentajeDistribucion,
        title: '${musculo.porcentajeDistribucion.toStringAsFixed(1)}%',
        radius: radius,
        titleStyle: GymType.body.copyWith(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        badgeWidget:
            isTouched ? _buildBadge(musculo.nombreMusculo, widgetSize) : null,
        badgePositionPercentageOffset: 1.3,
      );
    });
  }

  Widget _buildBadge(String nombreMusculo, double size) {
    final c = context.gym;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: c.line, width: 1),
      ),
      child: Text(
        nombreMusculo,
        style: GymType.body.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: c.ink,
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
    final c = context.gym;
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
                style: GymType.body.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: c.ink,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Text(
                '$volumenFormateado • $categoriaIntensidad',
                style: GymType.label.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: c.muted,
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
    final c = context.gym;
    return Container(
      padding: Espaciado.rellenoXl,
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(Espaciado.md),
        border: Border.all(color: c.line, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            IconsaxPlusLinear.chart,
            size: 64,
            color: c.faint,
          ),
          SizedBox(height: Espaciado.md),
          Text(
            'Sin datos de distribución',
            style: GymType.body.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: c.muted,
            ),
          ),
          SizedBox(height: Espaciado.xs),
          Text(
            'Entrena diferentes grupos musculares para ver la distribución',
            style: GymType.label.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: c.faint,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
