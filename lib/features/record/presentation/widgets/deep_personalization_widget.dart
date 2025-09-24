import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gymaster/core/theme/app_colors.dart';
import 'package:gymaster/core/theme/emotional_text_styles.dart';

/// Sistema de personalización profunda con preferencias emocionales
/// Adaptación inteligente basada en comportamiento y estado emocional del usuario
class DeepPersonalizationWidget extends StatefulWidget {
  final int userCompletedRoutines;
  final int userCurrentStreak;
  final Function(Map<String, dynamic>) onPreferencesChanged;

  const DeepPersonalizationWidget({
    super.key,
    required this.userCompletedRoutines,
    required this.userCurrentStreak,
    required this.onPreferencesChanged,
  });

  @override
  State<DeepPersonalizationWidget> createState() =>
      _DeepPersonalizationWidgetState();
}

class _DeepPersonalizationWidgetState extends State<DeepPersonalizationWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Preferencias del usuario
  String _motivationStyle = 'balanced';
  String _celebrationIntensity = 'medium';
  String _progressFocus = 'consistency';
  String _emotionalTone = 'encouraging';
  List<String> _preferredMotivationTimes = ['morning'];
  bool _enableHapticFeedback = true;
  bool _enableSoundEffects = true;
  double _motivationFrequency = 0.5;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _loadUserPreferences();
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  Future<void> _loadUserPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _motivationStyle = prefs.getString('motivation_style') ?? 'balanced';
      _celebrationIntensity =
          prefs.getString('celebration_intensity') ?? 'medium';
      _progressFocus = prefs.getString('progress_focus') ?? 'consistency';
      _emotionalTone = prefs.getString('emotional_tone') ?? 'encouraging';
      _preferredMotivationTimes =
          prefs.getStringList('motivation_times') ?? ['morning'];
      _enableHapticFeedback = prefs.getBool('haptic_feedback') ?? true;
      _enableSoundEffects = prefs.getBool('sound_effects') ?? true;
      _motivationFrequency = prefs.getDouble('motivation_frequency') ?? 0.5;
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('motivation_style', _motivationStyle);
    await prefs.setString('celebration_intensity', _celebrationIntensity);
    await prefs.setString('progress_focus', _progressFocus);
    await prefs.setString('emotional_tone', _emotionalTone);
    await prefs.setStringList('motivation_times', _preferredMotivationTimes);
    await prefs.setBool('haptic_feedback', _enableHapticFeedback);
    await prefs.setBool('sound_effects', _enableSoundEffects);
    await prefs.setDouble('motivation_frequency', _motivationFrequency);

    // Notificar cambios al widget padre
    widget.onPreferencesChanged({
      'motivation_style': _motivationStyle,
      'celebration_intensity': _celebrationIntensity,
      'progress_focus': _progressFocus,
      'emotional_tone': _emotionalTone,
      'motivation_times': _preferredMotivationTimes,
      'haptic_feedback': _enableHapticFeedback,
      'sound_effects': _enableSoundEffects,
      'motivation_frequency': _motivationFrequency,
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.calmBlue.withOpacity(0.1),
              AppColors.achievementGold.withOpacity(0.1),
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
            const SizedBox(height: 24),
            _buildPersonalizedInsights(),
            const SizedBox(height: 24),
            _buildMotivationStyleSection(),
            const SizedBox(height: 20),
            _buildCelebrationIntensitySection(),
            const SizedBox(height: 20),
            _buildProgressFocusSection(),
            const SizedBox(height: 20),
            _buildEmotionalToneSection(),
            const SizedBox(height: 20),
            _buildAdvancedSettings(),
            const SizedBox(height: 24),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.calmBlue.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.psychology,
            color: AppColors.calmBlue,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Personalización Profunda',
                style: EstilosTextoEmocional.motivacional.copyWith(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Text(
                'Adapta la experiencia a tu estilo emocional único',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
        const Text(
          '🧠',
          style: TextStyle(fontSize: 28),
        ),
      ],
    );
  }

  Widget _buildPersonalizedInsights() {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.insights,
                color: AppColors.achievementGold,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Insights Personalizados',
                style: EstilosTextoEmocional.aliento.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _getPersonalizedInsight(),
            style: EstilosTextoEmocional.logro.copyWith(
              fontSize: 16,
              color: AppColors.achievementGold,
            ),
          ),
        ],
      ),
    );
  }

  String _getPersonalizedInsight() {
    if (widget.userCurrentStreak >= 7) {
      return 'Tu constancia de ${widget.userCurrentStreak} días muestra que respondes bien a motivación consistente y celebraciones graduales.';
    } else if (widget.userCompletedRoutines >= 20) {
      return 'Con ${widget.userCompletedRoutines} rutinas completadas, tu perfil sugiere preferencia por logros tangibles y feedback inmediato.';
    } else if (widget.userCompletedRoutines >= 5) {
      return 'Tu progreso inicial sugiere que te motivan los pequeños logros y el reconocimiento frecuente.';
    } else {
      return 'Como nuevo usuario, recomendamos motivación suave y celebraciones que construyan confianza gradualmente.';
    }
  }

  Widget _buildMotivationStyleSection() {
    return _buildPreferenceSection(
      'Estilo de Motivación',
      Icons.flash_on,
      AppColors.energyOrange,
      [
        ('gentle', 'Suave', 'Motivación amable y comprensiva'),
        ('balanced', 'Equilibrado', 'Combinación de amabilidad y firmeza'),
        ('intense', 'Intenso', 'Motivación directa y enérgica'),
        ('warrior', 'Guerrero', 'Estilo competitivo y desafiante'),
      ],
      _motivationStyle,
      (value) => setState(() => _motivationStyle = value),
    );
  }

  Widget _buildCelebrationIntensitySection() {
    return _buildPreferenceSection(
      'Intensidad de Celebraciones',
      Icons.celebration,
      AppColors.successGreen,
      [
        ('minimal', 'Mínima', 'Reconocimiento sutil'),
        ('medium', 'Moderada', 'Balance perfecto'),
        ('epic', 'Épica', 'Celebraciones grandes'),
        ('legendary', 'Legendaria', 'Máxima pompa y celebración'),
      ],
      _celebrationIntensity,
      (value) => setState(() => _celebrationIntensity = value),
    );
  }

  Widget _buildProgressFocusSection() {
    return _buildPreferenceSection(
      'Enfoque de Progreso',
      Icons.trending_up,
      AppColors.motivationRed,
      [
        ('consistency', 'Consistencia', 'Enfoque en hábitos diarios'),
        ('milestones', 'Hitos', 'Celebrar grandes logros'),
        ('improvement', 'Mejora', 'Progreso técnico y rendimiento'),
        ('community', 'Comunidad', 'Comparación y competencia social'),
      ],
      _progressFocus,
      (value) => setState(() => _progressFocus = value),
    );
  }

  Widget _buildEmotionalToneSection() {
    return _buildPreferenceSection(
      'Tono Emocional',
      Icons.sentiment_satisfied,
      AppColors.calmBlue,
      [
        ('encouraging', 'Alentador', 'Siempre positivo y comprensivo'),
        ('realistic', 'Realista', 'Honesto pero motivador'),
        ('challenging', 'Desafiante', 'Te empuja a dar más'),
        ('zen', 'Zen', 'Calmo y mindful'),
      ],
      _emotionalTone,
      (value) => setState(() => _emotionalTone = value),
    );
  }

  Widget _buildPreferenceSection(
    String title,
    IconData icon,
    Color color,
    List<(String, String, String)> options,
    String currentValue,
    Function(String) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Text(
              title,
              style: EstilosTextoEmocional.aliento.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final (value, label, description) = option;
            final isSelected = currentValue == value;

            return GestureDetector(
              onTap: () => onChanged(value),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color:
                      isSelected ? color.withOpacity(0.2) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? color : color.withOpacity(0.3),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected ? color : null,
                          ),
                    ),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 11,
                          ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAdvancedSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.settings, color: AppColors.calmBlue, size: 18),
            const SizedBox(width: 8),
            Text(
              'Configuraciones Avanzadas',
              style: EstilosTextoEmocional.aliento.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildSwitchSetting(
          'Feedback Háptico',
          'Vibraciones en celebraciones y logros',
          _enableHapticFeedback,
          (value) => setState(() => _enableHapticFeedback = value),
        ),
        _buildSwitchSetting(
          'Efectos de Sonido',
          'Sonidos para celebraciones épicas',
          _enableSoundEffects,
          (value) => setState(() => _enableSoundEffects = value),
        ),
        const SizedBox(height: 16),
        Text(
          'Frecuencia de Motivación: ${(_motivationFrequency * 100).round()}%',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        Slider(
          value: _motivationFrequency,
          min: 0.0,
          max: 1.0,
          divisions: 10,
          activeColor: AppColors.motivationRed,
          onChanged: (value) => setState(() => _motivationFrequency = value),
        ),
      ],
    );
  }

  Widget _buildSwitchSetting(
      String title, String subtitle, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.successGreen,
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _savePreferences,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.achievementGold,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.save, size: 20),
            const SizedBox(width: 8),
            Text(
              'Guardar Preferencias',
              style: EstilosTextoEmocional.motivacional.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Servicio para obtener recomendaciones inteligentes basadas en el comportamiento
class IntelligentRecommendationService {
  static Map<String, dynamic> getRecommendations({
    required int completedRoutines,
    required int currentStreak,
    required Map<String, dynamic> userPreferences,
  }) {
    return {
      'motivation_style':
          _recommendMotivationStyle(completedRoutines, currentStreak),
      'celebration_intensity':
          _recommendCelebrationIntensity(completedRoutines),
      'progress_focus':
          _recommendProgressFocus(completedRoutines, currentStreak),
      'optimal_workout_time': _recommendWorkoutTime(userPreferences),
      'next_goals': _recommendNextGoals(completedRoutines, currentStreak),
    };
  }

  static String _recommendMotivationStyle(
      int completedRoutines, int currentStreak) {
    if (currentStreak >= 14) return 'warrior';
    if (completedRoutines >= 20) return 'intense';
    if (completedRoutines >= 5) return 'balanced';
    return 'gentle';
  }

  static String _recommendCelebrationIntensity(int completedRoutines) {
    if (completedRoutines >= 30) return 'legendary';
    if (completedRoutines >= 15) return 'epic';
    if (completedRoutines >= 5) return 'medium';
    return 'minimal';
  }

  static String _recommendProgressFocus(
      int completedRoutines, int currentStreak) {
    if (currentStreak >= 7) return 'consistency';
    if (completedRoutines >= 20) return 'milestones';
    if (completedRoutines >= 10) return 'improvement';
    return 'community';
  }

  static String _recommendWorkoutTime(Map<String, dynamic> preferences) {
    // Análisis inteligente basado en patrones de uso previos
    final motivationTimes =
        preferences['motivation_times'] as List<String>? ?? ['morning'];
    return motivationTimes.first;
  }

  static List<String> _recommendNextGoals(
      int completedRoutines, int currentStreak) {
    final goals = <String>[];

    if (currentStreak < 7) {
      goals.add('Alcanzar racha de 7 días');
    } else if (currentStreak < 14) {
      goals.add('Completar 2 semanas consecutivas');
    }

    if (completedRoutines < 10) {
      goals.add('Completar 10 rutinas totales');
    } else if (completedRoutines < 25) {
      goals.add('Alcanzar 25 rutinas');
    } else if (completedRoutines < 50) {
      goals.add('Llegar a 50 rutinas épicas');
    }

    return goals;
  }
}
