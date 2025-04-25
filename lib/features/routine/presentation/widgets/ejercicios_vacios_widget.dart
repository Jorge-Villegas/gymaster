import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymaster/core/generated/assets.gen.dart';
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
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;
        final imageSize = isSmallScreen ? 150.0 : 200.0;
        final verticalPadding = constraints.maxHeight * 0.1;
        final horizontalPadding = isSmallScreen ? 24.0 : 48.0;

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding > 20 ? verticalPadding : 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset(
                Assets.imagenes.otros.personaConPesaNegro.path,
                width: imageSize,
                height: imageSize,
              ),
              const SizedBox(height: 24),
              Text(
                'No hay ejercicios aún',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Agrega ejercicios para comenzar tu rutina',
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CustomElevatedButton(
                  onPressed: () {
                    context
                        .push('/agregar-ejercicios/$rutinaId/$sessionId')
                        .then((
                      _,
                    ) {
                      if (context.mounted) {
                        // Llama a getAllEjercicios después de que se cierra la pantalla AgregarEjerciciosPage
                        // BlocProvider.of<EjerciciosByRutinaCubit>(
                        //   context,
                        //   listen: false,
                        // ).getAllEjercicios(idRutina: rutinaId);
                      }
                    });
                  },
                  text: 'Agregar Ejercicio',
                ),
              ),
              const Spacer(),
            ],
          ),
        );
      },
    );
  }
}
