import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/exercise/domain/entities/exercise.dart';
import 'package:gymaster/features/exercise/domain/usecases/obtener_todos_los_ejercicios_usecase.dart';
import 'package:gymaster/features/exercise/domain/usecases/obtener_ejercicios_por_musculo_usecase.dart';
import 'package:gymaster/features/exercise/domain/usecases/buscar_ejercicios_usecase.dart';

part 'exercise_state.dart';

class ExerciseCubit extends Cubit<ExerciseState> {
  final ObtenerTodosLosEjerciciosUseCase getAllExercisesUseCase;
  final ObtenerEjerciciosCatalogoPorMusculoUseCase getExercisesByMuscleUseCase;
  final BuscarEjerciciosUseCase buscarEjerciciosUseCase;

  ExerciseCubit({
    required this.getAllExercisesUseCase,
    required this.getExercisesByMuscleUseCase,
    required this.buscarEjerciciosUseCase,
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
      ObtenerEjerciciosCatalogoPorMusculoParams(muscleId: muscleId),
    );

    result.fold(
      (failure) {
        emit(ExerciseError(failure.errorMessage));
      },
      (exercises) {
        emit(
          ExerciseLoaded(
            exercises: exercises,
            isFiltered: true,
            activeFilter: muscleId,
          ),
        );
      },
    );
  }

  void clearFilters() {
    loadAllExercises();
  }

  /// Buscar ejercicios por nombre siguiendo principios de UX
  Future<void> buscarEjercicios(String query) async {
    // Si el query está vacío, mostrar todos los ejercicios
    if (query.trim().isEmpty) {
      loadAllExercises();
      return;
    }

    emit(ExerciseLoading());

    final result = await buscarEjerciciosUseCase(
      BuscarEjerciciosParams(query: query),
    );

    result.fold(
      (failure) {
        debugPrint('Error búsqueda: ${failure.errorMessage}');
        emit(ExerciseError(_getUserFriendlyMessage(failure)));
      },
      (exercises) {
        if (exercises.isEmpty) {
          emit(ExerciseError(
              'No encontramos ejercicios que coincidan con "$query".\n¡Intenta con otro término! 💪'));
        } else {
          emit(ExerciseLoaded(
            exercises: exercises,
            isFiltered: true,
            activeFilter: 'búsqueda: $query',
          ));
        }
      },
    );
  }

  /// Filtro combinado: búsqueda + músculo
  Future<void> buscarEjerciciosEnMusculo({
    required String query,
    required String muscleId,
  }) async {
    emit(ExerciseLoading());

    // Primero obtener ejercicios por músculo
    final muscleResult = await getExercisesByMuscleUseCase(
      ObtenerEjerciciosCatalogoPorMusculoParams(muscleId: muscleId),
    );

    muscleResult.fold(
      (failure) => emit(ExerciseError(failure.errorMessage)),
      (exercisesByMuscle) {
        // Filtrar localmente por nombre dentro de los ejercicios del músculo
        final filteredExercises = exercisesByMuscle
            .where((exercise) =>
                exercise.name.toLowerCase().contains(query.toLowerCase()) ||
                exercise.description
                    .toLowerCase()
                    .contains(query.toLowerCase()))
            .toList();

        if (filteredExercises.isEmpty) {
          emit(ExerciseError(
              'No hay ejercicios que coincidan con "$query" en este grupo muscular.\n¡Prueba con otro término! 🔍'));
        } else {
          emit(ExerciseLoaded(
            exercises: filteredExercises,
            isFiltered: true,
            activeFilter: 'búsqueda: $query + músculo',
          ));
        }
      },
    );
  }

  /// Convierte errores técnicos en mensajes amigables
  String _getUserFriendlyMessage(Failure failure) {
    switch (failure.runtimeType) {
      case CacheFailure:
        return 'Error de base de datos.\n¡Intenta de nuevo! 🔄';
      case NoRecordsFailure:
        return 'No encontramos ejercicios.\n¡Revisa tu búsqueda! 🔍';
      case ServerFailure:
        return 'Sin conexión.\n¡Verifica tu internet! 📶';
      default:
        return 'Algo salió mal.\n¡Inténtalo de nuevo! 💪';
    }
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
