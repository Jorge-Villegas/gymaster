import 'package:flutter/material.dart';
import 'package:gymaster/core/theme/app_colors.dart';
import 'package:gymaster/core/theme/emotional_text_styles.dart';

/// Widget de comunidad fitness virtual para motivación social
/// Simula comparaciones con otros usuarios y proporciona motivación comunitaria
class CommunityWidget extends StatefulWidget {
  final int userCompletedRoutines;
  final int userCurrentStreak;

  const CommunityWidget({
    super.key,
    required this.userCompletedRoutines,
    required this.userCurrentStreak,
  });

  @override
  State<CommunityWidget> createState() => _CommunityWidgetState();
}

class _CommunityWidgetState extends State<CommunityWidget>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _slideController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.calmBlue.withOpacity(0.1),
              AppColors.successGreen.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.calmBlue.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildCommunityStats(),
            const SizedBox(height: 20),
            _buildMotivationalComparison(),
            const SizedBox(height: 20),
            _buildCommunitySupport(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.calmBlue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.groups,
                  color: AppColors.calmBlue,
                  size: 24,
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Comunidad GyMaster',
                style: EstilosTextoEmocional.motivacional.copyWith(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Text(
                'Tu progreso comparado con otros usuarios',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
        const Text(
          '🏆',
          style: TextStyle(fontSize: 28),
        ),
      ],
    );
  }

  Widget _buildCommunityStats() {
    final userPosition = _calculateUserPosition();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.achievementGold.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.achievementGold.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tu Posición en la Comunidad',
                style: EstilosTextoEmocional.aliento.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.achievementGold,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'TOP $userPosition%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildComparisonStat(
                  'Rutinas Completadas',
                  '${widget.userCompletedRoutines}',
                  '${_getAverageRoutines()}',
                  Icons.fitness_center,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildComparisonStat(
                  'Racha Actual',
                  '${widget.userCurrentStreak} días',
                  '${_getAverageStreak()} días',
                  Icons.local_fire_department,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonStat(
      String title, String userValue, String avgValue, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.successGreen, size: 20),
        const SizedBox(height: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          userValue,
          style: EstilosTextoEmocional.celebracion.copyWith(
            fontSize: 18,
            color: AppColors.successGreen,
          ),
        ),
        Text(
          'Promedio: $avgValue',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 10,
              ),
        ),
      ],
    );
  }

  Widget _buildMotivationalComparison() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.trending_up,
              color: AppColors.motivationRed,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Comparación Motivacional',
              style: EstilosTextoEmocional.aliento.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildMotivationalMessage(),
        const SizedBox(height: 16),
        _buildProgressBar(),
      ],
    );
  }

  Widget _buildMotivationalMessage() {
    final message = _getMotivationalMessage();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.motivationRed.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.motivationRed.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Text(
            message.icon,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message.text,
              style: EstilosTextoEmocional.logro.copyWith(
                fontSize: 16,
                color: AppColors.motivationRed,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    final nextMilestone = _getNextMilestone();
    final progress = widget.userCompletedRoutines / nextMilestone;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progreso al próximo hito',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              '${widget.userCompletedRoutines}/$nextMilestone',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress > 1 ? 1 : progress,
            backgroundColor: AppColors.calmBlue.withOpacity(0.2),
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppColors.successGreen),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildCommunitySupport() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.energyOrange.withOpacity(0.1),
            AppColors.achievementGold.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.favorite,
                color: AppColors.energyOrange,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Apoyo de la Comunidad',
                style: EstilosTextoEmocional.aliento.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _getCommunityMessage(),
            style: EstilosTextoEmocional.celebracion.copyWith(
              fontSize: 16,
              color: AppColors.energyOrange,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSupportReaction('💪', '2.3k'),
              _buildSupportReaction('🔥', '1.8k'),
              _buildSupportReaction('⭐', '987'),
              _buildSupportReaction('🏆', '654'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSupportReaction(String emoji, String count) {
    return Column(
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 4),
        Text(
          count,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.energyOrange,
              ),
        ),
      ],
    );
  }

  // Métodos auxiliares para datos simulados
  int _calculateUserPosition() {
    if (widget.userCompletedRoutines >= 50) return 5;
    if (widget.userCompletedRoutines >= 30) return 10;
    if (widget.userCompletedRoutines >= 20) return 20;
    if (widget.userCompletedRoutines >= 10) return 35;
    if (widget.userCompletedRoutines >= 5) return 50;
    return 75;
  }

  int _getAverageRoutines() {
    return (widget.userCompletedRoutines * 0.7).round().clamp(1, 100);
  }

  int _getAverageStreak() {
    return (widget.userCurrentStreak * 0.6).round().clamp(1, 30);
  }

  int _getNextMilestone() {
    if (widget.userCompletedRoutines < 5) return 5;
    if (widget.userCompletedRoutines < 10) return 10;
    if (widget.userCompletedRoutines < 20) return 20;
    if (widget.userCompletedRoutines < 30) return 30;
    if (widget.userCompletedRoutines < 50) return 50;
    return ((widget.userCompletedRoutines / 10).ceil() * 10) + 10;
  }

  ({String icon, String text}) _getMotivationalMessage() {
    if (widget.userCompletedRoutines >= 30) {
      return (
        icon: '🚀',
        text:
            '¡Estás en el TOP 10%! Tu dedicación inspira a toda la comunidad.',
      );
    } else if (widget.userCompletedRoutines >= 15) {
      return (
        icon: '⭐',
        text: '¡Excelente progreso! Estás superando al 65% de los usuarios.',
      );
    } else if (widget.userCompletedRoutines >= 7) {
      return (
        icon: '💪',
        text: '¡Muy bien! Ya superaste a más de la mitad de los usuarios.',
      );
    } else if (widget.userCompletedRoutines >= 3) {
      return (
        icon: '🌱',
        text: '¡Buen inicio! Cada rutina te acerca más a tus objetivos.',
      );
    } else {
      return (
        icon: '🎯',
        text: '¡Comienza tu journey! Miles de usuarios empezaron igual que tú.',
      );
    }
  }

  String _getCommunityMessage() {
    final messages = [
      '¡La comunidad te apoya en cada paso de tu journey!',
      'Cientos de usuarios celebran contigo cada logro.',
      'Tu progreso motiva a otros a seguir entrenando.',
      'Eres parte de una comunidad que nunca se rinde.',
      'Juntos somos más fuertes. ¡Sigue así!',
    ];

    final index = widget.userCompletedRoutines % messages.length;
    return messages[index];
  }
}
