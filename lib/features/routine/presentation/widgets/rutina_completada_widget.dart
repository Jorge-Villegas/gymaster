import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gymaster/shared/widgets/gym/gym.dart';
import 'package:gymaster/shared/widgets/tarjeta_estado.dart';
import 'package:lottie/lottie.dart';
import 'package:gymaster/core/generated/assets.gen.dart';
import 'package:gymaster/core/theme/gym_typography.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';
import 'package:gymaster/core/services/emotional_message_service.dart';
import 'package:gymaster/shared/utils/haptic_feedback_helper.dart';
import 'package:gymaster/shared/utils/audio_feedback_helper.dart';
import 'package:gymaster/features/routine/presentation/cubits/ejercicios_by_rutina/ejercicios_by_rutina_cubit.dart';
import 'package:gymaster/features/record/presentation/cubit/record_cubit.dart';
import 'package:gymaster/features/record/presentation/cubit/record_state.dart';

class RutinaCompletadaWidget extends StatefulWidget {
  final EjerciciosByRutinaCompleted state;

  const RutinaCompletadaWidget({
    super.key,
    required this.state,
  });

  @override
  State<RutinaCompletadaWidget> createState() => _RutinaCompletadaWidgetState();
}

class _RutinaCompletadaWidgetState extends State<RutinaCompletadaWidget>
    with TickerProviderStateMixin {
  int _totalRutinasCompletadas = 1; // Default para primera rutina
  bool _isLoadingRecords = false;

  // Controladores de animación para efectos tipo Duolingo
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _statsController;

  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _statsAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadCompletedRoutinesCount();
    _startCelebrationSequence();
  }

  void _setupAnimations() {
    // Animación de deslizamiento para el contenido principal
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));

    // Animación de escala para elementos interactivos
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    // Animación para las estadísticas
    _statsController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _statsAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _statsController,
      curve: Curves.easeOutQuart,
    ));
  }

  void _startCelebrationSequence() {
    // Secuencia de animaciones estilo Duolingo
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      HapticFeedbackHelper.vibracionLogro();
      AudioFeedbackHelper.reproducirSonidoCelebracion();

      // 1. Contenido principal con bounce
      _slideController.forward();

      // 2. Animación de escala para elementos importantes
      await Future.delayed(const Duration(milliseconds: 400));
      _scaleController.forward();

      // 3. Finalmente las estadísticas con stagger
      await Future.delayed(const Duration(milliseconds: 600));
      _statsController.forward();
    });
  }

  void _loadCompletedRoutinesCount() {
    final recordCubit = context.read<RecordCubit>();
    final currentState = recordCubit.state;

    if (currentState is RecordLoaded) {
      // Si ya tenemos los datos, usarlos directamente
      setState(() {
        _totalRutinasCompletadas = currentState.rutinas.length;
      });
    } else if (!_isLoadingRecords) {
      // Solo cargar si no estamos ya cargando
      setState(() {
        _isLoadingRecords = true;
      });
      recordCubit.getAllRutinas();
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _scaleController.dispose();
    _statsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecordCubit, RecordState>(
      listener: (context, recordState) {
        if (recordState is RecordLoaded && _isLoadingRecords) {
          setState(() {
            _totalRutinasCompletadas = recordState.rutinas.length;
            _isLoadingRecords = false;
          });
        }
      },
      child: Scaffold(
        backgroundColor: _buildGradientBackground(),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double screenWidth = constraints.maxWidth;
              final bool isSmallScreen = screenWidth < 400;
              final double horizontalPadding = isSmallScreen ? 8.0 : 24.0;
              final double verticalPadding = isSmallScreen ? 8.0 : 24.0;
              final double heroSize = isSmallScreen ? screenWidth * 0.6 : 200.0;

              return Stack(
                children: [
                  SlideTransition(
                    position: _slideAnimation,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                          vertical: verticalPadding,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: isSmallScreen ? 32 : 60),
                            _construirSeccionHeroResponsiva(context, heroSize),
                            SizedBox(height: isSmallScreen ? 16 : 32),
                            _construirGridEstadisticasEscalonadasResponsivo(
                                context),
                            SizedBox(height: isSmallScreen ? 24 : 40),
                            _construirBotonesAccionMejorados(context),
                            SizedBox(height: isSmallScreen ? 12 : 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _buildFloatingCloseButton(context),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Color _buildGradientBackground() {
    return Theme.of(context).scaffoldBackgroundColor;
  }

  Widget _construirSeccionHeroResponsiva(
      BuildContext context, double heroSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            height: heroSize,
            width: heroSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(heroSize / 2),
              boxShadow: [
                BoxShadow(
                  color: context.gym.xpInk.withValues(alpha: 0.4),
                  blurRadius: 30,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Lottie.asset(
              Assets.lottie.alzandoPesas,
              repeat: true,
              animate: true,
            ),
          ),
        ),
        SizedBox(height: heroSize * 0.16),
        ScaleTransition(
          scale: _scaleAnimation,
          child: _buildDuolingoStyleTitle(context),
        ),
        SizedBox(height: heroSize * 0.08),
        _buildAnimatedSubtitle(context),
      ],
    );
  }

  Widget _buildDuolingoStyleTitle(BuildContext context) {
    final String mensajePersonalizado =
        MensajesEmocionalesService.obtenerMensajeDeCompletacion(
      widget.state.rutinaName,
      _totalRutinasCompletadas,
      widget.state.totalEjercicios,
      widget.state.totalSeries,
    );

    return Column(
      children: [
        // Emoji header con bounce
        AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: 1.0 + (_scaleAnimation.value * 0.3),
              child: Text(
                '${_totalRutinasCompletadas.iconoProgreso} ¡Felicidades! ${_totalRutinasCompletadas.iconoProgreso}',
                style: GymType.display.copyWith(
                  fontSize: 32,
                ),
                textAlign: TextAlign.center,
              ),
            );
          },
        ),

        const SizedBox(height: 16),

        // Badge de progreso
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                context.gym.xpInk.withValues(alpha: 0.9),
                context.gym.xpInk.withValues(alpha: 0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: context.gym.xpInk.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            _totalRutinasCompletadas.insigniaProgreso,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: 1.2,
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Mensaje personalizado
        Text(
          mensajePersonalizado,
          style: GymType.section.copyWith(
            fontSize: 18,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAnimatedSubtitle(BuildContext context) {
    final String subtituloContextual =
        MensajesEmocionalesService.obtenerSubtituloContextual(
      widget.state.rutinaName,
      _totalRutinasCompletadas,
      widget.state.totalEjercicios,
    );

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Column(
        children: [
          Text(
            subtituloContextual,
            style: GymType.section.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            MensajesEmocionalesService.obtenerEstadisticasContext(
                _totalRutinasCompletadas),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.gym.xpInk,
                  fontWeight: FontWeight.w500,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            MensajesEmocionalesService.obtenerProyeccionDeLogros(
                _totalRutinasCompletadas),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _construirGridEstadisticasEscalonadasResponsivo(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 400;
        final cardWidth = isSmallScreen
            ? (constraints.maxWidth - 16) /
                2 // 2 cards por fila en pantallas pequeñas
            : (constraints.maxWidth - 32) /
                3; // 3 cards por fila en pantallas grandes

        return AnimatedBuilder(
          animation: _statsAnimation,
          builder: (context, child) {
            return Wrap(
              alignment: WrapAlignment.center,
              spacing: isSmallScreen ? 8 : 16,
              runSpacing: isSmallScreen ? 8 : 16,
              children: [
                // Card de total de ejercicios
                _buildAnimatedCard(
                  index: 1,
                  cardWidth: cardWidth,
                  child: TarjetaEstado(
                    titulo: 'Ejercicios',
                    textoCuerpo: widget.state.totalEjercicios.toString(),
                    icono: Icons.fitness_center,
                    colorFondo: context.gym.xpInk,
                  ),
                ),
                // Card de Completado
                _buildAnimatedCard(
                  index: 2,
                  cardWidth: cardWidth,
                  child: TarjetaEstado(
                    titulo: 'Tiempo',
                    textoCuerpo: _formatearTiempo(widget.state.tiempoTotal),
                    icono: Icons.timer,
                    colorFondo: context.gym.brand,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildAnimatedCard({
    required int index,
    required double cardWidth,
    required Widget child,
  }) {
    final delay = index * 0.2;
    final adjustedValue = (_statsAnimation.value - delay).clamp(0.0, 1.0);

    return Transform.translate(
      offset: Offset(0, (1 - adjustedValue) * 30),
      child: Opacity(
        opacity: adjustedValue,
        child: SizedBox(
          width: cardWidth,
          child: child,
        ),
      ),
    );
  }

  Widget _construirBotonesAccionMejorados(BuildContext context) {
    return AnimatedBuilder(
      animation: _statsAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, (1 - _statsAnimation.value) * 50),
          child: Opacity(
            opacity: _statsAnimation.value,
            child: Column(
              children: [
                // Botón principal
                GymButton(
                  label: 'Continuar Entrenando',
                  icon: Icons.fitness_center,
                  variant: GymButtonVariant.primary,
                  size: GymButtonSize.large,
                  expand: false,
                  onPressed: () => _navegarAlInicio(context),
                ),

                const SizedBox(height: 12),

                // Botón secundario
                GymButton(
                  label: 'Ver Mi Progreso',
                  icon: Icons.trending_up,
                  variant: GymButtonVariant.ghost,
                  size: GymButtonSize.large,
                  expand: false,
                  onPressed: () => _navegarAlHistorial(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFloatingCloseButton(BuildContext context) {
    return Positioned(
      top: 16,
      right: 16,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: context.gym.surface.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () {
              HapticFeedbackHelper.vibracionLogro();
              _navegarAlInicio(context);
            },
            icon: Icon(
              Icons.close,
              size: 24,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }

  String _formatearTiempo(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  void _navegarAlInicio(BuildContext context) {
    context.go('/');
  }

  void _navegarAlHistorial(BuildContext context) {
    // TODO: Implementar navegación al historial cuando esté disponible
    context.go('/');
  }
}
