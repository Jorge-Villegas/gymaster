import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gymaster/core/theme/app_colors.dart';
import 'package:gymaster/core/theme/emotional_text_styles.dart';
import 'package:gymaster/core/theme/tipografia_gymaster.dart';
import 'package:gymaster/features/exercise/domain/entities/exercise.dart';
import 'package:gymaster/features/exercise/presentation/cubits/exercise/exercise_cubit.dart';
import 'package:gymaster/features/exercise/presentation/cubits/favorito_ejercicio_cubit.dart';
import 'package:gymaster/features/exercise/presentation/cubits/favorito_ejercicio_state.dart';
import 'package:gymaster/features/routine/presentation/cubits/musculo/musculo_cubit.dart';
import 'package:gymaster/shared/utils/string_utils.dart';
import 'package:gymaster/shared/utils/verificador_tipo_archivo.dart';
import 'package:gymaster/shared/widgets/cabecera_reutilizable.dart';
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
      backgroundColor: AppColors.fondoPrincipal,
      body: SafeArea(
        child: Column(
          children: [
            CabeceraReutilizable(
              titulo: "Catálogo de Ejercicios",
              subtitulo: "Explora y descubre nuevos ejercicios",
              busqueda: ConfiguracionBusqueda.ejercicios(
                onBusqueda: (query) {
                  setState(() {
                    _searchQuery = query;
                  });
                  if (query.isNotEmpty) {
                    context.read<ExerciseCubit>().buscarEjercicios(query);
                  } else {
                    context.read<ExerciseCubit>().loadAllExercises();
                  }
                },
              ),
              botonIzquierdo: ConfiguracionBotonIzquierdo.menu(),
            ),
            _buildMuscleGroupFilter(context),
            _buildExerciseList(),
          ],
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
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título del filtro (Proximidad)
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 12),
                    child: Text(
                      'Grupos Musculares',
                      style: TextStyle(
                        fontWeight: TipografiaGyMaster.pesoSemiBold,
                        fontSize: TipografiaGyMaster.tamanoLg,
                        color: AppColors.primarioCalido,
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
          gradient: isSelected
              ? LinearGradient(
                  colors: isSpecial
                      ? [
                          AppColors.acentoCalido,
                          AppColors.acento
                        ] // Dorado cálido para "Todos"
                      : [
                          AppColors.secundario,
                          AppColors.secundarioClaro
                        ], // Azules suaves para músculos
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
                    ? AppColors.acentoCalido
                        .withValues(alpha: 0.4) // Dorado más sutil
                    : AppColors.secundario
                        .withValues(alpha: 0.3), // Azul más sutil
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: (isSpecial
                            ? AppColors.acentoCalido
                            : AppColors.secundario)
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
              style: EstilosTextoEmocional.amigable.copyWith(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : isSpecial
                        ? AppColors.acentoCalido // Dorado cálido para "Todos"
                        : AppColors
                            .secundario, // Azul profesional para músculos
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
                      color: AppColors.acento.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: EstilosTextoEmocional.amigable.copyWith(
                        color: AppColors.textoTerciario,
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
                        color: AppColors.secundarioClaro.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No se encontraron ejercicios',
                        style: EstilosTextoEmocional.amigable.copyWith(
                          color: AppColors.textoTerciario,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Intenta con otro grupo muscular',
                        style: EstilosTextoEmocional.recuperacion.copyWith(
                          color: AppColors.textoTerciario,
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
            color: AppColors.primario.withValues(alpha: 0.08),
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
                            color: AppColors.primario.withValues(alpha: 0.1),
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
                        style: TextStyle(
                          fontWeight: TipografiaGyMaster.pesoRegular,
                          fontSize: TipografiaGyMaster.tamanoMd,
                          height: 1.1,
                          color: AppColors.textoPrincipal,
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
                              color: AppColors.secundarioClaro
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.secundarioClaro
                                    .withValues(alpha: 0.3),
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              capitalizarPrimeraLetra(muscle),
                              style:
                                  EstilosTextoEmocional.recuperacion.copyWith(
                                fontSize: 11,
                                color: AppColors.secundarioClaro,
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
                    color: AppColors.acento.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    IconsaxPlusLinear.arrow_right_3,
                    color: AppColors.acento,
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
          color: AppColors.secundarioClaro
              .withValues(alpha: 0.1), // Solo color de fondo, sin gradiente
        ),
        child: Icon(
          IconsaxPlusLinear.weight,
          color: AppColors.primario.withValues(alpha: 0.6),
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
            AppColors.fondoPrincipalOscuro.withValues(alpha: 0.8),
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
              color: AppColors.acento.withValues(alpha: 0.1),
            ),
            child: Icon(
              IconsaxPlusLinear.danger,
              color: AppColors.acento.withValues(alpha: 0.6),
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
                      style: EstilosTextoEmocional.aliento.copyWith(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    backgroundColor: AppColors.acento,
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
