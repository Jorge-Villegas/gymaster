import 'dart:convert';

Muscle muscleFromJson(String str) => Muscle.fromJson(json.decode(str));

String muscleToJson(Muscle data) => json.encode(data.toJson());

class Muscle {
  final String id;
  final String name;
  final String? imagePath;
  final String createdAt;

  Muscle({
    required this.id,
    required this.name,
    this.imagePath,
    required this.createdAt,
  });

  Muscle copyWith({
    String? id,
    String? name,
    String? imagePath,
    String? createdAt,
  }) => Muscle(
    id: id ?? this.id,
    name: name ?? this.name,
    imagePath: imagePath ?? this.imagePath,
    createdAt: createdAt ?? this.createdAt,
  );

  factory Muscle.fromJson(Map<String, dynamic> json) => Muscle(
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
