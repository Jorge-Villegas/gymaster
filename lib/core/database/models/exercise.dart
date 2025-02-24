import 'dart:convert';

Exercise exerciseFromJson(String str) => Exercise.fromJson(json.decode(str));

String exerciseToJson(Exercise data) => json.encode(data.toJson());

class Exercise {
  final String id;
  final String name;
  final String? description;
  final String? imagePath;
  final String createdAt;
  final String? updatedAt;

  Exercise({
    required this.id,
    required this.name,
    this.description,
    this.imagePath,
    required this.createdAt,
    this.updatedAt,
  });

  Exercise copyWith({
    String? id,
    String? name,
    String? description,
    String? imagePath,
    String? createdAt,
    String? updatedAt,
  }) => Exercise(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    imagePath: imagePath ?? this.imagePath,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
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
