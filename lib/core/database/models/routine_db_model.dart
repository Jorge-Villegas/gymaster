import 'dart:convert';

RoutineDbModel routineFromJson(String str) =>
    RoutineDbModel.fromJson(json.decode(str));

String routineToJson(RoutineDbModel data) => json.encode(data.toJson());

class RoutineDbModel {
  // Nombres de las columnas de la tabla
  static const String table = 'routine';
  static const String columnId = 'id';
  static const String columnUserId = 'user_id';
  static const String columnName = 'name';
  static const String columnDescription = 'description';
  static const String columnColor = 'color';
  static const String columnImagePath = 'image_path';
  static const String columnCreatedAt = 'created_at';
  static const String columnUpdatedAt = 'updated_at';

  final String id;
  final String userId;
  final String name;
  final String? description;
  final int? color;
  final String? imagePath;
  final String createdAt;
  final String? updatedAt;

  RoutineDbModel({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    this.color,
    this.imagePath,
    required this.createdAt,
    this.updatedAt,
  });

  RoutineDbModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    int? color,
    String? imagePath,
    String? createdAt,
    String? updatedAt,
  }) =>
      RoutineDbModel(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        name: name ?? this.name,
        description: description ?? this.description,
        color: color ?? this.color,
        imagePath: imagePath ?? this.imagePath,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory RoutineDbModel.fromJson(Map<String, dynamic> json) => RoutineDbModel(
        id: json["id"],
        userId: json["user_id"],
        name: json["name"],
        description: json["description"],
        color: json["color"],
        imagePath: json["image_path"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "name": name,
        "description": description,
        "color": color,
        "image_path": imagePath,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
