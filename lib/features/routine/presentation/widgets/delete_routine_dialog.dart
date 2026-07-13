import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';
import 'package:gymaster/shared/utils/haptic_feedback_helper.dart';
import 'package:gymaster/features/routine/presentation/cubits/rutina/routine_cubit.dart';

/// Diálogo para confirmación de eliminación de rutinas
class DeleteRoutineDialog extends StatefulWidget {
  final String routineName;
  final String routineId;
  final VoidCallback? onDeleted;

  const DeleteRoutineDialog({
    super.key,
    required this.routineName,
    required this.routineId,
    this.onDeleted,
  });

  @override
  State<DeleteRoutineDialog> createState() => _DeleteRoutineDialogState();
}

class _DeleteRoutineDialogState extends State<DeleteRoutineDialog> {
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    HapticFeedbackHelper.vibracionRecordatorio();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RoutineCubit, RoutineState>(
      listener: (context, state) {
        if (state is RoutineDeleteSuccess) {
          _handleDeleteSuccess();
        } else if (state is RoutineError) {
          _handleDeleteError(state.message);
        }
      },
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(
              IconsaxPlusLinear.trash,
              color: context.gym.xpInk,
              size: 24,
            ),
            const SizedBox(width: 12),
            const Text(
              '¿Eliminar rutina?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 16,
                  color: context.gym.faint,
                ),
                children: [
                  const TextSpan(
                    text: 'Estás a punto de eliminar la rutina ',
                  ),
                  TextSpan(
                    text: '"${widget.routineName}"',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: context.gym.xpInk,
                    ),
                  ),
                  const TextSpan(
                    text:
                        '. No te preocupes, siempre podrás recuperarla más tarde.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.gym.info.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: context.gym.info.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    IconsaxPlusLinear.info_circle,
                    size: 16,
                    color: context.gym.info,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Tu progreso se mantendrá seguro',
                      style: TextStyle(
                        fontSize: 12,
                        color: context.gym.info,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: _isDeleting ? null : _handleCancel,
            child: Text(
              'Cancelar',
              style: TextStyle(
                color: context.gym.faint,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _isDeleting ? null : _handleDeleteConfirmed,
            style: ElevatedButton.styleFrom(
              backgroundColor: context.gym.xpInk,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isDeleting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _handleDeleteConfirmed() {
    setState(() {
      _isDeleting = true;
    });

    HapticFeedbackHelper.vibracionError();

    context.read<RoutineCubit>().deleteRoutine(
          id: widget.routineId,
          routineName: widget.routineName,
        );
  }

  void _handleCancel() {
    HapticFeedbackHelper.vibracionSeleccion();
    Navigator.of(context).pop();
  }

  void _handleDeleteSuccess() {
    HapticFeedbackHelper.vibracionExito();
    Navigator.of(context).pop();

    // Mostrar snackbar de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Rutina "${widget.routineName}" eliminada correctamente'),
        backgroundColor: context.gym.brand,
        action: SnackBarAction(
          label: 'Deshacer',
          textColor: Colors.white,
          onPressed: () {
            context.read<RoutineCubit>().restoreRoutine(id: widget.routineId);
          },
        ),
      ),
    );

    if (widget.onDeleted != null) {
      widget.onDeleted!();
    }
  }

  void _handleDeleteError(String error) {
    setState(() {
      _isDeleting = false;
    });

    HapticFeedbackHelper.vibracionError();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
        backgroundColor: context.gym.xpInk,
      ),
    );
  }
}
