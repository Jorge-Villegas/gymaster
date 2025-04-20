import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymaster/features/record/domain/entities/record_rutina.dart';
import 'package:gymaster/features/record/presentation/cubit/record_cubit.dart';
import 'package:gymaster/features/record/presentation/cubit/selected_routine/selected_routine_cubit.dart';
import 'package:gymaster/features/record/presentation/cubit/selected_routine/selected_routine_state.dart';
import 'package:gymaster/features/routine/presentation/widgets/lista_series_widget.dart';
import 'package:gymaster/shared/widgets/reusable_table.dart';

class DetalleEjercicioPage extends StatefulWidget {
  final RecordEjercicios recordEjercicios;

  const DetalleEjercicioPage({super.key, required this.recordEjercicios});

  @override
  _DetalleEjercicioPageState createState() => _DetalleEjercicioPageState();
}

class _DetalleEjercicioPageState extends State<DetalleEjercicioPage> {
  int? selectedRowIndex;

  @override
  void initState() {
    super.initState();
    if (widget.recordEjercicios.seriesDelEjercicio.isNotEmpty) {
      selectedRowIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Forzar recarga de datos cuando se regresa a la página anterior
        context.read<RecordCubit>().getAllRutinas();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.recordEjercicios.nombre),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                // Forzar reconstrucción del widget
                setState(() {});
              },
            ),
          ],
        ),
        body: BlocBuilder<SelectedRoutineCubit, SelectedRoutineState>(
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

              return _buildContent(context, state, ejercicio, tableData);
            }
            return const Center(child: CircularProgressIndicator());
          },
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Detalles de ${ejercicio.nombre}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        CustomDataTable(
          headers: const ['Serie', 'Peso', 'Reps', 'Acciones'],
          data: tableData,
          onRemoveRow: (index) {
            setState(() {
              ejercicio.seriesDelEjercicio.removeAt(index);
              // Actualizar el estado seleccionado
              context.read<SelectedRoutineCubit>().saveChanges(state.rutina);
              if (selectedRowIndex != null && index <= selectedRowIndex!) {
                selectedRowIndex = selectedRowIndex! - 1;
              }
            });
          },
          enableRowSelection: true,
          onRowSelected: (index) {
            setState(() {
              selectedRowIndex = index;
            });
          },
          selectedRowIndex: selectedRowIndex,
          headerColor: Theme.of(context).primaryColor,
          bodyTextColor: Colors.black87,
          backgroundColor: Colors.grey.shade100,
        ),
        const SizedBox(height: 24),
        if (selectedRowIndex != null && selectedRowIndex! < tableData.length)
          _buildControls(context, ejercicio, tableData),
      ],
    );
  }

  Widget _buildControls(
    BuildContext context,
    RecordEjercicios ejercicio,
    List<List<String>> tableData,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ajustar Serie ${selectedRowIndex! + 1}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              _buildControlRow(
                context: context,
                label: 'Peso:',
                value: tableData[selectedRowIndex!][1],
                onIncrement: () {
                  context.read<SelectedRoutineCubit>().incrementPeso(
                    ejercicio.id == widget.recordEjercicios.id ? 0 : 1,
                    selectedRowIndex!,
                  );
                },
                onDecrement: () {
                  context.read<SelectedRoutineCubit>().decrementPeso(
                    ejercicio.id == widget.recordEjercicios.id ? 0 : 1,
                    selectedRowIndex!,
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildControlRow(
                context: context,
                label: 'Repeticiones:',
                value: tableData[selectedRowIndex!][2],
                onIncrement: () {
                  context.read<SelectedRoutineCubit>().incrementReps(
                    ejercicio.id == widget.recordEjercicios.id ? 0 : 1,
                    selectedRowIndex!,
                  );
                },
                onDecrement: () {
                  context.read<SelectedRoutineCubit>().decrementReps(
                    ejercicio.id == widget.recordEjercicios.id ? 0 : 1,
                    selectedRowIndex!,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlRow({
    required BuildContext context,
    required String label,
    required String value,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Expanded(
          child: Center(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Row(
          children: [
            SeriesControlButton(icon: Icons.add, onPressed: onIncrement),
            const SizedBox(width: 8),
            SeriesControlButton(icon: Icons.remove, onPressed: onDecrement),
          ],
        ),
      ],
    );
  }
}
