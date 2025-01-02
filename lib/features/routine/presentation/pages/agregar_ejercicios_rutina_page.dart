import 'package:go_router/go_router.dart';
import 'package:gymaster/core/config/app_config.dart';
import 'package:gymaster/core/utils/text_formatter.dart';
import 'package:gymaster/features/routine/presentation/cubits/agregar_series/agregar_series_cubit.dart';
import 'package:gymaster/features/routine/presentation/cubits/agregar_series/agregar_series_state.dart';
import 'package:gymaster/features/routine/presentation/cubits/ejercicio/ejercicio_cubit.dart';
import 'package:gymaster/features/routine/presentation/widgets/encabezado_ejercicio_widget.dart';
import 'package:gymaster/features/routine/presentation/widgets/lista_series_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymaster/shared/widgets/show_custom_snack_bar.dart';

class AgregarEjercicioRutinaPage extends StatefulWidget {
  final String ejercicioNombre;
  final String ejercicioImagenDireccion;
  final String ejercicioId;
  final String rutinaId;

  const AgregarEjercicioRutinaPage({
    super.key,
    required this.ejercicioNombre,
    required this.ejercicioId,
    required this.rutinaId,
    String? ejercicioImagenDireccion,
  }) : ejercicioImagenDireccion =
            ejercicioImagenDireccion ?? AppConfig.defaultImagePath;

  @override
  State<AgregarEjercicioRutinaPage> createState() =>
      _AgregarEjercicioRutinaPageState();
}

class _AgregarEjercicioRutinaPageState
    extends State<AgregarEjercicioRutinaPage> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _pesoControllers = [];
  final List<TextEditingController> _repeticionesControllers = [];

  @override
  void initState() {
    super.initState();
    context.read<AgregarSeriesCubit>().iniciar();
    context.read<AgregarSeriesCubit>().stream.listen((state) {
      if (state is AgregarSeriesLoaded) {
        // Mientras la cantidad de controladores de peso sea menor que la cantidad de series en el estado...
        while (_pesoControllers.length < state.cantidadSeries) {
          _pesoControllers.add(TextEditingController());
          _repeticionesControllers.add(TextEditingController());
        }

        //Mientras la cantidad de controladores de peso sea mayor que la cantidad de series en el estado...
        while (_pesoControllers.length > state.cantidadSeries) {
          _pesoControllers.removeLast();
          _repeticionesControllers.removeLast();
        }
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _pesoControllers) {
      controller.dispose();
    }
    for (var controller in _repeticionesControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _guardarDatos() async {
    FocusScope.of(context).unfocus(); // Ocultar teclado

    // Verificamos si existe al menos una serie
    if (_pesoControllers.isEmpty || _repeticionesControllers.isEmpty) {
      showCustomSnackBar(
        context,
        'Por favor, agregue al menos una serie',
        SnackBarType.error,
      );
      return;
    }

    // Validamos si la validación pasa
    if (!_formKey.currentState!.validate()) {
      showCustomSnackBar(
        context,
        'Por favor, complete todos los campos',
        SnackBarType.error,
      );
      return;
    }

    List<double?> pesos = _pesoControllers
        .map((controller) => TextFormatter.stringToDouble(controller.text))
        .toList();
    List<int?> repeticiones = _repeticionesControllers
        .map((controller) => TextFormatter.stringToInt(controller.text))
        .toList();

    if (pesos.contains(null) || repeticiones.contains(null)) {
      showCustomSnackBar(
        context,
        'Por favor, ingrese números válidos',
        SnackBarType.error,
      );
      return;
    }

    // Guardar los datos de forma asíncrona
    final resul = await context.read<AgregarSeriesCubit>().guardarDatos(
          rutinaId: widget.rutinaId,
          ejercicioId: widget.ejercicioId,
          pesos: pesos.cast<double>(),
          repeticiones: repeticiones.cast<int>(),
        );

    // Verificar si el widget sigue montado antes de usar el contexto
    if (!mounted) return;

    if (resul) {

      
      // Llamar al EjercicioCubit para actualizar el estado
      context.read<EjercicioCubit>().ejercicioAgregado(id: widget.ejercicioId);

      context.pop();

      showCustomSnackBar(
        context,
        'El ejercicio ha sido guardado',
        SnackBarType.success,
      );
    } else {
      showCustomSnackBar(
        context,
        'Error al guardar el ejercicio',
        SnackBarType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Ejercicio a Rutina'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<AgregarSeriesCubit, AgregarSeriesState>(
          builder: (context, state) {
            if (state is AgregarSeriesLoaded) {
              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EncabezadoEjercicioWidget(
                      nombreEjercicio: widget.ejercicioNombre,
                      cantidadSeries: state.cantidadSeries,
                      urlImage: widget.ejercicioImagenDireccion,
                      onIncrement: () {
                        context.read<AgregarSeriesCubit>().incrementarSeries();
                      },
                      onDecrement: () {
                        context.read<AgregarSeriesCubit>().decrementarSeries();
                      },
                    ),
                    const SizedBox(height: 20),
                    ListaSeriesWidget(
                      cantidadSeries: state.cantidadSeries,
                      pesoControllers: _pesoControllers,
                      repeticionesControllers: _repeticionesControllers,
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _guardarDatos,
        label: const Text('Guardar'),
        icon: const Icon(Icons.save),
      ),
    );
  }
}
