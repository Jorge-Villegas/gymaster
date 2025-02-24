import 'dart:convert';

AuditLog auditLogFromJson(String str) => AuditLog.fromJson(json.decode(str));

String auditLogToJson(AuditLog data) => json.encode(data.toJson());

class AuditLog {
  String? id;
  final String userId;
  final String tableName;
  final String recordId;
  final String action;
  final String timestamp;

  AuditLog({
    this.id,
    required this.userId,
    required this.tableName,
    required this.recordId,
    required this.action,
    required this.timestamp,
  });

  AuditLog copyWith({
    String? id,
    String? userId,
    String? tableName,
    String? recordId,
    String? action,
    String? timestamp,
  }) => AuditLog(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    tableName: tableName ?? this.tableName,
    recordId: recordId ?? this.recordId,
    action: action ?? this.action,
    timestamp: timestamp ?? this.timestamp,
  );

  factory AuditLog.fromJson(Map<String, dynamic> json) => AuditLog(
    id: json["id"],
    userId: json["user_id"],
    tableName: json["table_name"],
    recordId: json["record_id"],
    action: json["action"],
    timestamp: json["timestamp"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "table_name": tableName,
    "record_id": recordId,
    "action": action,
    "timestamp": timestamp,
  };
}
