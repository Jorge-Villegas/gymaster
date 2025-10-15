class Logro {
  final String? id;
  final TipoLogro tipo;
  final String titulo;
  final String descripcion;
  final String nombreIcono;
  final int color;
  final int puntos;
  final DateTime? fechaDesbloqueo;
  final bool desbloqueado;
  final Map<String, dynamic> criterios;
  final double progreso;
  final RarezaLogro rareza;

  const Logro({
    this.id,
    required this.tipo,
    required this.titulo,
    required this.descripcion,
    required this.nombreIcono,
    required this.color,
    required this.puntos,
    this.fechaDesbloqueo,
    this.desbloqueado = false,
    required this.criterios,
    this.progreso = 0.0,
    required this.rareza,
  });

  Logro copyWith({
    String? id,
    TipoLogro? tipo,
    String? titulo,
    String? descripcion,
    String? nombreIcono,
    int? color,
    int? puntos,
    DateTime? fechaDesbloqueo,
    bool? desbloqueado,
    Map<String, dynamic>? criterios,
    double? progreso,
    RarezaLogro? rareza,
  }) =>
      Logro(
        id: id ?? this.id,
        tipo: tipo ?? this.tipo,
        titulo: titulo ?? this.titulo,
        descripcion: descripcion ?? this.descripcion,
        nombreIcono: nombreIcono ?? this.nombreIcono,
        color: color ?? this.color,
        puntos: puntos ?? this.puntos,
        fechaDesbloqueo: fechaDesbloqueo ?? this.fechaDesbloqueo,
        desbloqueado: desbloqueado ?? this.desbloqueado,
        criterios: criterios ?? this.criterios,
        progreso: progreso ?? this.progreso,
        rareza: rareza ?? this.rareza,
      );

  factory Logro.fromJson(Map<String, dynamic> json) => Logro(
        id: json["id"],
        tipo: TipoLogro.values.firstWhere(
          (e) => e.toString().split('.').last == json["tipo"],
        ),
        titulo: json["titulo"],
        descripcion: json["descripcion"],
        nombreIcono: json["nombreIcono"],
        color: json["color"],
        puntos: json["puntos"],
        fechaDesbloqueo: json["fechaDesbloqueo"] != null
            ? DateTime.parse(json["fechaDesbloqueo"])
            : null,
        desbloqueado: json["desbloqueado"] ?? false,
        criterios: Map<String, dynamic>.from(json["criterios"] ?? {}),
        progreso: (json["progreso"] ?? 0.0).toDouble(),
        rareza: RarezaLogro.values.firstWhere(
          (e) => e.toString().split('.').last == json["rareza"],
        ),
      );

  Map<String, dynamic> aJson() => {
        "id": id,
        "tipo": tipo.toString().split('.').last,
        "titulo": titulo,
        "descripcion": descripcion,
        "nombreIcono": nombreIcono,
        "color": color,
        "puntos": puntos,
        "fechaDesbloqueo": fechaDesbloqueo?.toIso8601String(),
        "desbloqueado": desbloqueado,
        "criterios": criterios,
        "progreso": progreso,
        "rareza": rareza.toString().split('.').last,
      };
}

/// Tipos de logros disponibles en GyMaster
enum TipoLogro {
  rutina, // Logros relacionados con rutinas
  ejercicio, // Logros de ejercicios específicos
  peso, // Logros de peso levantado
  tiempo, // Logros de tiempo (duración, consistencia)
  racha, // Logros de rachas
  hito, // Logros de hitos importantes
  desafio, // Logros de desafíos completados
  social, // Logros sociales (futuros)
}

/// Extensión para obtener información adicional de los tipos de logros
extension TipoLogroExtension on TipoLogro {
  /// Nombre del tipo en español
  String get displayName {
    switch (this) {
      case TipoLogro.rutina:
        return 'Rutina';
      case TipoLogro.ejercicio:
        return 'Ejercicio';
      case TipoLogro.peso:
        return 'Peso';
      case TipoLogro.tiempo:
        return 'Tiempo';
      case TipoLogro.racha:
        return 'Racha';
      case TipoLogro.hito:
        return 'Hito';
      case TipoLogro.desafio:
        return 'Desafío';
      case TipoLogro.social:
        return 'Social';
    }
  }

  /// Color asociado al tipo de logro
  int get colorTipo {
    switch (this) {
      case TipoLogro.rutina:
        return 0xFF4CAF50; // Verde
      case TipoLogro.ejercicio:
        return 0xFF2196F3; // Azul
      case TipoLogro.peso:
        return 0xFFFF9800; // Naranja
      case TipoLogro.tiempo:
        return 0xFF9C27B0; // Púrpura
      case TipoLogro.racha:
        return 0xFFF44336; // Rojo
      case TipoLogro.hito:
        return 0xFFFFEB3B; // Amarillo
      case TipoLogro.desafio:
        return 0xFF795548; // Marrón
      case TipoLogro.social:
        return 0xFF607D8B; // Azul gris
    }
  }
}

/// Rareza de los logros
enum RarezaLogro {
  comun,
  pocoComun,
  raro,
  epico,
  legendario,
}

/// Extensión para obtener información de rareza
extension RarezaLogroExtension on RarezaLogro {
  /// Nombre de la rareza en español
  String get nombreMostrar {
    switch (this) {
      case RarezaLogro.comun:
        return 'Común';
      case RarezaLogro.pocoComun:
        return 'Poco Común';
      case RarezaLogro.raro:
        return 'Raro';
      case RarezaLogro.epico:
        return 'Épico';
      case RarezaLogro.legendario:
        return 'Legendario';
    }
  }

  int get colorRareza {
    switch (this) {
      case RarezaLogro.comun:
        return 0xFF9E9E9E; // Gris
      case RarezaLogro.pocoComun:
        return 0xFF4CAF50; // Verde
      case RarezaLogro.raro:
        return 0xFF2196F3; // Azul
      case RarezaLogro.epico:
        return 0xFF9C27B0; // Púrpura
      case RarezaLogro.legendario:
        return 0xFFFFD700; // Dorado
    }
  }

  double get multiplicadorPuntos {
    switch (this) {
      case RarezaLogro.comun:
        return 1.0;
      case RarezaLogro.pocoComun:
        return 1.5;
      case RarezaLogro.raro:
        return 2.0;
      case RarezaLogro.epico:
        return 3.0;
      case RarezaLogro.legendario:
        return 5.0;
    }
  }
}

/// Logros predefinidos para GyMaster
class PlantillasLogro {
  /// Lista de logros comunes
  static List<Logro> get logrosComunes => [
        Logro(
          tipo: TipoLogro.rutina,
          titulo: 'Primera Rutina',
          descripcion: 'Completa tu primera rutina de ejercicios',
          nombreIcono: 'first_routine',
          color: TipoLogro.rutina.colorTipo,
          puntos: 10,
          criterios: {'routines_completed': 1},
          rareza: RarezaLogro.comun,
        ),
        Logro(
          tipo: TipoLogro.racha,
          titulo: 'Constante',
          descripcion: 'Entrena 3 días seguidos',
          nombreIcono: 'streak_3',
          color: TipoLogro.racha.colorTipo,
          puntos: 15,
          criterios: {'consecutive_days': 3},
          rareza: RarezaLogro.comun,
        ),
        Logro(
          tipo: TipoLogro.tiempo,
          titulo: 'Guerrero del Tiempo',
          descripcion: 'Entrena por más de 30 minutos',
          nombreIcono: 'time_warrior',
          color: TipoLogro.tiempo.colorTipo,
          puntos: 12,
          criterios: {'workout_duration_minutes': 30},
          rareza: RarezaLogro.comun,
        ),
      ];

  /// Lista de logros poco comunes
  static List<Logro> get logrosPocoComunes => [
        Logro(
          tipo: TipoLogro.rutina,
          titulo: 'Veterano',
          descripcion: 'Completa 10 rutinas de ejercicios',
          nombreIcono: 'veteran',
          color: TipoLogro.rutina.colorTipo,
          puntos: 25,
          criterios: {'routines_completed': 10},
          rareza: RarezaLogro.pocoComun,
        ),
        Logro(
          tipo: TipoLogro.racha,
          titulo: 'Semana Perfecta',
          descripcion: 'Entrena 7 días seguidos',
          nombreIcono: 'perfect_week',
          color: TipoLogro.racha.colorTipo,
          puntos: 35,
          criterios: {'consecutive_days': 7},
          rareza: RarezaLogro.pocoComun,
        ),
        Logro(
          tipo: TipoLogro.peso,
          titulo: 'Fuerza Creciente',
          descripcion: 'Levanta un total de 1000 kg',
          nombreIcono: 'growing_strength',
          color: TipoLogro.peso.colorTipo,
          puntos: 30,
          criterios: {'total_weight_kg': 1000},
          rareza: RarezaLogro.pocoComun,
        ),
      ];

  /// Lista de logros raros
  static List<Logro> get logrosRaros => [
        Logro(
          tipo: TipoLogro.hito,
          titulo: 'Mes de Fuerza',
          descripcion: 'Entrena todos los días durante un mes',
          nombreIcono: 'month_strength',
          color: TipoLogro.hito.colorTipo,
          puntos: 100,
          criterios: {'consecutive_days': 30},
          rareza: RarezaLogro.raro,
        ),
        Logro(
          tipo: TipoLogro.rutina,
          titulo: 'Centurión',
          descripcion: 'Completa 100 rutinas de ejercicios',
          nombreIcono: 'centurion',
          color: TipoLogro.rutina.colorTipo,
          puntos: 150,
          criterios: {'routines_completed': 100},
          rareza: RarezaLogro.raro,
        ),
      ];

  /// Lista de logros épicos
  static List<Logro> get logrosEpicos => [
        Logro(
          tipo: TipoLogro.peso,
          titulo: 'Titán de Hierro',
          descripcion: 'Levanta un total de 10,000 kg',
          nombreIcono: 'iron_titan',
          color: TipoLogro.peso.colorTipo,
          puntos: 300,
          criterios: {'total_weight_kg': 10000},
          rareza: RarezaLogro.epico,
        ),
        Logro(
          tipo: TipoLogro.tiempo,
          titulo: 'Maratonista',
          descripcion: 'Acumula 100 horas de entrenamiento',
          nombreIcono: 'marathoner',
          color: TipoLogro.tiempo.colorTipo,
          puntos: 250,
          criterios: {'total_hours': 100},
          rareza: RarezaLogro.epico,
        ),
      ];

  /// Lista de logros legendarios
  static List<Logro> get logrosLegendarios => [
        Logro(
          tipo: TipoLogro.hito,
          titulo: 'Leyenda del Gimnasio',
          descripcion: 'Entrena consistentemente durante un año completo',
          nombreIcono: 'gym_legend',
          color: TipoLogro.hito.colorTipo,
          puntos: 1000,
          criterios: {'consecutive_days': 365},
          rareza: RarezaLogro.legendario,
        ),
        Logro(
          tipo: TipoLogro.rutina,
          titulo: 'Maestro Supremo',
          descripcion: 'Completa 1000 rutinas de ejercicios',
          nombreIcono: 'supreme_master',
          color: TipoLogro.rutina.colorTipo,
          puntos: 1500,
          criterios: {'routines_completed': 1000},
          rareza: RarezaLogro.legendario,
        ),
      ];

  /// Obtiene todos los logros predefinidos
  static List<Logro> get todosLosLogros => [
        ...logrosComunes,
        ...logrosPocoComunes,
        ...logrosRaros,
        ...logrosEpicos,
        ...logrosLegendarios,
      ];
}
