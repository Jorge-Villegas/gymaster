import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gymaster/features/routine/presentation/cubits/rutina/routine_cubit.dart';
import 'package:gymaster/features/routine/presentation/pages/agregar_rutina_page.dart';
import 'package:gymaster/features/routine/presentation/pages/routine_search_delegate.dart';
import 'package:gymaster/features/routine/presentation/widgets/routine_card.dart';
import 'package:gymaster/shared/widgets/custom_elevated_button.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

class ListaRutinasPage extends StatelessWidget {
  const ListaRutinasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _builAddRoutineButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
    );
  }

  Widget _builAddRoutineButton(BuildContext context) {
    return FloatingActionButton(
      onPressed:
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AgregarRutinaPage()),
          ),
      child: const Icon(Icons.add),
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
    return BlocBuilder<RoutineCubit, RoutineState>(
      builder: (context, state) {
        if (state is RoutineError) {
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
                icon: const Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AgregarRutinaPage(),
                    ),
                  );
                },
              ),
            ],
          );
        }
        if (state is RoutineGetAllSuccess) {
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
        return const SizedBox();
      },
    );
  }

  Widget _buildRoutineList() {
    return Expanded(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: BlocBuilder<RoutineCubit, RoutineState>(
          builder: (context, state) {
            if (state is RoutineLoading) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                period: const Duration(seconds: 1),
                child: ListView.builder(
                  itemCount: 5, // Número de elementos de carga
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
            if (state is RoutineError) {
              debugPrint(state.message);
              // return Center(child: Text(state.message));
              // return Column(
              //   children: [
              //     Center(
              //       child: Lottie.asset('assets/lottie/alzando_pesas.json'),
              //     ),
              //     const Text(
              //       'Cada gran cambio comienza con un primer paso. Agrega tu primera rutina ahoraCada gran cambio comienza con un primer paso. Agrega tu primera rutina ahora',
              //     ),
              //   ],
              // );
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Lottie.asset(
                      'assets/lottie/alzando_pesas.json',
                      width: 200,
                      height: 200,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Cada gran cambio comienza con un primer paso. Agrega tu primera rutina ahora.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  CustomElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AgregarRutinaPage(),
                        ),
                      );
                    },
                    text: 'Agregar Rutina',
                    borderRadius: 10,
                    height: 40,
                  ),
                ],
              );
            }
            if (state is RoutineAddSuccess) {
              BlocProvider.of<RoutineCubit>(context).getAllRoutine();
            }
            if (state is RoutineGetAllSuccess) {
              if (state.routines.isEmpty) {
                return Column(
                  children: [
                    Center(
                      child: Lottie.network(
                        'https://lottie.host/69088e50-d3a1-4fcc-8c18-8fcee60c44f0/8UbSvpBZAe.lottiehttps://lottie.host/69088e50-d3a1-4fcc-8c18-8fcee60c44f0/8UbSvpBZAe.lottie',
                      ),
                    ),
                    const Text(
                      'Cada gran cambio comienza con un primer paso. Agrega tu primera rutina ahoraCada gran cambio comienza con un primer paso. Agrega tu primera rutina ahora',
                    ),
                  ],
                );
              }
              return ListView.separated(
                itemCount: state.routines.length,
                separatorBuilder:
                    (_, __) => Container(height: 10, color: Colors.grey[200]),
                itemBuilder: (context, i) {
                  final rutina = state.routines[i];
                  final cantidadTexto = _getCantidadTexto(
                    rutina.cantidadEjercicios,
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
                },
              );
            } else {
              return const Center(child: Text('Error al cargar las rutinas'));
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
}
