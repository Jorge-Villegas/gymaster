import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';
import 'package:gymaster/core/theme/gym_typography.dart';
import 'package:gymaster/shared/widgets/gym/gym.dart';

class RutinaCanceladaWidget extends StatelessWidget {
  final String rutinaName;
  final String rutinaId;
  final String sessionId;
  final int totalEjercicios;
  final DateTime fechaCancelada;

  const RutinaCanceladaWidget({
    super.key,
    required this.rutinaName,
    required this.rutinaId,
    required this.sessionId,
    required this.totalEjercicios,
    required this.fechaCancelada,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.cancel_rounded,
                    color: Theme.of(context).colorScheme.error, size: 100),
                const SizedBox(height: 24),
                Text(
                  'Rutina cancelada',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.error,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Has cancelado la rutina "$rutinaName"',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(
                          'Resumen',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.fitness_center,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant),
                            const SizedBox(width: 8),
                            Text('$totalEjercicios ejercicios'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Cancelada el ${_formatearFecha(fechaCancelada)}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Botón principal: Reintentar Rutina
                ElevatedButton.icon(
                  onPressed: () => _reintentarRutina(context),
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(
                    'Reintentar Rutina',
                    style: GymType.section.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                    elevation: 4,
                    backgroundColor: context.gym.xpInk, // Color emocional
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Mensaje motivacional
                Text(
                  '¡No te rindas! Puedes intentarlo de nuevo 💪',
                  style: GymType.section,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                GymButton(
                  label: 'Volver al Inicio',
                  icon: Icons.home_rounded,
                  variant: GymButtonVariant.primary,
                  size: GymButtonSize.medium,
                  expand: false,
                  onPressed: () => context.go('/'),
                ),
                // Botones secundarios
                OutlinedButton.icon(
                  onPressed: () => context.go('/'),
                  icon: const Icon(Icons.home_rounded),
                  label: const Text('Volver al Inicio'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 30,
                    ),
                    side: BorderSide(
                        color: Theme.of(context).colorScheme.outline),
                    foregroundColor: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => context.go('/'), // TODO: historial
                  icon: const Icon(Icons.history),
                  label: const Text('Ver Historial'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 30,
                    ),
                    side: BorderSide(
                        color: Theme.of(context).colorScheme.primary),
                    foregroundColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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

  void _reintentarRutina(BuildContext context) async {
    try {
      // Navegar directamente al detalle de la rutina
      // El cubit detectará que está cancelada y la mostrará como pending
      context.goNamed('detallerutina', pathParameters: {
        'rutinaId': rutinaId,
      });
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al navegar: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}
