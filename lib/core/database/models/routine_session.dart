import 'dart:convert';

RoutineSession routineSessionFromJson(String str) =>
    RoutineSession.fromJson(json.decode(str));

String routineSessionToJson(RoutineSession data) => json.encode(data.toJson());

class RoutineSession {
  final String id;
  final String routineId;
  final String? startTime;
  final String? endTime;
  final String status;
  final String createdAt;

  RoutineSession({
    required this.id,
    required this.routineId,
    this.startTime,
    this.endTime,
    required this.status,
    required this.createdAt,
  });

  RoutineSession copyWith({
    String? id,
    String? routineId,
    String? startTime,
    String? endTime,
    String? status,
    String? createdAt,
  }) => RoutineSession(
    id: id ?? this.id,
    routineId: routineId ?? this.routineId,
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
  );

  factory RoutineSession.fromJson(Map<String, dynamic> json) => RoutineSession(
    id: json["id"],
    routineId: json["routine_id"],
    startTime: json["start_time"],
    endTime: json["end_time"],
    status: json["status"],
    createdAt: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "routine_id": routineId,
    "start_time": startTime,
    "end_time": endTime,
    "status": status,
    "created_at": createdAt,
  };
}
