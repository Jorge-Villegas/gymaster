import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';
import 'package:gymaster/core/theme/gym_typography.dart';
import 'package:gymaster/features/exercise/domain/entities/exercise.dart';
import 'package:gymaster/features/exercise/presentation/cubits/exercise/exercise_cubit.dart';
import 'package:gymaster/features/exercise/presentation/cubits/favorito_ejercicio_cubit.dart';
import 'package:gymaster/features/exercise/presentation/cubits/favorito_ejercicio_state.dart';
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
  late AnimationController _listAnimationController;
  String? _selectedMuscleId;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _listAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Cargar datos y animar entrada
    _loadInitialData();
  }

  @override
  void dispose() {
    _listAnimationController.dispose();
    super.dispose();
  }

  void _loadInitialData() async {
    context.read<MusculoCubit>().getAllMusculo();
    context.read<ExerciseCubit>().loadAllExercises();

    await Future.delayed(const Duration(milliseconds: 500));
    _listAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.gym.bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchField(context),
            _buildMuscleGroupFilter(context),
            _buildExerciseList(),
          ],
        ),
      ),
    );
  }

  /// Campo de búsqueda temático (única cabecera de esta pantalla: sin título
  /// ni botón de menú, para ganar espacio y foco en los ejercicios).
  Widget _buildSearchField(BuildContext context) {
    final c = context.gym;
    OutlineInputBorder borde(Color color, [double ancho = 1]) =>
        OutlineInputBorder(
          borderRadius: GymRadius.rMd,
          borderSide: BorderSide(color: color, width: ancho),
        );
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      child: TextField(
        onChanged: (query) {
          setState(() => _searchQuery = query);
          if (query.isNotEmpty) {
            context.read<ExerciseCubit>().buscarEjercicios(query);
          } else {
            context.read<ExerciseCubit>().loadAllExercises();
          }
        },
        style: GymType.body.copyWith(color: c.ink),
        decoration: InputDecoration(
          hintText: 'Buscar ejercicios...',
          hintStyle: GymType.body.copyWith(color: c.faint),
          prefixIcon:
              Icon(IconsaxPlusLinear.search_normal, color: c.muted, size: 20),
          filled: true,
          fillColor: c.surface,
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          enabledBorder: borde(c.line),
          border: borde(c.line),
          focusedBorder: borde(c.brand, 1.5),
        ),
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
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título del filtro (Proximidad)
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 12),
                    child: Text(
                      'Grupos Musculares',
                      style: GymType.section,
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

                            // Mantener búsqueda si está activa
                            if (_searchQuery.isNotEmpty) {
                              context
                                  .read<ExerciseCubit>()
                                  .buscarEjercicios(_searchQuery);
                            } else {
                              context.read<ExerciseCubit>().clearFilters();
                            }
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
                                  // Desactivar filtro de músculo
                                  if (_searchQuery.isNotEmpty) {
                                    // Mantener solo la búsqueda
                                    context
                                        .read<ExerciseCubit>()
                                        .buscarEjercicios(_searchQuery);
                                  } else {
                                    context
                                        .read<ExerciseCubit>()
                                        .clearFilters();
                                  }
                                } else {
                                  // Activar filtro de músculo
                                  if (_searchQuery.isNotEmpty) {
                                    // Combinar búsqueda + músculo
                                    context
                                        .read<ExerciseCubit>()
                                        .buscarEjerciciosEnMusculo(
                                          query: _searchQuery,
                                          muscleId: muscle.id,
                                        );
                                  } else {
                                    // Solo filtro de músculo
                                    context
                                        .read<ExerciseCubit>()
                                        .filterByMuscle(muscle.id);
                                  }
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
          color: isSelected
              ? (isSpecial ? context.gym.xpInk : context.gym.info)
              : context.gym.surface,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : isSpecial
                    ? context.gym.xpInk
                        .withValues(alpha: 0.4) // Dorado más sutil
                    : context.gym.info
                        .withValues(alpha: 0.3), // Azul más sutil
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: (isSpecial
                            ? context.gym.xpInk
                            : context.gym.info)
                        .withValues(alpha: 0.25), // Sombra más sutil
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
              style: GymType.body.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : isSpecial
                        ? context.gym.xpInk // Dorado cálido para "Todos"
                        : context.gym.info, // Azul profesional para músculos
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
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: 8,
                itemBuilder: (context, index) => FadeInUp(
                  duration: const Duration(milliseconds: 400),
                  delay: Duration(milliseconds: index * 100),
                  child: _buildShimmerCard(context),
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
                      color: context.gym.xpInk.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: GymType.section.copyWith(
                        fontWeight: FontWeight.w300,
                        color: context.gym.faint,
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
                        color: context.gym.info.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No se encontraron ejercicios',
                        style: GymType.section.copyWith(
                          fontWeight: FontWeight.w300,
                          color: context.gym.faint,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Intenta con otro grupo muscular',
                        style: GymType.bodyStrong.copyWith(
                          fontWeight: FontWeight.w300,
                          color: context.gym.faint,
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
              padding: const EdgeInsets.symmetric(horizontal: 12),
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

  Widget _buildShimmerCard(BuildContext context) {
    final c = context.gym;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Shimmer.fromColors(
        baseColor: c.surface2,
        highlightColor: c.surface,
        child: Container(
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: c.line),
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
    final c = context.gym;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.line),
        boxShadow: [
          BoxShadow(
            color: c.brand.withValues(alpha: 0.08),
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
                // Imagen del ejercicio con corazón de favorito superpuesto
                Hero(
                  tag: 'exercise-image-${exercise.id}',
                  child: Stack(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: context.gym.brand.withValues(alpha: 0.1),
                            width: 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: _buildExerciseImage(exercise.imagePath),
                        ),
                      ),
                      // Corazón de favorito sutil superpuesto
                      _buildOverlayFavoriteIndicator(exercise),
                    ],
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
                        style: GymType.bodyStrong.copyWith(
                          fontWeight: FontWeight.w400,
                          height: 1.1,
                          color: c.ink,
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
                              color: context.gym.info.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: context.gym.info.withValues(alpha: 0.3),
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              capitalizarPrimeraLetra(muscle),
                              style: GymType.bodyStrong.copyWith(
                                fontWeight: FontWeight.w300,
                                fontSize: 11,
                                color: context.gym.info,
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
                    color: context.gym.xpInk.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    IconsaxPlusLinear.arrow_right_3,
                    color: context.gym.xpInk,
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
          color: context.gym.info
              .withValues(alpha: 0.1), // Solo color de fondo, sin gradiente
        ),
        child: Icon(
          IconsaxPlusLinear.weight,
          color: context.gym.brand.withValues(alpha: 0.6),
          size: 28,
        ),
      );
    }

    if (VerificadorTipoArchivo.esSvg(imagePath)) {
      return Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(236, 238, 240, 1),
        ),
        child: SvgPicture.asset(
          imagePath,
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            context.gym.ink.withValues(alpha: 0.8),
            BlendMode.srcATop,
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(236, 238, 240, 1),
      ),
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            decoration: BoxDecoration(
              color: context.gym.xpInk.withValues(alpha: 0.1),
            ),
            child: Icon(
              IconsaxPlusLinear.danger,
              color: context.gym.xpInk.withValues(alpha: 0.6),
              size: 24,
            ),
          );
        },
      ),
    );
  }

  /// Indicador sutil de favorito superpuesto en la esquina inferior derecha
  Widget _buildOverlayFavoriteIndicator(Exercise exercise) {
    return BlocBuilder<FavoritoEjercicioCubit, FavoritoEjercicioState>(
      builder: (context, state) {
        final favoritosCubit = context.read<FavoritoEjercicioCubit>();
        final esFavorito = favoritosCubit.esEjercicioFavoritoSync(exercise.id);

        // Solo mostrar si es favorito
        if (!esFavorito) return const SizedBox.shrink();

        return Positioned(
          bottom: 4,
          right: 4,
          child: GestureDetector(
            onTap: () async {
              // Feedback háptico para mejor experiencia emocional
              await favoritosCubit.toggleFavorito(exercise.id);

              // Mostrar mensaje emocional de feedback
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '💔 ${exercise.name} removido de favoritos',
                      style: GymType.body.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: context.gym.xpInk,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red.shade600,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Icon(
                IconsaxPlusBold.heart,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        );
      },
    );
  }
}
