import 'dart:convert';

RoutineSessionDbModel routineSessionFromJson(String str) =>
    RoutineSessionDbModel.fromJson(json.decode(str));

String routineSessionToJson(RoutineSessionDbModel data) =>
    json.encode(data.toJson());

class RoutineSessionDbModel {
  // Nombres de las columnas de la tabla
  static const String table = 'routine_session';
  static const String columnId = 'id';
  static const String columnRoutineId = 'routine_id';
  static const String columnStartTime = 'start_time';
  static const String columnEndTime = 'end_time';
  static const String columnStatus = 'status';
  static const String columnCreatedAt = 'created_at';

  final String id;
  final String routineId;
  final String? startTime;
  final String? endTime;
  final String status;
  final String createdAt;

  RoutineSessionDbModel({
    required this.id,
    required this.routineId,
    this.startTime,
    this.endTime,
    required this.status,
    required this.createdAt,
  });

  // como saco el tiempo que tomo realizar esta routina_session
  double get duration {
    final start = DateTime.parse(startTime!);
    final end = DateTime.parse(endTime!);
    return end.difference(start).inMinutes.toDouble();
  }

  RoutineSessionDbModel copyWith({
    String? id,
    String? routineId,
    String? startTime,
    String? endTime,
    String? status,
    String? createdAt,
  }) =>
      RoutineSessionDbModel(
        id: id ?? this.id,
        routineId: routineId ?? this.routineId,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
      );

  factory RoutineSessionDbModel.fromJson(Map<String, dynamic> json) =>
      RoutineSessionDbModel(
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
