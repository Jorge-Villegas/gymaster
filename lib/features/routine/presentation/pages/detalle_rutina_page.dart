import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gymaster/core/generated/assets.gen.dart';
import 'package:gymaster/features/routine/domain/entities/ejercicios_de_rutina.dart';
import 'package:gymaster/features/routine/presentation/cubits/ejercicios_by_rutina/ejercicios_by_rutina_cubit.dart';
import 'package:gymaster/features/routine/presentation/widgets/ejercicios_llenos_widget.dart';
import 'package:gymaster/features/routine/presentation/widgets/ejercicios_vacios_widget.dart';
import 'package:gymaster/shared/utils/text_formatter.dart';

class DetalleRutinaScreen extends StatelessWidget {
  // Identificador de la rutina.
  final String rutinaId;

  // Constructor de la clase, requiere el identificador de la rutina.
  const DetalleRutinaScreen({
    super.key,
    required this.rutinaId,
  });

  // Método para navegar a la pantalla de inicio de la rutina.
  Future<void> _goToIniciarRutina(
    BuildContext context,
    EjerciciosDeRutina ejerciciosDeRutina,
  ) async {
    context.push('/detalle-ejercicio');
  }

  // Método que construye la interfaz de usuario de la pantalla.
  @override
  Widget build(BuildContext context) {
    // Solicita todos los ejercicios de la rutina especificada.
    BlocProvider.of<EjerciciosByRutinaCubit>(context)
        .getAllEjercicios(idRutina: rutinaId);

    // Retorna un Scaffold que contiene la estructura básica de la interfaz de usuario de la aplicación.
    return Scaffold(
      // AppBar que muestra el nombre de la rutina o "RUTINA" si no se pudo obtener.
      appBar: AppBar(
        leading: IconButton(
          icon: SvgPicture.asset(Assets.icons.flechaIzquierda.path),
          onPressed: () {
            context.go('/');
          },
        ),
        title: BlocBuilder<EjerciciosByRutinaCubit, EjerciciosByRutinaState>(
          builder: (context, state) {
            if (state is EjerciciosByRutinaSuccess) {
              return Text(
                TextFormatter.capitalize(state.ejerciciosDeRutina.nombre),
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
                  icon: SvgPicture.asset(Assets.icons.iconsax.addCircle.path),
                  onPressed: () {
                    context.push('/agregar-ejercicios/$rutinaId').then((_) {
                      if (context.mounted) {
                        // Llama a getAllEjercicios después de que se cierra la pantalla AgregarEjerciciosPage
                        // cuando se vuelve de la pantalla de agregar, al regresar a la pantalla de detalle de la rutina
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
      // Fondo de la pantalla.
      // backgroundColor: Colors.grey.shade200,
      // Cuerpo de la pantalla que muestra los ejercicios de la rutina o un mensaje de error si no se pudieron obtener.
      body: BlocBuilder<EjerciciosByRutinaCubit, EjerciciosByRutinaState>(
        builder: (context, state) {
          if (state is EjerciciosByRutinaSuccess) {
            if (state.ejerciciosDeRutina.ejercicios.isEmpty) {
              return EjerciciosVaciosWidget(rutinaId: rutinaId);
            } else {
              return EjerciciosLlenosWidget(
                ejerciciosDeRutina: state.ejerciciosDeRutina,
                rutinaId: rutinaId,
                goToIniciarRutina: _goToIniciarRutina,
              );
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
          return const Center(child: Text('Error al cargar los ejercicios'));
        },
      ),
    );
  }
}
