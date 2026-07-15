import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';
import 'package:gymaster/core/theme/gym_typography.dart';
import 'package:gymaster/features/routine/presentation/widgets/crear_rutina_form.dart';
import 'package:gymaster/shared/widgets/gym/gym.dart';

/// Página completa de crear rutina (respaldo del route `/rutina/create`).
/// El flujo principal es el bottom sheet [mostrarCrearRutinaSheet]; ambos
/// reutilizan el mismo [CrearRutinaForm].
class AgregarRutinaPage extends StatelessWidget {
  const AgregarRutinaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.gym;
    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
              child: Row(
                children: [
                  GymIconButton(
                    icon: IconsaxPlusLinear.arrow_left_1,
                    tooltip: 'Volver',
                    onTap: () => context.canPop()
                        ? context.pop()
                        : context.go('/main?tab=1'),
                  ),
                  const SizedBox(width: 12),
                  Text('Nueva rutina',
                      style: GymType.title.copyWith(color: c.ink)),
                ],
              ),
            ),
            const Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(12, 8, 12, 16),
                child: CrearRutinaForm(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
