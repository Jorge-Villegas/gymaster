import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gymaster/core/theme/app_colors.dart';
import 'package:gymaster/core/theme/espaciado.dart';
import 'package:gymaster/core/theme/tipografia_gymaster.dart';
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
    if (widget.progreso.puntosProgreso.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      padding: Espaciado.rellenoMd,
      decoration: BoxDecoration(
        color: AppColors.fondoTarjetaClaro,
        borderRadius: BorderRadius.circular(Espaciado.md),
        border:
            Border.all(color: AppColors.borde.withValues(alpha: 0.2), width: 1),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            widget.progreso.nombreEjercicio,
            style: TipografiaGyMaster.textoPrincipal.copyWith(
              fontSize: TipografiaGyMaster.tamanoLg,
              fontWeight: TipografiaGyMaster.pesoSemiBold,
              color: AppColors.textoPrincipalOscuro,
            ),
          ),
        ),
        _buildTendenciaChip(),
      ],
    );
  }

  Widget _buildTendenciaChip() {
    final tendencia = widget.progreso.tendencia;
    Color colorFondo;
    Color colorTexto;

    switch (tendencia) {
      case TendenciaProgreso.mejorando:
        colorFondo = AppColors.exito.withValues(alpha: 0.2);
        colorTexto = AppColors.exito;
        break;
      case TendenciaProgreso.estable:
        colorFondo = AppColors.informacion.withValues(alpha: 0.2);
        colorTexto = AppColors.informacion;
        break;
      case TendenciaProgreso.decayendo:
        colorFondo = AppColors.error.withValues(alpha: 0.2);
        colorTexto = AppColors.error;
        break;
      case TendenciaProgreso.insuficienteDatos:
        colorFondo = AppColors.textoSecundario.withValues(alpha: 0.2);
        colorTexto = AppColors.textoSecundario;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colorFondo,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tendencia.simbolo,
            style: TextStyle(fontSize: TipografiaGyMaster.tamanoSm),
          ),
          SizedBox(width: Espaciado.xxs),
          Text(
            _getTendenciaLabel(tendencia),
            style: TipografiaGyMaster.textoPrincipal.copyWith(
              fontSize: TipografiaGyMaster.tamanoSm,
              fontWeight: TipografiaGyMaster.pesoSemiBold,
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.mostrarPeso) ...[
          _buildLegendItem('Peso máximo', AppColors.primario),
          SizedBox(width: Espaciado.md),
        ],
        if (widget.mostrarVolumen)
          _buildLegendItem('Volumen total', AppColors.acento),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
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
          style: TipografiaGyMaster.textoSecundario.copyWith(
            fontSize: TipografiaGyMaster.tamanoSm,
            color: AppColors.textoSecundarioOscuro,
          ),
        ),
      ],
    );
  }

  LineChartData _buildLineChartData() {
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
            color: AppColors.borde.withValues(alpha: 0.3),
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
                    style: TipografiaGyMaster.textoSecundario.copyWith(
                      fontSize: TipografiaGyMaster.tamanoXs,
                      color: AppColors.textoSecundarioOscuro,
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
                style: TipografiaGyMaster.textoSecundario.copyWith(
                  fontSize: TipografiaGyMaster.tamanoXs,
                  color: AppColors.textoSecundarioOscuro,
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
            color: AppColors.primario,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: _touchedIndex == index ? 6 : 4,
                  color: AppColors.primario,
                  strokeWidth: 2,
                  strokeColor: AppColors.superficie,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.primario.withValues(alpha: 0.1),
            ),
          ),
        if (widget.mostrarVolumen)
          LineChartBarData(
            spots: volumenSpots,
            isCurved: true,
            color: AppColors.acento,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: _touchedIndex == index ? 6 : 4,
                  color: AppColors.acento,
                  strokeWidth: 2,
                  strokeColor: AppColors.superficie,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.acento.withValues(alpha: 0.1),
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
          getTooltipColor: (spot) => AppColors.fondoSecundario,
          tooltipBorder: BorderSide(color: AppColors.borde, width: 1),
          tooltipPadding: const EdgeInsets.all(8),
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((spot) {
              final punto = puntos[spot.spotIndex];
              final esPeso = spot.barIndex == 0 && widget.mostrarPeso;

              return LineTooltipItem(
                esPeso
                    ? '${punto.pesoMaximo.toStringAsFixed(1)} kg'
                    : '${punto.volumenTotal.toStringAsFixed(0)} kg',
                TipografiaGyMaster.textoPrincipal.copyWith(
                  fontSize: TipografiaGyMaster.tamanoSm,
                  fontWeight: TipografiaGyMaster.pesoSemiBold,
                  color: esPeso ? AppColors.primario : AppColors.acento,
                ),
                children: [
                  TextSpan(
                    text: '\n${DateFormat('dd/MM/yyyy').format(punto.fecha)}',
                    style: TipografiaGyMaster.textoSecundario.copyWith(
                      fontSize: TipografiaGyMaster.tamanoXs,
                    ),
                  ),
                  TextSpan(
                    text:
                        '\n${punto.totalSeries} series • ${punto.totalRepeticiones} reps',
                    style: TipografiaGyMaster.textoSecundario.copyWith(
                      fontSize: TipografiaGyMaster.tamanoXs,
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
    return Container(
      padding: Espaciado.rellenoXl,
      decoration: BoxDecoration(
        color: AppColors.fondoTarjetaClaro,
        borderRadius: BorderRadius.circular(Espaciado.md),
        border:
            Border.all(color: AppColors.borde.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.show_chart_outlined,
            size: 64,
            color: AppColors.textoTerciarioOscuro,
          ),
          SizedBox(height: Espaciado.md),
          Text(
            'Sin datos de progreso',
            style: TipografiaGyMaster.textoPrincipal.copyWith(
              fontSize: TipografiaGyMaster.tamanoLg,
              fontWeight: TipografiaGyMaster.pesoSemiBold,
              color: AppColors.textoSecundarioOscuro,
            ),
          ),
          SizedBox(height: Espaciado.xs),
          Text(
            'Completa entrenamientos para ver tu progreso',
            style: TipografiaGyMaster.textoSecundario.copyWith(
              fontSize: TipografiaGyMaster.tamanoSm,
              color: AppColors.textoTerciarioOscuro,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
