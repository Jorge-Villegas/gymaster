import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymaster/features/setting/data/models/user_mood.dart';
import '../cubits/mood_detector_cubit.dart';
import '../cubits/mood_detector_state.dart';
import '../../../../../shared/utils/haptic_feedback_helper.dart';
import '../../../../../shared/widgets/custom_elevated_button.dart';
import '../../../../../core/theme/app_colors.dart';

/// Widget para detectar y registrar el estado anímico del usuario
/// Proporciona 4 opciones emocionales específicas para GyMaster
class MoodDetectorWidget extends StatefulWidget {
  /// Callback cuando se selecciona un estado de ánimo
  final Function(MoodType)? onMoodSelected;

  /// Si debe mostrar recomendaciones después de seleccionar
  final bool showRecommendations;

  /// Título del widget
  final String title;

  /// Si debe auto-guardar la selección
  final bool autoSave;

  const MoodDetectorWidget({
    super.key,
    this.onMoodSelected,
    this.showRecommendations = true,
    this.title = '¿Cómo te sientes hoy?',
    this.autoSave = true,
  });

  @override
  State<MoodDetectorWidget> createState() => _MoodDetectorWidgetState();
}

class _MoodDetectorWidgetState extends State<MoodDetectorWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  MoodType? _selectedMood;
  bool _showRecommendations = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MoodDetectorCubit, MoodDetectorState>(
      listener: (context, state) {
        if (state is MoodDetectorSaveSuccess) {
          _showSuccessMessage();
        } else if (state is MoodDetectorError) {
          _showErrorMessage(state.message);
        }
      },
      builder: (context, state) {
        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildMoodDetectorContent(state),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMoodDetectorContent(MoodDetectorState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTitle(),
          const SizedBox(height: 20),
          _buildMoodOptions(),
          if (_selectedMood != null) ...[
            const SizedBox(height: 20),
            _buildActionButtons(state),
          ],
          if (_showRecommendations && _selectedMood != null) ...[
            const SizedBox(height: 20),
            _buildRecommendations(),
          ],
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      widget.title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2C3E50),
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildMoodOptions() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 1.1,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      physics: const NeverScrollableScrollPhysics(),
      children: MoodType.values.map((mood) {
        final isSelected = _selectedMood == mood;
        return _buildMoodCard(mood, isSelected);
      }).toList(),
    );
  }

  Widget _buildMoodCard(MoodType mood, bool isSelected) {
    return GestureDetector(
      onTap: () => _selectMood(mood),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected
              ? mood.primaryColor.withOpacity(0.2)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? mood.primaryColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: mood.primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: Text(
                mood.emoji,
                style: const TextStyle(fontSize: 40),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              mood.displayName,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? mood.primaryColor : Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              mood.description,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(MoodDetectorState state) {
    return Row(
      children: [
        Expanded(
          child: CustomElevatedButton(
            text: widget.showRecommendations
                ? 'Ver Recomendaciones'
                : 'Confirmar',
            onPressed: _handleActionButtonPressed,
            emotionalType: EmotionalButtonType.energetic,
            enablePressAnimation: true,
            enableHapticFeedback: true,
          ),
        ),
        if (widget.autoSave) ...[
          const SizedBox(width: 12),
          Expanded(
            child: CustomElevatedButton(
              text: state is MoodDetectorLoading ? 'Guardando...' : 'Guardar',
              onPressed: () =>
                  state is MoodDetectorLoading ? null : _saveMood(),
              emotionalType: EmotionalButtonType.success,
              enablePressAnimation: true,
              enableHapticFeedback: true,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRecommendations() {
    if (_selectedMood == null) return const SizedBox.shrink();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _selectedMood!.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _selectedMood!.primaryColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: _selectedMood!.primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Recomendaciones para ti',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _selectedMood!.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._selectedMood!.workoutRecommendations.map((recommendation) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: _selectedMood!.primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      recommendation,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  void _selectMood(MoodType mood) {
    setState(() {
      _selectedMood = mood;
      _showRecommendations = false;
    });

    HapticFeedbackHelper.vibracionSeleccion();
    widget.onMoodSelected?.call(mood);
  }

  void _handleActionButtonPressed() {
    if (widget.showRecommendations) {
      setState(() {
        _showRecommendations = !_showRecommendations;
      });
    } else {
      _confirmSelection();
    }
  }

  void _confirmSelection() {
    if (_selectedMood != null) {
      Navigator.of(context).pop(_selectedMood);
    }
  }

  void _saveMood() {
    if (_selectedMood != null) {
      context.read<MoodDetectorCubit>().saveMood(_selectedMood!);
    }
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Estado de ánimo guardado correctamente'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

/// Widget simplificado para selección rápida de estado de ánimo
class QuickMoodSelector extends StatelessWidget {
  /// Callback cuando se selecciona un estado de ánimo
  final Function(MoodType) onMoodSelected;

  /// Estado de ánimo actualmente seleccionado
  final MoodType? selectedMood;

  const QuickMoodSelector({
    super.key,
    required this.onMoodSelected,
    this.selectedMood,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: MoodType.values.map((mood) {
          final isSelected = selectedMood == mood;
          return GestureDetector(
            onTap: () {
              HapticFeedbackHelper.vibracionSeleccion();
              onMoodSelected(mood);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? mood.primaryColor.withOpacity(0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? mood.primaryColor : Colors.grey.shade300,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    mood.emoji,
                    style: TextStyle(
                      fontSize: isSelected ? 24 : 20,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    mood.displayName,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color:
                          isSelected ? mood.primaryColor : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Modal para mostrar el detector de estado de ánimo
class MoodDetectorModal {
  /// Muestra el modal de detector de estado de ánimo
  static Future<MoodType?> show(
    BuildContext context, {
    String title = '¿Cómo te sientes hoy?',
    bool showRecommendations = true,
  }) {
    return showDialog<MoodType>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: MoodDetectorWidget(
          title: title,
          showRecommendations: showRecommendations,
          autoSave: false,
          onMoodSelected: (mood) {
            // Solo registrar la selección, no auto-cerrar
          },
        ),
      ),
    );
  }

  /// Muestra un bottom sheet con selector rápido
  static Future<MoodType?> showQuickSelector(
    BuildContext context, {
    MoodType? currentMood,
  }) {
    return showModalBottomSheet<MoodType>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Selecciona tu estado de ánimo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            QuickMoodSelector(
              selectedMood: currentMood,
              onMoodSelected: (mood) {
                Navigator.of(context).pop(mood);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
