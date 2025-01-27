import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                SizedBox(width: 50),
                Expanded(
                  child: Text(
                    'Peso',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Text(
                    'Repetición',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cantidadSeries,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Text(
                        ' ${index + 1}: ',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: pesoControllers[index],
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
                                    return 'Requerido';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SeriesControlButton(
                              icon: Icons.add,
                              onPressed: () => _incrementPeso(index),
                            ),
                            SeriesControlButton(
                              icon: Icons.remove,
                              onPressed: () => _decrementPeso(index),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: repeticionesControllers[index],
                                keyboardType: TextInputType.number,
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
                                    return 'Requerido';
                                  }
                                  if (int.parse(value) > 50) {
                                    return 'Máximo 50';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SeriesControlButton(
                              icon: Icons.add,
                              onPressed: () => _incrementRepeticiones(index),
                            ),
                            SeriesControlButton(
                              icon: Icons.remove,
                              onPressed: () => _decrementRepeticiones(index),
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

class SeriesControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const SeriesControlButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Container(
        decoration: BoxDecoration(
          color: const Color.fromRGBO(232, 238, 241, 1.0),
          borderRadius: BorderRadius.circular(50),
        ),
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          color: Colors.black,
          size: 24,
        ),
      ),
      onPressed: onPressed,
    );
  }
}
