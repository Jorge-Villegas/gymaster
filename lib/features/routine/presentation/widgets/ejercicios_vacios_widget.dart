import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymaster/core/generated/assets.gen.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';
import 'package:gymaster/shared/widgets/gym/gym.dart';

class EjerciciosVaciosWidget extends StatelessWidget {
  final String rutinaId;
  final String sessionId;

  const EjerciciosVaciosWidget({
    super.key,
    required this.rutinaId,
    required this.sessionId,
  });

  /// Navega a la pantalla de agregar ejercicios
  void _navegarAAgregarEjercicios(BuildContext context) {
    context.push('/agregar-ejercicios/$rutinaId/$sessionId').then((_) {
      if (context.mounted) {
        // TODO: Implementar refresh de ejercicios después de agregar
        // context.read<EjerciciosByRutinaCubit>().getAllEjercicios(idRutina: rutinaId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                '¡Tu rutina está lista para comenzar!',
                style: TextStyle(
                  fontSize: isSmallScreen ? 18 : 20,
                  fontWeight: FontWeight.w600,
                  color: context.gym.ink,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Agrega tus ejercicios favoritos y comienza a entrenar hoy',
                style: TextStyle(
                  fontSize: isSmallScreen ? 16 : 18,
                  fontWeight: FontWeight.w400,
                  color: context.gym.faint,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GymButton(
                    label: 'Agregar Ejercicio',
                    variant: GymButtonVariant.primary,
                    size: GymButtonSize.large,
                    expand: true,
                    onPressed: () => _navegarAAgregarEjercicios(context),
                  ),
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
