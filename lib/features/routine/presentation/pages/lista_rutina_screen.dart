import 'package:animate_do/animate_do.dart';
import 'package:gymaster/core/widgets/loader.dart';
import 'package:gymaster/features/routine/domain/entities/routine.dart';
import 'package:gymaster/features/routine/presentation/cubits/rutina/routine_cubit.dart';
import 'package:gymaster/features/routine/presentation/pages/agregar_rutina_page.dart';
import 'package:gymaster/features/routine/presentation/pages/detalle_rutina_page.dart';
import 'package:gymaster/features/routine/presentation/widgets/routine_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymaster/shared/utils/logger.dart';

class ListaRutinasPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const ListaRutinasPage(),
      );

  const ListaRutinasPage({super.key});

  @override
  State<ListaRutinasPage> createState() => _ListaRutinasPageState();
}

class _ListaRutinasPageState extends State<ListaRutinasPage> {
  _cargarRutinas() async {
    final routineCubit = BlocProvider.of<RoutineCubit>(context);

    routineCubit.getAllRoutine();
  }

  Future<void> goToAgregarRutina() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const AgregarRutinaPage(),
      ),
    );
    if (result != null) {
      debugPrint('result => $result');

      final routineCubit = BlocProvider.of<RoutineCubit>(context);

      routineCubit.addRoutine(
        name: result.name,
        description: result.description ?? '',
        creationDate: result.fechaCreacion,
        done: result.echo ?? false,
        color: result.color ?? 0,
      );
    } else {
      logger.t('No result from AgregarRutinaScreen');
    }
    _cargarRutinas();
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<RoutineCubit>(context).getAllRoutine();
  }

  Future<void> _goToDetalleRutina(String rutinaId) async {
    //TODO: ARRREGLAR EL PASO DE LA RUTINA AL CAMBIAR LA BASE DE DATOS
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetalleRutinaScreen(
          rutinaId: rutinaId,
        ),
      ),
    );
    // setState(() {
    //   _cargarRutinas();
    //   _cantidadEjerciciosPorSeries(rutina);
    // });
  }

  @override
  Widget build(BuildContext context) {
    // final ejercicioProvider = Provider.of<EjercicioProvider>(context);
    // final rp = Provider.of<RutinaProvider>(context);
    final routineCubit = BlocProvider.of<RoutineCubit>(context);
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Hola, Jorge',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D2A2A),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _cargarRutinas();
                    },
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Rutinas',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Color(0xE137FA),
                    ),
                  ),
                  //agregar boton para nueva rutina
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AgregarRutinaPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    iconSize: 30,
                    tooltip: 'Agregar nueva rutina',
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Scaffold(
                  body: BlocBuilder<RoutineCubit, RoutineState>(
                    builder: (context, state) {
                      if (state is RoutineLoading) {
                        return const Loader();
                      }
                      if (state is RoutineError) {
                        debugPrint(state.message);
                        return Center(
                          child: Text(state.message),
                        );
                      }
                      if (state is RoutineAddSuccess) {
                        routineCubit.getAllRoutine();
                      }
                      if (state is RoutineGetAllSuccess) {
                        if (state.routines.isEmpty) {
                          return const Center(
                            child: Text('No hay rutinas disponibles'),
                          );
                        }
                        return ListView.separated(
                            itemCount: state.routines.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, i) {
                              final rutina = state.routines[i];
                              String cantidadTexto;
                              if (rutina.cantidadEjercicios == 0) {
                                cantidadTexto = 'No hay Ejercicios';
                              } else if (rutina.cantidadEjercicios == 1) {
                                cantidadTexto =
                                    '${rutina.cantidadEjercicios} Ejercicio';
                              } else {
                                cantidadTexto =
                                    '${rutina.cantidadEjercicios} Ejercicios';
                              }

                              Routine(
                                cantidadEjercicios: rutina.cantidadEjercicios,
                                id: rutina.id,
                                name: rutina.name,
                                description: rutina.description,
                                fechaCreacion: rutina.fechaCreacion,
                                echo: rutina.echo,
                                color: rutina.color,
                              );

                              // Limita el retraso máximo a 1500 milisegundos (15 * 100)
                              final delay = Duration(
                                  milliseconds: 100 * (i < 15 ? i : 15));

                              return FadeInLeft(
                                delay: delay,
                                child: RoutineCard(
                                  color: rutina.color,
                                  title: rutina.name,
                                  cantidadEjerciciosPorSeries: cantidadTexto,
                                  onTap: () {
                                    _goToDetalleRutina(rutina.id!);
                                  },
                                ),
                              );
                            });
                      } else {
                        return const Center(
                          child: Text('Error al cargar las rutinas'),
                        );
                      }
                    },
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerFloat,
                  floatingActionButton: FloatingActionButton.extended(
                    elevation: 10,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AgregarRutinaPage(),
                        ),
                      );
                    },
                    label: const Text(
                      'Nueva Rutina',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}