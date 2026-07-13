import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';
import 'package:gymaster/core/theme/espaciado.dart';
import 'package:gymaster/core/theme/tipografia_gymaster.dart';
import 'package:gymaster/features/estadisticas/presentation/cubits/estadisticas_cubit.dart';
import 'package:gymaster/features/estadisticas/presentation/cubits/estadisticas_state.dart';
import 'package:gymaster/features/estadisticas/presentation/widgets/grafico_distribucion_muscular_widget.dart';
import 'package:gymaster/features/estadisticas/presentation/widgets/ranking_ejercicios_widget.dart';
import 'package:gymaster/features/estadisticas/presentation/widgets/recomendaciones_widget.dart';
import 'package:gymaster/features/estadisticas/presentation/widgets/selector_periodo_widget.dart';
import 'package:gymaster/features/estadisticas/presentation/widgets/tarjeta_metrica_widget.dart';
import 'package:gymaster/shared/widgets/chiclet_button.dart';

/// Página principal de estadísticas con visualizaciones interactivas.
///
/// Integra todos los widgets de estadísticas y maneja el estado con Cubit.
class EstadisticasPage extends StatelessWidget {
  const EstadisticasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocBuilder<EstadisticasCubit, EstadisticasState>(
        builder: (context, state) {
          return switch (state) {
            EstadisticasInitial() => _buildLoadingWidget(context),
            EstadisticasLoading() => _buildLoadingWidget(context),
            EstadisticasLoaded() => _buildLoadedContent(context, state),
            EstadisticasEmpty() => _buildEmptyState(context, state.message),
            EstadisticasError() => _buildErrorState(context, state.message),
          };
        },
      ),
    );
  }

  Widget _buildLoadingWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: context.gym.brand),
          SizedBox(height: Espaciado.md),
          Text(
            'Analizando tus entrenamientos...',
            style: TipografiaGyMaster.textoSecundario.copyWith(
              fontSize: TipografiaGyMaster.tamanoMd,
              color: context.gym.muted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedContent(BuildContext context, EstadisticasLoaded state) {
    final c = context.gym;
    final cubit = context.read<EstadisticasCubit>();
    final resumen = state.resumenGeneral;

    return RefreshIndicator(
      onRefresh: () async {
        await cubit.recargarEstadisticas();
      },
      color: c.brand,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: Espaciado.rellenoMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selector de periodo
            SelectorPeriodoWidget(
              periodoSeleccionado: state.periodoSeleccionado,
              onPeriodoSeleccionado: (periodo) {
                cubit.cambiarPeriodo(periodo);
              },
            ),
            SizedBox(height: Espaciado.lg),

            // Tarjetas de métricas generales
            _buildSeccionMetricas(context, resumen),
            SizedBox(height: Espaciado.lg),

            // Distribución muscular
            if (state.distribucionMuscular.isNotEmpty) ...[
              GraficoDistribucionMuscularWidget(
                distribucion: state.distribucionMuscular,
              ),
              SizedBox(height: Espaciado.lg),
            ],

            // Ranking de ejercicios
            if (state.rankingEjercicios.isNotEmpty) ...[
              RankingEjerciciosWidget(
                ranking: state.rankingEjercicios,
              ),
              SizedBox(height: Espaciado.lg),
            ],

            // Recomendaciones de músculos olvidados
            if (state.musculosOlvidados.isNotEmpty) ...[
              RecomendacionesWidget(
                recomendaciones: state.musculosOlvidados,
                onEntrenarMusculo: () {
                  // TODO: Navegar a crear rutina con el músculo seleccionado
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Funcionalidad próximamente',
                        style: TipografiaGyMaster.textoPrincipal.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: c.info,
                    ),
                  );
                },
              ),
              SizedBox(height: Espaciado.lg),
            ],

            // Gráfico de progreso del ejercicio más realizado
            if (state.rankingEjercicios.isNotEmpty) ...[
              _buildSeccionProgresoEjercicio(context, state),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSeccionMetricas(BuildContext context, dynamic resumen) {
    final c = context.gym;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Resumen del Periodo',
          style: TextStyle(
            fontSize: TipografiaGyMaster.tamanoLg,
            fontWeight: TipografiaGyMaster.pesoSemiBold,
            color: c.ink,
            height: 1.4,
          ),
        ),
        SizedBox(height: Espaciado.md),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: Espaciado.xs,
          crossAxisSpacing: Espaciado.xs,
          childAspectRatio: 1.40,
          children: [
            TarjetaMetricaWidget(
              icono: Icons.fitness_center,
              valor: '${resumen['total_sesiones'] ?? 0}',
              etiqueta: 'Entrenamientos',
              colorIcono: c.brand,
            ),
            TarjetaMetricaWidget(
              icono: Icons.local_fire_department,
              valor: '${resumen['racha_dias'] ?? 0}',
              etiqueta: 'Racha de días',
              colorIcono: c.coral,
              porcentajeCambio: (resumen['racha_dias'] ?? 0) > 7 ? 15.0 : -5.0,
            ),
            TarjetaMetricaWidget(
              icono: Icons.timer,
              valor: '${((resumen['total_series'] ?? 0) * 3).round()}',
              etiqueta: 'Minutos totales',
              colorIcono: c.info,
              subvalor: 'min',
            ),
            TarjetaMetricaWidget(
              icono: Icons.trending_up,
              valor:
                  '${(resumen['volumen_total'] ?? 0.0).toStringAsFixed(0)} kg',
              etiqueta: 'Volumen total',
              colorIcono: c.xpInk,
              porcentajeCambio: 10.0,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSeccionProgresoEjercicio(
      BuildContext context, EstadisticasLoaded state) {
    final c = context.gym;
    // Mostrar progreso del ejercicio más realizado
    final ejercicioTop = state.rankingEjercicios.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Progreso de ${ejercicioTop.nombreEjercicio}',
          style: TextStyle(
            fontSize: TipografiaGyMaster.tamanoLg,
            fontWeight: TipografiaGyMaster.pesoSemiBold,
            color: c.ink,
            height: 1.4,
          ),
        ),
        SizedBox(height: Espaciado.md),
        // TODO: Cargar progreso específico del ejercicio desde el Cubit
        // Por ahora mostrar placeholder
        Container(
          height: 300,
          padding: Espaciado.rellenoMd,
          decoration: BoxDecoration(
            color: c.surface2,
            borderRadius: BorderRadius.circular(Espaciado.md),
            border: Border.all(color: c.line, width: 1),
          ),
          child: Center(
            child: Text(
              'Gráfico de progreso disponible próximamente',
              style: TextStyle(
                fontWeight: TipografiaGyMaster.pesoRegular,
                color: c.faint,
                height: 1.3,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, String mensaje) {
    final c = context.gym;
    return Center(
      child: Padding(
        padding: Espaciado.rellenoXl,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.insert_chart_outlined,
              size: 100,
              color: c.faint,
            ),
            SizedBox(height: Espaciado.lg),
            Text(
              'Sin Datos Disponibles',
              style: TipografiaGyMaster.textoPrincipal.copyWith(
                fontSize: TipografiaGyMaster.tamano2xl,
                fontWeight: TipografiaGyMaster.pesoSemiBold,
                color: c.muted,
              ),
            ),
            SizedBox(height: Espaciado.md),
            Text(
              mensaje,
              style: TipografiaGyMaster.textoSecundario.copyWith(
                fontSize: TipografiaGyMaster.tamanoMd,
                color: c.faint,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Espaciado.xl),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Navegar a crear primera rutina
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: c.brand,
                padding: EdgeInsets.symmetric(
                  horizontal: Espaciado.xl,
                  vertical: Espaciado.md,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.add_circle_outline, color: Colors.white),
              label: Text(
                'Crear Primera Rutina',
                style: TipografiaGyMaster.textoPrincipal.copyWith(
                  fontSize: TipografiaGyMaster.tamanoMd,
                  fontWeight: TipografiaGyMaster.pesoSemiBold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String mensaje) {
    final c = context.gym;
    return Center(
      child: Padding(
        padding: Espaciado.rellenoXl,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 100,
              color: c.danger,
            ),
            SizedBox(height: Espaciado.lg),
            Text(
              'Error al Cargar Estadísticas',
              style: TextStyle(
                fontSize: TipografiaGyMaster.tamano2xl,
                fontWeight: TipografiaGyMaster.pesoSemiBold,
                color: c.danger,
                height: 1.4,
              ),
            ),
            SizedBox(height: Espaciado.md),
            Text(
              mensaje,
              style: TextStyle(
                fontSize: TipografiaGyMaster.tamanoMd,
                color: c.muted,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Espaciado.xl),
            ChicletButton(
              texto: 'Intentar de Nuevo',
              icono: Icons.refresh,
              tamano: TamanoBotonChiclet.grande,
              estilo: EstiloBotonChiclet.relleno,
              onPressed: () {
                context.read<EstadisticasCubit>().recargarEstadisticas();
              },
            ),
          ],
        ),
      ),
    );
  }
}
