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
    return Expanded(
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
                /**
                 * Peso
                 */

                const SizedBox(width: 15),
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 100),
                    child: TextFormField(
                      controller: pesoControllers[index],
                      decoration: InputDecoration(
                        labelText: 'Peso (kg)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        prefixIcon: IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () => _decrementPeso(index),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => _incrementPeso(index),
                        ),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*(\.\d*)?$'),
                        ),
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          final text = newValue.text;
                          if (newValue.text.startsWith('0') ||
                              newValue.text.startsWith('.') ||
                              newValue.text.startsWith(',')) {
                            return oldValue;
                          }
                          if (RegExp(r'^\d*(\.\d{0,2})?$').hasMatch(text)) {
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
                ),
                /**
                 * Repeticiones
                 */
                const SizedBox(width: 15),
                Expanded(
                  child: TextFormField(
                    controller: repeticionesControllers[index],
                    decoration: InputDecoration(
                      labelText: 'Repeticiones',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => _decrementRepeticiones(index),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => _incrementRepeticiones(index),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TextInputFormatter.withFunction((oldValue, newValue) {
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
              ],
            ),
          );
        },
      ),
    );
  }
}
