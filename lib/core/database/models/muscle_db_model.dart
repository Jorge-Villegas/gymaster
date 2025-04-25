import 'dart:convert';

MuscleDbModel muscleFromJson(String str) =>
    MuscleDbModel.fromJson(json.decode(str));

String muscleToJson(MuscleDbModel data) => json.encode(data.toJson());

class MuscleDbModel {
  // Nombres de las columnas de la tabla
  static const String table = 'muscle';
  static const String columnId = 'id';
  static const String columnName = 'name';
  static const String columnImagePath = 'image_path';
  static const String columnCreatedAt = 'created_at';

  final String id;
  final String name;
  final String? imagePath;
  final String createdAt;

  MuscleDbModel({
    required this.id,
    required this.name,
    this.imagePath,
    required this.createdAt,
  });

  MuscleDbModel copyWith({
    String? id,
    String? name,
    String? imagePath,
    String? createdAt,
  }) =>
      MuscleDbModel(
        id: id ?? this.id,
        name: name ?? this.name,
        imagePath: imagePath ?? this.imagePath,
        createdAt: createdAt ?? this.createdAt,
      );

  factory MuscleDbModel.fromJson(Map<String, dynamic> json) => MuscleDbModel(
        id: json["id"],
        name: json["name"],
        imagePath: json["image_path"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image_path": imagePath,
        "created_at": createdAt,
      };
}
