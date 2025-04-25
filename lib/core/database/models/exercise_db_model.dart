import 'dart:convert';

ExerciseDbModel exerciseFromJson(String str) =>
    ExerciseDbModel.fromJson(json.decode(str));

String exerciseToJson(ExerciseDbModel data) => json.encode(data.toJson());

class ExerciseDbModel {
  // Nombres de las columnas de la tabla
  static const String table = 'exercise';
  static const String columnId = 'id';
  static const String columnName = 'name';
  static const String columnDescription = 'description';
  static const String columnImagePath = 'image_path';
  static const String columnCreatedAt = 'created_at';
  static const String columnUpdatedAt = 'updated_at';

  final String id;
  final String name;
  final String? description;
  final String? imagePath;
  final String createdAt;
  final String? updatedAt;

  ExerciseDbModel({
    required this.id,
    required this.name,
    this.description,
    this.imagePath,
    required this.createdAt,
    this.updatedAt,
  });

  ExerciseDbModel copyWith({
    String? id,
    String? name,
    String? description,
    String? imagePath,
    String? createdAt,
    String? updatedAt,
  }) =>
      ExerciseDbModel(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        imagePath: imagePath ?? this.imagePath,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory ExerciseDbModel.fromJson(Map<String, dynamic> json) =>
      ExerciseDbModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        imagePath: json["image_path"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "image_path": imagePath,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
