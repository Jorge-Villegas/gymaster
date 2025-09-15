import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:gymaster/core/generated/assets.gen.dart';
import 'package:gymaster/core/theme/emotional_text_styles.dart';
import 'package:gymaster/core/theme/app_colors.dart';
import 'package:gymaster/core/services/emotional_message_service.dart';
import 'package:gymaster/shared/utils/haptic_feedback_helper.dart';
import 'package:gymaster/shared/utils/audio_feedback_helper.dart';
import 'package:gymaster/features/routine/presentation/cubits/ejercicios_by_rutina/ejercicios_by_rutina_cubit.dart';
import 'package:gymaster/features/record/presentation/cubit/record_cubit.dart';
import 'package:gymaster/features/record/presentation/cubit/record_state.dart';

/// Widget que muestra la celebración cuando una rutina es completada exitosamente
/// Sigue las reglas del proyecto: Clean Architecture, terminología en español, UI centrada en el usuario
class RutinaCompletadaWidget extends StatefulWidget {
  final EjerciciosByRutinaCompleted state;

  const RutinaCompletadaWidget({
    super.key,
    required this.state,
  });

  @override
  State<RutinaCompletadaWidget> createState() => _RutinaCompletadaWidgetState();
}

class _RutinaCompletadaWidgetState extends State<RutinaCompletadaWidget> {
  int _totalRutinasCompletadas = 1; // Default para primera rutina
  bool _isLoadingRecords = false;

  @override
  void initState() {
    super.initState();
    _loadCompletedRoutinesCount();

    // Trigger celebration feedback when widget builds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      HapticFeedbackHelper.vibracionLogro();
      AudioFeedbackHelper.reproducirSonidoCelebracion();
    });
  }

  void _loadCompletedRoutinesCount() {
    final recordCubit = context.read<RecordCubit>();
    final currentState = recordCubit.state;

    if (currentState is RecordLoaded) {
      // Si ya tenemos los datos, usarlos directamente
      setState(() {
        _totalRutinasCompletadas = currentState.rutinas.length;
      });
    } else if (!_isLoadingRecords) {
      // Solo cargar si no estamos ya cargando
      setState(() {
        _isLoadingRecords = true;
      });
      recordCubit.getAllRutinas();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecordCubit, RecordState>(
      listener: (context, recordState) {
        if (recordState is RecordLoaded && _isLoadingRecords) {
          setState(() {
            _totalRutinasCompletadas = recordState.rutinas.length;
            _isLoadingRecords = false;
          });
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                          height: 60), // Espacio para el botón cerrar
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
                // Botón para cerrar en la esquina superior derecha
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () => _navegarAlInicio(context),
                    icon: Icon(
                      Icons.close,
                      size: 32,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimacionCelebracion() {
    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(
            color: AppColors.achievementGold.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Lottie.asset(
        Assets.lottie.alzandoPesas,
        repeat: true,
        animate: true,
      ),
    );
  }

  Widget _buildTituloFelicitacion(BuildContext context) {
    final String mensajePersonalizado =
        MensajesEmocionalesService.obtenerMensajeDeCompletacion(
      widget.state.rutinaName,
      _totalRutinasCompletadas,
      widget.state.totalEjercicios,
      widget.state.totalSeries,
    );

    return Column(
      children: [
        Text(
          '${_totalRutinasCompletadas.iconoProgreso} ¡Felicidades! ${_totalRutinasCompletadas.iconoProgreso}',
          style: EmotionalTextStyles.celebration.copyWith(
            color: AppColors.achievementGold,
            fontSize: 28,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.achievementGold.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border:
                Border.all(color: AppColors.achievementGold.withOpacity(0.3)),
          ),
          child: Text(
            _totalRutinasCompletadas.insigniaProgreso,
            style: const TextStyle(
              color: AppColors.achievementGold,
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          mensajePersonalizado,
          style: EmotionalTextStyles.encouragement.copyWith(
            fontSize: 18,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSubtituloRutina(BuildContext context) {
    final String subtituloContextual =
        MensajesEmocionalesService.obtenerSubtituloContextual(
      widget.state.rutinaName,
      _totalRutinasCompletadas,
      widget.state.totalEjercicios,
    );

    return Column(
      children: [
        Text(
          subtituloContextual,
          style: EmotionalTextStyles.encouragement.copyWith(
            fontSize: 20,
            color: AppColors.successGreen,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          MensajesEmocionalesService.obtenerEstadisticasContext(
              _totalRutinasCompletadas),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.motivationRed,
                fontWeight: FontWeight.w500,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          MensajesEmocionalesService.obtenerProyeccionDeLogros(
              _totalRutinasCompletadas),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
          textAlign: TextAlign.center,
        ),
      ],
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
                  valor: '${widget.state.totalEjercicios}',
                  etiqueta: 'Ejercicios',
                ),
                _buildDividerVertical(context),
                _buildEstadisticaItem(
                  context,
                  icon: Icons.repeat,
                  valor: '${widget.state.totalSeries}',
                  etiqueta: 'Series',
                ),
                _buildDividerVertical(context),
                _buildEstadisticaItem(
                  context,
                  icon: Icons.timer,
                  valor: _formatearTiempo(widget.state.tiempoTotal),
                  etiqueta: 'Tiempo',
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Fecha de completado
            Text(
              'Completado el ${_formatearFecha(widget.state.fechaCompletado)}',
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
          child: ElevatedButton(
            onPressed: () => _navegarAlInicio(context),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            child: const Text('Volver al Inicio'),
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
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
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
