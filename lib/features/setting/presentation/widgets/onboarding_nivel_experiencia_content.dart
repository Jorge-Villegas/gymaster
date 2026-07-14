import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymaster/core/theme/espaciado.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';
import 'package:gymaster/core/theme/gym_typography.dart';
import 'package:gymaster/features/setting/domain/entities/perfil_usuario_completo.dart';
import 'package:gymaster/features/setting/presentation/cubits/onboarding/onboarding_cubit.dart';
import 'package:gymaster/shared/widgets/gymaster_choice_chip.dart';

class OnboardingNivelExperienciaContent extends StatefulWidget {
  const OnboardingNivelExperienciaContent({super.key});

  @override
  State<OnboardingNivelExperienciaContent> createState() =>
      _OnboardingNivelExperienciaContentState();
}

class _OnboardingNivelExperienciaContentState
    extends State<OnboardingNivelExperienciaContent> {
  NivelExperiencia? _nivelSeleccionado;

  final List<Map<String, dynamic>> nivelesInfo = [
    {
      'nivel': NivelExperiencia.principiante,
      'emoji': '🌱',
      'titulo': 'Principiante',
      'descripcion': 'Menos de 6 meses entrenando',
      'detalle': 'Perfecto para comenzar con fundamentos sólidos'
    },
    {
      'nivel': NivelExperiencia.intermedio,
      'emoji': '💪',
      'titulo': 'Intermedio',
      'descripcion': '6 meses a 2 años de experiencia',
      'detalle': 'Ya conoces los básicos, ¡hora de subir el nivel!'
    },
    {
      'nivel': NivelExperiencia.avanzado,
      'emoji': '🏆',
      'titulo': 'Avanzado',
      'descripcion': 'Más de 2 años entrenando',
      'detalle': 'Entrenamientos desafiantes para atletas experimentados'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(Espaciado.lg),
      child: Column(
        spacing: Espaciado.lg,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '¿Cuál es tu nivel de experiencia?',
            style: GymType.title,
          ),
          Text(
            'Esto nos ayudará a personalizar tus entrenamientos y establecer el ritmo adecuado para ti',
            style: GymType.body.copyWith(
              color: context.gym.muted,
            ),
          ),
          Column(
            children: nivelesInfo.map((info) {
              final nivel = info['nivel'] as NivelExperiencia;
              final isSelected = _nivelSeleccionado == nivel;
              return Padding(
                padding: const EdgeInsets.only(bottom: Espaciado.xs),
                child: SizedBox(
                  width: double.infinity,
                  child: GyMasterChoiceChip(
                    texto: info['titulo'] as String,
                    emoji: info['emoji'] as String,
                    descripcion: info['detalle'] as String,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        _nivelSeleccionado = nivel;
                        _guardarNivel();
                      });
                    },
                    tamano: TamanoChoiceChip.regular,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _guardarNivel() {
    if (_nivelSeleccionado != null) {
      context
          .read<OnboardingCubit>()
          .updateNivelExperiencia(_nivelSeleccionado!.name);
    }
  }
}
