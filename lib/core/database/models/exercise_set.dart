import 'dart:convert';

ExerciseSet exerciseSetFromJson(String str) =>
    ExerciseSet.fromJson(json.decode(str));

String exerciseSetToJson(ExerciseSet data) => json.encode(data.toJson());

class ExerciseSet {
  final String id;
  final String sessionExerciseId;
  final double? weight;
  final int? repetitions;
  final int? restTime;
  final String status;

  ExerciseSet({
    required this.id,
    required this.sessionExerciseId,
    this.weight,
    this.repetitions,
    this.restTime,
    required this.status,
  });

  ExerciseSet copyWith({
    String? id,
    String? sessionExerciseId,
    double? weight,
    int? repetitions,
    int? restTime,
    String? status,
  }) => ExerciseSet(
    id: id ?? this.id,
    sessionExerciseId: sessionExerciseId ?? this.sessionExerciseId,
    weight: weight ?? this.weight,
    repetitions: repetitions ?? this.repetitions,
    restTime: restTime ?? this.restTime,
    status: status ?? this.status,
  );

  factory ExerciseSet.fromJson(Map<String, dynamic> json) => ExerciseSet(
    id: json["id"],
    sessionExerciseId: json["session_exercise_id"],
    weight: json["weight"],
    repetitions: json["repetitions"],
    restTime: json["rest_time"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "session_exercise_id": sessionExerciseId,
    "weight": weight,
    "repetitions": repetitions,
    "rest_time": restTime,
    "status": status,
  };
}
