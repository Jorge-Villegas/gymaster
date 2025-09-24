import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gymaster/core/theme/app_colors.dart';
import 'package:gymaster/core/theme/emotional_text_styles.dart';
import 'package:gymaster/features/exercise/domain/entities/exercise.dart';
import 'package:gymaster/features/exercise/presentation/cubits/exercise/exercise_cubit.dart';
import 'package:gymaster/features/routine/presentation/cubits/musculo/musculo_cubit.dart';
import 'package:gymaster/shared/utils/string_utils.dart';
import 'package:gymaster/shared/utils/verificador_tipo_archivo.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:shimmer/shimmer.dart';

class ExerciseCatalogPage extends StatefulWidget {
  const ExerciseCatalogPage({super.key});

  @override
  State<ExerciseCatalogPage> createState() => _ExerciseCatalogPageState();
}

class _ExerciseCatalogPageState extends State<ExerciseCatalogPage>
    with TickerProviderStateMixin {
  late AnimationController _headerAnimationController;
  late AnimationController _listAnimationController;
  String? _selectedMuscleId;

  @override
  void initState() {
    super.initState();
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _listAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Cargar datos y animar entrada
    _loadInitialData();
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _listAnimationController.dispose();
    super.dispose();
  }

  void _loadInitialData() async {
    context.read<MusculoCubit>().getAllMusculo();
    context.read<ExerciseCubit>().loadAllExercises();

    await Future.delayed(const Duration(milliseconds: 200));
    _headerAnimationController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _listAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.backgroundLight,
              Colors.white,
              AppColors.backgroundLight.withValues(alpha: 0.8),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildEmotionalHeader(context),
              _buildSearchAndStats(context),
              _buildMuscleGroupFilter(context),
              _buildExerciseList(),
            ],
          ),
        ),
      ),
    );
  }

  /// Header emocional siguiendo principio de Proximidad y Von Restorff
  Widget _buildEmotionalHeader(BuildContext context) {
    return FadeInDown(
      duration: const Duration(milliseconds: 800),
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withValues(alpha: 0.1),
              AppColors.energyOrange.withValues(alpha: 0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Icono destacado (Von Restorff)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.energyOrange,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.energyOrange.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    IconsaxPlusLinear.weight,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                // Agrupación de texto (Proximidad)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Catálogo de Ejercicios',
                        style: EmotionalTextStyles.motivational.copyWith(
                          fontSize: 22,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Descubre tu próximo desafío',
                        style: EmotionalTextStyles.recovery.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Barra de estadísticas rápidas siguiendo Ley de Miller (7±2)
  Widget _buildSearchAndStats(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      delay: const Duration(milliseconds: 200),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: BlocBuilder<ExerciseCubit, ExerciseState>(
          builder: (context, state) {
            int totalExercises = 0;
            int filteredCount = 0;

            if (state is ExerciseLoaded) {
              totalExercises = state.exercises.length;
              filteredCount = state.exercises.length;
            }

            return Row(
              children: [
                // Estadística principal (Miller - información clave)
                Expanded(
                  child: _buildStatCard(
                    icon: IconsaxPlusLinear.activity,
                    title: 'Total',
                    value: '$totalExercises',
                    color: AppColors.calmBlue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: IconsaxPlusLinear.filter,
                    title: 'Mostrando',
                    value: '$filteredCount',
                    color: AppColors.successGreen,
                  ),
                ),
                const SizedBox(width: 12),
                // Botón de búsqueda destacado (Von Restorff)
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {
                      // TODO: Implementar búsqueda
                    },
                    icon: const Icon(
                      IconsaxPlusLinear.search_normal,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: EmotionalTextStyles.energetic.copyWith(
              fontSize: 16,
              color: color,
            ),
          ),
          Text(
            title,
            style: EmotionalTextStyles.recovery.copyWith(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMuscleGroupFilter(BuildContext context) {
    return BlocBuilder<MusculoCubit, MusculoState>(
      builder: (context, state) {
        if (state is MusculoLoaded) {
          // Principio de Pareto: mostrar los músculos más importantes primero
          return FadeInLeft(
            duration: const Duration(milliseconds: 600),
            delay: const Duration(milliseconds: 400),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título del filtro (Proximidad)
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 12),
                    child: Text(
                      'Grupos Musculares',
                      style: EmotionalTextStyles.energetic.copyWith(
                        fontSize: 16,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  // Botón "Todos" destacado (Von Restorff + Posición Serial)
                  SizedBox(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        const SizedBox(width: 4),
                        // Botón "Todos" en posición privilegiada (Posición Serial)
                        _buildMuscleFilterChip(
                          label: 'Todos',
                          isSelected: _selectedMuscleId == null,
                          isSpecial: true, // Von Restorff
                          onSelected: () {
                            setState(() {
                              _selectedMuscleId = null;
                            });
                            context.read<ExerciseCubit>().clearFilters();
                          },
                        ),
                        const SizedBox(width: 8),
                        // Músculos en orden de importancia (Pareto)
                        ...state.musculos.map((muscle) {
                          final isSelected = _selectedMuscleId == muscle.id;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _buildMuscleFilterChip(
                              label: capitalizarPrimeraLetra(muscle.nombre),
                              isSelected: isSelected,
                              onSelected: () {
                                setState(() {
                                  _selectedMuscleId =
                                      isSelected ? null : muscle.id;
                                });
                                if (isSelected) {
                                  context.read<ExerciseCubit>().clearFilters();
                                } else {
                                  context
                                      .read<ExerciseCubit>()
                                      .filterByMuscle(muscle.id);
                                }
                              },
                            ),
                          );
                        }),
                        const SizedBox(width: 12),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  /// Chip de filtro siguiendo Ley de Fitts (área táctil grande)
  Widget _buildMuscleFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onSelected,
    bool isSpecial = false,
  }) {
    return GestureDetector(
      onTap: onSelected,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: isSpecial
                      ? [AppColors.energyOrange, AppColors.motivationRed]
                      : [AppColors.primary, AppColors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : isSpecial
                    ? AppColors.energyOrange.withValues(alpha: 0.3)
                    : AppColors.primary.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color:
                        (isSpecial ? AppColors.energyOrange : AppColors.primary)
                            .withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              Icon(
                isSpecial
                    ? IconsaxPlusLinear.star_1
                    : IconsaxPlusLinear.tick_circle,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              capitalizarPrimeraLetra(label),
              style: EmotionalTextStyles.friendly.copyWith(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : isSpecial
                        ? AppColors.energyOrange
                        : AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseList() {
    return BlocBuilder<ExerciseCubit, ExerciseState>(
      builder: (context, state) {
        if (state is ExerciseLoading) {
          return Expanded(
            child: FadeIn(
              duration: const Duration(milliseconds: 400),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 8,
                itemBuilder: (context, index) => FadeInUp(
                  duration: const Duration(milliseconds: 400),
                  delay: Duration(milliseconds: index * 100),
                  child: _buildShimmerCard(),
                ),
              ),
            ),
          );
        }

        if (state is ExerciseError) {
          return Expanded(
            child: FadeIn(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      IconsaxPlusLinear.warning_2,
                      size: 64,
                      color: AppColors.motivationRed.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: EmotionalTextStyles.friendly.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (state is ExerciseLoaded) {
          if (state.exercises.isEmpty) {
            return Expanded(
              child: FadeIn(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        IconsaxPlusLinear.search_normal,
                        size: 64,
                        color: AppColors.calmBlue.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No se encontraron ejercicios',
                        style: EmotionalTextStyles.friendly.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Intenta con otro grupo muscular',
                        style: EmotionalTextStyles.recovery.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: state.exercises.length,
              itemBuilder: (context, index) {
                return FadeInUp(
                  duration: const Duration(milliseconds: 400),
                  delay: Duration(milliseconds: (index * 50).clamp(0, 800)),
                  child: _buildExerciseCard(context, state.exercises[index]),
                );
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildShimmerCard() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 18,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 120,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Tarjeta de ejercicio mejorada siguiendo Ley de Fitts y Proximidad
  Widget _buildExerciseCard(BuildContext context, Exercise exercise) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Feedback háptico para mejor experiencia
            context.push('/exercise-detail', extra: exercise);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Imagen del ejercicio (Proximidad)
                Hero(
                  tag: 'exercise-image-${exercise.id}',
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: _buildExerciseImage(exercise.imagePath),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Información del ejercicio (Proximidad + Miller)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        capitalizarPrimeraLetra(exercise.name),
                        style: EmotionalTextStyles.energetic.copyWith(
                          fontSize: 16,
                          color: AppColors.primary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      // Músculos objetivo con chips
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: exercise.targetMuscles.take(3).map((muscle) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.calmBlue.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color:
                                    AppColors.calmBlue.withValues(alpha: 0.3),
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              muscle,
                              style: EmotionalTextStyles.recovery.copyWith(
                                fontSize: 11,
                                color: AppColors.calmBlue,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Indicador de acción (Von Restorff)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.energyOrange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    IconsaxPlusLinear.arrow_right_3,
                    color: AppColors.energyOrange,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseImage(String imagePath) {
    if (imagePath.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.calmBlue.withValues(alpha: 0.1),
              AppColors.primary.withValues(alpha: 0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Icon(
          IconsaxPlusLinear.weight,
          color: AppColors.primary.withValues(alpha: 0.6),
          size: 28,
        ),
      );
    }

    if (VerificadorTipoArchivo.esSvg(imagePath)) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withValues(alpha: 0.05),
              AppColors.energyOrange.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: SvgPicture.asset(
          imagePath,
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            AppColors.primary.withValues(alpha: 0.8),
            BlendMode.srcATop,
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.05),
            AppColors.energyOrange.withValues(alpha: 0.05),
          ],
        ),
      ),
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.motivationRed.withValues(alpha: 0.1),
                  AppColors.energyOrange.withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Icon(
              IconsaxPlusLinear.danger,
              color: AppColors.motivationRed.withValues(alpha: 0.6),
              size: 24,
            ),
          );
        },
      ),
    );
  }
}
