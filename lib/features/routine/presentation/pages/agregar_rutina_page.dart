import 'package:gymaster/core/generated/assets.gen.dart';
import 'package:gymaster/features/routine/domain/entities/routine.dart';
import 'package:gymaster/features/routine/presentation/cubits/rutina/routine_cubit.dart';
import 'package:gymaster/features/routine/presentation/pages/detalle_rutina_page.dart';
import 'package:gymaster/features/routine/presentation/pages/lista_rutina_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class AgregarRutinaPage extends StatefulWidget {
  const AgregarRutinaPage({super.key});

  @override
  State<AgregarRutinaPage> createState() => _AgregarRutinaPageState();
}

class _AgregarRutinaPageState extends State<AgregarRutinaPage> {
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
      done: rutina.echo ?? false,
      color: rutina.color ?? 0,
    );

    if (routineCubit.state is RoutineAddSuccess) {
      debugPrint((routineCubit.state as RoutineAddSuccess).rutina.id!);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DetalleRutinaScreen(
            rutinaId: (routineCubit.state as RoutineAddSuccess).rutina.id!,
          ),
        ),
      );
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
            // Navega a la pantalla de lista de rutinas y elimina la pantalla actual de la pila de navegación.
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const ListaRutinasPage()),
              (Route<dynamic> route) => false,
            );
          },
        ),
        title: const Text('Agregar Rutina'),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 1.5,
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
                      scrollDirection: Axis.horizontal,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemCount: Colors.primaries.length,
                      itemBuilder: (context, index) {
                        final color = Colors.primaries[index].shade200;
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 5,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedColor = color;
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor: color,
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
                    child: TextButton(
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
                      child: const Text(
                        'Agregar',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
