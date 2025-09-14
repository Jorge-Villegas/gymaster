import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gymaster/features/routine/presentation/cubits/ejercicios_by_rutina/ejercicios_by_rutina_cubit.dart';
import 'package:gymaster/features/routine/presentation/widgets/ejercicios_llenos_widget.dart';
import 'package:gymaster/features/routine/presentation/widgets/ejercicios_vacios_widget.dart';
import 'package:gymaster/features/routine/presentation/widgets/rutina_completada_widget.dart';
import 'package:gymaster/shared/utils/text_formatter.dart';

class DetalleRutinaScreen extends StatelessWidget {
  // Identificador de la rutina.
  final String rutinaId;

  // Constructor de la clase, requiere el identificador de la rutina.
  const DetalleRutinaScreen({super.key, required this.rutinaId});

  // Método que construye la interfaz de usuario de la pantalla.
  @override
  Widget build(BuildContext context) {
    // Siempre recarga los ejercicios al entrar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<EjerciciosByRutinaCubit>(context, listen: false)
          .getAllEjercicios(idRutina: rutinaId);
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            context.go('/');
          },
        ),
        title: BlocBuilder<EjerciciosByRutinaCubit, EjerciciosByRutinaState>(
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
        actions: [
          BlocBuilder<EjerciciosByRutinaCubit, EjerciciosByRutinaState>(
            builder: (context, state) {
              if (state is! EjerciciosByRutinaCompleted &&
                  state is EjerciciosByRutinaSuccess) {
                final sessionId = state.ejerciciosDeRutina.session;
                return IconButton(
                  icon: const Icon(Icons.add_circle_outline_rounded),
                  onPressed: () {
                    context
                        .push('/agregar-ejercicios/$rutinaId/$sessionId')
                        .then((_) {
                      if (context.mounted) {
                        BlocProvider.of<EjerciciosByRutinaCubit>(
                          context,
                          listen: false,
                        ).getAllEjercicios(idRutina: rutinaId);
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
      body: BlocBuilder<EjerciciosByRutinaCubit, EjerciciosByRutinaState>(
        builder: (context, state) {
          if (state is EjerciciosByRutinaSuccess) {
            if (state.ejerciciosDeRutina.ejercicios.isEmpty) {
              return EjerciciosVaciosWidget(
                rutinaId: rutinaId,
                sessionId: state.ejerciciosDeRutina.session,
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
            return RutinaCompletadaWidget(state: state);
          }
          return const Center(
            child: Text('Error al cargar los ejercicios'),
          );
        },
      ),
    );
  }
}
