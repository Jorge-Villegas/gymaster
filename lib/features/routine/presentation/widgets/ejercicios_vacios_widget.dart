import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gymaster/core/generated/assets.gen.dart';
import 'package:gymaster/features/routine/presentation/cubits/ejercicios_by_rutina/ejercicios_by_rutina_cubit.dart';
import 'package:gymaster/shared/widgets/custom_elevated_button.dart';

class EjerciciosVaciosWidget extends StatelessWidget {
  final String rutinaId;
  final String sessionId;

  const EjerciciosVaciosWidget({
    super.key,
    required this.rutinaId,
    required this.sessionId,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.9,
      widthFactor: 1,
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            Assets.imagenes.otros.personaConPesaNegro.path,
            width: 200,
            height: 200,
          ),
          const SizedBox(height: 10),
          Text(
            'No hay ejercicios aún',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 10),
          Text(
            'Agrega ejercicios para comenzar tu rutina',
            style: Theme.of(context).textTheme.labelSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(5),
            child: CustomElevatedButton(
              onPressed: () {
                context.push('/agregar-ejercicios/$rutinaId/$sessionId').then((
                  _,
                ) {
                  if (context.mounted) {
                    // Llama a getAllEjercicios después de que se cierra la pantalla AgregarEjerciciosPage
                    BlocProvider.of<EjerciciosByRutinaCubit>(
                      context,
                      listen: false,
                    ).getAllEjercicios(idRutina: rutinaId);
                  }
                });
              },
              text: 'Agregar Ejercicio',
            ),
          ),
        ],
      ),
    );
  }
}
