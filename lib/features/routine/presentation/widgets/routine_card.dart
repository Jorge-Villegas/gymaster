import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gymaster/shared/utils/text_formatter.dart';
import 'package:gymaster/shared/utils/haptic_feedback_helper.dart';

class RoutineCard extends StatefulWidget {
  final VoidCallback onTap;
  final String cantidadEjerciciosPorSeries;
  final String title;
  final int color;
  final String? imagenDireccion;
  final int index; // Para animación escalonada

  const RoutineCard({
    super.key,
    required this.color,
    required this.title,
    required this.onTap,
    required this.cantidadEjerciciosPorSeries,
    this.imagenDireccion,
    this.index = 0,
  });

  @override
  State<RoutineCard> createState() => _RoutineCardState();
}

class _RoutineCardState extends State<RoutineCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

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

  @override
  Widget build(BuildContext context) {
    const Color colorTitle = Colors.black;
    const Color colorSubtitle = Colors.black45;

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
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              TextFormatter.capitalize(widget.title),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: colorTitle,
                              ),
                            ),
                            Text(
                              widget.cantidadEjerciciosPorSeries,
                              style: const TextStyle(
                                  color: colorSubtitle, fontSize: 18),
                            ),
                          ],
                        ),
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
