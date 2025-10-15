import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymaster/core/theme/app_colors.dart';
import 'package:gymaster/core/theme/emotional_text_styles.dart';
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
                  '🔔',
                  style: TextStyle(fontSize: 28),
                ),
                const SizedBox(height: 8),
                Text(
                  '¿Cómo te gusta que te motivemos?',
                  style: EstilosTextoEmocional.motivacional,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Personaliza tus recordatorios para mantenerte motivado 🔔',
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
            child: Column(
              children: [
                Card(
                  color: AppColors.fondoSecundario,
                  child: ListTile(
                    leading: const Icon(
                      IconsaxPlusLinear.notification,
                      color: AppColors.acento,
                    ),
                    title: const Text(
                      'Recordatorios activados',
                      style: TextStyle(
                        color: AppColors.textoPrincipal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      'Te enviaremos motivación cuando la necesites',
                      style: TextStyle(
                        color: AppColors.textoSecundario,
                      ),
                    ),
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {
                        // TODO: Implementar toggle de notificaciones
                      },
                      activeThumbColor: AppColors.acento,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  color: AppColors.fondoSecundario,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tono de motivación',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.textoPrincipal,
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
                              selectedColor: AppColors.acento,
                              backgroundColor: AppColors.fondoPrincipal,
                              labelStyle: TextStyle(
                                color: tone == MotivationTone.energetico
                                    ? Colors.white
                                    : AppColors.textoPrincipal,
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
                    color: AppColors.acento.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.acento.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        IconsaxPlusBold.timer_1,
                        color: AppColors.acento,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Te enviaremos recordatorios en tus horarios preferidos para mantenerte motivado',
                          style: EstilosTextoEmocional.amigable.copyWith(
                            fontSize: 13,
                            color: AppColors.textoPrincipal,
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
