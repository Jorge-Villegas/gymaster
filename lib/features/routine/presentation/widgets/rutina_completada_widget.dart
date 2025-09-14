import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:gymaster/core/generated/assets.gen.dart';
import 'package:gymaster/features/routine/presentation/cubits/ejercicios_by_rutina/ejercicios_by_rutina_cubit.dart';
import 'package:gymaster/shared/widgets/custom_elevated_button.dart';

/// Widget que muestra la celebración cuando una rutina es completada exitosamente
/// Sigue las reglas del proyecto: Clean Architecture, terminología en español, UI centrada en el usuario
class RutinaCompletadaWidget extends StatelessWidget {
  final EjerciciosByRutinaCompleted state;

  const RutinaCompletadaWidget({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    print('🎉 DEBUG: RutinaCompletadaWidget.build() llamado');
    print('   - Rutina: ${state.rutinaName}');
    print('   - Ejercicios: ${state.totalEjercicios}');
    print('   - Series: ${state.totalSeries}');

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Botón para cerrar en la esquina superior derecha
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () => _navegarAlInicio(context),
                    icon: const Icon(Icons.close),
                    iconSize: 32,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                // Animación de celebración
                _buildAnimacionCelebracion(),
                const SizedBox(height: 32),
                // Título de felicitación
                _buildTituloFelicitacion(context),
                const SizedBox(height: 16),
                // Subtítulo con nombre de rutina
                _buildSubtituloRutina(context),
                const SizedBox(height: 40),
                // Card con estadísticas
                _buildEstadisticasCard(context),
                const SizedBox(height: 40),
                // Botones de acción
                _buildBotonesAccion(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimacionCelebracion() {
    return SizedBox(
      height: 200,
      width: 200,
      child: Lottie.asset(
        Assets.lottie.alzandoPesas,
        repeat: true,
        animate: true,
      ),
    );
  }

  Widget _buildTituloFelicitacion(BuildContext context) {
    return Text(
      '¡Felicidades! 🎉',
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color.fromRGBO(86, 170, 27, 1), // Color verde del tema
          ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubtituloRutina(BuildContext context) {
    return Text(
      'Has completado "${state.rutinaName}"',
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildEstadisticasCard(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              'Resumen del Entrenamiento',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),

            // Fila de estadísticas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildEstadisticaItem(
                  context,
                  icon: Icons.fitness_center,
                  valor: '${state.totalEjercicios}',
                  etiqueta: 'Ejercicios',
                ),
                _buildDividerVertical(context),
                _buildEstadisticaItem(
                  context,
                  icon: Icons.repeat,
                  valor: '${state.totalSeries}',
                  etiqueta: 'Series',
                ),
                _buildDividerVertical(context),
                _buildEstadisticaItem(
                  context,
                  icon: Icons.timer,
                  valor: _formatearTiempo(state.tiempoTotal),
                  etiqueta: 'Tiempo',
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Fecha de completado
            Text(
              'Completado el ${_formatearFecha(state.fechaCompletado)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEstadisticaItem(
    BuildContext context, {
    required IconData icon,
    required String valor,
    required String etiqueta,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 32,
          color: const Color.fromRGBO(86, 170, 27, 1),
        ),
        const SizedBox(height: 8),
        Text(
          valor,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color.fromRGBO(86, 170, 27, 1),
              ),
        ),
        Text(
          etiqueta,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }

  Widget _buildDividerVertical(BuildContext context) {
    return Container(
      height: 60,
      width: 1,
      color: Theme.of(context).colorScheme.outlineVariant,
    );
  }

  Widget _buildBotonesAccion(BuildContext context) {
    return Column(
      children: [
        // Botón principal: Volver al inicio
        SizedBox(
          width: double.infinity,
          child: CustomElevatedButton(
            onPressed: () => _navegarAlInicio(context),
            text: 'Volver al Inicio',
            // backgroundColor usará colorScheme.primary por defecto
            // textColor usará colorScheme.onPrimary por defecto
          ),
        ),

        const SizedBox(height: 12),

        // Botón secundario: Ver historial
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _navegarAlHistorial(context),
            icon: const Icon(Icons.history),
            label: const Text('Ver Historial'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(
                color: Color.fromRGBO(86, 170, 27, 1),
              ),
              foregroundColor: const Color.fromRGBO(86, 170, 27, 1),
            ),
          ),
        ),
      ],
    );
  }

  String _formatearTiempo(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  String _formatearFecha(DateTime fecha) {
    final meses = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre'
    ];

    return '${fecha.day} de ${meses[fecha.month - 1]} de ${fecha.year}';
  }

  void _navegarAlInicio(BuildContext context) {
    context.go('/');
  }

  void _navegarAlHistorial(BuildContext context) {
    // TODO: Implementar navegación al historial cuando esté disponible
    context.go('/');
  }
}
