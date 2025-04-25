import 'dart:convert';

AuditLogDbModel auditLogFromJson(String str) =>
    AuditLogDbModel.fromJson(json.decode(str));

String auditLogToJson(AuditLogDbModel data) => json.encode(data.toJson());

class AuditLogDbModel {
  // Nombres de las columnas de la tabla
  static const String table = 'audit_log';
  static const String columnId = 'id';
  static const String columnUserId = 'user_id';
  static const String columnTableName = 'table_name';
  static const String columnRecordId = 'record_id';
  static const String columnAction = 'action';
  static const String columnTimestamp = 'timestamp';

  String? id;
  final String userId;
  final String tableName;
  final String recordId;
  final String action;
  final String timestamp;

  AuditLogDbModel({
    this.id,
    required this.userId,
    required this.tableName,
    required this.recordId,
    required this.action,
    required this.timestamp,
  });

  AuditLogDbModel copyWith({
    String? id,
    String? userId,
    String? tableName,
    String? recordId,
    String? action,
    String? timestamp,
  }) =>
      AuditLogDbModel(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        tableName: tableName ?? this.tableName,
        recordId: recordId ?? this.recordId,
        action: action ?? this.action,
        timestamp: timestamp ?? this.timestamp,
      );

  factory AuditLogDbModel.fromJson(Map<String, dynamic> json) =>
      AuditLogDbModel(
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
