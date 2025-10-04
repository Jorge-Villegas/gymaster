/// Entidad que representa una recomendación sobre músculos que
/// han sido olvidados o descuidados en el entrenamiento.
///
/// Permite identificar desequilibrios y sugerir ejercicios para equilibrar
/// el programa de entrenamiento.
class RecomendacionMuscular {
  /// ID único del músculo recomendado
  final String musculoId;

  /// Nombre del músculo (ej: "Tríceps", "Pantorrilla")
  final String nombreMusculo;

  /// Ruta de la imagen representativa del músculo
  final String? imagenMusculo;

  /// Número de días sin trabajar este músculo
  final int diasSinTrabajar;

  /// Nivel de prioridad (1-5, donde 5 es máxima prioridad)
  final int nivelPrioridad;

  /// Mensaje motivacional o sugerencia
  final String mensajeRecomendacion;

  /// Lista de ejercicios sugeridos para trabajar este músculo
  final List<String> ejerciciosSugeridos;

  /// Fecha de la última vez que se trabajó (null si nunca)
  final DateTime? ultimaFechaTrabajo;

  const RecomendacionMuscular({
    required this.musculoId,
    required this.nombreMusculo,
    this.imagenMusculo,
    required this.diasSinTrabajar,
    required this.nivelPrioridad,
    required this.mensajeRecomendacion,
    required this.ejerciciosSugeridos,
    this.ultimaFechaTrabajo,
  });

  /// Valida que los datos sean consistentes
  bool get esValido {
    return musculoId.isNotEmpty &&
        nombreMusculo.isNotEmpty &&
        diasSinTrabajar >= 0 &&
        nivelPrioridad >= 1 &&
        nivelPrioridad <= 5 &&
        mensajeRecomendacion.isNotEmpty;
  }

  /// Retorna true si es urgente (más de 14 días sin trabajar)
  bool get esUrgente => diasSinTrabajar > 14;

  /// Retorna true si requiere atención (más de 7 días sin trabajar)
  bool get requiereAtencion => diasSinTrabajar > 7;

  /// Retorna el emoji de alerta según la urgencia
  String get emojiAlerta {
    if (diasSinTrabajar > 21) return '🔴'; // Crítico
    if (diasSinTrabajar > 14) return '🟠'; // Urgente
    if (diasSinTrabajar > 7) return '🟡'; // Atención
    return '🟢'; // Normal
  }

  /// Retorna el texto de urgencia
  String get textoUrgencia {
    if (diasSinTrabajar > 21) return 'Crítico';
    if (diasSinTrabajar > 14) return 'Urgente';
    if (diasSinTrabajar > 7) return 'Atención';
    return 'Normal';
  }

  /// Retorna un mensaje formateado con el tiempo sin trabajar
  String get mensajeTiempo {
    if (diasSinTrabajar == 0) return 'Trabajado hoy';
    if (diasSinTrabajar == 1) return 'Hace 1 día';
    if (diasSinTrabajar < 7) return 'Hace $diasSinTrabajar días';
    if (diasSinTrabajar < 14) return 'Hace 1 semana';
    if (diasSinTrabajar < 30) {
      final semanas = (diasSinTrabajar / 7).floor();
      return 'Hace $semanas semanas';
    }
    final meses = (diasSinTrabajar / 30).floor();
    return 'Hace $meses ${meses == 1 ? 'mes' : 'meses'}';
  }

  /// Crea una copia del objeto con valores opcionales actualizados.
  ///
  /// Patrón copyWith manual obligatorio según arquitectura del proyecto.
  RecomendacionMuscular copyWith({
    String? musculoId,
    String? nombreMusculo,
    String? imagenMusculo,
    int? diasSinTrabajar,
    int? nivelPrioridad,
    String? mensajeRecomendacion,
    List<String>? ejerciciosSugeridos,
    DateTime? ultimaFechaTrabajo,
  }) =>
      RecomendacionMuscular(
        musculoId: musculoId ?? this.musculoId,
        nombreMusculo: nombreMusculo ?? this.nombreMusculo,
        imagenMusculo: imagenMusculo ?? this.imagenMusculo,
        diasSinTrabajar: diasSinTrabajar ?? this.diasSinTrabajar,
        nivelPrioridad: nivelPrioridad ?? this.nivelPrioridad,
        mensajeRecomendacion: mensajeRecomendacion ?? this.mensajeRecomendacion,
        ejerciciosSugeridos: ejerciciosSugeridos ?? this.ejerciciosSugeridos,
        ultimaFechaTrabajo: ultimaFechaTrabajo ?? this.ultimaFechaTrabajo,
      );

  @override
  String toString() {
    return 'RecomendacionMuscular('
        'musculo: $nombreMusculo, '
        'diasSinTrabajar: $diasSinTrabajar, '
        'prioridad: $nivelPrioridad, '
        'urgencia: $textoUrgencia'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RecomendacionMuscular &&
        other.musculoId == musculoId &&
        other.nombreMusculo == nombreMusculo &&
        other.diasSinTrabajar == diasSinTrabajar;
  }

  @override
  int get hashCode {
    return musculoId.hashCode ^
        nombreMusculo.hashCode ^
        diasSinTrabajar.hashCode;
  }
}
