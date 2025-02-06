import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymaster/features/record/domain/entities/record_rutina.dart';
import 'package:gymaster/features/record/presentation/cubit/record_cubit.dart';
import 'package:gymaster/features/record/presentation/cubit/record_state.dart';
import 'package:gymaster/features/routine/presentation/widgets/lista_series_widget.dart';
import 'package:gymaster/shared/utils/snackbar_helper.dart';
import 'package:gymaster/shared/widgets/reusable_table.dart';

class DetalleEjercicioPage extends StatefulWidget {
  final RecordEjercicios recordEjercicios;

  const DetalleEjercicioPage({
    super.key,
    required this.recordEjercicios,
  });

  @override
  _DetalleEjercicioPageState createState() => _DetalleEjercicioPageState();
}

class _DetalleEjercicioPageState extends State<DetalleEjercicioPage> {
  int? selectedRowIndex;

  @override
  void initState() {
    super.initState();
    // Selecciona la primera fila por defecto
    if (widget.recordEjercicios.seriesDelEjercicio.isNotEmpty) {
      selectedRowIndex = 0;
    }
    context.read<RecordCubit>().loadRecordRutina(RecordRutina(
          id: '',
          nombre: '',
          fechaRealizada: DateTime.now(),
          tiempoRealizado: '',
          color: 0,
          ejercicios: [widget.recordEjercicios],
        ));
  }

  void handleRowSelected(int index) {
    setState(() {
      selectedRowIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.recordEjercicios.nombre,
          textAlign: TextAlign.center,
        ),
      ),
      body: BlocConsumer<RecordCubit, RecordState>(
        listener: (context, state) {
          if (state is RecordError) {
            SnackbarHelper().showCustomSnackBar(
              context,
              state.message,
              SnackBarType.error,
            );
          }
        },
        builder: (context, state) {
          if (state is RecordLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is RutinaLoaded) {
            final recordEjercicios = state.rutina.ejercicios.first;
            final tableData = recordEjercicios.seriesDelEjercicio.map((serie) {
              return [
                (recordEjercicios.seriesDelEjercicio.indexOf(serie) + 1)
                    .toString(),
                '${serie.peso} kg',
                '${serie.repeticiones} x',
              ];
            }).toList();

            return Column(
              children: [
                CustomDataTable(
                  headers: const ['Serie', 'Peso', 'Reps', 'Acciones'],
                  data: tableData,
                  onRemoveRow: (index) {
                    setState(() {
                      recordEjercicios.seriesDelEjercicio.removeAt(index);
                      context
                          .read<RecordCubit>()
                          .loadRecordRutina(state.rutina);
                    });
                  },
                  enableRowSelection: true,
                  onRowSelected: handleRowSelected,
                  selectedRowIndex: selectedRowIndex,
                  bodyTextColor: Colors.black,
                  headerColor: Theme.of(context).primaryColor,
                  selectionColor:
                      Theme.of(context).primaryColor.withOpacity(0.2),
                  backgroundColor:
                      Theme.of(context).primaryColor.withOpacity(0.1),
                  cellTextAlign: TextAlign.center,
                  headerTextSize: 16.0,
                  maxHeight: 400,
                  minHeight: 200,
                ),
                const SizedBox(height: 20),
                Text(
                  widget.recordEjercicios.nombre,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 20),
                if (selectedRowIndex != null)
                  if (selectedRowIndex != null &&
                      selectedRowIndex! < tableData.length)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Serie:',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    tableData[selectedRowIndex!][0],
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  SeriesControlButton(
                                    icon: Icons.add,
                                    onPressed: () {
                                      context
                                          .read<RecordCubit>()
                                          .incrementSeries(
                                              0, selectedRowIndex!);
                                    },
                                  ),
                                  SeriesControlButton(
                                    icon: Icons.remove,
                                    onPressed: () {
                                      context
                                          .read<RecordCubit>()
                                          .decrementSeries(
                                              0, selectedRowIndex!);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Peso:',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    tableData[selectedRowIndex!][1],
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  SeriesControlButton(
                                    icon: Icons.add,
                                    onPressed: () {
                                      context
                                          .read<RecordCubit>()
                                          .incrementPeso(0, selectedRowIndex!);
                                    },
                                  ),
                                  SeriesControlButton(
                                    icon: Icons.remove,
                                    onPressed: () {
                                      context
                                          .read<RecordCubit>()
                                          .decrementPeso(0, selectedRowIndex!);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Reps:',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    tableData[selectedRowIndex!][2],
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  SeriesControlButton(
                                    icon: Icons.add,
                                    onPressed: () {
                                      context
                                          .read<RecordCubit>()
                                          .incrementReps(0, selectedRowIndex!);
                                    },
                                  ),
                                  SeriesControlButton(
                                    icon: Icons.remove,
                                    onPressed: () {
                                      context
                                          .read<RecordCubit>()
                                          .decrementReps(0, selectedRowIndex!);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
