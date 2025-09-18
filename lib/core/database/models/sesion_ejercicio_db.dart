import 'dart:convert';

SessionEjercicioDb sessionExerciseFromJson(String str) =>
    SessionEjercicioDb.fromJson(json.decode(str));

String sessionExerciseToJson(SessionEjercicioDb data) =>
    json.encode(data.toJson());

class SessionEjercicioDb {
  // Nombres de las columnas de la tabla
  static const String tabla = 'session_exercise';
  static const String columnId = 'id';
  static const String columnSessionId = 'session_id';
  static const String columnExerciseId = 'exercise_id';
  static const String columnStatus = 'status';
  static const String columnOrderIndex = 'order_index';

  final String id;
  final String sessionId;
  final String exerciseId;
  final String status;
  final int orderIndex;

  SessionEjercicioDb({
    required this.id,
    required this.sessionId,
    required this.exerciseId,
    required this.status,
    required this.orderIndex,
  });

  SessionEjercicioDb copyWith({
    String? id,
    String? sessionId,
    String? exerciseId,
    String? status,
    int? orderIndex,
  }) =>
      SessionEjercicioDb(
        id: id ?? this.id,
        sessionId: sessionId ?? this.sessionId,
        exerciseId: exerciseId ?? this.exerciseId,
        status: status ?? this.status,
        orderIndex: orderIndex ?? this.orderIndex,
      );

  factory SessionEjercicioDb.fromJson(Map<String, dynamic> json) =>
      SessionEjercicioDb(
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
