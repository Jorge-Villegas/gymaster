import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';
import 'package:gymaster/core/theme/gym_typography.dart';
import 'package:gymaster/features/setting/presentation/cubits/onboarding/onboarding_cubit.dart';
import 'package:gymaster/features/setting/data/models/user_motivation.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

/// Página 8 del onboarding: Preferencias de notificaciones
class OnboardingNotificacionesPage extends StatelessWidget {
  const OnboardingNotificacionesPage({super.key});

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
                  '🔔',
                  style: TextStyle(fontSize: 28),
                ),
                const SizedBox(height: 8),
                Text(
                  '¿Cómo te gusta que te motivemos?',
                  style: GymType.display,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Personaliza tus recordatorios para mantenerte motivado 🔔',
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
            child: Column(
              children: [
                Card(
                  color: context.gym.surface2,
                  child: ListTile(
                    leading: Icon(
                      IconsaxPlusLinear.notification,
                      color: context.gym.xpInk,
                    ),
                    title: Text(
                      'Recordatorios activados',
                      style: TextStyle(
                        color: context.gym.ink,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      'Te enviaremos motivación cuando la necesites',
                      style: TextStyle(
                        color: context.gym.muted,
                      ),
                    ),
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {
                        // TODO: Implementar toggle de notificaciones
                      },
                      activeThumbColor: context.gym.xpInk,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  color: context.gym.surface2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tono de motivación',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: context.gym.ink,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: MotivationTone.values.map((tone) {
                            return ChoiceChip(
                              label: Text(_getToneLabel(tone)),
                              selected: tone == MotivationTone.energetico,
                              onSelected: (selected) {
                                // TODO: Implementar selección de tono
                                if (selected) {
                                  final cubit = context.read<OnboardingCubit>();
                                  // Actualizar preferencias con el nuevo tono
                                  cubit.updateNotificationPreferences(
                                    NotificationPreferences(
                                      enabled: true,
                                      preferredHours: const [18, 19, 20],
                                      tone: tone,
                                      frequencyDays: 2,
                                    ),
                                  );
                                }
                              },
                              selectedColor: context.gym.xpInk,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              labelStyle: TextStyle(
                                color: tone == MotivationTone.energetico
                                    ? Colors.white
                                    : context.gym.ink,
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.gym.xpInk.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: context.gym.xpInk.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        IconsaxPlusBold.timer_1,
                        color: context.gym.xpInk,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Te enviaremos recordatorios en tus horarios preferidos para mantenerte motivado',
                          style: GymType.section.copyWith(
                            fontWeight: FontWeight.w300,
                            fontSize: 13,
                            color: context.gym.ink,
                          ),
                        ),
                      ),
                    ],
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
}
