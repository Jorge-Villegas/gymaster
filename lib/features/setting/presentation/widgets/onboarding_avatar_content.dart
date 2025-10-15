import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymaster/core/generated/assets.gen.dart';
import 'package:gymaster/core/theme/app_colors.dart';
import 'package:gymaster/core/theme/espaciado.dart';
import 'package:gymaster/features/setting/presentation/cubits/onboarding/onboarding_cubit.dart';

class OnboardingAvatarContent extends StatefulWidget {
  const OnboardingAvatarContent({super.key});

  @override
  State<OnboardingAvatarContent> createState() =>
      _OnboardingAvatarContentState();
}

class _OnboardingAvatarContentState extends State<OnboardingAvatarContent> {
  String? _avatarSeleccionado;

  final List<Map<String, String>> avatares = [
    {
      'id': 'perfil_1',
      'image': Assets.imagenes.perfilAvatar.perfil1.path,
      'name': 'Atlético'
    },
    {
      'id': 'perfil_2',
      'image': Assets.imagenes.perfilAvatar.perfil2.path,
      'name': 'Enérgico'
    },
    {
      'id': 'perfil_3',
      'image': Assets.imagenes.perfilAvatar.perfil3.path,
      'name': 'Fuerte'
    },
    {
      'id': 'perfil_4',
      'image': Assets.imagenes.perfilAvatar.perfil4.path,
      'name': 'Dinámico'
    },
    {
      'id': 'perfil_5',
      'image': Assets.imagenes.perfilAvatar.perfil5.path,
      'name': 'Activo'
    },
    {
      'id': 'perfil_6',
      'image': Assets.imagenes.perfilAvatar.perfil6.path,
      'name': 'Poderoso'
    },
    {
      'id': 'perfil_7',
      'image': Assets.imagenes.perfilAvatar.perfil7.path,
      'name': 'Valiente'
    },
    {
      'id': 'perfil_8',
      'image': Assets.imagenes.perfilAvatar.perfil8.path,
      'name': 'Resistente'
    },
    {
      'id': 'perfil_9',
      'image': Assets.imagenes.perfilAvatar.perfil9.path,
      'name': 'Determinado'
    },
    {
      'id': 'perfil_10',
      'image': Assets.imagenes.perfilAvatar.perfil10.path,
      'name': 'Luchador'
    },
    {
      'id': 'perfil_11',
      'image': Assets.imagenes.perfilAvatar.perfil11.path,
      'name': 'Decidido'
    },
    {
      'id': 'perfil_12',
      'image': Assets.imagenes.perfilAvatar.perfil12.path,
      'name': 'Campeón'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Espaciado.lg),
      child: Column(
        children: [
          const SizedBox(height: Espaciado.md),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: Espaciado.md,
                mainAxisSpacing: Espaciado.md,
                childAspectRatio: 0.8,
              ),
              itemCount: avatares.length,
              itemBuilder: (context, index) {
                final avatar = avatares[index];
                final isSelected = _avatarSeleccionado == avatar['id'];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _avatarSeleccionado = avatar['id'];
                    });
                    context
                        .read<OnboardingCubit>()
                        .updateAvatarSeleccionado(avatar['id']!);
                  },
                  child: TweenAnimationBuilder<double>(
                    duration: Duration(milliseconds: 300 + (index * 50)),
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    curve: Curves.easeOutBack,
                    builder: (context, animationValue, child) {
                      return Transform.scale(
                        scale: animationValue,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primario
                                  : Colors.transparent,
                              width: isSelected ? 5 : 0,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppColors.primario
                                          .withValues(alpha: 0.4),
                                      blurRadius: 16,
                                      offset: const Offset(0, 6),
                                    ),
                                    BoxShadow(
                                      color: AppColors.acento
                                          .withValues(alpha: 0.2),
                                      blurRadius: 20,
                                      offset: const Offset(3, 3),
                                    ),
                                  ]
                                : [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.1),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: AssetImage(avatar['image']!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: Espaciado.xs),
                              Text(
                                avatar['name']!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: isSelected
                                          ? AppColors.primario
                                          : AppColors.textoSecundario,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
