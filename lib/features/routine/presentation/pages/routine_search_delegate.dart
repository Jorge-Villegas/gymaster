import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gymaster/features/routine/presentation/cubits/rutina/routine_cubit.dart';
import 'package:gymaster/features/routine/domain/entities/routine.dart';
import 'package:gymaster/features/routine/presentation/widgets/routine_card.dart';

class RoutineSearchDelegate extends SearchDelegate<Routine> {
  @override
  String get searchFieldLabel => 'Buscar Rutina';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      BlocBuilder<RoutineCubit, RoutineState>(
        builder: (context, state) {
          if (state is RoutineLoading) {
            return SpinPerfect(
              duration: const Duration(seconds: 2),
              spins: 10,
              infinite: true,
              child: IconButton(
                onPressed: () => query = '',
                icon: const Icon(Icons.refresh_rounded),
              ),
            );
          } else {
            return FadeIn(
              animate: query.isNotEmpty,
              duration: const Duration(milliseconds: 200),
              child: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  query = '';
                },
              ),
            );
          }
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new_outlined),
      onPressed: () {
        close(
            context,
            Routine(
                name: '',
                fechaCreacion: DateTime.now(),
                echo: true,
                color: 4151,
                cantidadEjercicios: 0,
                imagenDireccion: ''));
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildRoutineList(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text('Introduce un nombre para buscar'));
    }
    BlocProvider.of<RoutineCubit>(context).searchRoutineByName(query);
    return _buildRoutineList(context);
  }

  Widget _buildRoutineList(BuildContext context) {
    return BlocBuilder<RoutineCubit, RoutineState>(
      builder: (context, state) {
        if (state is RoutineLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is RoutineError) {
          return Center(child: Text(state.message));
        }
        if (state is RoutineGetByNameSuccess) {
          final routines = state.routines;
          if (routines.isEmpty) {
            return const Center(child: Text('No se encontraron rutinas'));
          }
          return Padding(
            padding: const EdgeInsets.all(10),
            child: ListView.separated(
                itemCount: state.routines.length,
                separatorBuilder: (_, __) => Container(
                      height: 10,
                      color: Colors.grey[200],
                    ),
                itemBuilder: (context, i) {
                  final rutina = state.routines[i];
                  String cantidadTexto;
                  if (rutina.cantidadEjercicios == 0) {
                    cantidadTexto = 'No hay Ejercicios';
                  } else if (rutina.cantidadEjercicios == 1) {
                    cantidadTexto = '${rutina.cantidadEjercicios} Ejercicio';
                  } else {
                    cantidadTexto = '${rutina.cantidadEjercicios} Ejercicios';
                  }

                  Routine(
                    cantidadEjercicios: rutina.cantidadEjercicios,
                    id: rutina.id,
                    name: rutina.name,
                    description: rutina.description,
                    fechaCreacion: rutina.fechaCreacion,
                    echo: rutina.echo,
                    color: rutina.color,
                    imagenDireccion: rutina.imagenDireccion,
                  );

                  // Limita el retraso máximo a 1500 milisegundos (15 * 100)
                  final delay = Duration(milliseconds: 50 * (i < 5 ? i : 5));

                  return FadeInLeft(
                    delay: delay,
                    child: RoutineCard(
                      color: rutina.color,
                      title: rutina.name,
                      cantidadEjerciciosPorSeries: cantidadTexto,
                      imagenDireccion: rutina.imagenDireccion,
                      onTap: () {
                        context.push('/rutina/detalle/${rutina.id!}');
                      },
                    ),
                  );
                }),
          );
        }
        return const Center(child: Text('Introduce un nombre para buscar'));
      },
    );
  }
}
