import 'package:equatable/equatable.dart';

class Exercise extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imagePath;
  final List<String> targetMuscles;
  final String equipment;
  final String instructions;
  final List<String> variations;
  final Map<String, dynamic> metrics;

  const Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.targetMuscles,
    this.equipment = '',
    this.instructions = '',
    this.variations = const [],
    this.metrics = const {},
  });

  Exercise copyWith({
    String? id,
    String? name,
    String? description,
    String? imagePath,
    List<String>? targetMuscles,
    String? difficulty,
    String? equipment,
    String? instructions,
    List<String>? variations,
    Map<String, dynamic>? metrics,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      targetMuscles: targetMuscles ?? this.targetMuscles,
      equipment: equipment ?? this.equipment,
      instructions: instructions ?? this.instructions,
      variations: variations ?? this.variations,
      metrics: metrics ?? this.metrics,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        imagePath,
        targetMuscles,
        equipment,
        instructions,
        variations,
        metrics,
      ];
}
