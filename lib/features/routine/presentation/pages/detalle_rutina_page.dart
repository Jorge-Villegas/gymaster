import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gymaster/core/generated/assets.gen.dart';
import 'package:gymaster/features/routine/presentation/cubits/ejercicios_by_rutina/ejercicios_by_rutina_cubit.dart';
import 'package:gymaster/features/routine/presentation/widgets/ejercicios_llenos_widget.dart';
import 'package:gymaster/features/routine/presentation/widgets/ejercicios_vacios_widget.dart';
import 'package:gymaster/shared/utils/text_formatter.dart';

class DetalleRutinaScreen extends StatelessWidget {
  // Identificador de la rutina.
  final String rutinaId;

  // Constructor de la clase, requiere el identificador de la rutina.
  const DetalleRutinaScreen({super.key, required this.rutinaId});

  // Método que construye la interfaz de usuario de la pantalla.
  @override
  Widget build(BuildContext context) {
    // Solicita todos los ejercicios de la rutina especificada.
    // BlocProvider.of<EjerciciosByRutinaCubit>(
    //   context,
    // ).getAllEjercicios(idRutina: rutinaId);

    // Cambiar a FutureBuilder para manejar el Future<String> de sessionId
    return FutureBuilder<String>(
      future: BlocProvider.of<EjerciciosByRutinaCubit>(
        context,
      ).getRoutineSessionByRoutineId(rutinaId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else {
          final sessionId = snapshot.data ?? '';
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () {
                  context.go('/');
                },
              ),
              title:
                  BlocBuilder<EjerciciosByRutinaCubit, EjerciciosByRutinaState>(
                builder: (context, state) {
                  if (state is EjerciciosByRutinaSuccess) {
                    return Text(
                      TextFormatter.capitalize(
                        state.ejerciciosDeRutina.nombre,
                      ),
                    );
                  }
                  return const Text('RUTINA');
                },
              ),
              // Botón para agregar ejercicios a la rutina.
              actions: [
                BlocBuilder<EjerciciosByRutinaCubit, EjerciciosByRutinaState>(
                  builder: (context, state) {
                    if (state is! EjerciciosByRutinaCompleted) {
                      return IconButton(
                        icon: const Icon(Icons.add_circle_outline_rounded),
                        onPressed: () {
                          context
                              .push('/agregar-ejercicios/$rutinaId/$sessionId')
                              .then((_) {
                            if (context.mounted) {
                              // Llama a getAllEjercicios después de que se cierra la pantalla AgregarEjerciciosPage
                              // cuando se vuelve de la pantalla de agregar, al regresar a la pantalla de detalle de la rutina
                              // BlocProvider.of<EjerciciosByRutinaCubit>(
                              //   context,
                              //   listen: false,
                              // ).getAllEjercicios(idRutina: rutinaId);
                            }
                          });
                        },
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ],
            ),
            // Fondo de la pantalla.
            // backgroundColor: Colors.grey.shade200,
            // Cuerpo de la pantalla que muestra los ejercicios de la rutina o un mensaje de error si no se pudieron obtener.
            body: BlocBuilder<EjerciciosByRutinaCubit, EjerciciosByRutinaState>(
              builder: (context, state) {
                if (state is EjerciciosByRutinaSuccess) {
                  if (state.ejerciciosDeRutina.ejercicios.isEmpty) {
                    return EjerciciosVaciosWidget(
                      rutinaId: rutinaId,
                      sessionId: sessionId,
                    );
                  } else {
                    return const EjerciciosLlenosWidget();
                  }
                }
                if (state is EjerciciosByRutinaLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is EjerciciosByRutinaError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                if (state is EjerciciosByRutinaCompleted) {
                  return const Center(child: Text('Rutina completada'));
                }
                return const Center(
                  child: Text('Error al cargar los ejercicios'),
                );
              },
            ),
          );
        }
      },
    );
  }
}
