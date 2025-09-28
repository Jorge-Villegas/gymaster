import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymaster/core/theme/app_colors.dart';
import 'package:gymaster/core/theme/emotional_text_styles.dart';

/// Sistema de celebraciones épicas para hitos importantes
/// Animaciones fullscreen, confetti, y reconocimiento de logros especiales
class EpicCelebrationWidget extends StatefulWidget {
  final int routinesCompleted;
  final String achievementTitle;
  final String achievementDescription;
  final VoidCallback onDismiss;

  const EpicCelebrationWidget({
    super.key,
    required this.routinesCompleted,
    required this.achievementTitle,
    required this.achievementDescription,
    required this.onDismiss,
  });

  @override
  State<EpicCelebrationWidget> createState() => _EpicCelebrationWidgetState();
}

class _EpicCelebrationWidgetState extends State<EpicCelebrationWidget>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _confettiController;
  late AnimationController _pulseController;
  late AnimationController _rotationController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _confettiAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    // Vibración épica
    HapticFeedback.heavyImpact();

    _setupAnimations();
    _startCelebration();
  }

  void _setupAnimations() {
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.bounceOut),
    );

    _confettiAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _confettiController, curve: Curves.easeOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );
  }

  void _startCelebration() {
    _mainController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      _confettiController.forward();
    });
    _pulseController.repeat(reverse: true);
    _rotationController.repeat();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _confettiController.dispose();
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.acento.withValues(alpha: 0.95),
              AppColors.acento.withValues(alpha: 0.95),
              AppColors.acento.withValues(alpha: 0.95),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              _buildConfetti(),
              _buildMainContent(),
              _buildCloseButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfetti() {
    return AnimatedBuilder(
      animation: _confettiAnimation,
      builder: (context, child) {
        return Stack(
          children: List.generate(30, (index) {
            final x = (index % 5) * 0.2;
            final delay = (index % 3) * 0.3;
            final confettiY =
                (_confettiAnimation.value - delay).clamp(0.0, 1.0);

            return Positioned(
              left: MediaQuery.of(context).size.width * x,
              top: MediaQuery.of(context).size.height * confettiY - 20,
              child: AnimatedBuilder(
                animation: _rotationAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotationAnimation.value * 6.28 * (index % 3 + 1),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _getConfettiColor(index),
                        shape: index % 2 == 0
                            ? BoxShape.circle
                            : BoxShape.rectangle,
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        );
      },
    );
  }

  Color _getConfettiColor(int index) {
    final colors = [
      AppColors.acento,
      AppColors.exito,
      AppColors.acento,
      AppColors.secundarioClaro,
      AppColors.acento,
    ];
    return colors[index % colors.length];
  }

  Widget _buildMainContent() {
    return AnimatedBuilder(
      animation: _mainController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildEpicIcon(),
                      const SizedBox(height: 32),
                      _buildMainTitle(),
                      const SizedBox(height: 16),
                      _buildDescription(),
                      const SizedBox(height: 32),
                      _buildStats(),
                      const SizedBox(height: 40),
                      _buildContinueButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEpicIcon() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.acento.withValues(alpha: 0.5),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Center(
              child: Text(
                _getEpicEmoji(),
                style: const TextStyle(fontSize: 60),
              ),
            ),
          ),
        );
      },
    );
  }

  String _getEpicEmoji() {
    if (widget.routinesCompleted >= 50) return '👑';
    if (widget.routinesCompleted >= 30) return '🏆';
    if (widget.routinesCompleted >= 20) return '🔥';
    if (widget.routinesCompleted >= 10) return '⭐';
    if (widget.routinesCompleted >= 5) return '💪';
    return '🎯';
  }

  Widget _buildMainTitle() {
    return Text(
      widget.achievementTitle,
      style: EstilosTextoEmocional.celebracion.copyWith(
        fontSize: 32,
        color: Colors.white,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
            offset: const Offset(2, 2),
            blurRadius: 4,
            color: Colors.black.withOpacity(0.3),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescription() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Text(
        widget.achievementDescription,
        style: EstilosTextoEmocional.aliento.copyWith(
          fontSize: 18,
          color: Colors.white,
          height: 1.4,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildStats() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem('Rutinas', '${widget.routinesCompleted}', '🏋️'),
          _buildStatItem('Nivel', _getUserLevel(), '📈'),
          _buildStatItem('Rank', _getUserRank(), '🏅'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, String emoji) {
    return Column(
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: EstilosTextoEmocional.logro.copyWith(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }

  String _getUserLevel() {
    if (widget.routinesCompleted >= 50) return 'LEYENDA';
    if (widget.routinesCompleted >= 30) return 'EXPERTO';
    if (widget.routinesCompleted >= 20) return 'AVANZADO';
    if (widget.routinesCompleted >= 10) return 'INTERMEDIO';
    if (widget.routinesCompleted >= 5) return 'PRINCIPIANTE';
    return 'NOVATO';
  }

  String _getUserRank() {
    if (widget.routinesCompleted >= 50) return 'TOP 1%';
    if (widget.routinesCompleted >= 30) return 'TOP 5%';
    if (widget.routinesCompleted >= 20) return 'TOP 15%';
    if (widget.routinesCompleted >= 10) return 'TOP 35%';
    if (widget.routinesCompleted >= 5) return 'TOP 60%';
    return 'TOP 80%';
  }

  Widget _buildContinueButton() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (_pulseAnimation.value - 1.0) * 0.3,
          child: ElevatedButton(
            onPressed: widget.onDismiss,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.acento,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 8,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.celebration, size: 24),
                const SizedBox(width: 12),
                Text(
                  '¡CONTINUAR!',
                  style: EstilosTextoEmocional.motivacional.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.acento,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCloseButton() {
    return Positioned(
      top: 16,
      right: 16,
      child: IconButton(
        onPressed: widget.onDismiss,
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.close,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  /// Método estático para mostrar celebración épica
  static void show(
    BuildContext context, {
    required int routinesCompleted,
    required String achievementTitle,
    required String achievementDescription,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => EpicCelebrationWidget(
        routinesCompleted: routinesCompleted,
        achievementTitle: achievementTitle,
        achievementDescription: achievementDescription,
        onDismiss: () => Navigator.of(context).pop(),
      ),
    );
  }

  /// Método estático para verificar si se debe mostrar celebración
  static bool shouldShowEpicCelebration(int routinesCompleted) {
    final milestones = [5, 10, 20, 30, 50, 75, 100];
    return milestones.contains(routinesCompleted);
  }

  /// Método estático para obtener datos de celebración
  static ({String title, String description}) getCelebrationData(
      int routinesCompleted) {
    switch (routinesCompleted) {
      case 5:
        return (
          title: '¡PRIMERA SEMANA!',
          description:
              'Has completado 5 rutinas. ¡El hábito empieza a formarse!',
        );
      case 10:
        return (
          title: '¡CONSTANCIA DEMOSTRADA!',
          description: '10 rutinas completadas. Tu dedicación es increíble.',
        );
      case 20:
        return (
          title: '¡ATLETA EN PROGRESO!',
          description: '20 rutinas son una marca de verdadera dedicación.',
        );
      case 30:
        return (
          title: '¡EXPERTO FITNESS!',
          description: 'Has alcanzado el nivel experto con 30 rutinas.',
        );
      case 50:
        return (
          title: '¡LEYENDA VIVIENTE!',
          description:
              '50 rutinas te convierten en una inspiración para todos.',
        );
      case 75:
        return (
          title: '¡MAESTRO ABSOLUTO!',
          description: 'Tu dedicación de 75 rutinas es simplemente épica.',
        );
      case 100:
        return (
          title: '¡CENTURIÓN FITNESS!',
          description: '100 rutinas: Has alcanzado la élite absoluta.',
        );
      default:
        return (
          title: '¡LOGRO ÉPICO!',
          description: 'Has alcanzado un hito increíble en tu journey.',
        );
    }
  }
}
