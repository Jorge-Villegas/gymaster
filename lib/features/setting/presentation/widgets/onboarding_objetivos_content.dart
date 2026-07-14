import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymaster/core/theme/espaciado.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';
import 'package:gymaster/core/theme/gym_typography.dart';
import 'package:gymaster/features/setting/domain/entities/perfil_usuario_completo.dart';
import 'package:gymaster/features/setting/presentation/cubits/onboarding/onboarding_cubit.dart';
import 'package:gymaster/shared/widgets/gymaster_input_field.dart';
import 'package:gymaster/shared/widgets/gymaster_choice_chip.dart';

class OnboardingObjetivosContent extends StatefulWidget {
  const OnboardingObjetivosContent({super.key});

  @override
  State<OnboardingObjetivosContent> createState() =>
      _OnboardingObjetivosContentState();
}

class _OnboardingObjetivosContentState
    extends State<OnboardingObjetivosContent> {
  ObjetivoFitness? _objetivoSeleccionado;
  final _pesoObjetivoController = TextEditingController();

  final List<Map<String, dynamic>> objetivosInfo = [
    {
      'objetivo': ObjetivoFitness.perder_peso,
      'icono': '🔥',
      'descripcion': 'Reducir grasa corporal y mantener masa muscular'
    },
    {
      'objetivo': ObjetivoFitness.ganar_musculo,
      'icono': '💪',
      'descripcion': 'Aumentar masa muscular y fuerza'
    },
    {
      'objetivo': ObjetivoFitness.mantenimiento,
      'icono': '⚖️',
      'descripcion': 'Mantener peso y composición corporal actual'
    },
    {
      'objetivo': ObjetivoFitness.fuerza,
      'icono': '🏋️',
      'descripcion': 'Aumentar fuerza y rendimiento'
    },
    {
      'objetivo': ObjetivoFitness.resistencia,
      'icono': '🏃',
      'descripcion': 'Mejorar capacidad cardiovascular'
    },
    {
      'objetivo': ObjetivoFitness.tonificar,
      'icono': '✨',
      'descripcion': 'Definir músculos y mejorar forma física'
    },
  ];

  @override
  void dispose() {
    _pesoObjetivoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(Espaciado.lg),
      child: Column(
        spacing: Espaciado.lg,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '¿Cuál es tu objetivo principal?',
            style: GymType.title,
          ),
          Text(
            'Selecciona el objetivo que mejor describa lo que quieres lograr',
            style: GymType.body.copyWith(
              color: context.gym.muted,
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: Espaciado.sm,
              mainAxisSpacing: Espaciado.sm,
              childAspectRatio: 1.1,
            ),
            itemCount: objetivosInfo.length,
            itemBuilder: (context, index) {
              final info = objetivosInfo[index];
              final objetivo = info['objetivo'] as ObjetivoFitness;
              final isSelected = _objetivoSeleccionado == objetivo;

              return GyMasterChoiceChip(
                texto: objetivo.nombre,
                emoji: info['icono'] as String,
                descripcion: info['descripcion'] as String,
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    _objetivoSeleccionado = objetivo;
                    _guardarObjetivo();
                  });
                },
                tamano: TamanoChoiceChip.grande,
              );
            },
          ),
          _construirCampoPesoObjetivo(),
        ],
      ),
    );
  }

  Widget _construirCampoPesoObjetivo() {
    return GyMasterNumberInputField(
      label: 'Peso objetivo (opcional)',
      hintText: 'kg',
      controller: _pesoObjetivoController,
      allowDecimals: true,
      maxLength: 5,
      suffixText: 'kg',
      helpText: 'Puedes dejarlo vacío si no tienes un objetivo específico.',
    );
  }

  void _guardarObjetivo() {
    if (_objetivoSeleccionado != null) {
      context
          .read<OnboardingCubit>()
          .updateObjetivo(_objetivoSeleccionado!.name);
    }
  }
}
