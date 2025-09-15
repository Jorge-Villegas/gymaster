/// Entidad Achievement para el sistema de gamificación de GyMaster
/// Representa logros obtenidos por el usuario en su journey fitness
class Achievement {
  /// ID único del logro
  final String? id;

  /// Tipo de logro (rutina, ejercicio, tiempo, peso, etc.)
  final AchievementType type;

  /// Título del logro en español
  final String title;

  /// Descripción detallada del logro
  final String description;

  /// Icono asociado al logro
  final String iconName;

  /// Color del logro en formato hexadecimal
  final int color;

  /// Puntos otorgados por este logro
  final int points;

  /// Fecha en que se obtuvo el logro
  final DateTime? achievedAt;

  /// Si el logro está desbloqueado
  final bool isUnlocked;

  /// Criterios necesarios para desbloquear (JSON)
  final Map<String, dynamic> criteria;

  /// Progreso actual hacia el logro (0.0 - 1.0)
  final double progress;

  /// Rareza del logro
  final AchievementRarity rarity;

  const Achievement({
    this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.iconName,
    required this.color,
    required this.points,
    this.achievedAt,
    this.isUnlocked = false,
    required this.criteria,
    this.progress = 0.0,
    required this.rarity,
  });

  Achievement copyWith({
    String? id,
    AchievementType? type,
    String? title,
    String? description,
    String? iconName,
    int? color,
    int? points,
    DateTime? achievedAt,
    bool? isUnlocked,
    Map<String, dynamic>? criteria,
    double? progress,
    AchievementRarity? rarity,
  }) =>
      Achievement(
        id: id ?? this.id,
        type: type ?? this.type,
        title: title ?? this.title,
        description: description ?? this.description,
        iconName: iconName ?? this.iconName,
        color: color ?? this.color,
        points: points ?? this.points,
        achievedAt: achievedAt ?? this.achievedAt,
        isUnlocked: isUnlocked ?? this.isUnlocked,
        criteria: criteria ?? this.criteria,
        progress: progress ?? this.progress,
        rarity: rarity ?? this.rarity,
      );

  factory Achievement.fromJson(Map<String, dynamic> json) => Achievement(
        id: json["id"],
        type: AchievementType.values.firstWhere(
          (e) => e.toString().split('.').last == json["type"],
        ),
        title: json["title"],
        description: json["description"],
        iconName: json["iconName"],
        color: json["color"],
        points: json["points"],
        achievedAt: json["achievedAt"] != null
            ? DateTime.parse(json["achievedAt"])
            : null,
        isUnlocked: json["isUnlocked"] ?? false,
        criteria: Map<String, dynamic>.from(json["criteria"] ?? {}),
        progress: (json["progress"] ?? 0.0).toDouble(),
        rarity: AchievementRarity.values.firstWhere(
          (e) => e.toString().split('.').last == json["rarity"],
        ),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type.toString().split('.').last,
        "title": title,
        "description": description,
        "iconName": iconName,
        "color": color,
        "points": points,
        "achievedAt": achievedAt?.toIso8601String(),
        "isUnlocked": isUnlocked,
        "criteria": criteria,
        "progress": progress,
        "rarity": rarity.toString().split('.').last,
      };
}

/// Tipos de logros disponibles en GyMaster
enum AchievementType {
  routine, // Logros relacionados con rutinas
  exercise, // Logros de ejercicios específicos
  weight, // Logros de peso levantado
  time, // Logros de tiempo (duración, consistencia)
  streak, // Logros de rachas
  milestone, // Logros de hitos importantes
  challenge, // Logros de desafíos completados
  social, // Logros sociales (futuros)
}

/// Extensión para obtener información adicional de los tipos de logros
extension AchievementTypeExtension on AchievementType {
  /// Nombre del tipo en español
  String get displayName {
    switch (this) {
      case AchievementType.routine:
        return 'Rutina';
      case AchievementType.exercise:
        return 'Ejercicio';
      case AchievementType.weight:
        return 'Peso';
      case AchievementType.time:
        return 'Tiempo';
      case AchievementType.streak:
        return 'Racha';
      case AchievementType.milestone:
        return 'Hito';
      case AchievementType.challenge:
        return 'Desafío';
      case AchievementType.social:
        return 'Social';
    }
  }

  /// Color asociado al tipo de logro
  int get typeColor {
    switch (this) {
      case AchievementType.routine:
        return 0xFF4CAF50; // Verde
      case AchievementType.exercise:
        return 0xFF2196F3; // Azul
      case AchievementType.weight:
        return 0xFFFF9800; // Naranja
      case AchievementType.time:
        return 0xFF9C27B0; // Púrpura
      case AchievementType.streak:
        return 0xFFF44336; // Rojo
      case AchievementType.milestone:
        return 0xFFFFEB3B; // Amarillo
      case AchievementType.challenge:
        return 0xFF795548; // Marrón
      case AchievementType.social:
        return 0xFF607D8B; // Azul gris
    }
  }
}

/// Rareza de los logros
enum AchievementRarity {
  common, // Común
  uncommon, // Poco común
  rare, // Raro
  epic, // Épico
  legendary, // Legendario
}

/// Extensión para obtener información de rareza
extension AchievementRarityExtension on AchievementRarity {
  /// Nombre de la rareza en español
  String get displayName {
    switch (this) {
      case AchievementRarity.common:
        return 'Común';
      case AchievementRarity.uncommon:
        return 'Poco Común';
      case AchievementRarity.rare:
        return 'Raro';
      case AchievementRarity.epic:
        return 'Épico';
      case AchievementRarity.legendary:
        return 'Legendario';
    }
  }

  /// Color asociado a la rareza
  int get rarityColor {
    switch (this) {
      case AchievementRarity.common:
        return 0xFF9E9E9E; // Gris
      case AchievementRarity.uncommon:
        return 0xFF4CAF50; // Verde
      case AchievementRarity.rare:
        return 0xFF2196F3; // Azul
      case AchievementRarity.epic:
        return 0xFF9C27B0; // Púrpura
      case AchievementRarity.legendary:
        return 0xFFFFD700; // Dorado
    }
  }

  /// Multiplicador de puntos por rareza
  double get pointsMultiplier {
    switch (this) {
      case AchievementRarity.common:
        return 1.0;
      case AchievementRarity.uncommon:
        return 1.5;
      case AchievementRarity.rare:
        return 2.0;
      case AchievementRarity.epic:
        return 3.0;
      case AchievementRarity.legendary:
        return 5.0;
    }
  }
}

/// Logros predefinidos para GyMaster
class AchievementTemplates {
  /// Lista de logros comunes
  static List<Achievement> get commonAchievements => [
        Achievement(
          type: AchievementType.routine,
          title: 'Primera Rutina',
          description: 'Completa tu primera rutina de ejercicios',
          iconName: 'first_routine',
          color: AchievementType.routine.typeColor,
          points: 10,
          criteria: {'routines_completed': 1},
          rarity: AchievementRarity.common,
        ),
        Achievement(
          type: AchievementType.streak,
          title: 'Constante',
          description: 'Entrena 3 días seguidos',
          iconName: 'streak_3',
          color: AchievementType.streak.typeColor,
          points: 15,
          criteria: {'consecutive_days': 3},
          rarity: AchievementRarity.common,
        ),
        Achievement(
          type: AchievementType.time,
          title: 'Guerrero del Tiempo',
          description: 'Entrena por más de 30 minutos',
          iconName: 'time_warrior',
          color: AchievementType.time.typeColor,
          points: 12,
          criteria: {'workout_duration_minutes': 30},
          rarity: AchievementRarity.common,
        ),
      ];

  /// Lista de logros poco comunes
  static List<Achievement> get uncommonAchievements => [
        Achievement(
          type: AchievementType.routine,
          title: 'Veterano',
          description: 'Completa 10 rutinas de ejercicios',
          iconName: 'veteran',
          color: AchievementType.routine.typeColor,
          points: 25,
          criteria: {'routines_completed': 10},
          rarity: AchievementRarity.uncommon,
        ),
        Achievement(
          type: AchievementType.streak,
          title: 'Semana Perfecta',
          description: 'Entrena 7 días seguidos',
          iconName: 'perfect_week',
          color: AchievementType.streak.typeColor,
          points: 35,
          criteria: {'consecutive_days': 7},
          rarity: AchievementRarity.uncommon,
        ),
        Achievement(
          type: AchievementType.weight,
          title: 'Fuerza Creciente',
          description: 'Levanta un total de 1000 kg',
          iconName: 'growing_strength',
          color: AchievementType.weight.typeColor,
          points: 30,
          criteria: {'total_weight_kg': 1000},
          rarity: AchievementRarity.uncommon,
        ),
      ];

  /// Lista de logros raros
  static List<Achievement> get rareAchievements => [
        Achievement(
          type: AchievementType.milestone,
          title: 'Mes de Fuerza',
          description: 'Entrena todos los días durante un mes',
          iconName: 'month_strength',
          color: AchievementType.milestone.typeColor,
          points: 100,
          criteria: {'consecutive_days': 30},
          rarity: AchievementRarity.rare,
        ),
        Achievement(
          type: AchievementType.routine,
          title: 'Centurión',
          description: 'Completa 100 rutinas de ejercicios',
          iconName: 'centurion',
          color: AchievementType.routine.typeColor,
          points: 150,
          criteria: {'routines_completed': 100},
          rarity: AchievementRarity.rare,
        ),
      ];

  /// Lista de logros épicos
  static List<Achievement> get epicAchievements => [
        Achievement(
          type: AchievementType.weight,
          title: 'Titán de Hierro',
          description: 'Levanta un total de 10,000 kg',
          iconName: 'iron_titan',
          color: AchievementType.weight.typeColor,
          points: 300,
          criteria: {'total_weight_kg': 10000},
          rarity: AchievementRarity.epic,
        ),
        Achievement(
          type: AchievementType.time,
          title: 'Maratonista',
          description: 'Acumula 100 horas de entrenamiento',
          iconName: 'marathoner',
          color: AchievementType.time.typeColor,
          points: 250,
          criteria: {'total_hours': 100},
          rarity: AchievementRarity.epic,
        ),
      ];

  /// Lista de logros legendarios
  static List<Achievement> get legendaryAchievements => [
        Achievement(
          type: AchievementType.milestone,
          title: 'Leyenda del Gimnasio',
          description: 'Entrena consistentemente durante un año completo',
          iconName: 'gym_legend',
          color: AchievementType.milestone.typeColor,
          points: 1000,
          criteria: {'consecutive_days': 365},
          rarity: AchievementRarity.legendary,
        ),
        Achievement(
          type: AchievementType.routine,
          title: 'Maestro Supremo',
          description: 'Completa 1000 rutinas de ejercicios',
          iconName: 'supreme_master',
          color: AchievementType.routine.typeColor,
          points: 1500,
          criteria: {'routines_completed': 1000},
          rarity: AchievementRarity.legendary,
        ),
      ];

  /// Obtiene todos los logros predefinidos
  static List<Achievement> get allAchievements => [
        ...commonAchievements,
        ...uncommonAchievements,
        ...rareAchievements,
        ...epicAchievements,
        ...legendaryAchievements,
      ];
}
