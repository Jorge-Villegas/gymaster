import 'package:gymaster/features/setting/domain/entities/logro.dart';

class LogroDbModel {
  static const String tabla = 'achievement';

  // Columnas
  static const String columnaId = 'id';
  static const String columnaTipo = 'tipo';
  static const String columnaTitulo = 'titulo';
  static const String columnaDescripcion = 'descripcion';
  static const String columnaIcono = 'icono';
  static const String columnaColor = 'color';
  static const String columnaPuntos = 'puntos';
  static const String columnaFechaDesbloqueo = 'fecha_desbloqueo';
  static const String columnaDesbloqueado = 'desbloqueado';
  static const String columnaCriterios = 'criterios';
  static const String columnaProgreso = 'progreso';
  static const String columnaRareza = 'rareza';
  static const String columnaFechaCreacion = 'fecha_creacion';
  static const String columnaFechaActualizacion = 'fecha_actualizacion';

  final String id;
  final String type;
  final String title;
  final String description;
  final String iconName;
  final int color;
  final int points;
  final String? achievedAt;
  final int isUnlocked;
  final String criteria; // JSON string
  final double progress;
  final String rarity;
  final DateTime fechaCreacion;
  final DateTime fechaActualizacion;

  LogroDbModel({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.iconName,
    required this.color,
    required this.points,
    this.achievedAt,
    required this.isUnlocked,
    required this.criteria,
    required this.progress,
    required this.rarity,
    required this.fechaCreacion,
    required this.fechaActualizacion,
  });

  factory LogroDbModel.fromDomain(Logro achievement) {
    return LogroDbModel(
        id: achievement.id!,
        type: achievement.tipo.toString().split('.').last,
        title: achievement.titulo,
        description: achievement.descripcion,
        iconName: achievement.nombreIcono,
        color: achievement.color,
        points: achievement.puntos,
        achievedAt: achievement.fechaDesbloqueo?.toIso8601String(),
        isUnlocked: achievement.desbloqueado ? 1 : 0,
        criteria: achievement.criterios.toString(),
        progress: achievement.progreso,
        rarity: achievement.rareza.toString().split('.').last,
        fechaCreacion: DateTime.now(),
        fechaActualizacion: DateTime.now());
  }

  Logro toDomain() {
    return Logro(
      id: id,
      tipo: TipoLogro.values.firstWhere(
        (e) => e.toString().split('.').last == type,
      ),
      titulo: title,
      descripcion: description,
      nombreIcono: iconName,
      color: color,
      puntos: points,
      fechaDesbloqueo: achievedAt != null ? DateTime.parse(achievedAt!) : null,
      desbloqueado: isUnlocked == 1,
      criterios: _parseCriteria(criteria),
      progreso: progress,
      rareza: RarezaLogro.values.firstWhere(
        (e) => e.toString().split('.').last == rarity,
      ),
    );
  }

  factory LogroDbModel.fromJson(Map<String, dynamic> json) {
    return LogroDbModel(
      id: json[columnaId],
      type: json[columnaTipo],
      title: json[columnaTitulo],
      description: json[columnaDescripcion],
      iconName: json[columnaIcono],
      color: json[columnaColor],
      points: json[columnaPuntos],
      achievedAt: json[columnaFechaDesbloqueo],
      isUnlocked: json[columnaDesbloqueado],
      criteria: json[columnaCriterios],
      progress: (json[columnaProgreso] ?? 0.0).toDouble(),
      rarity: json[columnaRareza],
      fechaCreacion: DateTime.parse(json[columnaFechaCreacion]),
      fechaActualizacion: DateTime.parse(json[columnaFechaActualizacion]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      columnaId: id,
      columnaTipo: type,
      columnaTitulo: title,
      columnaDescripcion: description,
      columnaIcono: iconName,
      columnaColor: color,
      columnaPuntos: points,
      columnaFechaDesbloqueo: achievedAt,
      columnaDesbloqueado: isUnlocked,
      columnaCriterios: criteria,
      columnaProgreso: progress,
      columnaRareza: rarity,
      columnaFechaCreacion: fechaCreacion.toIso8601String(),
      columnaFechaActualizacion: fechaActualizacion.toIso8601String(),
    };
  }

  /// Parse criteria desde string (implementación simple)
  Map<String, dynamic> _parseCriteria(String criteriaString) {
    try {
      // Por ahora, criterios simples como "routines_completed: 1"
      if (criteriaString.contains('routines_completed')) {
        final value = int.parse(criteriaString.split(':').last.trim());
        return {'routines_completed': value};
      }
      if (criteriaString.contains('consecutive_days')) {
        final value = int.parse(criteriaString.split(':').last.trim());
        return {'consecutive_days': value};
      }
      if (criteriaString.contains('workout_duration_minutes')) {
        final value = int.parse(criteriaString.split(':').last.trim());
        return {'workout_duration_minutes': value};
      }
      if (criteriaString.contains('total_weight_kg')) {
        final value = int.parse(criteriaString.split(':').last.trim());
        return {'total_weight_kg': value};
      }
      if (criteriaString.contains('total_hours')) {
        final value = int.parse(criteriaString.split(':').last.trim());
        return {'total_hours': value};
      }
      return {};
    } catch (e) {
      return {};
    }
  }
}
