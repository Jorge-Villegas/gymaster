/// Entidad que representa la posición de un ejercicio en el ranking
/// basado en diferentes criterios (frecuencia, volumen, peso máximo).
///
/// Permite identificar ejercicios favoritos, más efectivos o más realizados.
class RankingEjercicio {
  /// Posición en el ranking (1 = primero, 2 = segundo, etc.)
  final int posicion;

  /// ID único del ejercicio
  final String ejercicioId;

  /// Nombre del ejercicio (ej: "Press Banca", "Sentadilla")
  final String nombreEjercicio;

  /// Ruta de la imagen representativa del ejercicio
  final String? imagenEjercicio;

  /// Nombre del músculo principal trabajado
  final String musculoPrincipal;

  /// Número de veces que se realizó el ejercicio (frecuencia)
  final int vecesRealizado;

  /// Volumen total acumulado = Σ(peso × repeticiones × series)
  final double volumenTotal;

  /// Peso máximo levantado en el periodo
  final double pesoMaximo;

  /// Promedio de peso por sesión
  final double promedioPeso;

  /// Total de series completadas
  final int totalSeries;

  /// Total de repeticiones acumuladas
  final int totalRepeticiones;

  /// Fecha de inicio del periodo analizado
  final DateTime fechaInicio;

  /// Fecha de fin del periodo analizado
  final DateTime fechaFin;

  const RankingEjercicio({
    required this.posicion,
    required this.ejercicioId,
    required this.nombreEjercicio,
    this.imagenEjercicio,
    required this.musculoPrincipal,
    required this.vecesRealizado,
    required this.volumenTotal,
    required this.pesoMaximo,
    required this.promedioPeso,
    required this.totalSeries,
    required this.totalRepeticiones,
    required this.fechaInicio,
    required this.fechaFin,
  });

  /// Valida que los datos sean consistentes
  bool get esValido {
    return posicion > 0 &&
        ejercicioId.isNotEmpty &&
        nombreEjercicio.isNotEmpty &&
        musculoPrincipal.isNotEmpty &&
        vecesRealizado >= 0 &&
        volumenTotal >= 0 &&
        pesoMaximo >= 0 &&
        totalSeries >= 0 &&
        totalRepeticiones >= 0 &&
        fechaInicio.isBefore(fechaFin.add(const Duration(days: 1)));
  }

  /// Retorna el emoji de medalla según la posición
  String get emojiPosicion {
    switch (posicion) {
      case 1:
        return '🥇';
      case 2:
        return '🥈';
      case 3:
        return '🥉';
      default:
        return '$posicion.';
    }
  }

  /// Retorna true si está en el top 3
  bool get esTopTres => posicion <= 3;

  /// Retorna el volumen formateado en toneladas si es >= 1000kg
  String get volumenFormateado {
    if (volumenTotal >= 1000) {
      return '${(volumenTotal / 1000).toStringAsFixed(1)}t';
    }
    return '${volumenTotal.toStringAsFixed(0)}kg';
  }

  /// Retorna el peso máximo formateado
  String get pesoMaximoFormateado {
    return '${pesoMaximo.toStringAsFixed(1)}kg';
  }

  /// Retorna un resumen compacto para mostrar en listas
  String get resumenCompacto {
    return '$vecesRealizado veces • $volumenFormateado • $musculoPrincipal';
  }

  /// Crea una copia del objeto con valores opcionales actualizados.
  ///
  /// Patrón copyWith manual obligatorio según arquitectura del proyecto.
  RankingEjercicio copyWith({
    int? posicion,
    String? ejercicioId,
    String? nombreEjercicio,
    String? imagenEjercicio,
    String? musculoPrincipal,
    int? vecesRealizado,
    double? volumenTotal,
    double? pesoMaximo,
    double? promedioPeso,
    int? totalSeries,
    int? totalRepeticiones,
    DateTime? fechaInicio,
    DateTime? fechaFin,
  }) =>
      RankingEjercicio(
        posicion: posicion ?? this.posicion,
        ejercicioId: ejercicioId ?? this.ejercicioId,
        nombreEjercicio: nombreEjercicio ?? this.nombreEjercicio,
        imagenEjercicio: imagenEjercicio ?? this.imagenEjercicio,
        musculoPrincipal: musculoPrincipal ?? this.musculoPrincipal,
        vecesRealizado: vecesRealizado ?? this.vecesRealizado,
        volumenTotal: volumenTotal ?? this.volumenTotal,
        pesoMaximo: pesoMaximo ?? this.pesoMaximo,
        promedioPeso: promedioPeso ?? this.promedioPeso,
        totalSeries: totalSeries ?? this.totalSeries,
        totalRepeticiones: totalRepeticiones ?? this.totalRepeticiones,
        fechaInicio: fechaInicio ?? this.fechaInicio,
        fechaFin: fechaFin ?? this.fechaFin,
      );

  @override
  String toString() {
    return 'RankingEjercicio('
        'pos: $emojiPosicion, '
        'ejercicio: $nombreEjercicio, '
        'veces: $vecesRealizado, '
        'volumen: $volumenFormateado'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RankingEjercicio &&
        other.posicion == posicion &&
        other.ejercicioId == ejercicioId &&
        other.nombreEjercicio == nombreEjercicio;
  }

  @override
  int get hashCode {
    return posicion.hashCode ^ ejercicioId.hashCode ^ nombreEjercicio.hashCode;
  }
}
