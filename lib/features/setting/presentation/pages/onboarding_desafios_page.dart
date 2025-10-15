import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymaster/core/theme/app_colors.dart';
import 'package:gymaster/core/theme/emotional_text_styles.dart';
import 'package:gymaster/features/setting/presentation/cubits/onboarding/onboarding_cubit.dart';
import 'package:gymaster/features/setting/presentation/cubits/onboarding/onboarding_state.dart';
import 'package:gymaster/features/setting/data/models/user_motivation.dart';
import 'package:gymaster/shared/utils/haptic_feedback_helper.dart';

/// Página 6 del onboarding: Selección de desafíos
class OnboardingDesafiosPage extends StatelessWidget {
  const OnboardingDesafiosPage({super.key});

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
                  '💪',
                  style: TextStyle(fontSize: 28),
                ),
                const SizedBox(height: 8),
                Text(
                  '¿Cuáles son tus mayores desafíos?',
                  style: EstilosTextoEmocional.motivacional,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Conocerlos nos ayuda a ayudarte mejor 🤝',
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
              itemCount: MotivationOptions.challenges.length,
              itemBuilder: (context, index) {
                final challenge = MotivationOptions.challenges[index];
                return BlocBuilder<OnboardingCubit, OnboardingState>(
                  builder: (context, state) {
                    bool isSelected = false;
                    if (state is OnboardingPageChanged) {
                      isSelected = state.partialMotivation.challenges
                          .contains(challenge);
                    }

                    return _buildSelectableCard(
                      context: context,
                      text: challenge,
                      isSelected: isSelected,
                      onTap: () {
                        final cubit = context.read<OnboardingCubit>();
                        final currentChallenges =
                            (state is OnboardingPageChanged)
                                ? state.partialMotivation.challenges
                                : <String>[];

                        List<String> newChallenges =
                            List.from(currentChallenges);
                        if (isSelected) {
                          newChallenges.remove(challenge);
                        } else {
                          newChallenges.add(challenge);
                        }

                        cubit.updateChallenges(newChallenges);
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
