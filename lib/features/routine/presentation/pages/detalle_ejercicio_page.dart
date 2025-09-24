import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gymaster/core/theme/app_colors.dart';
import 'package:gymaster/core/theme/emotional_text_styles.dart';
import 'package:gymaster/features/routine/domain/entities/ejercicios_de_rutina.dart';
import 'package:gymaster/features/routine/presentation/cubits/ejercicios_by_rutina/ejercicios_by_rutina_cubit.dart';
import 'package:gymaster/features/routine/presentation/widgets/rutina_cancelada_widget.dart';
import 'package:gymaster/features/routine/presentation/widgets/rutina_completada_widget.dart';
import 'package:gymaster/shared/utils/enum.dart';
import 'package:gymaster/shared/utils/text_formatter.dart';
import 'package:gymaster/shared/utils/verificador_tipo_archivo.dart';
import 'package:gymaster/shared/widgets/chiclet_button.dart';
import 'package:animate_do/animate_do.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

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
    return Center(
      child: AspectRatio(
        aspectRatio: 1.2,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                AppColors.energyOrange.withOpacity(0.08),
                AppColors.primary.withOpacity(0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.energyOrange.withOpacity(0.12),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
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
              color: AppColors.energyOrange,
            ),
            const SizedBox(height: 10),
            Text(
              'Imagen no disponible',
              style: EstilosTextoEmocional.amigable.copyWith(
                color: AppColors.textSecondary,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimplifiedSeriesDisplay({
    required Serie serie,
    required int serieActual,
    required int totalSeries,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Título motivacional
          Text(
            '¡Tu objetivo ahora!',
            style: EstilosTextoEmocional.energetico.copyWith(
              color: AppColors.primary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          // Stats principales
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.repeat_rounded,
                  value: '${serie.repeticiones}',
                  label: 'Repeticiones',
                  color: AppColors.motivationRed,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.fitness_center_rounded,
                  value: '${serie.peso}',
                  label: 'Peso (kg)',
                  color: AppColors.energyOrange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: EstilosTextoEmocional.energetico.copyWith(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: EstilosTextoEmocional.amigable.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOptimizedControls(
      BuildContext context, Serie serie, EjerciciosByRutinaSuccess state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            '¡Ajusta tu entrenamiento!',
            style: EstilosTextoEmocional.energetico.copyWith(
              color: AppColors.primary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          // Control de repeticiones
          _buildControlSection(
            title: 'Repeticiones',
            value: serie.repeticiones,
            color: AppColors.motivationRed,
            onIncrement: () =>
                context.read<EjerciciosByRutinaCubit>().aumentarRepeticiones(),
            onDecrement: () =>
                context.read<EjerciciosByRutinaCubit>().disminuirRepeticiones(),
          ),

          const SizedBox(height: 16),

          // Control de peso
          _buildControlSection(
            title: 'Peso (kg)',
            value: serie.peso.round(),
            color: AppColors.energyOrange,
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
            style: EstilosTextoEmocional.amigable.copyWith(
              color: AppColors.textSecondary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Row(
          children: [
            ChicletButton(
              onPressed: onDecrement,
              icono: Icons.remove_rounded,
              texto: '',
              tamano: TamanoBotonChiclet.pequeno,
              estilo: EstiloBotonChiclet.contorno,
              colorBorde: color,
              colorTexto: color,
            ),
            Container(
              width: 60,
              alignment: Alignment.center,
              child: Text(
                '$value',
                style: EstilosTextoEmocional.energetico.copyWith(
                  color: color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ChicletButton(
              onPressed: onIncrement,
              icono: Icons.add_rounded,
              texto: '',
              tamano: TamanoBotonChiclet.pequeno,
              estilo: EstiloBotonChiclet.contorno,
              colorBorde: color,
              colorTexto: color,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmotionalDynamicActionButtons(BuildContext context,
      Ejercicio ejercicio, EjerciciosByRutinaSuccess state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            // Botón principal dinámico
            _buildMainActionButton(context, state),

            const SizedBox(height: 12),

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
                    colorBorde: AppColors.textSecondary,
                    colorTexto: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ChicletButton(
                    onPressed: () => _handleRestTimer(context),
                    texto: 'Descanso',
                    icono: Icons.timer_rounded,
                    tamano: TamanoBotonChiclet.mediano,
                    estilo: EstiloBotonChiclet.contorno,
                    colorBorde: AppColors.energyOrange,
                    colorTexto: AppColors.energyOrange,
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
          colorFondo: AppColors.celebrationPurple,
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
      colorBoton = AppColors.celebrationPurple;
      accionBoton = () => _handleCompleteSerie(context, state);
    } else if (!esUltimoEjercicio) {
      // Series completadas, hay más ejercicios
      textoBoton = '¡Siguiente Ejercicio!';
      iconoBoton = Icons.arrow_forward_rounded;
      colorBoton = AppColors.energyOrange;
      accionBoton = () => _handleNextExercise(context, state);
    } else {
      // Último ejercicio, todas las series completadas
      textoBoton = '¡Rutina Completada!';
      iconoBoton = Icons.celebration_rounded;
      colorBoton = AppColors.achievementGold;
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
            color: AppColors.primary,
          ),
        ),
        content: Text(
          '¡No te rindas ahora! Estás haciendo un gran trabajo.',
          style: EstilosTextoEmocional.amigable.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          ChicletButton(
            onPressed: () => Navigator.pop(context),
            texto: 'Continuar',
            tamano: TamanoBotonChiclet.pequeno,
            estilo: EstiloBotonChiclet.relleno,
            colorFondo: AppColors.celebrationPurple,
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
            colorBorde: AppColors.textSecondary,
            colorTexto: AppColors.textSecondary,
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
            color: AppColors.energyOrange,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.timer_rounded,
              size: 48,
              color: AppColors.energyOrange,
            ),
            const SizedBox(height: 16),
            Text(
              'Descansa 60 segundos y vuelve más fuerte.',
              style: EstilosTextoEmocional.amigable.copyWith(
                color: AppColors.textSecondary,
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
            colorFondo: AppColors.energyOrange,
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
            color: AppColors.achievementGold,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.celebration_rounded,
              size: 64,
              color: AppColors.achievementGold,
            ),
            const SizedBox(height: 16),
            Text(
              'Has completado toda la rutina.\n¡Excelente trabajo!',
              style: EstilosTextoEmocional.amigable.copyWith(
                color: AppColors.textSecondary,
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
            colorFondo: AppColors.achievementGold,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.backgroundLight,
              Colors.white,
              AppColors.backgroundLight.withValues(alpha: 0.8),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: FadeIn(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.energyOrange),
                ),
                SizedBox(height: 16),
                Text(
                  'Preparando tu ejercicio...',
                  style: TextStyle(
                    color: AppColors.primary,
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
      backgroundColor: AppColors.backgroundLight,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.backgroundLight,
              Colors.white,
              AppColors.backgroundLight.withValues(alpha: 0.8),
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
                        color: AppColors.motivationRed.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.warning_rounded,
                        size: 48,
                        color: AppColors.motivationRed,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      '¡Ups! Algo salió mal',
                      style: EstilosTextoEmocional.energetico.copyWith(
                        color: AppColors.primary,
                        fontSize: 22,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      message,
                      style: EstilosTextoEmocional.amigable.copyWith(
                        color: AppColors.textSecondary,
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
                        colorFondo: AppColors.motivationRed,
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
      backgroundColor: AppColors.backgroundLight,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.backgroundLight,
              Colors.white,
              AppColors.backgroundLight.withValues(alpha: 0.8),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header Emocional Minimalista
              _buildEmotionalHeader(
                context: context,
                exerciseName: ejercicio.nombre,
                serieActual: serieActualIndex,
                totalSeries: totalSeries,
                rutineName: state.ejerciciosDeRutina.nombre,
              ),

              // Barra Motivacional
              SlideInDown(
                duration: const Duration(milliseconds: 500),
                child: _buildMotivationalBar(serieActualIndex, totalSeries),
              ),

              // Contenido Principal
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Imagen del ejercicio con animación
                      FadeInUp(
                        duration: const Duration(milliseconds: 600),
                        child: _buildExerciseImage(ejercicio.imagenDireccion),
                      ),

                      const SizedBox(height: 24),

                      // Series simplificadas
                      SlideInLeft(
                        duration: const Duration(milliseconds: 700),
                        child: _buildSimplifiedSeriesDisplay(
                          serie: serie,
                          serieActual: serieActualIndex,
                          totalSeries: totalSeries,
                        ),
                      ),

                      const SizedBox(height: 24),

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

  Widget _buildEmotionalHeader({
    required BuildContext context,
    required String exerciseName,
    required int serieActual,
    required int totalSeries,
    required String rutineName,
  }) {
    return FadeInDown(
      duration: const Duration(milliseconds: 800),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Botón de volver minimalista (igual que detalle_rutina)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.energyOrange.withValues(alpha: 0.1),
                    offset: const Offset(0, 2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () => context.pop(),
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: AppColors.energyOrange,
                  size: 20,
                ),
                padding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(width: 16),
            // Título emocional simple (igual que detalle_rutina)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    TextFormatter.capitalize(exerciseName),
                    style: EstilosTextoEmocional.energetico.copyWith(
                      color: AppColors.primary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Serie $serieActual de $totalSeries 💪',
                    style: EstilosTextoEmocional.amigable.copyWith(
                      color: AppColors.energyOrange,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            // Indicador de progreso minimalista
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.motivationRed,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.motivationRed.withValues(alpha: 0.3),
                    offset: const Offset(0, 4),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '$serieActual',
                  style: EstilosTextoEmocional.contador.copyWith(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construye la barra motivacional con frase de ánimo
  Widget _buildMotivationalBar(int serieActual, int totalSeries) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.motivationRed.withOpacity(0.1),
            AppColors.energyOrange.withOpacity(0.1),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.energyOrange.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Icono motivacional
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.energyOrange,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.local_fire_department,
              color: Colors.white,
              size: 16,
            ),
          ),

          const SizedBox(width: 12),

          // Mensaje motivacional
          Expanded(
            child: Text(
              _getMotivationalMessage(serieActual, totalSeries),
              style: EstilosTextoEmocional.motivacional.copyWith(
                fontSize: 14,
                color: AppColors.motivationRed,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Indicador de progreso
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.energyOrange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$serieActual/$totalSeries',
              style: EstilosTextoEmocional.contador.copyWith(
                fontSize: 12,
                color: AppColors.energyOrange,
                fontWeight: FontWeight.bold,
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

Widget _construirDetallesEjercicio(
  BuildContext context, {
  required EjerciciosByRutinaSuccess state,
  required String imagenDireccion,
}) {
  final colorScheme = Theme.of(context).colorScheme;

  final ejercicios = state.ejerciciosDeRutina.ejercicios;
  // Asegurar que ejercicioIndex sea válido
  final currentEjercicioIndex =
      ejercicios.indexWhere((e) => e.id == state.ejercicioIndex);
  if (currentEjercicioIndex == -1) {
    return const SizedBox.shrink();
  }

  final ejercicio = ejercicios[currentEjercicioIndex];

  // Preparar datos para la tabla, incluyendo estado de completado
  final tableData = ejercicio.series.map((serie) {
    return [
      '${ejercicio.series.indexOf(serie) + 1}', // Serie
      '${serie.peso} kg', // Peso
      '${serie.repeticiones} x', // Repeticiones
    ];
  }).toList();

  final completedRows = ejercicio.series
      .map((serie) => serie.estado == EstadoSerieEjercicio.completado.name)
      .toList();

  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 2, // Elevación sutil
    clipBehavior: Clip.antiAlias,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Opcional: Temporizadores - Hacerlos funcionales o eliminarlos si son decorativos
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildTimerInfo(context, IconsaxPlusLinear.timer, '120 seg'),
              _buildTimerInfo(context, IconsaxPlusLinear.timer_1, '20 min'),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Imagen a la izquierda
              _construirWidgetImagen(
                imagenDireccion,
                width: 120,
                height: 120,
              ),
              const SizedBox(width: 16),
              // Tabla a la derecha
              Expanded(
                child: CustomDataTable(
                  headers: const ['Serie', 'Peso', 'Reps'],
                  data: tableData,
                  completedRows: completedRows,
                  showActions: false,
                  backgroundColor: Colors.transparent,
                  headerColor: Colors.transparent,
                  bodyTextColor: colorScheme.onSurfaceVariant,
                  headerTextColor: colorScheme.onSurfaceVariant.withAlpha(175),
                  cellTextAlign: TextAlign.center,
                  rowHeight: 36.0, // Ajustar altura de fila
                  // Usar colores del tema para las filas
                  rowColors: ejercicio.series.map((serie) {
                    bool isCompleted =
                        serie.estado == EstadoSerieEjercicio.completado.name;
                    return isCompleted
                        ? Colors.green.shade50
                        : Colors.grey.shade100;
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Indicador de progreso mejorado
          _buildExerciseProgressIndicator(
              context, ejercicios, currentEjercicioIndex),
        ],
      ),
    ),
  );
}

// Ayudante para mostrar información del temporizador
Widget _buildTimerInfo(BuildContext context, IconData iconData, String label) {
  final textTheme = Theme.of(context).textTheme;
  final colorScheme = Theme.of(context).colorScheme;
  return Row(
    children: [
      Icon(
        iconData,
        color: colorScheme.onSurfaceVariant,
        size: 16,
      ),
      const SizedBox(width: 4),
      Text(
        label,
        style:
            textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
      ),
    ],
  );
}

// Widget de Indicador de Progreso Mejorado
Widget _buildExerciseProgressIndicator(BuildContext context,
    List<Ejercicio> ejercicios, int currentEjercicioIndex) {
  final colorScheme = Theme.of(context).colorScheme;
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(ejercicios.length, (index) {
      final ejercicio = ejercicios[index];
      final isCompleted = ejercicio.estado == EstadoEjercicio.completado.name;
      final isInProgress = ejercicio.estado == EstadoEjercicio.en_progreso.name;
      final isCurrent = index == currentEjercicioIndex;

      Color color;
      double radius =
          isCurrent ? 5.0 : 4.0; // Radio ligeramente mayor para el actual

      if (isCompleted) {
        color = Colors.green; // Completado
      } else if (isCurrent || isInProgress) {
        color = colorScheme.primary; // Actual o En Progreso
      } else {
        color = colorScheme.outline.withAlpha(125); // Pendiente
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3.0),
        child: CircleAvatar(radius: radius, backgroundColor: color),
      );
    }),
  );
}

Widget _construirWidgetImagen(String direccionImagen,
    {double width = 150, double height = 150}) {
  // Envolver el widget de imagen con un SizedBox para forzar dimensiones fijas
  return SizedBox(
    width: width,
    height: height,
    child: _buildImageContent(direccionImagen, width, height),
  );
}

// Función auxiliar para construir el contenido real de la imagen
Widget _buildImageContent(String direccionImagen, double width, double height) {
  if (VerificadorTipoArchivo.esSvg(direccionImagen)) {
    return SvgPicture.asset(
      direccionImagen,
      // Ancho/Alto eliminados de aquí, manejados por SizedBox
      // Asegurar que la imagen encaje bien dentro de los límites
      fit: BoxFit.contain,
      semanticsLabel: 'Ilustración del ejercicio',
    );
  }
  if (VerificadorTipoArchivo.esImagen(direccionImagen)) {
    return Image.asset(
      direccionImagen,
      // Ancho/Alto eliminados de aquí, manejados por SizedBox
      // Asegurar que la imagen encaje bien dentro de los límites
      fit: BoxFit.contain,
      semanticLabel: 'Ilustración del ejercicio',
      // Añadir constructor de errores para mejor manejo si la imagen falla al cargar
      errorBuilder: (context, error, stackTrace) =>
          _buildErrorPlaceholder(width, height),
    );
  }
  // Icono de fallback (ya dentro de SizedBox)
  return _buildErrorPlaceholder(width, height);
}

// Ayudante para mostrar marcador de posición/error
Widget _buildErrorPlaceholder(double width, double height) {
  return Container(
    color: Colors.grey[200],
    child: const Center(
      // Centrar el icono
      child: Icon(
        Icons.image_not_supported_outlined,
        size: 50,
        color: Colors.grey,
        semanticLabel: 'Error al cargar la imagen',
      ),
    ),
  );
}

Widget _construirEstadisticasEjercicio({
  required String nombreEjercicio,
  required BuildContext context,
  required int repeticiones,
  required double peso,
  required int totalSeries,
  required int serieActual,
}) {
  final textTheme = Theme.of(context).textTheme;
  final colorScheme = Theme.of(context).colorScheme;

  return Column(
    // No se necesita Container/Padding extra aquí si el padre lo maneja
    children: <Widget>[
      // Contador de Series
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment:
            CrossAxisAlignment.baseline, // Alinear texto correctamente
        textBaseline: TextBaseline.alphabetic,
        children: <Widget>[
          Text('Serie',
              style: textTheme.titleMedium
                  ?.copyWith(color: colorScheme.onSurfaceVariant)),
          const SizedBox(width: 8),
          Text(
            '$serieActual',
            style: textTheme.titleLarge?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            ' / $totalSeries',
            style: textTheme.titleMedium?.copyWith(color: colorScheme.outline),
          ),
        ],
      ),
      const SizedBox(height: 4),
      // Nombre del Ejercicio
      Text(
        TextFormatter.capitalize(nombreEjercicio),
        textAlign: TextAlign.center,
        style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 16),
      // Fila de Peso
      _construirFilaControl(
        context: context,
        label: 'Peso',
        value: peso,
        unit: 'kg',
        onDecrement: () =>
            context.read<EjerciciosByRutinaCubit>().disminuirPeso(),
        onIncrement: () =>
            context.read<EjerciciosByRutinaCubit>().aumentarPeso(),
      ),
      const SizedBox(height: 12),
      // Fila de Repeticiones
      _construirFilaControl(
        context: context,
        label: 'Reps',
        value: repeticiones.toDouble(), // Usar double por consistencia
        unit: '', // Sin unidad para repeticiones
        isInteger: true, // Indicar que es un valor entero
        onDecrement: () =>
            context.read<EjerciciosByRutinaCubit>().disminuirRepeticiones(),
        onIncrement: () =>
            context.read<EjerciciosByRutinaCubit>().aumentarRepeticiones(),
      ),
    ],
  );
}

// Widget de Control de Fila Refactorizado
Widget _construirFilaControl({
  required BuildContext context,
  required String label,
  required double value,
  required String unit,
  required VoidCallback onDecrement,
  required VoidCallback onIncrement,
  bool isInteger = false,
}) {
  final textTheme = Theme.of(context).textTheme;
  final colorScheme = Theme.of(context).colorScheme;

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espaciar elementos
    children: <Widget>[
      // Etiqueta
      Expanded(
        flex: 2, // Dar algo de espacio a la etiqueta
        // Mantenido como titleMedium
        child: Text(label,
            style: textTheme.titleMedium
                ?.copyWith(color: colorScheme.onSurfaceVariant)),
      ),
      // Botón de Decremento con ChicletButton outlined
      Expanded(
        flex: 1,
        child: ChicletButton(
          texto: '',
          icono: IconsaxPlusLinear.minus,
          estilo: EstiloBotonChiclet.contorno,
          tamano: TamanoBotonChiclet.mediano,
          colorFondo: colorScheme.surface,
          colorTexto: colorScheme.onSurface,
          colorBorde: colorScheme.surface,
          radioBorde: 20,
          conSombreado: true,
          conBordes: true,
          onPressed: onDecrement,
        ),
      ),
      // Visualización del Valor
      Expanded(
        flex: 2, // Dar más espacio al valor
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
                opacity: animation,
                child: ScaleTransition(scale: animation, child: child));
          },
          child: Text(
            isInteger ? '${value.toInt()}' : '$value $unit'.trim(),
            key: ValueKey<double>(value),
            textAlign: TextAlign.center,
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ),
      // Botón de Incremento con ChicletButton outlined
      Expanded(
        flex: 1,
        child: ChicletButton(
          texto: '',
          icono: IconsaxPlusLinear.add,
          estilo: EstiloBotonChiclet.contorno,
          tamano: TamanoBotonChiclet.mediano,
          colorFondo: colorScheme.surface,
          colorTexto: colorScheme.onSurface,
          colorBorde: colorScheme.surface,
          radioBorde: 20,
          conSombreado: true,
          conBordes: true,
          onPressed: onIncrement,
        ),
      ),
    ],
  );
} // Constructor de Botón de Acción Actualizado con ChicletButtons

Widget _buildActionButtons(BuildContext context, Ejercicio ejercicio,
    EjerciciosByRutinaSuccess state) {
  bool todasLasSeriesCompletadas = ejercicio.series.every(
    (serie) => serie.estado == EstadoSerieEjercicio.completado.name,
  );

  // Verificar si este es el último ejercicio y todas sus series están hechas
  final ejercicios = state.ejerciciosDeRutina.ejercicios;
  final currentEjercicioIndex =
      ejercicios.indexWhere((e) => e.id == state.ejercicioIndex);
  final isLastExercise = currentEjercicioIndex == ejercicios.length - 1;

  if (todasLasSeriesCompletadas) {
    if (isLastExercise) {
      return ChicletButton(
        texto: 'Finalizar Rutina',
        colorFondo: AppColors.celebrationPurple,
        colorTexto: Colors.white,
        onPressed: () {
          // Marcar el último ejercicio como completado antes de finalizar
          context.read<EjerciciosByRutinaCubit>().completeRoutine(
              routineSessionId: state.ejerciciosDeRutina.session);
        },
        estaHabilitado: true,
        tamano: TamanoBotonChiclet.grande,
        estilo: EstiloBotonChiclet.relleno,
        radioBorde: 28,
        ancho: double.infinity,
      );
    } else {
      return ChicletButton(
        texto: 'Siguiente Ejercicio',
        colorFondo: AppColors.secondary,
        colorTexto: Colors.white,
        onPressed: () => context
            .read<EjerciciosByRutinaCubit>()
            .avanzarAlSiguienteEjercicio(),
        estaHabilitado: true,
        tamano: TamanoBotonChiclet.grande,
        estilo: EstiloBotonChiclet.relleno,
        radioBorde: 28,
        ancho: double.infinity,
        conSombreado: true,
        conBordes: true,
      );
    }
  } else {
    return ChicletButton(
      texto: 'Completar Serie',
      colorFondo: AppColors.success,
      colorTexto: Colors.white,
      onPressed: () => context.read<EjerciciosByRutinaCubit>().avanzarSerie(),
      estaCargando: false,
      estaHabilitado: true,
      tamano: TamanoBotonChiclet.grande,
      estilo: EstiloBotonChiclet.relleno,
      radioBorde: 28,
      ancho: double.infinity,
      conSombreado: true,
      conBordes: true,
    );
  }
}
