import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gymaster/shared/widgets/tarjeta_estado.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/generated/assets.gen.dart';
import '../../../../core/services/emotional_message_service.dart';
import '../../../../core/theme/emotional_text_styles.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../record/presentation/cubit/record_cubit.dart';
import '../../../record/presentation/cubit/record_state.dart';
import '../cubits/ejercicios_by_rutina/ejercicios_by_rutina_cubit.dart';

class CelebracionRutinaPage extends StatefulWidget {
  final EjerciciosByRutinaCompleted estadoCompletado;

  const CelebracionRutinaPage({
    super.key,
    required this.estadoCompletado,
  });

  @override
  State<CelebracionRutinaPage> createState() => _CelebracionRutinaPageState();
}

class _CelebracionRutinaPageState extends State<CelebracionRutinaPage>
    with TickerProviderStateMixin {
  late AnimationController _animacionEntrada;
  late AnimationController _animacionTexto;
  late AnimationController _animacionEstadisticas;
  late AnimationController _animacionBoton;

  late Animation<double> _opacidadAnimacion;
  late Animation<Offset> _deslizamientoTexto;
  late Animation<double> _escalaEstadisticas;
  late Animation<double> _reboteBoton;

  int _totalRutinasCompletadas = 0;
  bool _cargandoRecords = false;

  @override
  void initState() {
    super.initState();
    _inicializarAnimaciones();
    _cargarDatosRecord();
    _iniciarSecuenciaAnimaciones();

    // Feedback háptico de celebración
    HapticFeedback.heavyImpact();
  }

  void _inicializarAnimaciones() {
    _animacionEntrada = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _animacionTexto = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _animacionEstadisticas = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _animacionBoton = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _opacidadAnimacion = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animacionEntrada,
      curve: Curves.easeInOut,
    ));

    _deslizamientoTexto = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animacionTexto,
      curve: Curves.elasticOut,
    ));

    _escalaEstadisticas = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animacionEstadisticas,
      curve: Curves.bounceOut,
    ));

    _reboteBoton = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animacionBoton,
      curve: Curves.elasticOut,
    ));
  }

  void _iniciarSecuenciaAnimaciones() {
    Future.delayed(const Duration(milliseconds: 300), () async {
      // 1. Entrada general con la animación Lottie
      _animacionEntrada.forward();

      // 2. Textos motivacionales
      await Future.delayed(const Duration(milliseconds: 400));
      _animacionTexto.forward();

      // 3. Estadísticas escalonadas
      await Future.delayed(const Duration(milliseconds: 600));
      _animacionEstadisticas.forward();

      // 4. Botón final
      await Future.delayed(const Duration(milliseconds: 800));
      _animacionBoton.forward();
    });
  }

  void _cargarDatosRecord() {
    final recordCubit = context.read<RecordCubit>();
    final currentState = recordCubit.state;

    if (currentState is RecordLoaded) {
      setState(() {
        _totalRutinasCompletadas = currentState.rutinas.length;
      });
    } else if (!_cargandoRecords) {
      setState(() {
        _cargandoRecords = true;
      });
      recordCubit.getAllRutinas();
    }
  }

  String _obtenerTiempoFormateado(Duration duracion) {
    final horas = duracion.inHours;
    final minutos = duracion.inMinutes.remainder(60);
    final segundos = duracion.inSeconds.remainder(60);

    if (horas > 0) {
      return '${horas}h ${minutos}m';
    } else if (minutos > 0) {
      return '${minutos}m ${segundos}s';
    } else {
      return '${segundos}s';
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevenir navegación hacia atrás
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocListener<RecordCubit, RecordState>(
          listener: (context, state) {
            if (state is RecordLoaded) {
              setState(() {
                _totalRutinasCompletadas = state.rutinas.length;
                _cargandoRecords = false;
              });
            }
          },
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final alturaAnimacion = constraints.maxHeight * 0.35;
                final anchoPantalla = constraints.maxWidth;
                final esMovil = anchoPantalla < 600;

                return Column(
                  children: [
                    // Área superior - Animación Lottie (35%)
                    FadeTransition(
                      opacity: _opacidadAnimacion,
                      child: SizedBox(
                        height: alturaAnimacion,
                        width: double.infinity,
                        child: Center(
                          child: SizedBox(
                            width: esMovil ? 200 : 250,
                            height: esMovil ? 200 : 250,
                            child: Lottie.asset(
                              Assets.lottie.alzandoPesas,
                              fit: BoxFit.contain,
                              repeat: true,
                              animate: true,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Área inferior - Contenido (65%)
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: esMovil ? 24 : 32,
                          vertical: esMovil ? 20 : 24,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Títulos motivacionales
                              SlideTransition(
                                position: _deslizamientoTexto,
                                child: FadeTransition(
                                  opacity: _animacionTexto,
                                  child: _construirSeccionTitulos(esMovil),
                                ),
                              ),

                              SizedBox(height: esMovil ? 16 : 20),

                              // Estadísticas
                              ScaleTransition(
                                scale: _escalaEstadisticas,
                                child: FadeTransition(
                                  opacity: _animacionEstadisticas,
                                  child: _construirEstadisticas(esMovil),
                                ),
                              ),

                              SizedBox(height: esMovil ? 24 : 32),

                              // Botón de continuar
                              ScaleTransition(
                                scale: _reboteBoton,
                                child: _construirBotonContinuar(esMovil),
                              ),

                              SizedBox(height: esMovil ? 16 : 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _construirSeccionTitulos(bool esMovil) {
    final tituloCompletacion =
        MensajesEmocionalesService.obtenerMensajeDeCompletacion(
      widget.estadoCompletado.rutinaName,
      _totalRutinasCompletadas,
      widget.estadoCompletado.totalEjercicios,
      widget.estadoCompletado.totalSeries,
    );

    final subtituloContextual =
        MensajesEmocionalesService.obtenerSubtituloContextual(
      widget.estadoCompletado.rutinaName,
      _totalRutinasCompletadas,
      widget.estadoCompletado.totalEjercicios,
    );

    return Column(
      children: [
        // Emoji header con bounce
        AnimatedBuilder(
          animation: _escalaEstadisticas,
          builder: (context, child) {
            return Transform.scale(
              scale: 1.0 + (_escalaEstadisticas.value * 0.3),
              child: Text(
                '${_totalRutinasCompletadas.iconoProgreso} ¡Felicidades! ${_totalRutinasCompletadas.iconoProgreso}',
                style: EstilosTextoEmocional.celebracion.copyWith(
                  fontSize: esMovil ? 32 : 40,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
        SizedBox(height: esMovil ? 8 : 12),
        Text(
          subtituloContextual,
          style: EstilosTextoEmocional.aliento.copyWith(
            fontSize: esMovil ? 16 : 18,
            color: Colors.grey[800],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _construirEstadisticas(bool esMovil) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: esMovil ? 8 : 16,
        vertical: esMovil ? 12 : 20,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: TarjetaEstado(
              titulo: 'Ejercicios',
              textoCuerpo: widget.estadoCompletado.totalEjercicios.toString(),
              icono: Icons.fitness_center,
              colorFondo: AppColors.motivacionPrincipal,
            ),
          ),
          SizedBox(width: esMovil ? 8 : 16),
          Expanded(
            child: TarjetaEstado(
              titulo: 'Series',
              textoCuerpo: widget.estadoCompletado.totalSeries.toString(),
              icono: Icons.repeat,
              colorFondo: AppColors.exitoCompletado,
            ),
          ),
          SizedBox(width: esMovil ? 8 : 16),
          Expanded(
            child: TarjetaEstado(
              titulo: 'Tiempo',
              textoCuerpo:
                  _obtenerTiempoFormateado(widget.estadoCompletado.tiempoTotal),
              icono: Icons.timer,
              colorFondo: AppColors.logroDesbloqueado,
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirBotonContinuar(bool esMovil) {
    return SizedBox(
      width: double.infinity,
      height: esMovil ? 56 : 64,
      child: ElevatedButton(
        onPressed: () {
          HapticFeedback.mediumImpact();
          context.go('/'); // Volver al inicio
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.logroDesbloqueado,
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: AppColors.logroDesbloqueado.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          'RECIBIR XP',
          style: TextStyle(
            fontSize: esMovil ? 16 : 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontFamily: 'ZonaPro',
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animacionEntrada.dispose();
    _animacionTexto.dispose();
    _animacionEstadisticas.dispose();
    _animacionBoton.dispose();
    super.dispose();
  }
}
