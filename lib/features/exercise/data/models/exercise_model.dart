import 'package:gymaster/features/exercise/domain/entities/exercise.dart';
import 'package:gymaster/core/database/models/exercise.dart' as exercise_db;

class ExerciseModel extends Exercise {
  const ExerciseModel({
    required super.id,
    required super.name,
    required super.description,
    required super.imagePath,
    required super.targetMuscles,
    required super.equipment,
    required super.instructions,
    super.variations,
    super.metrics,
  });

  factory ExerciseModel.fromDatabase(
    exercise_db.Exercise exerciseDB,
    List<String> muscles,
  ) {
    return ExerciseModel(
      id: exerciseDB.id,
      name: exerciseDB.name,
      description: exerciseDB.description ?? '',
      imagePath: exerciseDB.imagePath ?? '',
      targetMuscles: muscles,
      equipment: '',
      instructions: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imagePath': imagePath,
      'targetMuscles': targetMuscles,
      'equipment': equipment,
      'instructions': instructions,
      'variations': variations,
      'metrics': metrics,
    };
  }

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imagePath: json['imagePath'],
      targetMuscles: List<String>.from(json['targetMuscles']),
      equipment: json['equipment'],
      instructions: json['instructions'],
      variations: json['variations'] != null
          ? List<String>.from(json['variations'])
          : [],
      metrics: json['metrics'] ?? {},
    );
  }
}
