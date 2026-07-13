import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';
import 'package:gymaster/shared/widgets/chiclet_button.dart';

/// Widget que muestra una lista de series de ejercicios.
///
/// Cada serie tiene un campo para el peso y otro para las repeticiones.
/// Ambos campos pueden incrementarse o decrementarse con botones.
class ListaSeriesWidget extends StatefulWidget {
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

  @override
  State<ListaSeriesWidget> createState() => _ListaSeriesWidgetState();
}

class _ListaSeriesWidgetState extends State<ListaSeriesWidget> {
  // Estado para controlar qué serie y qué campo está expandido
  int? _expandedSerieIndex;
  String? _expandedField; // 'peso' o 'repeticiones'

  /// Incrementa el peso de la serie en el índice dado en 5 kg.
  void _incrementPeso(int index) {
    double currentValue =
        double.tryParse(widget.pesoControllers[index].text) ?? 0.0;
    currentValue += 5;
    widget.pesoControllers[index].text = currentValue.toStringAsFixed(2);
  }

  /// Decrementa el peso de la serie en el índice dado en 5 kg.
  void _decrementPeso(int index) {
    double currentValue =
        double.tryParse(widget.pesoControllers[index].text) ?? 0.0;
    if (currentValue <= 0) return;
    currentValue -= 5;
    widget.pesoControllers[index].text = currentValue.toStringAsFixed(2);
  }

  /// Incrementa las repeticiones de la serie en el índice dado en 1.
  void _incrementRepeticiones(int index) {
    int currentValue =
        int.tryParse(widget.repeticionesControllers[index].text) ?? 0;
    currentValue += 1;
    widget.repeticionesControllers[index].text = currentValue.toString();
  }

  /// Decrementa las repeticiones de la serie en el índice dado en 1.
  void _decrementRepeticiones(int index) {
    int currentValue =
        int.tryParse(widget.repeticionesControllers[index].text) ?? 0;
    if (currentValue <= 0) return;
    currentValue -= 1;
    widget.repeticionesControllers[index].text = currentValue.toString();
  }

  /// Expande/colapsa un campo específico
  void _toggleField(int serieIndex, String field) {
    setState(() {
      if (_expandedSerieIndex == serieIndex && _expandedField == field) {
        // Si ya está expandido, colapsar
        _expandedSerieIndex = null;
        _expandedField = null;
      } else {
        // Expandir el campo seleccionado
        _expandedSerieIndex = serieIndex;
        _expandedField = field;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Verificar que tengamos suficientes controladores
    if (widget.pesoControllers.length < widget.cantidadSeries ||
        widget.repeticionesControllers.length < widget.cantidadSeries) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    for (var controller in widget.pesoControllers) {
      if (controller.text.isEmpty) {
        controller.text = '40.00';
      }
    }
    for (var controller in widget.repeticionesControllers) {
      if (controller.text.isEmpty) {
        controller.text = '10';
      }
    }

    return Column(
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
        // Usar Column en lugar de ListView para evitar conflictos de scroll
        ...List.generate(
          widget.cantidadSeries,
          (index) {
            final bool isPesoExpanded =
                _expandedSerieIndex == index && _expandedField == 'peso';
            final bool isRepeticionesExpanded = _expandedSerieIndex == index &&
                _expandedField == 'repeticiones';

            return GestureDetector(
              // Detectar tap fuera del elemento activo para colapsar
              onTap: () {
                if (_expandedSerieIndex == index) {
                  setState(() {
                    _expandedSerieIndex = null;
                    _expandedField = null;
                  });
                }
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
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
                    // SECCIÓN DE PESO
                    Expanded(
                      child: _buildPesoSection(index, isPesoExpanded),
                    ),
                    const SizedBox(width: 10),
                    // SECCIÓN DE REPETICIONES
                    Expanded(
                      child: _buildRepeticionesSection(
                          index, isRepeticionesExpanded),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  /// Construye la sección de peso (expandible/colapsable)
  Widget _buildPesoSection(int index, bool isExpanded) {
    if (isExpanded) {
      // Vista expandida: botón - | campo | botón +
      return Row(
        children: [
          SizedBox(
            width: 32,
            height: 32,
            child: ChicletButton(
              texto: '',
              icono: Icons.remove,
              colorFondo: Colors.white,
              colorTexto: Colors.black,
              estilo: EstiloBotonChiclet.contorno,
              tamano: TamanoBotonChiclet.pequeno,
              radioBorde: 20,
              paddingHorizontal: 4,
              paddingVertical: 4,
              onPressed: () => _decrementPeso(index),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: GestureDetector(
              onTap: () => _toggleField(index, 'peso'),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF38B6FF).withAlpha((0.1 * 255).toInt()),
                      const Color(0xFF54BEFF).withAlpha((0.05 * 255).toInt()),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: const Color(0xFF38B6FF), width: 2),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF38B6FF)
                          .withAlpha((0.2 * 255).toInt()),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: widget.pesoControllers[index],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6366F1),
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*(\.\d*)?$')),
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
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          SizedBox(
            width: 32,
            height: 32,
            child: ChicletButton(
              texto: '',
              icono: Icons.add,
              colorFondo: Colors.white,
              colorTexto: Colors.black,
              estilo: EstiloBotonChiclet.contorno,
              tamano: TamanoBotonChiclet.pequeno,
              radioBorde: 20,
              paddingHorizontal: 4,
              paddingVertical: 4,
              onPressed: () => _incrementPeso(index),
            ),
          ),
        ],
      );
    } else {
      // Vista colapsada: solo el número
      return GestureDetector(
        onTap: () => _toggleField(index, 'peso'),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.gym.surface2,
            border: Border.all(color: context.gym.line, width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${widget.pesoControllers[index].text} kg',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: context.gym.ink,
            ),
          ),
        ),
      );
    }
  }

  /// Construye la sección de repeticiones (expandible/colapsable)
  Widget _buildRepeticionesSection(int index, bool isExpanded) {
    if (isExpanded) {
      // Vista expandida: botón - | campo | botón +
      return Row(
        children: [
          SizedBox(
            width: 32,
            height: 32,
            child: ChicletButton(
              texto: '',
              icono: Icons.remove,
              colorFondo: Colors.white,
              colorTexto: Colors.black,
              estilo: EstiloBotonChiclet.contorno,
              tamano: TamanoBotonChiclet.pequeno,
              radioBorde: 20,
              paddingHorizontal: 4,
              paddingVertical: 4,
              onPressed: () => _decrementRepeticiones(index),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: GestureDetector(
              onTap: () => _toggleField(index, 'repeticiones'),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF3FC55F).withAlpha((0.1 * 255).toInt()),
                      const Color(0xFF2A9D48).withAlpha((0.05 * 255).toInt()),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: const Color(0xFF3FC55F), width: 2),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3FC55F)
                          .withAlpha((0.2 * 255).toInt()),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: widget.repeticionesControllers[index],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF10B981),
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
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
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          SizedBox(
            width: 32,
            height: 32,
            child: ChicletButton(
              texto: '',
              icono: Icons.add,
              colorFondo: Colors.white,
              colorTexto: Colors.black,
              estilo: EstiloBotonChiclet.contorno,
              tamano: TamanoBotonChiclet.pequeno,
              radioBorde: 20,
              paddingHorizontal: 4,
              paddingVertical: 4,
              onPressed: () => _incrementRepeticiones(index),
            ),
          ),
        ],
      );
    } else {
      // Vista colapsada: solo el número
      return GestureDetector(
        onTap: () => _toggleField(index, 'repeticiones'),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.gym.surface2,
            border: Border.all(color: context.gym.line, width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${widget.repeticionesControllers[index].text} reps',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: context.gym.ink,
            ),
          ),
        ),
      );
    }
  }
}
