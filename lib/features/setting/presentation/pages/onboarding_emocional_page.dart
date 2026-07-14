import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';
import 'package:gymaster/core/theme/gym_typography.dart';
import 'package:gymaster/features/setting/presentation/cubits/onboarding/onboarding_state.dart';
import 'package:gymaster/features/setting/presentation/cubits/onboarding/onboarding_cubit.dart';
import 'package:gymaster/features/setting/presentation/cubits/onboarding_usuario_cubit.dart';
import 'package:gymaster/features/setting/presentation/cubits/onboarding_usuario_state.dart';
import 'package:gymaster/features/setting/data/models/user_motivation.dart';
import 'package:gymaster/features/setting/domain/entities/perfil_usuario_completo.dart';

import 'package:gymaster/shared/utils/haptic_feedback_helper.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:gymaster/shared/widgets/gym/gym.dart';
import 'package:gymaster/shared/widgets/onboarding_header_widget.dart';

class OnboardingEmocionalPage extends StatefulWidget {
  final Map<String, dynamic>? datosCompletos;

  const OnboardingEmocionalPage({super.key, this.datosCompletos});

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OnboardingCubit>().navigateToPage('motivaciones');
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: MultiBlocListener(
        listeners: [
          BlocListener<OnboardingCubit, OnboardingState>(
            listener: (context, state) {
              if (state is OnboardingCompleted) {
                // Al completar el onboarding emocional, crear el perfil
                _crearPerfilCompleto(context);
              } else if (state is OnboardingError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: context.gym.danger,
                  ),
                );
              }
            },
          ),
          BlocListener<OnboardingUsuarioCubit, OnboardingUsuarioState>(
            listener: (context, state) {
              if (state is OnboardingUsuarioPerfilCreado) {
                context.pushReplacementNamed('listaRutinas');
              } else if (state is OnboardingUsuarioError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.mensaje),
                    backgroundColor: context.gym.danger,
                  ),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<OnboardingCubit, OnboardingState>(
          builder: (context, state) {
            if (state is OnboardingLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final cubit = context.read<OnboardingCubit>();
            int currentPage = cubit.currentPage;

            int currentSubPage = 0;
            if (currentPage >= 4 && currentPage <= 7) {
              currentSubPage = currentPage - 4;
            }

            if (state is OnboardingPageChanged &&
                currentPage >= 4 &&
                currentPage <= 7) {
              if (_pageController.hasClients &&
                  _pageController.page?.round() != currentSubPage) {
                _pageController.animateToPage(
                  currentSubPage,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            }

            return SafeArea(
              child: Column(
                children: [
                  const OnboardingHeaderWidget(),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (page) {},
                      children: [
                        _buildMotivationPage(context),
                        _buildChallengesPage(context),
                        _buildPostWorkoutFeelingsPage(context),
                        _buildNotificationPreferencesPage(context),
                      ],
                    ),
                  ),
                  _buildNavigationButtons(context, currentSubPage),
                ],
              ),
            );
          },
        ),
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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  context.gym.xpInk.withValues(alpha: 0.1),
                  context.gym.brand.withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: context.gym.xpInk.withValues(alpha: 0.2),
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
                  style: GymType.display,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Selecciona todo lo que te inspire 💪',
                  style: GymType.section.copyWith(
                    fontWeight: FontWeight.w300,
                    color: context.gym.ink,
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

  Widget _buildChallengesPage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            '¿Cuáles son tus mayores desafíos?',
            style: GymType.display,
          ),
          const SizedBox(height: 10),
          Text(
            'Conocerlos nos ayuda a ayudarte mejor 🤝',
            style: GymType.section.copyWith(fontWeight: FontWeight.w300),
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

  Widget _buildPostWorkoutFeelingsPage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            '¿Cómo esperas sentirte después de entrenar?',
            style: GymType.display,
          ),
          const SizedBox(height: 10),
          Text(
            'Esto nos ayuda a diseñar la experiencia perfecta ✨',
            style: GymType.section.copyWith(fontWeight: FontWeight.w300),
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
                      context: context,
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
            style: GymType.display,
          ),
          const SizedBox(height: 10),
          Text(
            'Personaliza tus recordatorios para mantenerte motivado 🔔',
            style: GymType.section.copyWith(fontWeight: FontWeight.w300),
          ),
          const SizedBox(height: 30),
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
                      onChanged: (value) {},
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
                              onSelected: (selected) {},
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
          color: isSelected ? context.gym.xpInk : context.gym.surface2,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? context.gym.xpInk : context.gym.faint,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : context.gym.ink,
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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).scaffoldBackgroundColor,
            context.gym.xpInk.withValues(alpha: 0.05),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        children: [
          if (currentPage > 0)
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: context.gym.xpInk),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () => context.read<OnboardingCubit>().previousPage(),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Text(
                        '← Anterior',
                        style: TextStyle(
                          color: context.gym.xpInk,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (currentPage > 0) const SizedBox(width: 16),
          Expanded(
            child: BlocBuilder<OnboardingCubit, OnboardingState>(
              builder: (context, state) {
                final cubit = context.read<OnboardingCubit>();
                final canContinue = cubit.canContinueFromCurrentPage();
                final isLastStep = cubit.isLastPage;

                final buttonTexts = [
                  '¡Sigamos! 🎯',
                  '¡Continuar! 💪',
                  '¡Siguiente! ⚡',
                  '🚀 ¡Comenzar mi aventura!'
                ];

                return GymButton(
                  label: buttonTexts[currentPage],
                  onPressed: canContinue
                      ? () {
                          if (isLastStep) {
                            cubit.completeOnboarding();
                          } else {
                            cubit.nextPage();
                          }
                        }
                      : null,
                  variant: GymButtonVariant.primary,
                  size: GymButtonSize.large,
                  expand: true,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _crearPerfilCompleto(BuildContext context) {
    if (widget.datosCompletos == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Error: Datos incompletos'),
          backgroundColor: context.gym.danger,
        ),
      );
      return;
    }

    final datos = widget.datosCompletos!;

    // Crear el perfil con todos los datos recolectados
    context.read<OnboardingUsuarioCubit>().crearPerfilCompleto(
          nombreUsuario: datos['nombre'] ?? '',
          correo: datos['correo']?.isEmpty == true ? null : datos['correo'],
          fotoPerfil: datos['avatar'] ?? 'perfil_1',
          nombreCompleto: datos['nombre'] ?? '',
          fechaNacimiento: datos['fechaNacimiento'] != null
              ? DateTime.parse(datos['fechaNacimiento'])
              : null,
          genero: Genero.values.firstWhere(
            (g) => g.name == datos['genero'],
            orElse: () => Genero.prefiero_no_decir,
          ),
          objetivoFitness: ObjetivoFitness.values.firstWhere(
            (o) => o.name == datos['objetivoFitness'],
            orElse: () => ObjetivoFitness.mantenimiento,
          ),
          nivelExperiencia: NivelExperiencia.values.firstWhere(
            (n) => n.name == datos['nivelExperiencia'],
            orElse: () => NivelExperiencia.principiante,
          ),
          alturaCm: datos['altura'],
          pesoActualKg: datos['peso'],
          pesoObjetivoKg: datos['pesoObjetivo'],
        );
  }
}
