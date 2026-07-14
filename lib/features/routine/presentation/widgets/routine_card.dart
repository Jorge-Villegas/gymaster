import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:gymaster/core/theme/espaciado.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';
import 'package:gymaster/shared/utils/text_formatter.dart';
import 'package:gymaster/shared/utils/haptic_feedback_helper.dart';
import 'package:gymaster/features/routine/presentation/widgets/delete_routine_dialog.dart';

class RoutineCard extends StatefulWidget {
  final VoidCallback onTap;
  final String cantidadEjerciciosPorSeries;
  final String title;
  final int color;
  final String? imagenDireccion;
  final int index; // Para animación escalonada
  final String? routineId; // ID para eliminación
  final VoidCallback? onDeleted; // Callback para notificar eliminación

  const RoutineCard({
    super.key,
    required this.color,
    required this.title,
    required this.onTap,
    required this.cantidadEjerciciosPorSeries,
    this.imagenDireccion,
    this.index = 0,
    this.routineId,
    this.onDeleted,
  });

  @override
  State<RoutineCard> createState() => _RoutineCardState();
}

class _RoutineCardState extends State<RoutineCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // Animación de entrada escalonada
    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    // Iniciar animación de entrada con delay basado en index
    Future.delayed(Duration(milliseconds: widget.index * 100), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
    HapticFeedbackHelper.vibracionSeleccion();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    widget.onTap();
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'delete':
        _showDeleteDialog();
        break;
    }
  }

  void _showDeleteDialog() {
    if (widget.routineId == null) return;

    HapticFeedbackHelper.vibracionSeleccion();

    showDialog(
      context: context,
      builder: (context) => DeleteRoutineDialog(
        routineName: widget.title,
        routineId: widget.routineId!,
        onDeleted: () {
          if (widget.onDeleted != null) {
            widget.onDeleted!();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - _slideAnimation.value)),
          child: Opacity(
            opacity: (_slideAnimation.value).clamp(0.0, 1.0),
            child: AnimatedScale(
              scale: _isPressed ? 0.95 : 1.0,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeInOut,
              child: GestureDetector(
                onTapDown: _onTapDown,
                onTapUp: _onTapUp,
                onTapCancel: _onTapCancel,
                child: Stack(
                  children: <Widget>[
                    _BotonGordoBackground(
                      widget.imagenDireccion ?? 'assets/default.svg',
                      Color(widget.color),
                      Color(widget.color),
                    ),
                    Positioned.fill(
                      child: Padding(
                        padding: Espaciado.rellenoHorizontalLg,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              TextFormatter.capitalize(widget.title),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: context.gym.ink,
                                height: 1.3,
                              ),
                            ),
                            Text(
                              widget.cantidadEjerciciosPorSeries,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: context.gym.ink,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Botón de menú contextual
                    if (widget.routineId != null)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: PopupMenuButton<String>(
                          onSelected: _handleMenuAction,
                          icon: Icon(
                            IconsaxPlusLinear.more,
                            color: Colors.white.withValues(alpha: 0.8),
                            size: 20,
                          ),
                          color: context.gym.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          itemBuilder: (BuildContext context) => [
                            PopupMenuItem<String>(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(
                                    IconsaxPlusLinear.trash,
                                    color: context.gym.danger,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Eliminar rutina',
                                    style: TextStyle(
                                      color: context.gym.danger,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BotonGordoBackground extends StatelessWidget {
  final String imagenDireccion;
  final Color color1;
  final Color color2;

  const _BotonGordoBackground(this.imagenDireccion, this.color1, this.color2);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [color1, color2]),
            ),
          ),
          Positioned(
            right: -20,
            top: -20,
            child: SvgPicture.asset(
              imagenDireccion,
              width: 150,
              height: 150,
              colorFilter: ColorFilter.mode(
                color1.withAlpha((0.75 * 255).toInt()),
                BlendMode.srcATop,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((0.1 * 255).toInt()),
                    offset: const Offset(4, 6),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
