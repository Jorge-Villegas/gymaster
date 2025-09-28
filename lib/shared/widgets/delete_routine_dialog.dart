import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:gymaster/core/theme/app_colors.dart';
import 'package:gymaster/core/theme/emotional_text_styles.dart';
import 'package:gymaster/core/theme/tipografia_gymaster.dart';
import 'package:gymaster/shared/utils/haptic_feedback_helper.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

/// Diálogo de confirmación emocional para eliminar rutinas
/// Sigue principios de UX/UI emocional del proyecto
class DeleteRoutineDialog extends StatefulWidget {
  final String routineName;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const DeleteRoutineDialog({
    super.key,
    required this.routineName,
    required this.onConfirm,
    this.onCancel,
  });

  /// Muestra el diálogo de eliminación con diseño emocional
  static Future<bool?> show({
    required BuildContext context,
    required String routineName,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => DeleteRoutineDialog(
        routineName: routineName,
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
    );
  }

  @override
  State<DeleteRoutineDialog> createState() => _DeleteRoutineDialogState();
}

class _DeleteRoutineDialogState extends State<DeleteRoutineDialog>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _handleConfirm() async {
    await HapticFeedbackHelper.vibracionError();
    _shakeController.forward().then((_) {
      widget.onConfirm();
      Navigator.of(context).pop(true);
    });
  }

  void _handleCancel() async {
    await HapticFeedbackHelper.vibracionSeleccion();
    if (widget.onCancel != null) {
      widget.onCancel!();
    }
    Navigator.of(context).pop(false);
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: CurvedAnimation(
        parent: _scaleController,
        curve: Curves.elasticOut,
      ),
      child: AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Container(
          constraints: const BoxConstraints(maxWidth: 320),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icono emocional con animación
              _buildEmotionalIcon(),

              const SizedBox(height: 20),

              // Título emocional
              _buildEmotionalTitle(),

              const SizedBox(height: 12),

              // Mensaje emocional
              _buildEmotionalMessage(),

              const SizedBox(height: 24),

              // Botones de acción
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmotionalIcon() {
    return FadeInDown(
      duration: const Duration(milliseconds: 600),
      child: AnimatedBuilder(
        animation: _shakeController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
              5 * _shakeController.value * (1 - _shakeController.value) * 4,
              0,
            ),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(40),
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Icon(
                IconsaxPlusLinear.trash,
                color: AppColors.error,
                size: 36,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmotionalTitle() {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      delay: const Duration(milliseconds: 200),
      child: Text(
        '¿Eliminar rutina? 🗑️',
        style: EstilosTextoEmocional.energetico.copyWith(
          fontSize: TipografiaGyMaster.titulo.fontSize,
          color: AppColors.textoPrincipalClaro,
          fontWeight: TipografiaGyMaster.pesoSemiBold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildEmotionalMessage() {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      delay: const Duration(milliseconds: 400),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: EstilosTextoEmocional.amigable.copyWith(
            fontSize: TipografiaGyMaster.textoPrincipal.fontSize,
            color: AppColors.textoDeshabilitado,
            height: 1.4,
          ),
          children: [
            const TextSpan(
              text: 'La rutina ',
            ),
            TextSpan(
              text: '"${widget.routineName}"',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primario,
              ),
            ),
            const TextSpan(
              text:
                  ' se enviará a la papelera.\n\n¡No te preocupes! Puedes restaurarla después si cambias de opinión. 💪',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      delay: const Duration(milliseconds: 600),
      child: Row(
        children: [
          // Botón Cancelar
          Expanded(
            child: _buildCancelButton(),
          ),

          const SizedBox(width: 12),

          // Botón Eliminar
          Expanded(
            child: _buildDeleteButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildCancelButton() {
    return OutlinedButton(
      onPressed: _handleCancel,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: BorderSide(
          color: AppColors.textoTerciario.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Text(
        'Cancelar',
        style: EstilosTextoEmocional.amigable.copyWith(
          color: AppColors.textoTerciario,
          fontSize: TipografiaGyMaster.textoPrincipal.fontSize,
          fontWeight: TipografiaGyMaster.pesoSemiBold,
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return ElevatedButton(
      onPressed: _handleConfirm,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.error,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
      child: Text(
        'Eliminar',
        style: EstilosTextoEmocional.aliento.copyWith(
          color: Colors.white,
          fontSize: TipografiaGyMaster.textoPrincipal.fontSize,
          fontWeight: TipografiaGyMaster.pesoSemiBold,
        ),
      ),
    );
  }
}
