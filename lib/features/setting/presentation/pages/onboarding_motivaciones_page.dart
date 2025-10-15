import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymaster/core/theme/app_colors.dart';
import 'package:gymaster/core/theme/emotional_text_styles.dart';
import 'package:gymaster/features/setting/presentation/cubits/onboarding/onboarding_cubit.dart';
import 'package:gymaster/features/setting/presentation/cubits/onboarding/onboarding_state.dart';
import 'package:gymaster/features/setting/data/models/user_motivation.dart';
import 'package:gymaster/shared/utils/haptic_feedback_helper.dart';

/// Página 5 del onboarding: Selección de motivaciones
class OnboardingMotivacionesPage extends StatelessWidget {
  const OnboardingMotivacionesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.acento.withValues(alpha: 0.1),
                  AppColors.primario.withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.acento.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                const Text(
                  '🎯',
                  style: TextStyle(fontSize: 28),
                ),
                const SizedBox(height: 8),
                Text(
                  '¿Qué te motiva a entrenar?',
                  style: EstilosTextoEmocional.motivacional,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Selecciona todo lo que te inspire 💪',
                  style: EstilosTextoEmocional.amigable.copyWith(
                    color: AppColors.textoPrincipal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: MotivationOptions.motivations.length,
              itemBuilder: (context, index) {
                final motivation = MotivationOptions.motivations[index];
                return BlocBuilder<OnboardingCubit, OnboardingState>(
                  builder: (context, state) {
                    bool isSelected = false;
                    if (state is OnboardingPageChanged) {
                      isSelected = state.partialMotivation.motivations
                          .contains(motivation);
                    }

                    return _buildSelectableCard(
                      context: context,
                      text: motivation,
                      isSelected: isSelected,
                      onTap: () {
                        final cubit = context.read<OnboardingCubit>();
                        final currentMotivations =
                            (state is OnboardingPageChanged)
                                ? state.partialMotivation.motivations
                                : <String>[];

                        List<String> newMotivations =
                            List.from(currentMotivations);
                        if (isSelected) {
                          newMotivations.remove(motivation);
                        } else {
                          newMotivations.add(motivation);
                        }

                        cubit.updateMotivations(newMotivations);
                        HapticFeedbackHelper.vibracionSeleccion();
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectableCard({
    required BuildContext context,
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.acento : AppColors.fondoSecundario,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.acento : AppColors.textoTerciario,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
