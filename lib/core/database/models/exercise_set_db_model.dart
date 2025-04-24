import 'dart:convert';

ExerciseSetDbModel exerciseSetFromJson(String str) =>
    ExerciseSetDbModel.fromJson(json.decode(str));

String exerciseSetToJson(ExerciseSetDbModel data) => json.encode(data.toJson());

class ExerciseSetDbModel {
  // Nombres de las columnas de la tabla
  static const String table = 'exercise_set';
  static const String columnId = 'id';
  static const String columnSessionExerciseId = 'session_exercise_id';
  static const String columnWeight = 'weight';
  static const String columnRepetitions = 'repetitions';
  static const String columnRestTime = 'rest_time';
  static const String columnStatus = 'status';

  final String id;
  final String sessionExerciseId;
  final double? weight;
  final int? repetitions;
  final int? restTime;
  final String status;

  ExerciseSetDbModel({
    required this.id,
    required this.sessionExerciseId,
    this.weight,
    this.repetitions,
    this.restTime,
    required this.status,
  });

  ExerciseSetDbModel copyWith({
    String? id,
    String? sessionExerciseId,
    double? weight,
    int? repetitions,
    int? restTime,
    String? status,
  }) =>
      ExerciseSetDbModel(
        id: id ?? this.id,
        sessionExerciseId: sessionExerciseId ?? this.sessionExerciseId,
        weight: weight ?? this.weight,
        repetitions: repetitions ?? this.repetitions,
        restTime: restTime ?? this.restTime,
        status: status ?? this.status,
      );

  factory ExerciseSetDbModel.fromJson(Map<String, dynamic> json) =>
      ExerciseSetDbModel(
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
