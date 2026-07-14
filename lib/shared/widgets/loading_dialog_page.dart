import 'package:flutter/material.dart';
import 'package:gymaster/core/theme/espaciado.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';
import 'package:gymaster/core/theme/gym_typography.dart';

class LoadingDialogPage extends StatelessWidget {
  const LoadingDialogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(
        alpha: (0.5 * 255).roundToDouble(),
      ),
      body: Center(
        child: Container(
          padding: Espaciado.rellenoMd,
          decoration: BoxDecoration(
            color: context.gym.surface,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              Espaciado.separacionVerticalSm,
              Text(
                'Cargando...',
                style: GymType.body,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
