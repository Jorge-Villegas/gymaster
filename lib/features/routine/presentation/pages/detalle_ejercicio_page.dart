import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gymaster/core/theme/app_colors.dart';
import 'package:gymaster/core/theme/emotional_text_styles.dart';
import 'package:gymaster/core/theme/espaciado.dart';
import 'package:gymaster/core/theme/tipografia_gymaster.dart';

import 'package:gymaster/features/exercise/presentation/cubits/favorito_ejercicio_cubit.dart';
import 'package:gymaster/features/exercise/presentation/cubits/favorito_ejercicio_state.dart';
import 'package:gymaster/features/routine/domain/entities/ejercicios_de_rutina.dart';
import 'package:gymaster/features/routine/presentation/cubits/ejercicios_by_rutina/ejercicios_by_rutina_cubit.dart';
import 'package:gymaster/features/routine/presentation/widgets/rutina_cancelada_widget.dart';
import 'package:gymaster/features/routine/presentation/widgets/rutina_completada_widget.dart';
import 'package:gymaster/shared/utils/text_formatter.dart';
import 'package:gymaster/shared/utils/verificador_tipo_archivo.dart';
import 'package:gymaster/shared/widgets/cabecera_reutilizable.dart';
import 'package:gymaster/shared/widgets/chiclet_button.dart';
import 'package:animate_do/animate_do.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

class CustomDataTable extends StatelessWidget {
  final List<String> headers;
  final List<List<String>> data;
  final bool showActions;
  final Color backgroundColor;
  final Color headerColor;
  final Color bodyTextColor;
  final Color headerTextColor;
  final TextAlign cellTextAlign;
  final double rowHeight;
  final List<Color>? rowColors; // Hacer rowColors opcional
  final List<bool>?
      completedRows; // Añadir lista opcional para indicar filas completadas

  const CustomDataTable({
    super.key,
    required this.headers,
    required this.data,
    this.showActions = false,
    this.backgroundColor = Colors.white,
    this.headerColor = Colors.grey,
    this.bodyTextColor = Colors.black,
    this.headerTextColor = Colors.white,
    this.cellTextAlign = TextAlign.left,
    this.rowHeight = 45.0,
    this.rowColors,
    this.completedRows,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Table(
      border: TableBorder.all(color: Colors.grey.shade300, width: 1),
      columnWidths: const <int, TableColumnWidth>{
        0: IntrinsicColumnWidth(), // Serie
        1: IntrinsicColumnWidth(), // Peso
        2: IntrinsicColumnWidth(), // Reps
        3: IntrinsicColumnWidth(), // Checkmark (si está completado)
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        // Fila de Encabezado
        TableRow(
          decoration: BoxDecoration(color: headerColor),
          children: [
            ...headers.map(
              (header) => Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(
                  header,
                  // Cambiado de labelMedium a labelSmall
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: headerTextColor),
                  textAlign: cellTextAlign,
                ),
              ),
            ),
            // Encabezado vacío para la columna de marca de verificación
            const SizedBox.shrink(),
          ],
        ),
        // Filas de Datos
        ...data.asMap().entries.map((entry) {
          int idx = entry.key;
          List<String> rowData = entry.value;
          bool isCompleted = completedRows != null &&
              idx < completedRows!.length &&
              completedRows![idx];
          Color rowColor = rowColors != null && idx < rowColors!.length
              ? rowColors![idx]
              : (isCompleted ? Colors.green.shade100 : Colors.grey.shade100);

          return TableRow(
            decoration: BoxDecoration(color: rowColor),
            children: [
              ...rowData.map(
                (cellData) => Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(
                    cellData,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: bodyTextColor,
                      decoration: isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                    textAlign: cellTextAlign,
                  ),
                ),
              ),
              // Celda de marca de verificación
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: isCompleted
                    ? Icon(Icons.check_circle,
                        color: Colors.green.shade700, size: 14)
                    : const SizedBox(width: 14),
              ),
            ],
          );
        }),
      ],
    );
  }
}

class DetalleEjercicioScreen extends StatelessWidget {
  const DetalleEjercicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EjerciciosByRutinaCubit, EjerciciosByRutinaState>(
      builder: (context, state) {
        if (state is EjerciciosByRutinaCancelled) {
          return RutinaCanceladaWidget(
            rutinaName: state.rutinaName,
            rutinaId: state.rutinaId,
            sessionId: state.sessionId,
            totalEjercicios: state.totalEjercicios,
            fechaCancelada: state.fechaCancelada,
          );
        }
        if (state is EjerciciosByRutinaLoading) {
          return _buildLoadingState();
        }
        if (state is EjerciciosByRutinaError) {
          return _buildErrorState(state.message);
        }
        if (state is EjerciciosByRutinaCompleted) {
          return RutinaCompletadaWidget(state: state);
        }
        if (state is EjerciciosByRutinaSuccess) {
          return _buildSuccessState(context, state);
        }
        return _buildErrorState('Estado inesperado');
      },
    );
  }

  Widget _buildExerciseImage(String imagenDireccion) {
    return Container(
      margin: Espaciado.rellenoHorizontalMd,
      child: AspectRatio(
        aspectRatio: 1.2,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Espaciado.sm),
            gradient: AppColors.gradientePrimario,
            boxShadow: AppColors.sombraSuave,
          ),
          clipBehavior: Clip.antiAlias,
          child: _buildImageWidget(imagenDireccion),
        ),
      ),
    );
  }

// Admite SVG, PNG/JPG y fallback
  Widget _buildImageWidget(String imagenDireccion) {
    if (VerificadorTipoArchivo.esSvg(imagenDireccion)) {
      return SvgPicture.asset(
        imagenDireccion,
        fit: BoxFit.contain,
        semanticsLabel: 'Ilustración del ejercicio',
        placeholderBuilder: (context) => _buildImagePlaceholder(),
      );
    }
    if (VerificadorTipoArchivo.esImagen(imagenDireccion)) {
      return Image.asset(
        imagenDireccion,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(),
      );
    }
    return _buildImagePlaceholder();
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: Colors.grey[100],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.fitness_center_rounded,
              size: 56,
              color: AppColors.acento,
            ),
            const SizedBox(height: 10),
            Text(
              'Imagen no disponible',
              style: EstilosTextoEmocional.amigable.copyWith(
                color: AppColors.textoTerciario,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget reutilizable para mostrar un dato centralizado (valor grande, etiqueta y unidad)
  Widget _buildDatoEjercicioCentral({
    required String valor,
    required String etiqueta,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          valor,
          style: EstilosTextoEmocional.contador.copyWith(
            fontSize: TipografiaGyMaster.tamano5xl,
            color: AppColors.acento,
            fontWeight: TipografiaGyMaster.pesoSemiBold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: Espaciado.xxs),
        Text(
          etiqueta,
          style: EstilosTextoEmocional.amigable.copyWith(
            fontSize: TipografiaGyMaster.tamanoSm,
            color: AppColors.textoSecundarioOscuro,
            fontWeight: TipografiaGyMaster.pesoRegular,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildOptimizedControls(
      BuildContext context, Serie serie, EjerciciosByRutinaSuccess state) {
    return Container(
      width: double.infinity,
      margin: Espaciado.rellenoHorizontalMd,
      padding: Espaciado.rellenoMd,
      decoration: BoxDecoration(
        color: AppColors.fondoTarjetaClaro,
        borderRadius: BorderRadius.circular(Espaciado.sm),
        boxShadow: AppColors.sombraSuave,
      ),
      child: Column(
        children: [
          Text(
            '¡Ajusta tu entrenamiento!',
            style: TextStyle(
              fontWeight: TipografiaGyMaster.pesoSemiBold,
              fontSize: TipografiaGyMaster.tamanoLg,
              color: AppColors.primarioCalido,
              height: 1.1,
            ),
          ),

          SizedBox(height: Espaciado.md),

          // Control de repeticiones
          _buildControlSection(
            title: 'Repeticiones',
            value: serie.repeticiones,
            color: AppColors.acento,
            onIncrement: () =>
                context.read<EjerciciosByRutinaCubit>().aumentarRepeticiones(),
            onDecrement: () =>
                context.read<EjerciciosByRutinaCubit>().disminuirRepeticiones(),
          ),

          SizedBox(height: Espaciado.sm),

          // Control de peso
          _buildControlSection(
            title: 'Peso (kg)',
            value: serie.peso.round(),
            color: AppColors.acento,
            onIncrement: () =>
                context.read<EjerciciosByRutinaCubit>().aumentarPeso(),
            onDecrement: () =>
                context.read<EjerciciosByRutinaCubit>().disminuirPeso(),
          ),
        ],
      ),
    );
  }

  Widget _buildControlSection({
    required String title,
    required int value,
    required Color color,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontWeight: TipografiaGyMaster.pesoRegular,
              fontSize: TipografiaGyMaster.tamanoLg,
              color: AppColors.textoPrincipalOscuro,
            ),
          ),
        ),
        Row(
          children: [
            ChicletButton(
              onPressed: onDecrement,
              icono: Icons.remove_rounded,
              texto: '',
              colorFondo: AppColors.textoTerciario,
              colorTexto: Colors.white,
              tamano: TamanoBotonChiclet.pequeno,
              estilo: EstiloBotonChiclet.relleno,
              paddingHorizontal: 8,
              paddingVertical: 4,
              ancho: 36,
              alto: 36,
            ),
            Container(
              width: Espaciado.xxxl,
              alignment: Alignment.center,
              child: Text(
                '$value',
                style: TextStyle(
                  fontWeight: TipografiaGyMaster.pesoRegular, // SemiBold
                  fontSize: TipografiaGyMaster.tamano2xl,
                  color: AppColors.textoPrincipalOscuro,
                ),
              ),
            ),
            ChicletButton(
              onPressed: onIncrement,
              texto: '',
              icono: Icons.add,
              colorFondo: AppColors.secundario,
              colorTexto: Colors.white,
              tamano: TamanoBotonChiclet.pequeno,
              estilo: EstiloBotonChiclet.relleno,
              paddingHorizontal: 8,
              paddingVertical: 4,
              ancho: 36,
              alto: 36,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmotionalDynamicActionButtons(BuildContext context,
      Ejercicio ejercicio, EjerciciosByRutinaSuccess state) {
    return Container(
      padding: Espaciado.rellenoMd,
      decoration: BoxDecoration(
        color: AppColors.fondoTarjetaClaro,
        boxShadow: AppColors.sombraSuave,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            // Botón principal dinámico
            _buildMainActionButton(context, state),

            SizedBox(height: Espaciado.sm),

            // Botones secundarios
            Row(
              children: [
                Expanded(
                  child: ChicletButton(
                    onPressed: () => _handleCancelRoutine(context, state),
                    texto: 'Pausar',
                    icono: Icons.pause_circle_outline_rounded,
                    tamano: TamanoBotonChiclet.mediano,
                    estilo: EstiloBotonChiclet.contorno,
                    colorBorde: AppColors.textoTerciario,
                    colorTexto: AppColors.textoTerciario,
                  ),
                ),
                SizedBox(width: Espaciado.sm),
                Expanded(
                  child: ChicletButton(
                    onPressed: () => _handleRestTimer(context),
                    texto: 'Descanso',
                    icono: Icons.timer_rounded,
                    tamano: TamanoBotonChiclet.mediano,
                    estilo: EstiloBotonChiclet.contorno,
                    colorBorde: AppColors.acento,
                    colorTexto: AppColors.acento,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainActionButton(
      BuildContext context, EjerciciosByRutinaSuccess state) {
    // Encontrar ejercicio actual
    final ejercicioActual =
        state.ejerciciosDeRutina.ejercicios.firstWhereOrNull(
      (e) => e.id == state.ejercicioIndex,
    );

    if (ejercicioActual == null) {
      // Fallback si no se encuentra el ejercicio
      return Pulse(
        infinite: true,
        duration: const Duration(seconds: 2),
        child: ChicletButton(
          onPressed: () => _handleCompleteSerie(context, state),
          texto: '¡Completar Serie!',
          icono: Icons.check_circle_rounded,
          tamano: TamanoBotonChiclet.grande,
          estilo: EstiloBotonChiclet.relleno,
          colorFondo: AppColors.exito,
        ),
      );
    }

    // Contar series completadas vs totales
    final seriesCompletadas =
        ejercicioActual.series.where((s) => s.estado == 'completado').length;
    final totalSeries = ejercicioActual.series.length;

    // Encontrar índice del ejercicio actual
    final ejercicioIndexNum = state.ejerciciosDeRutina.ejercicios.indexWhere(
      (e) => e.id == state.ejercicioIndex,
    );
    final esUltimoEjercicio =
        ejercicioIndexNum >= state.ejerciciosDeRutina.ejercicios.length - 1;
    final todasSeriesCompletadas = seriesCompletadas >= totalSeries;

    String textoBoton;
    IconData iconoBoton;
    Color colorBoton;
    VoidCallback accionBoton;

    if (!todasSeriesCompletadas) {
      // Aún hay series por completar
      textoBoton = '¡Completar Serie ${seriesCompletadas + 1}!';
      iconoBoton = Icons.check_circle_rounded;
      colorBoton = AppColors.exito;
      accionBoton = () => _handleCompleteSerie(context, state);
    } else if (!esUltimoEjercicio) {
      // Series completadas, hay más ejercicios
      textoBoton = '¡Siguiente Ejercicio!';
      iconoBoton = Icons.arrow_forward_rounded;
      colorBoton = AppColors.acento;
      accionBoton = () => _handleNextExercise(context, state);
    } else {
      // Último ejercicio, todas las series completadas
      textoBoton = '¡Rutina Completada!';
      iconoBoton = Icons.celebration_rounded;
      colorBoton = AppColors.acento;
      accionBoton = () => _handleFinishRoutine(context, state);
    }

    return Pulse(
      infinite: true,
      duration: const Duration(seconds: 2),
      child: ChicletButton(
        onPressed: accionBoton,
        texto: textoBoton,
        icono: iconoBoton,
        tamano: TamanoBotonChiclet.grande,
        estilo: EstiloBotonChiclet.relleno,
        colorFondo: colorBoton,
      ),
    );
  }

  void _handleCompleteSerie(
      BuildContext context, EjerciciosByRutinaSuccess state) {
    print('🔥 _handleCompleteSerie llamado');
    print('🔥 Estado actual: ${state.ejercicioIndex}');
    print('🔥 Serie actual: ${state.serieIndex}');
    context.read<EjerciciosByRutinaCubit>().avanzarSerie();
    print('🔥 avanzarSerie() ejecutado');
  }

  void _handleCancelRoutine(
      BuildContext context, EjerciciosByRutinaSuccess state) {
    // Implementar lógica de pausa con diálogo emocional
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '¿Pausar entrenamiento?',
          style: EstilosTextoEmocional.energetico.copyWith(
            color: AppColors.primario,
          ),
        ),
        content: Text(
          '¡No te rindas ahora! Estás haciendo un gran trabajo.',
          style: EstilosTextoEmocional.amigable.copyWith(
            color: AppColors.textoTerciario,
          ),
        ),
        actions: [
          ChicletButton(
            onPressed: () => Navigator.pop(context),
            texto: 'Continuar',
            tamano: TamanoBotonChiclet.pequeno,
            estilo: EstiloBotonChiclet.relleno,
            colorFondo: AppColors.exito,
          ),
          ChicletButton(
            onPressed: () {
              Navigator.pop(context);
              // Navegación de vuelta sin cancelar formalmente
              context.go('/');
            },
            texto: 'Pausar',
            tamano: TamanoBotonChiclet.pequeno,
            estilo: EstiloBotonChiclet.contorno,
            colorBorde: AppColors.textoTerciario,
            colorTexto: AppColors.textoTerciario,
          ),
        ],
      ),
    );
  }

  void _handleRestTimer(BuildContext context) {
    // Implementar temporizador de descanso
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '¡Tiempo de descanso!',
          style: EstilosTextoEmocional.energetico.copyWith(
            color: AppColors.acento,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.timer_rounded,
              size: 48,
              color: AppColors.acento,
            ),
            const SizedBox(height: 16),
            Text(
              'Descansa 60 segundos y vuelve más fuerte.',
              style: EstilosTextoEmocional.amigable.copyWith(
                color: AppColors.textoTerciario,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ChicletButton(
            onPressed: () => Navigator.pop(context),
            texto: 'Entendido',
            tamano: TamanoBotonChiclet.mediano,
            estilo: EstiloBotonChiclet.relleno,
            colorFondo: AppColors.acento,
          ),
        ],
      ),
    );
  }

  void _handleNextExercise(
      BuildContext context, EjerciciosByRutinaSuccess state) {
    print('⏭️ _handleNextExercise llamado');
    // Usar el método existente del cubit para avanzar al siguiente ejercicio
    context.read<EjerciciosByRutinaCubit>().avanzarAlSiguienteEjercicio();
    print('✅ avanzarAlSiguienteEjercicio() ejecutado');
  }

  void _handleFinishRoutine(
      BuildContext context, EjerciciosByRutinaSuccess state) {
    print('🏁 _handleFinishRoutine llamado');

    // Mostrar diálogo de felicitación antes de finalizar
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          '🎉 ¡Felicitaciones!',
          style: EstilosTextoEmocional.energetico.copyWith(
            color: AppColors.acento,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.celebration_rounded,
              size: 64,
              color: AppColors.acento,
            ),
            const SizedBox(height: 16),
            Text(
              'Has completado toda la rutina.\n¡Excelente trabajo!',
              style: EstilosTextoEmocional.amigable.copyWith(
                color: AppColors.textoTerciario,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ChicletButton(
            onPressed: () {
              Navigator.pop(context);
              // Finalizar la rutina usando el nuevo método específico
              context.read<EjerciciosByRutinaCubit>().finalizarRutina();
            },
            texto: '¡Finalizar!',
            tamano: TamanoBotonChiclet.mediano,
            estilo: EstiloBotonChiclet.relleno,
            colorFondo: AppColors.acento,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Scaffold(
      backgroundColor: AppColors.fondoPrincipalClaro,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.fondoPrincipalClaro,
              Colors.white,
              AppColors.fondoPrincipalClaro.withValues(alpha: 0.8),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: FadeIn(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.acento),
                ),
                SizedBox(height: 16),
                Text(
                  'Preparando tu ejercicio...',
                  style: TextStyle(
                    color: AppColors.primario,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Scaffold(
      backgroundColor: AppColors.fondoPrincipalClaro,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.fondoPrincipalClaro,
              Colors.white,
              AppColors.fondoPrincipalClaro.withValues(alpha: 0.8),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: FadeIn(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.acento.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.warning_rounded,
                        size: 48,
                        color: AppColors.acento,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      '¡Ups! Algo salió mal',
                      style: EstilosTextoEmocional.energetico.copyWith(
                        color: AppColors.primario,
                        fontSize: 22,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      message,
                      style: EstilosTextoEmocional.amigable.copyWith(
                        color: AppColors.textoTerciario,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    Builder(
                      builder: (context) => ChicletButton(
                        onPressed: () => context.go('/'),
                        texto: 'Volver al inicio',
                        icono: Icons.home_rounded,
                        tamano: TamanoBotonChiclet.grande,
                        estilo: EstiloBotonChiclet.relleno,
                        colorFondo: AppColors.acento,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessState(
      BuildContext context, EjerciciosByRutinaSuccess state) {
    if (state.ejerciciosDeRutina.ejercicios.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.go('/');
        }
      });
      return _buildErrorState('No hay ejercicios disponibles');
    }

    final ejercicio = state.ejerciciosDeRutina.ejercicios.firstWhereOrNull(
      (e) => e.id == state.ejercicioIndex,
    );

    if (ejercicio == null) {
      return _buildErrorState('No se pudo encontrar el ejercicio actual.');
    }

    final serie = ejercicio.series.firstWhereOrNull(
      (s) => s.id == state.serieIndex,
    );

    if (serie == null) {
      return _buildErrorState('No se pudo encontrar la serie actual.');
    }

    final serieActualIndex = ejercicio.series.indexOf(serie) + 1;
    final totalSeries = ejercicio.cantidadSeries;

    return Scaffold(
      backgroundColor: AppColors.fondoPrincipalClaro,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.fondoPrincipalClaro,
              Colors.white,
              AppColors.fondoPrincipalClaro.withValues(alpha: 0.8),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header usando CabeceraReutilizable para consistencia
              CabeceraReutilizable(
                titulo: TextFormatter.capitalize(ejercicio.nombre),
                subtitulo:
                    'Serie $serieActualIndex de $totalSeries • ${state.ejerciciosDeRutina.nombre}',
                botonIzquierdo: ConfiguracionBotonIzquierdo.volver(),
                colorFondo: AppColors.fondoPrincipalClaro,
                relleno: Espaciado.rellenoMd,
              ),

              // Barra Motivacional
              SlideInDown(
                duration: const Duration(milliseconds: 500),
                child: _buildMotivationalBar(serieActualIndex, totalSeries),
              ),

              SizedBox(height: Espaciado.md),

              // Contenido Principal
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    spacing: Espaciado.md,
                    children: [
                      // Imagen del ejercicio con animación e indicador de favorito
                      FadeInUp(
                        duration: const Duration(milliseconds: 600),
                        child: Stack(
                          children: [
                            _buildExerciseImage(ejercicio.imagenDireccion),
                            _buildExerciseFavoriteIndicator(ejercicio.id),
                          ],
                        ),
                      ),
                      // Series simplificadas
                      SlideInLeft(
                        duration: const Duration(milliseconds: 700),
                        child: Container(
                          width: double.infinity,
                          margin: Espaciado.rellenoHorizontalMd,
                          padding: Espaciado.rellenoMd,
                          decoration: BoxDecoration(
                            color: AppColors.fondoTarjetaClaro,
                            borderRadius: BorderRadius.circular(Espaciado.sm),
                            boxShadow: AppColors.sombraSuave,
                          ),
                          child: Row(
                            spacing: Espaciado.md,
                            children: [
                              Expanded(
                                child: _buildDatoEjercicioCentral(
                                  valor: '${serie.repeticiones}',
                                  etiqueta: 'Repeticiones',
                                ),
                              ),
                              Expanded(
                                child: _buildDatoEjercicioCentral(
                                  valor: '${serie.peso}',
                                  etiqueta: 'Peso (Kg)',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Controles optimizados
                      SlideInRight(
                        duration: const Duration(milliseconds: 800),
                        child: _buildOptimizedControls(context, serie, state),
                      ),
                    ],
                  ),
                ),
              ),

              // Botones de acción dinámicos con diseño emocional
              _buildEmotionalDynamicActionButtons(context, ejercicio, state),
            ],
          ),
        ),
      ),
    );
  }

  // _buildEmotionalHeader eliminado - ahora usamos CabeceraReutilizable

  /// Construye la barra motivacional con frase de ánimo
  Widget _buildMotivationalBar(int serieActual, int totalSeries) {
    return Container(
      width: double.infinity,
      margin: Espaciado.rellenoHorizontalMd,
      padding: Espaciado.rellenoSm,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.acento.withValues(alpha: 0.1),
            AppColors.acentoCalido.withValues(alpha: 0.1),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(Espaciado.xs),
        border: Border.all(
          color: AppColors.acento.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        spacing: Espaciado.sm,
        children: [
          // Icono motivacional
          Container(
            padding: EdgeInsets.all(Espaciado.xxs + 2),
            decoration: BoxDecoration(
              color: AppColors.acento,
              borderRadius: BorderRadius.circular(Espaciado.xs),
            ),
            child: const Icon(
              Icons.local_fire_department,
              color: Colors.white,
              size: 16,
            ),
          ),

          // Mensaje motivacional
          Expanded(
            child: Text(
              _getMotivationalMessage(serieActual, totalSeries),
              style: TextStyle(
                fontWeight: TipografiaGyMaster.pesoRegular,
                fontSize: TipografiaGyMaster.tamanoMd,
                color: AppColors.acento,
              ),
            ),
          ),

          // Indicador de progreso
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: Espaciado.xs,
              vertical: Espaciado.xxs,
            ),
            decoration: BoxDecoration(
              color: AppColors.acento.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(Espaciado.xs),
            ),
            child: Text(
              '$serieActual/$totalSeries',
              style: EstilosTextoEmocional.contador.copyWith(
                fontSize: 12,
                color: AppColors.acento,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _getMotivationalMessage(int serieActual, int totalSeries) {
  final progress = serieActual / totalSeries;

  if (progress <= 0.33) {
    return '¡Vamos con toda la energía!';
  } else if (progress <= 0.66) {
    return '¡Ya llevas la mitad, sigue así!';
  } else if (serieActual < totalSeries) {
    return '¡Último esfuerzo, ya casi!';
  } else {
    return '¡Esta es la última, dalo todo!';
  }
}

Widget _buildExerciseFavoriteIndicator(String? ejercicioId) {
  if (ejercicioId == null) return const SizedBox.shrink();

  return BlocBuilder<FavoritoEjercicioCubit, FavoritoEjercicioState>(
    builder: (context, state) {
      final isFavorite = state is FavoritoEjercicioObtenerTodosSuccess &&
          state.ejerciciosFavoritos.any((fav) => fav.id == ejercicioId);

      if (!isFavorite) return const SizedBox.shrink();

      return Positioned(
        bottom: 8,
        right: 8,
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Icon(
            Icons.favorite,
            color: AppColors.acento,
            size: 20,
          ),
        ),
      );
    },
  );
}
