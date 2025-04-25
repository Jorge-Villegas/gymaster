import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gymaster/features/exercise/domain/entities/exercise.dart';
import 'package:gymaster/features/exercise/presentation/cubits/exercise/exercise_cubit.dart';
import 'package:gymaster/features/routine/presentation/cubits/musculo/musculo_cubit.dart';
import 'package:gymaster/shared/utils/verificador_tipo_archivo.dart';
import 'package:shimmer/shimmer.dart';

class ExerciseCatalogPage extends StatefulWidget {
  const ExerciseCatalogPage({super.key});

  @override
  State<ExerciseCatalogPage> createState() => _ExerciseCatalogPageState();
}

class _ExerciseCatalogPageState extends State<ExerciseCatalogPage> {
  @override
  void initState() {
    super.initState();
    // Cargar los músculos y ejercicios al iniciar la página
    context.read<MusculoCubit>().getAllMusculo();
    context.read<ExerciseCubit>().loadAllExercises();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo de Ejercicios')),
      body: Column(children: [_buildMuscleGroupFilter(), _buildExerciseList()]),
    );
  }

  Widget _buildMuscleGroupFilter() {
    return BlocBuilder<MusculoCubit, MusculoState>(
      builder: (context, state) {
        if (state is MusculoLoaded) {
          return SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.musculos.length,
              itemBuilder: (context, index) {
                final muscle = state.musculos[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: Text(muscle.nombre),
                    onSelected: (selected) {
                      if (selected) {
                        context.read<ExerciseCubit>().filterByMuscle(muscle.id);
                      } else {
                        context.read<ExerciseCubit>().clearFilters();
                      }
                    },
                    selected: context.watch<ExerciseCubit>().state
                            is ExerciseLoaded &&
                        (context.watch<ExerciseCubit>().state as ExerciseLoaded)
                                .activeFilter ==
                            muscle.id,
                  ),
                );
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildExerciseList() {
    return BlocBuilder<ExerciseCubit, ExerciseState>(
      builder: (context, state) {
        if (state is ExerciseLoading) {
          return Expanded(
            child: ListView.builder(
              itemCount: 8,
              itemBuilder: (_, __) => _buildShimmerCard(),
            ),
          );
        }

        if (state is ExerciseError) {
          return Center(child: Text(state.message));
        }

        if (state is ExerciseLoaded) {
          return Expanded(
            child: ListView.builder(
              itemCount: state.exercises.length,
              itemBuilder: (context, index) {
                return _buildExerciseCard(context, state.exercises[index]);
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Card(
          child: ListTile(
            leading: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            title: Container(
              width: double.infinity,
              height: 16,
              color: Colors.white,
            ),
            subtitle: Container(
              width: double.infinity,
              height: 12,
              margin: const EdgeInsets.only(top: 8),
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseCard(BuildContext context, Exercise exercise) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Hero(
          tag: 'exercise-image-${exercise.id}',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Material(
              type: MaterialType.transparency,
              child: SizedBox(
                width: 56,
                height: 56,
                child: _buildExerciseImage(exercise.imagePath),
              ),
            ),
          ),
        ),
        title: Text(exercise.name),
        subtitle: Text(
          exercise.targetMuscles.join(', '),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
          // No necesitamos llamar a selectExercise aquí
          context.push('/exercise-detail', extra: exercise);
        },
      ),
    );
  }

  Widget _buildExerciseImage(String imagePath) {
    if (imagePath.isEmpty) {
      return Container(
        color: Colors.grey[200],
        child: const Icon(
          Icons.fitness_center,
          color: Colors.grey,
          size: 28,
        ),
      );
    }

    if (VerificadorTipoArchivo.esSvg(imagePath)) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey[100]!,
              Colors.grey[200]!,
            ],
          ),
        ),
        child: SvgPicture.asset(
          imagePath,
          fit: BoxFit.cover,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey[100]!,
            Colors.grey[200]!,
          ],
        ),
      ),
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[200],
            child: Icon(Icons.error, color: Colors.grey[400]),
          );
        },
      ),
    );
  }
}
