import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gymaster/features/routine/presentation/cubits/rutina/routine_cubit.dart';
import 'package:gymaster/features/routine/presentation/pages/agregar_rutina_page.dart';
import 'package:gymaster/features/routine/presentation/pages/routine_search_delegate.dart';
import 'package:gymaster/features/routine/presentation/widgets/routine_card.dart';
import 'package:gymaster/shared/widgets/loader.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class ListaRutinasPage extends StatelessWidget {
  const ListaRutinasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),
              _buildHeader(context),
              const SizedBox(height: 20),
              _buildSearchBar(context),
              const SizedBox(height: 10),
              _buildRoutineList(),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Hola, Jorge',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 3, 3, 3),
          ),
        ),
        IconButton(
          onPressed: () {
            BlocProvider.of<RoutineCubit>(context).getAllRoutine();
          },
          icon: const Icon(Icons.refresh),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Rutinas',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        IconButton(
          icon: const Icon(IconsaxPlusLinear.search_normal_1),
          onPressed: () async {
            final routineCubit = BlocProvider.of<RoutineCubit>(context);
            final result = await showSearch(
              context: context,
              delegate: RoutineSearchDelegate(),
            );
            if (result != null && context.mounted) {
              routineCubit.getAllRoutine();
            }
          },
        ),
      ],
    );
  }

  Widget _buildRoutineList() {
    return Expanded(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
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
              BlocProvider.of<RoutineCubit>(context).getAllRoutine();
            }
            if (state is RoutineGetAllSuccess) {
              if (state.routines.isEmpty) {
                return const Center(
                  child: Text('No hay rutinas disponibles'),
                );
              }
              return ListView.separated(
                itemCount: state.routines.length,
                separatorBuilder: (_, __) => Container(
                  height: 10,
                  color: Colors.grey[200],
                ),
                itemBuilder: (context, i) {
                  final rutina = state.routines[i];
                  final cantidadTexto =
                      _getCantidadTexto(rutina.cantidadEjercicios);

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
                },
              );
            } else {
              return const Center(
                child: Text('Error al cargar las rutinas'),
              );
            }
          },
        ),
      ),
    );
  }

  String _getCantidadTexto(int cantidadEjercicios) {
    if (cantidadEjercicios == 0) {
      return 'No hay Ejercicios';
    } else if (cantidadEjercicios == 1) {
      return '$cantidadEjercicios Ejercicio';
    } else {
      return '$cantidadEjercicios Ejercicios';
    }
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      elevation: 10,
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const AgregarRutinaPage(),
          ),
        );
      },
      label: Text(
        'Nueva Rutina',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.bodyMedium?.color,
        ),
      ),
    );
  }
}
