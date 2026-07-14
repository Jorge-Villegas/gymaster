import 'package:flutter/material.dart';
import 'package:gymaster/features/record/presentation/widgets/progress_visualization_widget.dart';
import 'package:gymaster/features/record/presentation/widgets/community_widget.dart';
import 'package:gymaster/features/record/presentation/widgets/epic_celebration_widget.dart';
import 'package:gymaster/features/record/presentation/widgets/deep_personalization_widget.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';
import 'package:gymaster/core/theme/gym_typography.dart';

/// Widget integrador de la Fase 3: Nivel Reflexivo - Conexión Emocional
/// Combina todos los elementos emocionales avanzados en una experiencia cohesiva
class Phase3EmotionalIntegrationWidget extends StatefulWidget {
  final int userCompletedRoutines;
  final int userCurrentStreak;
  final int userWeeklyRoutines;
  final int userMonthlyRoutines;
  final List<DateTime> userActiveDays;

  const Phase3EmotionalIntegrationWidget({
    super.key,
    required this.userCompletedRoutines,
    required this.userCurrentStreak,
    this.userWeeklyRoutines = 0,
    this.userMonthlyRoutines = 0,
    this.userActiveDays = const [],
  });

  @override
  State<Phase3EmotionalIntegrationWidget> createState() =>
      _Phase3EmotionalIntegrationWidgetState();
}

class _Phase3EmotionalIntegrationWidgetState
    extends State<Phase3EmotionalIntegrationWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabScaleAnimation;

  Map<String, dynamic> _userEmotionalPreferences = {};

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _checkForEpicCelebration();
  }

  void _setupAnimations() {
    _tabController = TabController(length: 4, vsync: this);

    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fabScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _fabAnimationController, curve: Curves.elasticOut),
    );

    _fabAnimationController.forward();
  }

  void _checkForEpicCelebration() {
    // Verificar si se debe mostrar celebración épica
    final milestones = [5, 10, 20, 30, 50, 75, 100];
    if (milestones.contains(widget.userCompletedRoutines)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showEpicCelebrationDialog();
      });
    }
  }

  void _showEpicCelebrationDialog() {
    final (title, description) =
        _getCelebrationData(widget.userCompletedRoutines);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => EpicCelebrationWidget(
        routinesCompleted: widget.userCompletedRoutines,
        achievementTitle: title,
        achievementDescription: description,
        onDismiss: () => Navigator.of(context).pop(),
      ),
    );
  }

  (String, String) _getCelebrationData(int routinesCompleted) {
    switch (routinesCompleted) {
      case 5:
        return (
          '¡PRIMERA SEMANA!',
          'Has completado 5 rutinas. ¡El hábito empieza a formarse!'
        );
      case 10:
        return (
          '¡CONSTANCIA DEMOSTRADA!',
          '10 rutinas completadas. Tu dedicación es increíble.'
        );
      case 20:
        return (
          '¡ATLETA EN PROGRESO!',
          '20 rutinas son una marca de verdadera dedicación.'
        );
      case 30:
        return (
          '¡EXPERTO FITNESS!',
          'Has alcanzado el nivel experto con 30 rutinas.'
        );
      case 50:
        return (
          '¡LEYENDA VIVIENTE!',
          '50 rutinas te convierten en una inspiración para todos.'
        );
      default:
        return (
          '¡LOGRO ÉPICO!',
          'Has alcanzado un hito increíble en tu journey.'
        );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          _buildHeader(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProgressTab(),
                _buildCommunityTab(),
                _buildPersonalizationTab(),
                _buildInsightsTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildEmotionalFAB(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.gym.xpInk.withValues(alpha: 0.1),
            context.gym.info.withValues(alpha: 0.1),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.gym.xpInk.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.psychology,
                  color: context.gym.xpInk,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Conexión Emocional',
                      style: GymType.display.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'Nivel Reflexivo - Experiencia Personalizada',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              Text(
                _getEmotionalStateEmoji(),
                style: const TextStyle(fontSize: 32),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildQuickStatsRow(),
        ],
      ),
    );
  }

  String _getEmotionalStateEmoji() {
    if (widget.userCurrentStreak >= 14) return '🔥';
    if (widget.userCompletedRoutines >= 30) return '👑';
    if (widget.userCompletedRoutines >= 15) return '⭐';
    if (widget.userCompletedRoutines >= 5) return '💪';
    return '🌱';
  }

  Widget _buildQuickStatsRow() {
    return Row(
      children: [
        _buildQuickStat(
            '${widget.userCompletedRoutines}', 'Rutinas', context.gym.xpInk),
        const SizedBox(width: 20),
        _buildQuickStat(
            '${widget.userCurrentStreak}', 'Racha', context.gym.brand),
        const SizedBox(width: 20),
        _buildQuickStat(
            '${widget.userWeeklyRoutines}', 'Semana', context.gym.xpInk),
      ],
    );
  }

  Widget _buildQuickStat(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GymType.number,
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(25),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: context.gym.xpInk,
          borderRadius: BorderRadius.circular(25),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(icon: Icon(Icons.analytics), text: 'Progreso'),
          Tab(icon: Icon(Icons.groups), text: 'Comunidad'),
          Tab(icon: Icon(Icons.tune), text: 'Personal'),
          Tab(icon: Icon(Icons.insights), text: 'Insights'),
        ],
      ),
    );
  }

  Widget _buildProgressTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: ProgressVisualizationWidget(
        totalRutinasCompletadas: widget.userCompletedRoutines,
        rutinasEstaSemana: widget.userWeeklyRoutines,
        rutinasEsteMes: widget.userMonthlyRoutines,
        rachaActual: widget.userCurrentStreak,
        diasActivos: widget.userActiveDays,
      ),
    );
  }

  Widget _buildCommunityTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: CommunityWidget(
        userCompletedRoutines: widget.userCompletedRoutines,
        userCurrentStreak: widget.userCurrentStreak,
      ),
    );
  }

  Widget _buildPersonalizationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: DeepPersonalizationWidget(
        userCompletedRoutines: widget.userCompletedRoutines,
        userCurrentStreak: widget.userCurrentStreak,
        onPreferencesChanged: (preferences) {
          setState(() {
            _userEmotionalPreferences = preferences;
          });
        },
      ),
    );
  }

  Widget _buildInsightsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEmotionalJourneySection(),
          const SizedBox(height: 24),
          _buildBehaviorInsightsSection(),
          const SizedBox(height: 24),
          _buildPersonalizedRecommendationsSection(),
        ],
      ),
    );
  }

  Widget _buildEmotionalJourneySection() {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.timeline, color: context.gym.xpInk),
              const SizedBox(width: 8),
              Text(
                'Tu Journey Emocional',
                style: GymType.section,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _getEmotionalJourneyInsight(),
            style: GymType.body,
          ),
        ],
      ),
    );
  }

  String _getEmotionalJourneyInsight() {
    if (widget.userCurrentStreak >= 21) {
      return 'Has desarrollado una mentalidad de guerrero. Tu disciplina emocional es extraordinaria y sirves de inspiración para otros.';
    } else if (widget.userCurrentStreak >= 14) {
      return 'Tu resiliencia emocional está en pleno desarrollo. Has superado la barrera de los 14 días y tu mente se está fortaleciendo.';
    } else if (widget.userCurrentStreak >= 7) {
      return 'Has comenzado a formar un vínculo emocional real con el fitness. Tu cerebro está reconectándose para el éxito.';
    } else if (widget.userCompletedRoutines >= 5) {
      return 'Estás en la fase de construcción emocional. Cada rutina fortalece tu identidad como persona fitness.';
    } else {
      return 'Estás comenzando tu transformación emocional. Cada paso cuenta en este journey hacia una nueva versión de ti.';
    }
  }

  Widget _buildBehaviorInsightsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.gym.info.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: context.gym.info.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.psychology, color: context.gym.info),
              const SizedBox(width: 8),
              Text(
                'Insights Comportamentales',
                style: GymType.section,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInsightItem('Patrón de Consistencia', _getConsistencyPattern()),
          _buildInsightItem('Momento Óptimo', _getOptimalTime()),
          _buildInsightItem('Tipo de Motivación', _getMotivationType()),
        ],
      ),
    );
  }

  Widget _buildInsightItem(String title, String insight) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: context.gym.info,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  insight,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getConsistencyPattern() {
    if (widget.userCurrentStreak >= 7) {
      return 'Excelente - Muestras un patrón de consistencia sólido';
    } else {
      return 'En desarrollo - Enfócate en crear una rutina diaria';
    }
  }

  String _getOptimalTime() {
    return 'Matutino - Basado en tu actividad, rindes mejor en las mañanas';
  }

  String _getMotivationType() {
    if (widget.userCompletedRoutines >= 20) {
      return 'Logros - Te motivan los hitos y reconocimientos';
    } else {
      return 'Progreso - Te impulsa ver mejoras constantes';
    }
  }

  Widget _buildPersonalizedRecommendationsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.gym.brand.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.gym.brand.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, color: context.gym.brand),
              const SizedBox(width: 8),
              Text(
                'Recomendaciones Personalizadas',
                style: GymType.section,
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...(_getPersonalizedRecommendations()
              .map(
                  (rec) => _buildRecommendationItem(rec.title, rec.description))
              .toList()),
        ],
      ),
    );
  }

  Widget _buildRecommendationItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.gym.brand.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GymType.bodyStrong,
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  List<({String title, String description})> _getPersonalizedRecommendations() {
    final recommendations = <({String title, String description})>[];

    if (widget.userCurrentStreak < 7) {
      recommendations.add((
        title: 'Construye tu racha de 7 días',
        description:
            'Enfócate en entrenar 7 días consecutivos para formar el hábito base.',
      ));
    }

    if (widget.userCompletedRoutines < 15) {
      recommendations.add((
        title: 'Celebra cada pequeño logro',
        description:
            'Reconoce cada rutina completada para reforzar la motivación intrínseca.',
      ));
    }

    recommendations.add((
      title: 'Personaliza tu experiencia',
      description:
          'Ajusta las configuraciones emocionales en la pestaña Personal para optimizar tu motivación.',
    ));

    return recommendations;
  }

  Widget _buildEmotionalFAB() {
    return ScaleTransition(
      scale: _fabScaleAnimation,
      child: FloatingActionButton.extended(
        onPressed: _showEpicCelebrationDialog,
        backgroundColor: context.gym.xpInk,
        icon: const Icon(Icons.celebration, color: Colors.white),
        label: Text(
          'Celebrar',
          style: GymType.display.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
