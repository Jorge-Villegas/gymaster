import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymaster/features/record/presentation/widgets/series_control_button.dart';

/// Widget que muestra una lista de series de ejercicios.
///
/// Cada serie tiene un campo para el peso y otro para las repeticiones.
/// Ambos campos pueden incrementarse o decrementarse con botones.
class ListaSeriesWidget extends StatelessWidget {
  /// Cantidad de series a mostrar.
  final int cantidadSeries;

  /// Controladores de texto para los campos de peso de cada serie.
  final List<TextEditingController> pesoControllers;

  /// Controladores de texto para los campos de repeticiones de cada serie.
  final List<TextEditingController> repeticionesControllers;

  const ListaSeriesWidget({
    super.key,
    required this.cantidadSeries,
    required this.pesoControllers,
    required this.repeticionesControllers,
  });

  /// Incrementa el peso de la serie en el índice dado en 5 kg.
  _incrementPeso(int index) {
    double currentValue = double.tryParse(pesoControllers[index].text) ?? 0.0;
    currentValue += 5;
    pesoControllers[index].text = currentValue.toStringAsFixed(2);
  }

  /// Decrementa el peso de la serie en el índice dado en 5 kg.
  _decrementPeso(int index) {
    double currentValue = double.tryParse(pesoControllers[index].text) ?? 0.0;
    if (currentValue <= 0) return;
    currentValue -= 5;
    pesoControllers[index].text = currentValue.toStringAsFixed(2);
  }

  /// Incrementa las repeticiones de la serie en el índice dado en 1.
  _incrementRepeticiones(int index) {
    int currentValue = int.tryParse(repeticionesControllers[index].text) ?? 0;
    currentValue += 1;
    repeticionesControllers[index].text = currentValue.toString();
  }

  /// Decrementa las repeticiones de la serie en el índice dado en 1.
  _decrementRepeticiones(int index) {
    int currentValue = int.tryParse(repeticionesControllers[index].text) ?? 0;
    if (currentValue <= 0) return;
    currentValue -= 1;
    repeticionesControllers[index].text = currentValue.toString();
  }

  @override
  Widget build(BuildContext context) {
    for (var controller in pesoControllers) {
      if (controller.text.isEmpty) {
        controller.text = '40.00';
      }
    }
    for (var controller in repeticionesControllers) {
      if (controller.text.isEmpty) {
        controller.text = '10';
      }
    }

    return Expanded(
      child: Column(
        children: [
          const Padding(
            // Mantener Padding para los encabezados
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: Row(
              children: [
                SizedBox(width: 40),
                Expanded(
                  child: Text(
                    'Peso (kg)',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 80),
                Expanded(
                  child: Text(
                    'Repeticiones',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 72),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cantidadSeries,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        // Envuelve el número de serie para controlar ancho
                        width: 40, // Ancho fijo para alineación
                        child: Text(
                          ' ${index + 1}:',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      // const SizedBox(width: 5),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment
                              .center, // Centrar verticalmente
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: pesoControllers[index],
                                textAlign: TextAlign.center, // Centrar texto
                                decoration: const InputDecoration(
                                  // Añadir decoración
                                  border: OutlineInputBorder(),
                                  isDense: true, // Hacerlo más compacto
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 8.0),
                                ),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*(\.\d*)?$'),
                                  ),
                                  TextInputFormatter.withFunction(
                                      (oldValue, newValue) {
                                    final text = newValue.text;
                                    if (newValue.text.startsWith('0') ||
                                        newValue.text.startsWith('.') ||
                                        newValue.text.startsWith(',')) {
                                      return oldValue;
                                    }
                                    if (RegExp(r'^\d*(\.\d{0,2})?$')
                                        .hasMatch(text)) {
                                      return newValue;
                                    } else {
                                      return oldValue;
                                    }
                                  }),
                                ],
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      double.tryParse(value) == null ||
                                      double.parse(value) <= 0) {
                                    return 'Inválido';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 4),
                            SizedBox(
                              // Mantener SizedBox para tamaño de botón
                              width: 36,
                              height: 36,
                              child: SeriesControlButton(
                                icon: Icons.add,
                                onPressed: () => _incrementPeso(index),
                              ),
                            ),
                            SizedBox(
                              // Mantener SizedBox para tamaño de botón
                              width: 36,
                              height: 36,
                              child: SeriesControlButton(
                                icon: Icons.remove,
                                onPressed: () => _decrementPeso(index),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: repeticionesControllers[index],
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  // Añadir decoración
                                  border: OutlineInputBorder(),
                                  isDense: true, // Hacerlo más compacto
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 8.0),
                                ),
                                keyboardType: TextInputType.number,
                                // ...existing inputFormatters and validator...
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  TextInputFormatter.withFunction(
                                      (oldValue, newValue) {
                                    if (newValue.text.startsWith('0')) {
                                      return oldValue;
                                    }
                                    return newValue;
                                  }),
                                ],
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      int.tryParse(value) == null ||
                                      int.parse(value) <= 0) {
                                    return 'Inválido';
                                  }
                                  if (int.parse(value) > 50) {
                                    return '>50';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 4),
                            SizedBox(
                              // Mantener SizedBox para tamaño de botón
                              width: 36,
                              height: 36,
                              child: SeriesControlButton(
                                icon: Icons.add,
                                onPressed: () => _incrementRepeticiones(index),
                              ),
                            ),
                            SizedBox(
                              // Mantener SizedBox para tamaño de botón
                              width: 36,
                              height: 36,
                              child: SeriesControlButton(
                                icon: Icons.remove,
                                onPressed: () => _decrementRepeticiones(index),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
