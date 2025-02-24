import 'dart:convert';

ExerciseMuscle exerciseMuscleFromJson(String str) =>
    ExerciseMuscle.fromJson(json.decode(str));

String exerciseMuscleToJson(ExerciseMuscle data) => json.encode(data.toJson());

class ExerciseMuscle {
  final String exerciseId;
  final String muscleId;

  ExerciseMuscle({required this.exerciseId, required this.muscleId});

  ExerciseMuscle copyWith({String? exerciseId, String? muscleId}) =>
      ExerciseMuscle(
        exerciseId: exerciseId ?? this.exerciseId,
        muscleId: muscleId ?? this.muscleId,
      );

  factory ExerciseMuscle.fromJson(Map<String, dynamic> json) => ExerciseMuscle(
    exerciseId: json["exercise_id"],
    muscleId: json["muscle_id"],
  );

  Map<String, dynamic> toJson() => {
    "exercise_id": exerciseId,
    "muscle_id": muscleId,
  };
}
