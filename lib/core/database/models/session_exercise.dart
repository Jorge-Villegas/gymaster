import 'dart:convert';

SessionExercise sessionExerciseFromJson(String str) =>
    SessionExercise.fromJson(json.decode(str));

String sessionExerciseToJson(SessionExercise data) =>
    json.encode(data.toJson());

class SessionExercise {
  final String id;
  final String sessionId;
  final String exerciseId;
  final String status;
  final int orderIndex;

  SessionExercise({
    required this.id,
    required this.sessionId,
    required this.exerciseId,
    required this.status,
    required this.orderIndex,
  });

  SessionExercise copyWith({
    String? id,
    String? sessionId,
    String? exerciseId,
    String? status,
    int? orderIndex,
  }) => SessionExercise(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    exerciseId: exerciseId ?? this.exerciseId,
    status: status ?? this.status,
    orderIndex: orderIndex ?? this.orderIndex,
  );

  factory SessionExercise.fromJson(Map<String, dynamic> json) =>
      SessionExercise(
        id: json["id"],
        sessionId: json["session_id"],
        exerciseId: json["exercise_id"],
        status: json["status"],
        orderIndex: json["order_index"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "session_id": sessionId,
    "exercise_id": exerciseId,
    "status": status,
    "order_index": orderIndex,
  };
}
