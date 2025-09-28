import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animate_do/animate_do.dart';
import 'package:gymaster/core/theme/app_colors.dart';
import 'package:gymaster/core/theme/emotional_text_styles.dart';
import 'package:gymaster/core/theme/espaciado.dart';
import 'package:gymaster/core/theme/tipografia_gymaster.dart';
import 'package:gymaster/features/record/domain/entities/record_rutina.dart';
import 'package:gymaster/features/record/presentation/cubit/selected_routine/selected_routine_cubit.dart';
import 'package:gymaster/features/record/presentation/cubit/selected_routine/selected_routine_state.dart';
import 'package:gymaster/shared/utils/string_utils.dart';
import 'package:gymaster/shared/widgets/chiclet_button.dart';

class DetalleEjercicioPage extends StatefulWidget {
  final RecordEjercicios recordEjercicios;
  final RecordRutina rutina;

  const DetalleEjercicioPage({
    super.key,
    required this.recordEjercicios,
    required this.rutina,
  });

  @override
  _DetalleEjercicioPageState createState() => _DetalleEjercicioPageState();
}

class _DetalleEjercicioPageState extends State<DetalleEjercicioPage> {
  int? selectedRowIndex;

  @override
  void initState() {
    super.initState();
    // Cargar la rutina en el SelectedRoutineCubit
    context.read<SelectedRoutineCubit>().loadRoutine(widget.rutina);

    if (widget.recordEjercicios.seriesDelEjercicio.isNotEmpty) {
      selectedRowIndex = 0;
    }
  }

  // Método para encontrar el índice correcto del ejercicio en la lista
  int _findEjercicioIndex(
      List<RecordEjercicios> ejercicios, String ejercicioId) {
    for (int i = 0; i < ejercicios.length; i++) {
      if (ejercicios[i].id == ejercicioId) {
        return i;
      }
    }
    return -1; // No encontrado
  }

  // Header limpio siguiendo el patrón del catálogo de ejercicios
  Widget _buildEmotionalHeader(BuildContext context) {
    return FadeInDown(
      duration: const Duration(milliseconds: 800),
      child: Container(
        padding: Espaciado.rellenoSm, // Más compacto para header
        child: Row(
          children: [
            // Botón de volver minimalista
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secundario.withValues(alpha: 0.1),
                    offset: const Offset(0, 2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: AppColors.secundario,
                  size: 20,
                ),
                padding: const EdgeInsets.all(12),
              ),
            ),
            Espaciado.separacionHorizontalXs, // Menor separación horizontal
            // Título simple y profesional
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Detalles del Ejercicio',
                    style: TextStyle(
                      fontWeight: TipografiaGyMaster.pesoSemiBold,
                      fontSize:
                          TipografiaGyMaster.tamano2xl, // Título principal
                      letterSpacing: 1.2,
                      height: 1.1,
                      color: AppColors.secundario,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Espaciado.separacionVerticalXs,
                  // Text(
                  //   capitalizarPrimeraLetra(
                  //     widget.recordEjercicios.nombre,
                  //   ),
                  //   style: TextStyle(
                  //     color: AppColors.primario,
                  //     fontSize: TipografiaGyMaster.tamanoMd,
                  //     fontWeight: TipografiaGyMaster.pesoSemiBold,
                  //   ),
                  // ),
                ],
              ),
            ),
            Espaciado.separacionHorizontalXs,
            // Botón de actualizar simple
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secundario.withValues(alpha: 0.1),
                    offset: const Offset(0, 2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(
                  Icons.refresh_rounded,
                  color: AppColors.secundario,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {});
                },
                padding: const EdgeInsets.all(12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Estado de carga simple
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.primario,
            strokeWidth: 3,
          ),
          Espaciado.separacionVerticalSm,
          Text(
            'Cargando datos...',
            style: EstilosTextoEmocional.amigable.copyWith(
              color: AppColors.textoTerciario,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoPrincipalClaro,
      body: SafeArea(
        child: Column(
          children: [
            // Header limpio
            _buildEmotionalHeader(context),
            // Contenido principal
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.fondoPrincipalClaro,
                      Colors.white,
                      AppColors.fondoPrincipalClaro.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.0, 0.3, 1.0],
                  ),
                ),
                child: BlocBuilder<SelectedRoutineCubit, SelectedRoutineState>(
                  builder: (context, state) {
                    if (state is SelectedRoutineLoaded) {
                      // Encontrar el ejercicio específico en la rutina seleccionada
                      final ejercicio = state.rutina.ejercicios.firstWhere(
                        (e) => e.id == widget.recordEjercicios.id,
                        orElse: () => widget.recordEjercicios,
                      );

                      final tableData =
                          ejercicio.seriesDelEjercicio.map((serie) {
                        return [
                          (ejercicio.seriesDelEjercicio.indexOf(serie) + 1)
                              .toString(),
                          '${serie.peso} kg',
                          '${serie.repeticiones} x',
                        ];
                      }).toList();

                      return _buildContent(
                          context, state, ejercicio, tableData);
                    }
                    return _buildLoadingState();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    SelectedRoutineLoaded state,
    RecordEjercicios ejercicio,
    List<List<String>> tableData,
  ) {
    return SingleChildScrollView(
      padding: Espaciado.rellenoMd,
      child: Column(
        children: [
          // Información básica del ejercicio
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(
                bottom: Espaciado.sm), // Menor separación entre bloques
            padding: Espaciado.rellenoSm, // Más compacto para card principal
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primario.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primario.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.fitness_center,
                    color: AppColors.primario,
                    size: 24,
                  ),
                ),
                Espaciado.separacionHorizontalSm,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        capitalizarPrimeraLetra(ejercicio.nombre),
                        style: TextStyle(
                          color: AppColors.primario,
                          fontSize: TipografiaGyMaster.tamanoLg, // Subtítulo
                          fontWeight: TipografiaGyMaster.pesoSemiBold,
                        ),
                      ),
                      Espaciado.separacionVerticalXs,
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secundario.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${tableData.length} series registradas',
                          style: TextStyle(
                            color: AppColors.secundario,
                            fontSize:
                                TipografiaGyMaster.tamanoSm, // Info secundaria
                            fontWeight: TipografiaGyMaster.pesoLigero,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Tabla de series
          Container(
            width: double.infinity,
            padding: Espaciado.rellenoSm,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primario.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Ajustar al contenido
              children: [
                Text(
                  'Series del Ejercicio',
                  style: TextStyle(
                    color: AppColors.primario,
                    fontSize:
                        TipografiaGyMaster.tamanoLg, // Encabezado de sección
                    fontWeight: TipografiaGyMaster.pesoSemiBold,
                  ),
                ),
                Espaciado.separacionVerticalSm,
                _buildSimpleTable(tableData), // Sin Expanded
              ],
            ),
          ),

          Espaciado.separacionVerticalSm, // Separación entre tabla y controles

          // Controles de edición
          if (selectedRowIndex != null)
            _buildControls(context, ejercicio, tableData),
        ],
      ),
    );
  }

  Widget _buildSimpleTable(List<List<String>> tableData) {
    // Limitar altura máxima para evitar overflow en pantallas pequeñas
    final maxHeight =
        MediaQuery.of(context).size.height * 0.4; // 40% de la pantalla

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.primario.withValues(alpha: 0.2),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header de la tabla
          Container(
            padding: Espaciado.relleno16y8,
            decoration: BoxDecoration(
              color: AppColors.primario.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Serie',
                    style: TextStyle(
                      color: AppColors.primario,
                      fontSize: TipografiaGyMaster.tamanoMd, // Subtítulo tabla
                      fontWeight: TipografiaGyMaster.pesoSemiBold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Peso',
                    style: TextStyle(
                      color: AppColors.primario,
                      fontSize: TipografiaGyMaster.tamanoMd, // Subtítulo tabla
                      fontWeight: TipografiaGyMaster.pesoSemiBold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Reps',
                    style: TextStyle(
                      color: AppColors.primario,
                      fontSize: TipografiaGyMaster.tamanoMd, // Subtítulo tabla
                      fontWeight: TipografiaGyMaster.pesoSemiBold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          // Filas de datos con scroll si es necesario
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: maxHeight,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: tableData.asMap().entries.map((entry) {
                  final index = entry.key;
                  final data = entry.value;
                  final isSelected = selectedRowIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedRowIndex = index;
                      });
                    },
                    child: Container(
                      padding: Espaciado.relleno16y8,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.secundario.withValues(alpha: 0.1)
                            : Colors.transparent,
                        border: Border(
                          bottom: BorderSide(
                            color: AppColors.primario.withValues(alpha: 0.1),
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              data[0],
                              style: TextStyle(
                                color: isSelected
                                    ? AppColors.secundario
                                    : AppColors.textoPrincipalClaro,
                                fontSize:
                                    TipografiaGyMaster.tamanoSm, // Celdas tabla
                                fontWeight: isSelected
                                    ? TipografiaGyMaster.pesoSemiBold
                                    : TipografiaGyMaster.pesoLigero,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              data[1],
                              style: TextStyle(
                                color: isSelected
                                    ? AppColors.secundario
                                    : AppColors.textoPrincipalClaro,
                                fontSize:
                                    TipografiaGyMaster.tamanoSm, // Celdas tabla
                                fontWeight: isSelected
                                    ? TipografiaGyMaster.pesoSemiBold
                                    : TipografiaGyMaster.pesoLigero,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              data[2],
                              style: TextStyle(
                                color: isSelected
                                    ? AppColors.secundario
                                    : AppColors.textoPrincipalClaro,
                                fontSize:
                                    TipografiaGyMaster.tamanoSm, // Celdas tabla
                                fontWeight: isSelected
                                    ? TipografiaGyMaster.pesoSemiBold
                                    : TipografiaGyMaster.pesoLigero,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls(
    BuildContext context,
    RecordEjercicios ejercicio,
    List<List<String>> tableData,
  ) {
    return Container(
      width: double.infinity,
      padding: Espaciado.rellenoSm, // Más compacto para controles
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primario.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header simple de controles
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primario.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.tune,
                  color: AppColors.primario,
                  size: 20,
                ),
              ),
              const SizedBox(width: Espaciado.sm),
              Text(
                'Ajustar Serie ${selectedRowIndex! + 1}',
                style: TextStyle(
                  color: AppColors.primario,
                  fontSize: TipografiaGyMaster.tamanoLg, // Subtítulo sección
                  fontWeight: TipografiaGyMaster.pesoSemiBold,
                ),
              ),
            ],
          ),
          Espaciado
              .separacionVerticalSm, // Menor separación entre header y controles

          // Controles de peso
          _buildControlRow(
            context: context,
            label: 'Peso:',
            value: tableData[selectedRowIndex!][1],
            icon: Icons.monitor_weight,
            color: AppColors.peso,
            onIncrement: () {
              final currentState = context.read<SelectedRoutineCubit>().state;
              if (currentState is SelectedRoutineLoaded) {
                final ejercicioIndex = _findEjercicioIndex(
                    currentState.rutina.ejercicios, ejercicio.id);
                if (ejercicioIndex != -1) {
                  context.read<SelectedRoutineCubit>().incrementPeso(
                        ejercicioIndex,
                        selectedRowIndex!,
                      );
                }
              }
            },
            onDecrement: () {
              final currentState = context.read<SelectedRoutineCubit>().state;
              if (currentState is SelectedRoutineLoaded) {
                final ejercicioIndex = _findEjercicioIndex(
                    currentState.rutina.ejercicios, ejercicio.id);
                if (ejercicioIndex != -1) {
                  context.read<SelectedRoutineCubit>().decrementPeso(
                        ejercicioIndex,
                        selectedRowIndex!,
                      );
                }
              }
            },
          ),
          Espaciado.separacionVerticalXs, // Menor separación entre controles

          // Controles de repeticiones
          _buildControlRow(
            context: context,
            label: 'Reps:',
            value: tableData[selectedRowIndex!][2],
            icon: Icons.repeat,
            color: AppColors.repeticiones,
            onIncrement: () {
              final currentState = context.read<SelectedRoutineCubit>().state;
              if (currentState is SelectedRoutineLoaded) {
                final ejercicioIndex = _findEjercicioIndex(
                    currentState.rutina.ejercicios, ejercicio.id);
                if (ejercicioIndex != -1) {
                  context.read<SelectedRoutineCubit>().incrementReps(
                        ejercicioIndex,
                        selectedRowIndex!,
                      );
                }
              }
            },
            onDecrement: () {
              final currentState = context.read<SelectedRoutineCubit>().state;
              if (currentState is SelectedRoutineLoaded) {
                final ejercicioIndex = _findEjercicioIndex(
                    currentState.rutina.ejercicios, ejercicio.id);
                if (ejercicioIndex != -1) {
                  context.read<SelectedRoutineCubit>().decrementReps(
                        ejercicioIndex,
                        selectedRowIndex!,
                      );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildControlRow({
    required BuildContext context,
    required String label,
    required String value,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: Espaciado.relleno16y8,
      margin: const EdgeInsets.only(bottom: Espaciado.xs),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        spacing: Espaciado.xs,
        children: [
          // Icono y etiqueta
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 18,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.textoPrincipalClaro,
                fontSize: TipografiaGyMaster.tamanoMd,
                fontWeight: TipografiaGyMaster.pesoSemiBold,
              ),
            ),
          ),
          // Valor central
          Expanded(
            flex: 3,
            child: Container(
              padding: Espaciado.relleno16y8,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: color.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: TipografiaGyMaster.tamanoXl,
                    fontWeight: TipografiaGyMaster.pesoSemiBold,
                  ),
                ),
              ),
            ),
          ),
          // Botones de control tipo ChicletButton
          Row(
            children: [
              ChicletButton(
                texto: '',
                icono: Icons.add,
                colorFondo: AppColors.secundario,
                colorTexto: Colors.white,
                radioBorde: 8,
                tamano: TamanoBotonChiclet.pequeno,
                estilo: EstiloBotonChiclet.relleno,
                onPressed: onIncrement,
                conSombreado: false,
                paddingHorizontal: 8,
                paddingVertical: 4,
                ancho: 36,
                alto: 36,
              ),
              const SizedBox(width: Espaciado.xs),
              ChicletButton(
                texto: '',
                icono: Icons.remove,
                colorFondo: AppColors.textoTerciario,
                colorTexto: Colors.white,
                radioBorde: 8,
                tamano: TamanoBotonChiclet.pequeno,
                estilo: EstiloBotonChiclet.relleno,
                onPressed: onDecrement,
                conSombreado: false,
                paddingHorizontal: 8,
                paddingVertical: 4,
                ancho: 36,
                alto: 36,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
