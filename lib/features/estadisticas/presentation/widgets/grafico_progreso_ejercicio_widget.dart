import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';
import 'package:gymaster/core/theme/gym_typography.dart';
import 'package:gymaster/core/theme/espaciado.dart';
import 'package:gymaster/features/estadisticas/domain/entities/progreso_ejercicio.dart';
import 'package:gymaster/features/estadisticas/domain/entities/tendencia_progreso.dart';
import 'package:intl/intl.dart';

/// Gráfico de líneas para mostrar el progreso de un ejercicio a lo largo del tiempo.
///
/// Muestra peso máximo y volumen total con diferentes colores según la tendencia.
/// Implementa interactividad con tooltips personalizados y zoom.
class GraficoProgresoEjercicioWidget extends StatefulWidget {
  final ProgresoEjercicio progreso;
  final bool mostrarPeso;
  final bool mostrarVolumen;

  const GraficoProgresoEjercicioWidget({
    super.key,
    required this.progreso,
    this.mostrarPeso = true,
    this.mostrarVolumen = true,
  });

  @override
  State<GraficoProgresoEjercicioWidget> createState() =>
      _GraficoProgresoEjercicioWidgetState();
}

class _GraficoProgresoEjercicioWidgetState
    extends State<GraficoProgresoEjercicioWidget> {
  int? _touchedIndex;

  @override
  Widget build(BuildContext context) {
    final c = context.gym;
    if (widget.progreso.puntosProgreso.isEmpty) {
      return _buildEmptyState();
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
          _buildHeader(),
          SizedBox(height: Espaciado.md),
          _buildLegend(),
          SizedBox(height: Espaciado.md),
          SizedBox(
            height: 250,
            child: LineChart(
              _buildLineChartData(),
              duration: const Duration(milliseconds: 250),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final c = context.gym;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            widget.progreso.nombreEjercicio,
            style: GymType.body.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: c.ink,
            ),
          ),
        ),
        _buildTendenciaChip(),
      ],
    );
  }

  Widget _buildTendenciaChip() {
    final c = context.gym;
    final tendencia = widget.progreso.tendencia;
    Color colorTexto;

    switch (tendencia) {
      case TendenciaProgreso.mejorando:
        colorTexto = c.brand;
        break;
      case TendenciaProgreso.estable:
        colorTexto = c.info;
        break;
      case TendenciaProgreso.decayendo:
        colorTexto = c.danger;
        break;
      case TendenciaProgreso.insuficienteDatos:
        colorTexto = c.faint;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colorTexto.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tendencia.simbolo,
            style: const TextStyle(fontSize: 14),
          ),
          SizedBox(width: Espaciado.xxs),
          Text(
            _getTendenciaLabel(tendencia),
            style: GymType.label.copyWith(
              fontSize: 14,
              color: colorTexto,
            ),
          ),
        ],
      ),
    );
  }

  String _getTendenciaLabel(TendenciaProgreso tendencia) {
    switch (tendencia) {
      case TendenciaProgreso.mejorando:
        return 'Mejorando';
      case TendenciaProgreso.estable:
        return 'Estable';
      case TendenciaProgreso.decayendo:
        return 'Bajando';
      case TendenciaProgreso.insuficienteDatos:
        return 'Insuficientes datos';
    }
  }

  Widget _buildLegend() {
    final c = context.gym;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.mostrarPeso) ...[
          _buildLegendItem('Peso máximo', c.brand),
          SizedBox(width: Espaciado.md),
        ],
        if (widget.mostrarVolumen)
          _buildLegendItem('Volumen total', c.info),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    final c = context.gym;
    return Row(
      children: [
        Container(
          width: 16,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: Espaciado.xs),
        Text(
          label,
          style: GymType.label.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: c.muted,
          ),
        ),
      ],
    );
  }

  LineChartData _buildLineChartData() {
    final c = context.gym;
    final puntos = widget.progreso.puntosProgreso;
    final pesoSpots = <FlSpot>[];
    final volumenSpots = <FlSpot>[];

    for (int i = 0; i < puntos.length; i++) {
      final punto = puntos[i];
      if (widget.mostrarPeso) {
        pesoSpots.add(FlSpot(i.toDouble(), punto.pesoMaximo));
      }
      if (widget.mostrarVolumen) {
        // Normalizar volumen para visualización (dividir por 100 para escala)
        volumenSpots.add(FlSpot(i.toDouble(), punto.volumenTotal / 100));
      }
    }

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: c.line,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (value, meta) {
              if (value.toInt() >= 0 && value.toInt() < puntos.length) {
                final fecha = puntos[value.toInt()].fecha;
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    DateFormat('dd/MM').format(fecha),
                    style: GymType.label.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: c.muted,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toInt().toString(),
                style: GymType.label.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: c.muted,
                ),
              );
            },
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        if (widget.mostrarPeso)
          LineChartBarData(
            spots: pesoSpots,
            isCurved: true,
            color: c.brand,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: _touchedIndex == index ? 6 : 4,
                  color: c.brand,
                  strokeWidth: 2,
                  strokeColor: c.surface,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: c.brand.withValues(alpha: 0.1),
            ),
          ),
        if (widget.mostrarVolumen)
          LineChartBarData(
            spots: volumenSpots,
            isCurved: true,
            color: c.info,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: _touchedIndex == index ? 6 : 4,
                  color: c.info,
                  strokeWidth: 2,
                  strokeColor: c.surface,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: c.info.withValues(alpha: 0.1),
            ),
          ),
      ],
      lineTouchData: LineTouchData(
        enabled: true,
        touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
          setState(() {
            if (touchResponse == null || touchResponse.lineBarSpots == null) {
              _touchedIndex = null;
            } else {
              _touchedIndex = touchResponse.lineBarSpots!.first.spotIndex;
            }
          });
        },
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (spot) => c.surface2,
          tooltipBorder: BorderSide(color: c.line, width: 1),
          tooltipPadding: const EdgeInsets.all(8),
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((spot) {
              final punto = puntos[spot.spotIndex];
              final esPeso = spot.barIndex == 0 && widget.mostrarPeso;

              return LineTooltipItem(
                esPeso
                    ? '${punto.pesoMaximo.toStringAsFixed(1)} kg'
                    : '${punto.volumenTotal.toStringAsFixed(0)} kg',
                GymType.body.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: esPeso ? c.brand : c.info,
                ),
                children: [
                  TextSpan(
                    text: '\n${DateFormat('dd/MM/yyyy').format(punto.fecha)}',
                    style: GymType.label.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: c.muted,
                    ),
                  ),
                  TextSpan(
                    text:
                        '\n${punto.totalSeries} series • ${punto.totalRepeticiones} reps',
                    style: GymType.label.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: c.muted,
                    ),
                  ),
                ],
              );
            }).toList();
          },
        ),
      ),
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
            IconsaxPlusLinear.chart_2,
            size: 64,
            color: c.faint,
          ),
          SizedBox(height: Espaciado.md),
          Text(
            'Sin datos de progreso',
            style: GymType.body.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: c.muted,
            ),
          ),
          SizedBox(height: Espaciado.xs),
          Text(
            'Completa entrenamientos para ver tu progreso',
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
