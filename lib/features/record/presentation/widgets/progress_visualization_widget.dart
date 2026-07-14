import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';
import 'package:gymaster/core/theme/gym_typography.dart';
import 'package:gymaster/core/services/emotional_message_service.dart';

/// Widget para visualización emocional del progreso del usuario
/// Muestra gráficos emocionales, calendario visual y línea de tiempo de logros
class ProgressVisualizationWidget extends StatefulWidget {
  final int totalRutinasCompletadas;
  final int rutinasEstaSemana;
  final int rutinasEsteMes;
  final int rachaActual;
  final List<DateTime> diasActivos;

  const ProgressVisualizationWidget({
    super.key,
    required this.totalRutinasCompletadas,
    this.rutinasEstaSemana = 0,
    this.rutinasEsteMes = 0,
    this.rachaActual = 0,
    this.diasActivos = const [],
  });

  @override
  State<ProgressVisualizationWidget> createState() =>
      _ProgressVisualizationWidgetState();
}

class _ProgressVisualizationWidgetState
    extends State<ProgressVisualizationWidget> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    context.gym.xpInk.withValues(alpha: 0.1),
                    context.gym.brand.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: context.gym.xpInk.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildStatsGrid(),
                  const SizedBox(height: 24),
                  _buildProgressTimeline(),
                  const SizedBox(height: 24),
                  _buildEmotionalStats(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.gym.xpInk.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            IconsaxPlusLinear.chart_2,
            color: context.gym.xpInk,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tu Journey Fitness',
                style: GymType.title.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Text(
                'Visualiza tu progreso y celebra cada logro',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
        Text(
          widget.totalRutinasCompletadas.iconoProgreso,
          style: const TextStyle(fontSize: 32),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.3,
      children: [
        _buildStatCard(
          'Total Rutinas',
          '${widget.totalRutinasCompletadas}',
          context.gym.xpInk,
          IconsaxPlusLinear.weight,
        ),
        _buildStatCard(
          'Esta Semana',
          '${widget.rutinasEstaSemana}',
          context.gym.brand,
          IconsaxPlusLinear.calendar_1,
        ),
        _buildStatCard(
          'Este Mes',
          '${widget.rutinasEsteMes}',
          context.gym.xpInk,
          IconsaxPlusLinear.calendar_1,
        ),
        _buildStatCard(
          'Racha Actual',
          '${widget.rachaActual} días',
          context.gym.xpInk,
          IconsaxPlusLinear.flash_1,
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: GymType.number,
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressTimeline() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              IconsaxPlusLinear.chart,
              color: context.gym.brand,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Línea de Tiempo de Logros',
              style: GymType.section.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildTimelineItem('Primer Entreno', '🌱', true, 'El comienzo de todo'),
        if (widget.totalRutinasCompletadas >= 3)
          _buildTimelineItem('3 Rutinas', '⭐', true, 'Construyendo el hábito'),
        if (widget.totalRutinasCompletadas >= 7)
          _buildTimelineItem('1 Semana', '🔥', true, 'Consistencia sólida'),
        if (widget.totalRutinasCompletadas >= 15)
          _buildTimelineItem('15 Rutinas', '💎', true, 'Nivel avanzado'),
        if (widget.totalRutinasCompletadas >= 30)
          _buildTimelineItem('30 Rutinas', '🏆', true, 'Experto fitness'),
        _buildTimelineItem(
          'Próximo Hito',
          '🎯',
          false,
          MensajesEmocionalesService.obtenerProyeccionDeLogros(
              widget.totalRutinasCompletadas),
        ),
      ],
    );
  }

  Widget _buildTimelineItem(
      String milestone, String emoji, bool achieved, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: achieved
                  ? context.gym.brand.withValues(alpha: 0.2)
                  : context.gym.info.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: achieved
                    ? context.gym.brand
                    : context.gym.info.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  milestone,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: achieved
                            ? context.gym.brand
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          if (achieved)
            Icon(
              IconsaxPlusLinear.tick_circle,
              color: context.gym.brand,
              size: 20,
            ),
        ],
      ),
    );
  }

  Widget _buildEmotionalStats() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.gym.xpInk.withValues(alpha: 0.1),
            context.gym.xpInk.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                IconsaxPlusLinear.heart,
                color: context.gym.xpInk,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Impacto Emocional',
                style: GymType.section.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            MensajesEmocionalesService.obtenerEstadisticasContext(
                widget.totalRutinasCompletadas),
            style: GymType.section,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            _getMotivationalQuote(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getMotivationalQuote() {
    final quotes = [
      '"El progreso, no la perfección, es lo que cuenta."',
      '"Cada día es una nueva oportunidad para mejorar."',
      '"Tu única competencia eres tú de ayer."',
      '"La constancia es la madre de todos los logros."',
      '"El éxito es la suma de pequeños esfuerzos repetidos."',
    ];
    final index = widget.totalRutinasCompletadas % quotes.length;
    return quotes[index];
  }
}
