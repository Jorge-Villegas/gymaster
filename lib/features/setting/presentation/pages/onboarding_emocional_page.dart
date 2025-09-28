import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gymaster/core/theme/app_colors.dart';
import 'package:gymaster/core/theme/emotional_text_styles.dart';
import 'package:gymaster/features/setting/domain/entities/user_motivation.dart';
import 'package:gymaster/features/setting/presentation/cubits/onboarding/onboarding_cubit.dart';
import 'package:gymaster/features/setting/presentation/cubits/onboarding/onboarding_state.dart';
import 'package:gymaster/shared/utils/haptic_feedback_helper.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class OnboardingEmocionalPage extends StatefulWidget {
  const OnboardingEmocionalPage({super.key});

  @override
  State<OnboardingEmocionalPage> createState() =>
      _OnboardingEmocionalPageState();
}

class _OnboardingEmocionalPageState extends State<OnboardingEmocionalPage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<OnboardingCubit, OnboardingState>(
        listener: (context, state) {
          if (state is OnboardingCompleted) {
            // Navegar a la página principal
            context.go('/main');
          } else if (state is OnboardingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: BlocBuilder<OnboardingCubit, OnboardingState>(
          builder: (context, state) {
            if (state is OnboardingLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            int currentPage = 0;
            if (state is OnboardingPageChanged) {
              currentPage = state.currentPage;
              // Sincronizar el PageController con el estado del cubit
              if (_pageController.hasClients &&
                  _pageController.page?.round() != currentPage) {
                _pageController.animateToPage(
                  currentPage,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            }

            return SafeArea(
              child: Column(
                children: [
                  _buildProgressHeader(context, currentPage),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics:
                          const NeverScrollableScrollPhysics(), // Deshabilitar deslizamiento
                      onPageChanged: (page) {
                        debugPrint('📖 PageView cambió a página: $page');
                        // No hacer nada aquí, el cambio de página se maneja solo con botones
                      },
                      children: [
                        _buildMotivationPage(context),
                        _buildChallengesPage(context),
                        _buildPostWorkoutFeelingsPage(context),
                        _buildNotificationPreferencesPage(context),
                      ],
                    ),
                  ),
                  _buildNavigationButtons(context, currentPage),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProgressHeader(BuildContext context, int currentPage) {
    final progress = (currentPage + 1) / 4;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${currentPage + 1} de 4',
                style: EstilosTextoEmocional.amigable,
              ),
              if (currentPage > 0)
                IconButton(
                  onPressed: () =>
                      context.read<OnboardingCubit>().previousPage(),
                  icon: const Icon(IconsaxPlusLinear.arrow_left),
                ),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.acento),
            minHeight: 6,
          ),
        ],
      ),
    );
  }

  Widget _buildMotivationPage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            '¿Qué te motiva a entrenar?',
            style: EstilosTextoEmocional.motivacional,
          ),
          const SizedBox(height: 10),
          Text(
            'Selecciona todo lo que te inspire 💪',
            style: EstilosTextoEmocional.amigable,
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

  Widget _buildChallengesPage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            '¿Cuáles son tus mayores desafíos?',
            style: EstilosTextoEmocional.motivacional,
          ),
          const SizedBox(height: 10),
          Text(
            'Conocerlos nos ayuda a ayudarte mejor 🤝',
            style: EstilosTextoEmocional.amigable,
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

  Widget _buildPostWorkoutFeelingsPage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            '¿Cómo esperas sentirte después de entrenar?',
            style: EstilosTextoEmocional.motivacional,
          ),
          const SizedBox(height: 10),
          Text(
            'Esto nos ayuda a diseñar la experiencia perfecta ✨',
            style: EstilosTextoEmocional.amigable,
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
              itemCount: MotivationOptions.postWorkoutFeelings.length,
              itemBuilder: (context, index) {
                final feeling = MotivationOptions.postWorkoutFeelings[index];
                return BlocBuilder<OnboardingCubit, OnboardingState>(
                  builder: (context, state) {
                    bool isSelected = false;
                    if (state is OnboardingPageChanged) {
                      isSelected = state.partialMotivation.postWorkoutFeelings
                          .contains(feeling);
                    }

                    return _buildSelectableCard(
                      text: feeling,
                      isSelected: isSelected,
                      onTap: () {
                        final cubit = context.read<OnboardingCubit>();
                        final currentFeelings = (state is OnboardingPageChanged)
                            ? state.partialMotivation.postWorkoutFeelings
                            : <String>[];

                        List<String> newFeelings = List.from(currentFeelings);
                        if (isSelected) {
                          newFeelings.remove(feeling);
                        } else {
                          newFeelings.add(feeling);
                        }

                        cubit.updatePostWorkoutFeelings(newFeelings);
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

  Widget _buildNotificationPreferencesPage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            '¿Cómo te gusta que te motivemos?',
            style: EstilosTextoEmocional.motivacional,
          ),
          const SizedBox(height: 10),
          Text(
            'Personaliza tus recordatorios para mantenerte motivado 🔔',
            style: EstilosTextoEmocional.amigable,
          ),
          const SizedBox(height: 30),
          // Configuraciones de notificación aquí
          // TODO: Implementar controles de notificación
          Expanded(
            child: Column(
              children: [
                Card(
                  child: ListTile(
                    leading: const Icon(IconsaxPlusLinear.notification),
                    title: const Text('Recordatorios activados'),
                    subtitle: const Text(
                        'Te enviaremos motivación cuando la necesites'),
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {
                        // TODO: Implementar toggle
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tono de motivación',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          children: MotivationTone.values.map((tone) {
                            return ChoiceChip(
                              label: Text(_getToneLabel(tone)),
                              selected: tone == MotivationTone.energetico,
                              onSelected: (selected) {
                                // TODO: Implementar selección de tono
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getToneLabel(MotivationTone tone) {
    switch (tone) {
      case MotivationTone.energetico:
        return '🔥 Energético';
      case MotivationTone.suave:
        return '😊 Suave';
      case MotivationTone.competitivo:
        return '💪 Competitivo';
      case MotivationTone.empoderador:
        return '⭐ Empoderador';
    }
  }

  Widget _buildSelectableCard({
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
          color: isSelected ? AppColors.acento : AppColors.fondoSecundarioClaro,
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

  Widget _buildNavigationButtons(BuildContext context, int currentPage) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          if (currentPage > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () => context.read<OnboardingCubit>().previousPage(),
                child: const Text('Anterior'),
              ),
            ),
          if (currentPage > 0) const SizedBox(width: 16),
          Expanded(
            child: BlocBuilder<OnboardingCubit, OnboardingState>(
              builder: (context, state) {
                final canContinue = context
                    .read<OnboardingCubit>()
                    .canContinueFromCurrentPage();
                final isLastPage = currentPage == 3;

                debugPrint(
                    '🔘 Construyendo botón - Página: $currentPage, Puede continuar: $canContinue');

                return ElevatedButton(
                  onPressed: canContinue
                      ? () {
                          debugPrint(
                              '🚀 Botón presionado - Página: $currentPage');
                          if (isLastPage) {
                            context
                                .read<OnboardingCubit>()
                                .completeOnboarding();
                          } else {
                            context.read<OnboardingCubit>().nextPage();
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.acento,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(isLastPage ? '¡Comenzar!' : 'Siguiente'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
