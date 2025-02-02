import 'package:flutter/material.dart';
import 'package:gymaster/features/record/presentation/pages/pages.dart';
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
  List<List<String>> tableData = [];
  int? selectedRowIndex;

  @override
  void initState() {
    super.initState();
    // Inicializar la tabla Datos con la serie del registro Ejercicios
    tableData = widget.recordEjercicios.seriesDelEjercicio.map((serie) {
      return [
        (widget.recordEjercicios.seriesDelEjercicio.indexOf(serie) + 1)
            .toString(),
        '${serie.peso} kg',
        '${serie.repeticiones} x',
      ];
    }).toList();
    // Selecciona la primera fila por defecto
    if (tableData.isNotEmpty) {
      selectedRowIndex = 0;
    }
  }

  void removeRow(int index) {
    setState(() {
      if (index < tableData.length) {
        bool wasSelectedRow = selectedRowIndex == index;
        tableData.removeAt(index);
        if (tableData.isEmpty) {
          selectedRowIndex = null;
          SnackbarHelper().showCustomSnackBar(
            context,
            'No hay más datos por eliminar.',
            SnackBarType.warning,
          );
        } else if (wasSelectedRow) {
          // Seleccionar la fila más cercana
          if (index == tableData.length) {
            selectedRowIndex = index - 1;
          } else {
            selectedRowIndex = index;
          }
        }
      }
    });
  }

  void handleRowSelected(int index) {
    setState(() {
      selectedRowIndex = index; // Actualizar la fila seleccionada
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
      body: Column(
        children: [
          CustomDataTable(
            headers: const ['Serie', 'Peso', 'Reps', 'Acciones'],
            data: tableData,
            onRemoveRow: removeRow,
            enableRowSelection: true, // Habilitar selección de filas
            onRowSelected: handleRowSelected, // Manejar selección de filas
            selectedRowIndex: selectedRowIndex, // Pasar el índice seleccionado
            bodyTextColor: Colors.black,
            headerColor: Theme.of(context).primaryColor,
            selectionColor: Theme.of(context).primaryColor.withOpacity(0.2),
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
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
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            SeriesControlButton(
                              icon: Icons.add,
                              onPressed: () {
                                setState(() {
                                  tableData[selectedRowIndex!][0] = (int.parse(
                                              tableData[selectedRowIndex!][0]) +
                                          1)
                                      .toString();
                                });
                              },
                            ),
                            SeriesControlButton(
                              icon: Icons.remove,
                              onPressed: () {
                                setState(() {
                                  int currentValue = int.parse(
                                      tableData[selectedRowIndex!][0]);
                                  if (currentValue > 0) {
                                    tableData[selectedRowIndex!][0] =
                                        (currentValue - 1).toString();
                                  }
                                });
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
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            SeriesControlButton(
                              icon: Icons.add,
                              onPressed: () {
                                setState(() {
                                  tableData[selectedRowIndex!][1] =
                                      '${(double.parse(tableData[selectedRowIndex!][1].split(' ')[0]) + 5).toStringAsFixed(1)} kg';
                                });
                              },
                            ),
                            SeriesControlButton(
                              icon: Icons.remove,
                              onPressed: () {
                                setState(() {
                                  double currentValue = double.parse(
                                      tableData[selectedRowIndex!][1]
                                          .split(' ')[0]);
                                  if (currentValue > 0) {
                                    tableData[selectedRowIndex!][1] =
                                        '${(currentValue - 5).toStringAsFixed(1)} kg';
                                  }
                                });
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
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            SeriesControlButton(
                              icon: Icons.add,
                              onPressed: () {
                                setState(() {
                                  tableData[selectedRowIndex!][2] =
                                      '${int.parse(tableData[selectedRowIndex!][2].split(' ')[0]) + 1} x';
                                });
                              },
                            ),
                            SeriesControlButton(
                              icon: Icons.remove,
                              onPressed: () {
                                setState(() {
                                  int currentValue = int.parse(
                                      tableData[selectedRowIndex!][2]
                                          .split(' ')[0]);
                                  if (currentValue > 0) {
                                    tableData[selectedRowIndex!][2] =
                                        '${currentValue - 1} x';
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              )
          // ...existing code...
        ],
      ),
    );
  }
}
