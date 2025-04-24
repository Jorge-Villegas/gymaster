import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gymaster/core/generated/assets.gen.dart';
import 'package:gymaster/features/routine/domain/entities/ejercicios_de_rutina.dart';
import 'package:gymaster/features/routine/presentation/cubits/ejercicios_by_rutina/ejercicios_by_rutina_cubit.dart';
import 'package:gymaster/shared/utils/enum.dart';
import 'package:gymaster/shared/utils/text_formatter.dart';
import 'package:gymaster/shared/utils/verificador_tipo_archivo.dart';
import 'package:gymaster/shared/widgets/custom_icon_button.dart';
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<EjerciciosByRutinaCubit, EjerciciosByRutinaState>(
      builder: (context, state) {
        if (state is EjerciciosByRutinaLoading) {
          return Scaffold(
            appBar: AppBar(title: const Text('Cargando...')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (state is EjerciciosByRutinaError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error: ${state.message}\nPor favor, vuelve e inténtalo de nuevo.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }
        if (state is EjerciciosByRutinaCompleted) {
          // Usar un listener u otro mecanismo para la navegación
          // Esto evita activar la navegación durante la fase de construcción
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              context.go('/');
            }
          });
          return Scaffold(
            appBar: AppBar(title: const Text('Rutina Completada')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (state is EjerciciosByRutinaSuccess) {
          if (state.ejerciciosDeRutina.ejercicios.isEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                context.go('/');
              }
            });
            return Scaffold(
              appBar: AppBar(title: const Text('Rutina Vacía')),
              body: const Center(child: Text('No hay ejercicios disponibles')),
            );
          }

          // Usar firstWhereOrNull y manejar el caso nulo
          final ejercicio =
              state.ejerciciosDeRutina.ejercicios.firstWhereOrNull(
            (e) => e.id == state.ejercicioIndex,
          );

          // Manejar el caso en que no se encuentre el ejercicio (idealmente no debería suceder si el estado es consistente)
          if (ejercicio == null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Error Interno')),
              body: const Center(
                  child: Text('No se pudo encontrar el ejercicio actual.')),
            );
          }

          final serie = ejercicio.series.firstWhereOrNull(
            (s) => s.id == state.serieIndex,
          );

          // Manejar el caso en que no se encuentre la serie
          if (serie == null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Error Interno')),
              body: const Center(
                  child: Text('No se pudo encontrar la serie actual.')),
            );
          }

          final serieActualIndex = ejercicio.series.indexOf(serie) + 1;
          final totalSeries = ejercicio.cantidadSeries;

          return Scaffold(
            backgroundColor: colorScheme.surface,
            appBar: AppBar(
              title: Text(
                TextFormatter.capitalize(state.ejerciciosDeRutina.nombre),
                style: textTheme.titleLarge
                    ?.copyWith(color: colorScheme.onSurface),
              ),
              centerTitle: true,
              elevation: 1, // Elevación sutil
              backgroundColor: colorScheme.surface,
              foregroundColor: colorScheme.onSurface,
              iconTheme: IconThemeData(color: colorScheme.onSurface),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 80.0),
                child: ListView(
                  // Usar ListView para contenido potencialmente largo
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  children: <Widget>[
                    const SizedBox(height: 20),
                    _construirDetallesEjercicio(
                      context,
                      state: state,
                      imagenDireccion: ejercicio.imagenDireccion,
                    ),
                    const SizedBox(height: 24),
                    _construirEstadisticasEjercicio(
                      nombreEjercicio: ejercicio.nombre,
                      context: context,
                      repeticiones: serie.repeticiones,
                      peso: serie.peso,
                      totalSeries: totalSeries,
                      serieActual: serieActualIndex,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            // Usar persistentFooterButtons o bottomNavigationBar para mejor UX que FAB + Espaciador
            persistentFooterButtons: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: _buildActionButtons(context, ejercicio, state),
              )
            ],
            // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat, // Alternativa
          );
        }
        // Fallback para estados inesperados
        return Scaffold(
          appBar: AppBar(title: const Text('Error Inesperado')),
          body: const Center(
            child: Text('Ha ocurrido un error inesperado'),
          ),
        );
      },
    );
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
        .map((serie) => serie.estado == ExerciseSetStatus.completed.name)
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
                _buildTimerInfo(
                    context, Assets.icons.iconsax.timer.path, '120 seg'),
                _buildTimerInfo(
                    context, Assets.icons.iconsax.timer1.path, '20 min'),
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
                    headerTextColor:
                        colorScheme.onSurfaceVariant.withAlpha(175),
                    cellTextAlign: TextAlign.center,
                    rowHeight: 36.0, // Ajustar altura de fila
                    // Usar colores del tema para las filas
                    rowColors: ejercicio.series.map((serie) {
                      bool isCompleted =
                          serie.estado == ExerciseSetStatus.completed.name;
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
  Widget _buildTimerInfo(BuildContext context, String iconPath, String label) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      // Usar Row en lugar de TextButton si no es clickeable
      children: [
        SvgPicture.asset(
          iconPath,
          colorFilter:
              ColorFilter.mode(colorScheme.onSurfaceVariant, BlendMode.srcIn),
          height: 16,
          width: 16,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: textTheme.bodySmall
              ?.copyWith(color: colorScheme.onSurfaceVariant),
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
        final isCompleted = ejercicio.estado == ExerciseStatus.completed.name;
        final isInProgress =
            ejercicio.estado == ExerciseStatus.in_progress.name;
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
  Widget _buildImageContent(
      String direccionImagen, double width, double height) {
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
              style:
                  textTheme.titleMedium?.copyWith(color: colorScheme.outline),
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
        // Botón de Decremento
        Expanded(
          flex: 1,
          child: CustomIconButton(
            icon: SvgPicture.asset(
              Assets.icons.iconsax.minus.path,
              colorFilter:
                  ColorFilter.mode(colorScheme.primary, BlendMode.srcIn),
              width: 18,
              height: 18,
            ),
            borderColor: colorScheme.outline.withAlpha(127),
            backgroundColor: colorScheme.surface,
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
              style:
                  textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        // Botón de Incremento
        Expanded(
          flex: 1,
          child: CustomIconButton(
            icon: SvgPicture.asset(
              Assets.icons.iconsax.add.path,
              colorFilter:
                  ColorFilter.mode(colorScheme.primary, BlendMode.srcIn),
              width: 18,
              height: 18,
            ),
            borderColor: colorScheme.outline.withAlpha(125),
            backgroundColor: colorScheme.surface,
            onPressed: onIncrement,
          ),
        ),
      ],
    );
  }

  // Constructor de Botón de Acción Actualizado
  Widget _buildActionButtons(BuildContext context, Ejercicio ejercicio,
      EjerciciosByRutinaSuccess state) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    bool todasLasSeriesCompletadas = ejercicio.series.every(
      (serie) => serie.estado == ExerciseSetStatus.completed.name,
    );

    // Verificar si este es el último ejercicio y todas sus series están hechas
    final ejercicios = state.ejerciciosDeRutina.ejercicios;
    final currentEjercicioIndex =
        ejercicios.indexWhere((e) => e.id == state.ejercicioIndex);
    final isLastExercise = currentEjercicioIndex == ejercicios.length - 1;

    String buttonText;
    Color buttonColor;
    IconData buttonIcon;
    VoidCallback onPressed;

    if (todasLasSeriesCompletadas) {
      if (isLastExercise) {
        buttonText = 'Finalizar Rutina';
        buttonColor = colorScheme.tertiary;
        buttonIcon = Icons.check_circle_outline;
        onPressed = () {
          // Marcar el último ejercicio como completado antes de finalizar
          context.read<EjerciciosByRutinaCubit>().completeRoutine(
              routineSessionId: state.ejerciciosDeRutina.session);
        };
      } else {
        buttonText = 'Siguiente Ejercicio';
        buttonColor = colorScheme.primary;
        buttonIcon = Icons.arrow_forward;
        onPressed = () => context
            .read<EjerciciosByRutinaCubit>()
            .avanzarAlSiguienteEjercicio();
      }
    } else {
      buttonText = 'Completar Serie';
      buttonColor = Colors.green;
      buttonIcon = Icons.check;
      onPressed = () => context.read<EjerciciosByRutinaCubit>().avanzarSerie();
    }

    return SizedBox(
      // Hacer botón de ancho completo
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        icon: Icon(buttonIcon, size: 20),
        label: Text(
          buttonText,
          style: textTheme.titleMedium
              ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
