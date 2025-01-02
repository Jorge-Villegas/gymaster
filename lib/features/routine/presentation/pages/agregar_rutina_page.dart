import 'package:go_router/go_router.dart';
import 'package:gymaster/core/generated/assets.gen.dart';
import 'package:gymaster/features/routine/domain/entities/routine.dart';
import 'package:gymaster/features/routine/presentation/cubits/rutina/routine_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class AgregarRutinaPage extends StatefulWidget {
  const AgregarRutinaPage({super.key});

  @override
  State<AgregarRutinaPage> createState() => _AgregarRutinaPageState();
}

class _AgregarRutinaPageState extends State<AgregarRutinaPage> {
  List<int> colors = [
    0xFFF48FB1,
    0xFFB39DDB,
    0xFF90CAF9,
    0xFF80DEEA,
    0xFFA5D6A7,
    0xFFE6EE9C,
    0xFFFFE082,
    0xFFFFAB91,
    0xFFB0BEC5,
    0xFFBCAAA4,
    0xFFFFCC80,
    0xFFFFF59D,
    0xFFC5E1A5,
    0xFF80CBC4,
    0xFF81D4FA,
    0xFFEF9A9A,
    0xFF9FA8DA,
    0xFFCE93D8,
    0xFFD1C4E9,
    0xFFBBDEFB,
    0xFFB2EBF2,
    0xFFAED581,
    0xFFFFF176,
    0xFFCFD8DC,
    0xFFE1BEE7,
    0xFFD7CCC8,
    0xFFFFE0B2,
    0xFFFFF9C4,
    0xFFDCEDC8,
    0xFFC5CAE9,
    0xFFB3E5FC,
    0xFFB2DFDB,
    0xFFFFCDD2,
  ];

  Color selectedColor = Colors.primaries.first.shade200;
  final textController = TextEditingController();
  String? errorMessage;

  void _onSave() async {
    final nombre = textController.text.trim();
    if (nombre.isEmpty) {
      setState(() {
        errorMessage = 'El nombre de la rutina es requerido';
      });
      return;
    } else {
      // setState(() {
      //   errorMessage = null;
      // });
    }

    final rutina = Routine(
      fechaCreacion: DateTime.now(),
      name: nombre,
      echo: false,
      color: selectedColor.value,
      description: '',
      cantidadEjercicios: 0,
    );

    final routineCubit = BlocProvider.of<RoutineCubit>(context);

    await routineCubit.addRoutine(
      name: rutina.name,
      description: rutina.description ?? '',
      creationDate: rutina.fechaCreacion,
      done: rutina.echo,
      color: rutina.color,
    );

    if (routineCubit.state is RoutineAddSuccess) {
      final rutinaId = (routineCubit.state as RoutineAddSuccess).rutina.id!;
      context.push('/rutina/detalle/$rutinaId');
    }
    if (routineCubit.state is RoutineError) {
      setState(() {
        errorMessage = (routineCubit.state as RoutineError).message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: SvgPicture.asset(Assets.icons.flechaIzquierda.path),
          onPressed: () {
            context.pop();
          },
        ),
        title: const Text('Agregar Rutina'),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 1,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                color: selectedColor,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.group,
                      size: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextField(
                        controller: textController,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Nombre de la rutina',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 20,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        errorMessage ?? '',
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    child: Text(
                      'SELECCIONE UN COLOR',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: colors.length,
                      itemBuilder: (context, index) {
                        final color = Color(colors[index]);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedColor = color;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(
                                  10), // Bordes redondeados
                            ),
                            child: const Icon(
                              Icons.color_lens,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        if (textController.text.isEmpty) {
                          setState(() {
                            errorMessage =
                                'El nombre de la rutina no puede estar vacio';
                          });
                        } else {
                          _onSave();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8870FF),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                          ), // Icono del botón
                          SizedBox(width: 10),
                          Text(
                            'Agregar',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
