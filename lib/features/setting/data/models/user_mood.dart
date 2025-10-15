import 'package:flutter/material.dart';

/// Entidad UserMood para el sistema emocional de GyMaster
class UserMood {
  final String userId;
  final MoodType mood;
  final int intensity; // 1-10, qué tan intenso es el estado
  final DateTime timestamp;
  final String? notes; // Comentarios opcionales del usuario

  const UserMood({
    required this.userId,
    required this.mood,
    required this.intensity,
    required this.timestamp,
    this.notes,
  });

  UserMood copyWith({
    String? userId,
    MoodType? mood,
    int? intensity,
    DateTime? timestamp,
    String? notes,
  }) =>
      UserMood(
        userId: userId ?? this.userId,
        mood: mood ?? this.mood,
        intensity: intensity ?? this.intensity,
        timestamp: timestamp ?? this.timestamp,
        notes: notes ?? this.notes,
      );

  factory UserMood.fromJson(Map<String, dynamic> json) => UserMood(
        userId: json["userId"],
        mood: MoodType.values.firstWhere((e) => e.name == json["mood"]),
        intensity: json["intensity"],
        timestamp: DateTime.parse(json["timestamp"]),
        notes: json["notes"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "mood": mood.name,
        "intensity": intensity,
        "timestamp": timestamp.toIso8601String(),
        "notes": notes,
      };
}

/// Tipos de estado anímico disponibles
enum MoodType {
  cansado, // 😴 Poca energía, rutinas suaves
  motivado, // 😊 Estado normal, rutinas estándar
  energetico, // 🔥 Alta energía, rutinas intensas
  estresado, // 😰 Alto estrés, rutinas relajantes
}

/// Extensión para obtener información de cada mood
extension MoodTypeExtension on MoodType {
  String get emoji {
    switch (this) {
      case MoodType.cansado:
        return '😴';
      case MoodType.motivado:
        return '😊';
      case MoodType.energetico:
        return '🔥';
      case MoodType.estresado:
        return '😰';
    }
  }

  String get displayName {
    switch (this) {
      case MoodType.cansado:
        return 'Cansado';
      case MoodType.motivado:
        return 'Motivado';
      case MoodType.energetico:
        return 'Energético';
      case MoodType.estresado:
        return 'Estresado';
    }
  }

  String get title {
    switch (this) {
      case MoodType.cansado:
        return 'Cansado';
      case MoodType.motivado:
        return 'Motivado';
      case MoodType.energetico:
        return 'Energético';
      case MoodType.estresado:
        return 'Estresado';
    }
  }

  String get description {
    switch (this) {
      case MoodType.cansado:
        return 'Poca energía, necesito algo suave';
      case MoodType.motivado:
        return 'Me siento bien, listo para entrenar';
      case MoodType.energetico:
        return 'Tengo mucha energía, ¡vamos con todo!';
      case MoodType.estresado:
        return 'Necesito relajarme y desestresarme';
    }
  }

  /// Color primario asociado al estado de ánimo
  Color get primaryColor {
    switch (this) {
      case MoodType.cansado:
        return const Color(0xFF6C7CE7); // Azul suave
      case MoodType.motivado:
        return const Color(0xFF4CAF50); // Verde positivo
      case MoodType.energetico:
        return const Color(0xFFFF5722); // Naranja energético
      case MoodType.estresado:
        return const Color(0xFF9C27B0); // Púrpura calmante
    }
  }

  String get workoutRecommendation {
    switch (this) {
      case MoodType.cansado:
        return 'Te recomendamos estiramientos suaves y ejercicios de movilidad';
      case MoodType.motivado:
        return 'Perfecto para tu rutina habitual de entrenamiento';
      case MoodType.energetico:
        return '¡Ideal para rutinas intensas y desafiantes!';
      case MoodType.estresado:
        return 'Ejercicios de relajación, yoga o caminatas tranquilas';
    }
  }

  /// Lista de recomendaciones específicas para el entrenamiento
  List<String> get workoutRecommendations {
    switch (this) {
      case MoodType.cansado:
        return [
          'Estiramientos suaves de 15-20 minutos',
          'Ejercicios de movilidad articular',
          'Caminata tranquila al aire libre',
          'Yoga restaurativo o meditación activa',
        ];
      case MoodType.motivado:
        return [
          'Tu rutina habitual de entrenamiento',
          'Combina cardio y fuerza moderada',
          'Ejercicios que disfrutes y te motiven',
          'Mantén la consistencia en tu plan',
        ];
      case MoodType.energetico:
        return [
          'Rutinas HIIT de alta intensidad',
          'Levantamiento de pesas con más carga',
          'Ejercicios pliométricos o funcionales',
          'Desafíate con nuevos movimientos',
        ];
      case MoodType.estresado:
        return [
          'Yoga suave o ejercicios de respiración',
          'Caminata meditativa de 20-30 minutos',
          'Natación relajante o aqua aeróbicos',
          'Tai chi o ejercicios de estiramiento',
        ];
    }
  }
}
