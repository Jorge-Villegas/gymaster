import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gymaster/core/config/app_config.dart';
import 'package:gymaster/core/theme/app_colors.dart';
import 'package:gymaster/core/theme/emotional_text_styles.dart';
import 'package:gymaster/features/routine/presentation/cubits/agregar_series/agregar_series_cubit.dart';
import 'package:gymaster/features/routine/presentation/cubits/agregar_series/agregar_series_state.dart';
import 'package:gymaster/features/routine/presentation/cubits/ejercicio/ejercicio_cubit.dart';
import 'package:gymaster/features/routine/presentation/cubits/rutina/routine_cubit.dart';
import 'package:gymaster/features/routine/presentation/widgets/encabezado_ejercicio_widget.dart';
import 'package:gymaster/features/routine/presentation/widgets/lista_series_widget.dart';
import 'package:gymaster/shared/utils/snackbar_helper.dart';
import 'package:gymaster/shared/utils/text_formatter.dart';
import 'package:gymaster/shared/widgets/chiclet_button.dart';
import 'package:animate_do/animate_do.dart';

class AgregarEjercicioRutinaPage extends StatefulWidget {
  final String nombreEjercicio;
  final String idSesion;
  final String direccionImagenEjercicio;
  final String idEjercicio;
  final String idRutina;

  const AgregarEjercicioRutinaPage({
    super.key,
    required this.idSesion,
    required this.nombreEjercicio,
    required this.idEjercicio,
    required this.idRutina,
    String? direccionImagenEjercicio,
  }) : direccionImagenEjercicio =
            direccionImagenEjercicio ?? AppConfig.defaultImagePath;

  @override
  State<AgregarEjercicioRutinaPage> createState() =>
      _AgregarEjercicioRutinaPageState();
}

class _AgregarEjercicioRutinaPageState
    extends State<AgregarEjercicioRutinaPage> {
  final _claveFomulario = GlobalKey<FormState>();
  final List<TextEditingController> _controladoresPeso = [];
  final List<TextEditingController> _controladoresRepeticiones = [];

  @override
  void initState() {
    super.initState();
    _controladoresPeso.add(TextEditingController());
    _controladoresRepeticiones.add(TextEditingController());
    context.read<AgregarSeriesCubit>().iniciar();
  }

  void _sincronizarControladores(int cantidadSeries) {
    while (_controladoresPeso.length < cantidadSeries) {
      _controladoresPeso.add(TextEditingController());
      _controladoresRepeticiones.add(TextEditingController());
    }

    while (_controladoresPeso.length > cantidadSeries) {
      _controladoresPeso.removeLast().dispose();
      _controladoresRepeticiones.removeLast().dispose();
    }
  }

  @override
  void dispose() {
    for (var controller in _controladoresPeso) {
      controller.dispose();
    }
    for (var controller in _controladoresRepeticiones) {
      controller.dispose();
    }
    super.dispose();
  }

  void _guardarDatos() async {
    FocusScope.of(context).unfocus();

    if (_controladoresPeso.isEmpty || _controladoresRepeticiones.isEmpty) {
      SnackbarHelper.showSafeSnackBar(
        context,
        'Por favor, agregue al menos una serie',
        SnackBarType.error,
      );
      return;
    }

    if (!_claveFomulario.currentState!.validate()) {
      SnackbarHelper.showSafeSnackBar(
        context,
        'Por favor, complete todos los campos',
        SnackBarType.error,
      );
      return;
    }

    List<double?> pesos = _controladoresPeso
        .map((controller) => TextFormatter.stringToDouble(controller.text))
        .toList();
    List<int?> repeticiones = _controladoresRepeticiones
        .map((controller) => TextFormatter.stringToInt(controller.text))
        .toList();

    if (pesos.contains(null) || repeticiones.contains(null)) {
      SnackbarHelper.showSafeSnackBar(
        context,
        'Por favor, ingrese números válidos',
        SnackBarType.error,
      );
      return;
    }

    final resultado = await context.read<AgregarSeriesCubit>().guardarDatos(
          idSesion: widget.idSesion,
          rutinaId: widget.idRutina,
          ejercicioId: widget.idEjercicio,
          pesos: pesos.cast<double>(),
          repeticiones: repeticiones.cast<int>(),
        );

    if (!mounted) return;

    if (resultado) {
      context.read<EjercicioCubit>().ejercicioAgregado(id: widget.idEjercicio);
      context.read<RoutineCubit>().getAllRoutine();
      context.pop();

      SnackbarHelper.showSafeSnackBar(
        context,
        '¡Ejercicio guardado con éxito! 💪',
        SnackBarType.success,
      );
    } else {
      final state = context.read<AgregarSeriesCubit>().state;
      if (state is AgregarSeriesError) {
        SnackbarHelper.showSafeSnackBar(
          context,
          state.message,
          SnackBarType.error,
        );
        context.pop();
      } else {
        SnackbarHelper.showSafeSnackBar(
          context,
          'Error inesperado al guardar el ejercicio',
          SnackBarType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.backgroundLight,
              Colors.white,
              AppColors.backgroundLight.withOpacity(0.8),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _construirHeaderEmocional(),
              Expanded(
                child: BlocListener<AgregarSeriesCubit, AgregarSeriesState>(
                  listener: (context, state) {
                    if (state is AgregarSeriesLoaded) {
                      _sincronizarControladores(state.cantidadSeries);
                    }
                  },
                  child: BlocBuilder<AgregarSeriesCubit, AgregarSeriesState>(
                    builder: (context, state) {
                      if (state is AgregarSeriesLoaded) {
                        final etiquetaHero =
                            'exercise-image-${widget.idEjercicio}';
                        return FadeInUp(
                          duration: const Duration(milliseconds: 600),
                          child: Form(
                            key: _claveFomulario,
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: EncabezadoEjercicioWidget(
                                      heroTag: etiquetaHero,
                                      nombreEjercicio: widget.nombreEjercicio,
                                      cantidadSeries: state.cantidadSeries,
                                      urlImage: widget.direccionImagenEjercicio,
                                      onIncrement: () {
                                        context
                                            .read<AgregarSeriesCubit>()
                                            .incrementarSeries();
                                      },
                                      onDecrement: () {
                                        context
                                            .read<AgregarSeriesCubit>()
                                            .decrementarSeries();
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: ListaSeriesWidget(
                                      cantidadSeries: state.cantidadSeries,
                                      pesoControllers: _controladoresPeso,
                                      repeticionesControllers:
                                          _controladoresRepeticiones,
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Center(
                                      child: _construirBotonGuardar(),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return _construirEstadoCarga();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget del header emocional motivacional
  Widget _construirHeaderEmocional() {
    return FadeInDown(
      duration: const Duration(milliseconds: 800),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Botón de volver minimalista
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color:
                        AppColors.motivacionPrincipal.withValues(alpha: 0.15),
                    offset: const Offset(0, 2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () => context.pop(),
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: AppColors.motivacionPrincipal,
                  size: 20,
                ),
                padding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(width: 16),
            // Título emocional simple
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '¡Configura tu poder!',
                    style: EstilosTextoEmocional.energetico.copyWith(
                      color: AppColors.primary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget del botón guardar motivacional
  Widget _construirBotonGuardar() {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: ChicletButton(
        onPressed: _guardarDatos,
        texto: '¡Guardar ejercicio!',
        tamano: TamanoBotonChiclet.grande,
        estilo: EstiloBotonChiclet.relleno,
        colorFondo: AppColors.exitoCompletado,
      ),
    );
  }

  // Widget de estado de carga emocional
  Widget _construirEstadoCarga() {
    return FadeIn(
      duration: const Duration(milliseconds: 600),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.motivacionPrincipal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.motivacionPrincipal),
                  strokeWidth: 3,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Preparando tu entrenamiento...',
              style: EstilosTextoEmocional.amigable.copyWith(
                color: AppColors.primary,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '¡Casi listo para entrenar! 💪',
              style: EstilosTextoEmocional.aliento.copyWith(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
