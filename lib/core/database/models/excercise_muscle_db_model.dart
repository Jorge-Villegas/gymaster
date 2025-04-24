import 'dart:convert';

ExerciseMuscleDbModel exerciseMuscleFromJson(String str) =>
    ExerciseMuscleDbModel.fromJson(json.decode(str));

String exerciseMuscleToJson(ExerciseMuscleDbModel data) =>
    json.encode(data.toJson());

class ExerciseMuscleDbModel {
  // Nombres de las columnas de la tabla
  static const String table = 'exercise_muscle';
  static const String columnExerciseId = 'exercise_id';
  static const String columnMuscleId = 'muscle_id';

  final String exerciseId;
  final String muscleId;

  ExerciseMuscleDbModel({required this.exerciseId, required this.muscleId});

  ExerciseMuscleDbModel copyWith({String? exerciseId, String? muscleId}) =>
      ExerciseMuscleDbModel(
        exerciseId: exerciseId ?? this.exerciseId,
        muscleId: muscleId ?? this.muscleId,
      );

  factory ExerciseMuscleDbModel.fromJson(Map<String, dynamic> json) =>
      ExerciseMuscleDbModel(
        exerciseId: json["exercise_id"],
        muscleId: json["muscle_id"],
      );

  Map<String, dynamic> toJson() => {
        "exercise_id": exerciseId,
        "muscle_id": muscleId,
      };
}
