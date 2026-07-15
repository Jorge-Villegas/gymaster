import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';
import 'package:gymaster/core/theme/gym_typography.dart';
import 'package:gymaster/shared/utils/text_formatter.dart';
import 'package:gymaster/shared/utils/haptic_feedback_helper.dart';
import 'package:gymaster/features/routine/presentation/widgets/delete_routine_dialog.dart';

/// Acento de color normalizado a la paleta candy del tema. El color guardado
/// por rutina (un `int` arbitrario) se mapea al tono más cercano para que todas
/// las tarjetas se vean de la misma familia y se adapten a claro/oscuro.
enum _Acento { brand, coral, xp, info, plum }

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
    setState(() => _isPressed = true);
    HapticFeedbackHelper.vibracionSeleccion();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    widget.onTap();
  }

  void _onTapCancel() => setState(() => _isPressed = false);

  void _handleMenuAction(String action) {
    if (action == 'delete') _showDeleteDialog();
  }

  void _showDeleteDialog() {
    if (widget.routineId == null) return;
    HapticFeedbackHelper.vibracionSeleccion();
    showDialog(
      context: context,
      builder: (context) => DeleteRoutineDialog(
        routineName: widget.title,
        routineId: widget.routineId!,
        onDeleted: () => widget.onDeleted?.call(),
      ),
    );
  }

  /// Mapea el color arbitrario de la rutina al tono de paleta más cercano
  /// (por matiz). Los grises caen a la marca. Estable: mismo color → mismo tono.
  _Acento _acentoDe(Color c) {
    final hsv = HSVColor.fromColor(c);
    if (hsv.saturation < 0.12) return _Acento.brand; // gris/neutro → marca
    const anclas = <_Acento, double>{
      _Acento.coral: 13,
      _Acento.xp: 45,
      _Acento.brand: 136,
      _Acento.info: 200,
      _Acento.plum: 252,
    };
    _Acento mejor = _Acento.brand;
    double menor = 360;
    anclas.forEach((acento, hue) {
      final d = (hsv.hue - hue).abs();
      final dist = d > 180 ? 360 - d : d; // distancia circular
      if (dist < menor) {
        menor = dist;
        mejor = acento;
      }
    });
    return mejor;
  }

  /// Resuelve el trío (base, suave, tinta) del tema para un acento. Al leerse de
  /// `context.gym`, se adapta automáticamente a claro/oscuro.
  (Color, Color, Color) _coloresAcento(GymColors g, _Acento a) {
    return switch (a) {
      _Acento.brand => (g.brand, g.brandSoft, g.brandInk),
      _Acento.coral => (g.coral, g.coralSoft, g.coralInk),
      _Acento.xp => (g.xp, g.xpSoft, g.xpInk),
      _Acento.info => (g.info, g.infoSoft, g.info),
      _Acento.plum => (g.plum, g.plumSoft, g.plum),
    };
  }

  @override
  Widget build(BuildContext context) {
    final g = context.gym;
    final (base, suave, tinta) = _coloresAcento(g, _acentoDe(Color(widget.color)));

    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - _slideAnimation.value)),
          child: Opacity(
            opacity: _slideAnimation.value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        child: GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: g.surface,
              borderRadius: GymRadius.rMd,
              border: Border.all(color: g.line),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                _chip(base, suave),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        TextFormatter.capitalize(widget.title),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GymType.section.copyWith(color: g.ink),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        widget.cantidadEjerciciosPorSeries,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GymType.label.copyWith(
                          color: g.muted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _trailing(g, tinta),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Chip de icono con el color de acento (fondo suave + imagen/ícono tintado).
  Widget _chip(Color base, Color suave) {
    final ruta = widget.imagenDireccion;
    return Container(
      width: 56,
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: suave,
        borderRadius: GymRadius.rSm,
      ),
      child: ruta != null && ruta.isNotEmpty
          ? SvgPicture.asset(
              ruta,
              width: 30,
              height: 30,
              colorFilter: ColorFilter.mode(base, BlendMode.srcIn),
              placeholderBuilder: (_) =>
                  Icon(IconsaxPlusLinear.weight, color: base, size: 28),
            )
          : Icon(IconsaxPlusLinear.weight, color: base, size: 28),
    );
  }

  /// Zona derecha: chevron + menú contextual (eliminar) si aplica.
  Widget _trailing(GymColors g, Color tinta) {
    if (widget.routineId == null) {
      return Icon(IconsaxPlusLinear.arrow_right_3, size: 18, color: g.faint);
    }
    return PopupMenuButton<String>(
      onSelected: _handleMenuAction,
      icon: Icon(IconsaxPlusLinear.more, color: g.faint, size: 20),
      color: g.surface,
      shape: RoundedRectangleBorder(borderRadius: GymRadius.rMd),
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Icon(IconsaxPlusLinear.trash, color: g.danger, size: 18),
              const SizedBox(width: 12),
              Text(
                'Eliminar rutina',
                style: GymType.body.copyWith(
                  color: g.danger,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
