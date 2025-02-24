import 'dart:convert';

Routine routineFromJson(String str) => Routine.fromJson(json.decode(str));

String routineToJson(Routine data) => json.encode(data.toJson());

class Routine {
  final String id;
  final String userId;
  final String name;
  final String? description;
  final int? color;
  final String? imagePath;
  final String createdAt;
  final String? updatedAt;

  Routine({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    this.color,
    this.imagePath,
    required this.createdAt,
    this.updatedAt,
  });

  Routine copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    int? color,
    String? imagePath,
    String? createdAt,
    String? updatedAt,
  }) => Routine(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    name: name ?? this.name,
    description: description ?? this.description,
    color: color ?? this.color,
    imagePath: imagePath ?? this.imagePath,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  factory Routine.fromJson(Map<String, dynamic> json) => Routine(
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
