import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/exercise/domain/entities/exercise.dart';
import 'package:gymaster/features/exercise/domain/usecases/get_all_exercises_usecase.dart';
import 'package:gymaster/features/exercise/domain/usecases/get_exercises_by_muscle_usecase.dart';

part 'exercise_state.dart';

class ExerciseCubit extends Cubit<ExerciseState> {
  final GetAllExercisesUseCase getAllExercisesUseCase;
  final GetExercisesByMuscleUseCase getExercisesByMuscleUseCase;

  ExerciseCubit({
    required this.getAllExercisesUseCase,
    required this.getExercisesByMuscleUseCase,
  }) : super(ExerciseInitial());

  Future<void> loadAllExercises() async {
    emit(ExerciseLoading());

    final result = await getAllExercisesUseCase(NoParams());

    result.fold(
      (failure) => emit(ExerciseError(failure.errorMessage)),
      (exercises) => emit(ExerciseLoaded(exercises: exercises)),
    );
  }

  Future<void> filterByMuscle(String muscleId) async {
    emit(ExerciseLoading());

    final result = await getExercisesByMuscleUseCase(
      GetExercisesByMuscleParams(muscleId: muscleId),
    );

    result.fold(
      (failure) => emit(ExerciseError(failure.errorMessage)),
      (exercises) => emit(
        ExerciseLoaded(
          exercises: exercises,
          isFiltered: true,
          activeFilter: muscleId,
        ),
      ),
    );
  }

  void clearFilters() {
    loadAllExercises();
  }

  // Eliminar o modificar este método para que no afecte el estado de la lista
  void selectExercise(Exercise exercise) {
    // Si realmente necesitas mantener el ejercicio seleccionado,
    // guárdalo en una variable pero no emitas un nuevo estado
    // O emite un estado que combine la lista y el ejercicio seleccionado
  }

  // Opcional: Agregar un método para mantener el estado de la lista
  void maintainExerciseList(List<Exercise> exercises, {String? activeFilter}) {
    emit(ExerciseLoaded(
      exercises: exercises,
      isFiltered: activeFilter != null,
      activeFilter: activeFilter,
    ));
  }
}
