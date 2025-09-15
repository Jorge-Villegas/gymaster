/// Entidad que representa las motivaciones y preferencias emocionales del usuario
class UserMotivation {
  final String userId;
  final List<String> motivations; // ¿Qué te motiva a entrenar?
  final List<String> challenges; // ¿Cuál es tu mayor desafío?
  final List<String>
      postWorkoutFeelings; // ¿Cómo te sientes después de entrenar?
  final NotificationPreferences notificationPreferences;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserMotivation({
    required this.userId,
    required this.motivations,
    required this.challenges,
    required this.postWorkoutFeelings,
    required this.notificationPreferences,
    required this.createdAt,
    required this.updatedAt,
  });

  UserMotivation copyWith({
    String? userId,
    List<String>? motivations,
    List<String>? challenges,
    List<String>? postWorkoutFeelings,
    NotificationPreferences? notificationPreferences,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      UserMotivation(
        userId: userId ?? this.userId,
        motivations: motivations ?? this.motivations,
        challenges: challenges ?? this.challenges,
        postWorkoutFeelings: postWorkoutFeelings ?? this.postWorkoutFeelings,
        notificationPreferences:
            notificationPreferences ?? this.notificationPreferences,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory UserMotivation.fromJson(Map<String, dynamic> json) => UserMotivation(
        userId: json["userId"],
        motivations: List<String>.from(json["motivations"].map((x) => x)),
        challenges: List<String>.from(json["challenges"].map((x) => x)),
        postWorkoutFeelings:
            List<String>.from(json["postWorkoutFeelings"].map((x) => x)),
        notificationPreferences:
            NotificationPreferences.fromJson(json["notificationPreferences"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "motivations": List<dynamic>.from(motivations.map((x) => x)),
        "challenges": List<dynamic>.from(challenges.map((x) => x)),
        "postWorkoutFeelings":
            List<dynamic>.from(postWorkoutFeelings.map((x) => x)),
        "notificationPreferences": notificationPreferences.toJson(),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}

/// Preferencias de notificaciones motivacionales
class NotificationPreferences {
  final bool enabled;
  final List<int> preferredHours; // Horas preferidas (0-23)
  final MotivationTone tone; // Tono motivacional
  final int frequencyDays; // Cada cuántos días sin entrenar enviar recordatorio

  const NotificationPreferences({
    required this.enabled,
    required this.preferredHours,
    required this.tone,
    required this.frequencyDays,
  });

  NotificationPreferences copyWith({
    bool? enabled,
    List<int>? preferredHours,
    MotivationTone? tone,
    int? frequencyDays,
  }) =>
      NotificationPreferences(
        enabled: enabled ?? this.enabled,
        preferredHours: preferredHours ?? this.preferredHours,
        tone: tone ?? this.tone,
        frequencyDays: frequencyDays ?? this.frequencyDays,
      );

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) =>
      NotificationPreferences(
        enabled: json["enabled"],
        preferredHours: List<int>.from(json["preferredHours"].map((x) => x)),
        tone: MotivationTone.values.firstWhere((e) => e.name == json["tone"]),
        frequencyDays: json["frequencyDays"],
      );

  Map<String, dynamic> toJson() => {
        "enabled": enabled,
        "preferredHours": List<dynamic>.from(preferredHours.map((x) => x)),
        "tone": tone.name,
        "frequencyDays": frequencyDays,
      };
}

/// Tonos motivacionales disponibles
enum MotivationTone {
  energetico, // "🔥 ¡Vamos a romperla!"
  suave, // "😊 ¿Qué tal un poco de ejercicio?"
  competitivo, // "💪 ¡No dejes que otros te superen!"
  empoderador, // "⭐ Eres más fuerte de lo que crees"
}

/// Opciones predefinidas para motivaciones
class MotivationOptions {
  static const List<String> motivations = [
    "Sentirme más fuerte 💪",
    "Mejorar mi salud ❤️",
    "Aumentar mi energía ⚡",
    "Reducir estrés 😌",
    "Verme mejor físicamente 🏃",
    "Socializar y conocer gente 👥",
    "Superar mis límites 🚀",
    "Crear un hábito saludable 🌱",
  ];

  static const List<String> challenges = [
    "Falta de tiempo ⏰",
    "Falta de motivación 😴",
    "No sé qué ejercicios hacer 🤔",
    "Me da vergüenza entrenar 😳",
    "Me canso muy rápido 😮‍💨",
    "No veo resultados 📉",
    "Lesiones o dolores 🩹",
    "Falta de constancia 📅",
  ];

  static const List<String> postWorkoutFeelings = [
    "Energizado y poderoso 🔋",
    "Relajado y en paz 😌",
    "Orgulloso de mí mismo 🏆",
    "Más confiado 💪",
    "Feliz y de buen humor 😄",
    "Cansado pero satisfecho 😊",
    "Motivado para seguir 🚀",
    "Como si pudiera con todo 💫",
  ];
}
