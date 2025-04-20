part of 'exercise_cubit.dart';

sealed class ExerciseState extends Equatable {
  const ExerciseState();

  @override
  List<Object> get props => [];
}

final class ExerciseInitial extends ExerciseState {}

final class ExerciseLoading extends ExerciseState {}

final class ExerciseError extends ExerciseState {
  final String message;

  const ExerciseError(this.message);

  @override
  List<Object> get props => [message];
}

final class ExerciseLoaded extends ExerciseState {
  final List<Exercise> exercises;
  final bool isFiltered;
  final String? activeFilter;

  const ExerciseLoaded({
    required this.exercises,
    this.isFiltered = false,
    this.activeFilter,
  });

  @override
  List<Object> get props => [exercises, isFiltered];
}

final class ExerciseDetailLoaded extends ExerciseState {
  final Exercise exercise;

  const ExerciseDetailLoaded(this.exercise);

  @override
  List<Object> get props => [exercise];
}
