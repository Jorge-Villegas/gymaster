/// Entidad que representa la distribución del trabajo realizado
/// sobre un grupo muscular específico en un periodo de tiempo.
///
/// Permite visualizar qué músculos se están trabajando más y detectar
/// posibles desequilibrios en el entrenamiento.
class DistribucionMuscular {
  /// ID único del grupo muscular
  final String musculoId;

  /// Nombre del grupo muscular (ej: "Pecho", "Espalda", "Piernas")
  final String nombreMusculo;

  /// Ruta de la imagen representativa del músculo
  final String? imagenMusculo;

  /// Volumen total acumulado para este músculo en el periodo
  /// = Σ(peso × repeticiones) de todos los ejercicios que trabajan este músculo
  final double volumenTotal;

  /// Porcentaje de trabajo respecto al total de todos los músculos (0-100)
  final double porcentajeDistribucion;

  /// Número de sesiones en las que se trabajó este músculo
  final int frecuenciaSesiones;

  /// Total de series realizadas para este músculo
  final int totalSeries;

  /// Número de ejercicios diferentes que trabajan este músculo
  final int cantidadEjerciciosDiferentes;

  /// Fecha de inicio del periodo analizado
  final DateTime fechaInicio;

  /// Fecha de fin del periodo analizado
  final DateTime fechaFin;

  const DistribucionMuscular({
    required this.musculoId,
    required this.nombreMusculo,
    this.imagenMusculo,
    required this.volumenTotal,
    required this.porcentajeDistribucion,
    required this.frecuenciaSesiones,
    required this.totalSeries,
    required this.cantidadEjerciciosDiferentes,
    required this.fechaInicio,
    required this.fechaFin,
  });

  /// Valida que los datos sean consistentes
  bool get esValido {
    return musculoId.isNotEmpty &&
        nombreMusculo.isNotEmpty &&
        volumenTotal >= 0 &&
        porcentajeDistribucion >= 0 &&
        porcentajeDistribucion <= 100 &&
        frecuenciaSesiones >= 0 &&
        totalSeries >= 0 &&
        cantidadEjerciciosDiferentes >= 0 &&
        fechaInicio.isBefore(fechaFin.add(const Duration(days: 1)));
  }

  /// Retorna true si este músculo representa más del 20% del trabajo total
  /// (puede indicar sobreentrenamiento)
  bool get estaSubreentrenado => porcentajeDistribucion < 10.0;

  /// Retorna true si este músculo representa menos del 10% del trabajo total
  /// (puede indicar subentrenamiento)
  bool get estaSobreentrenado => porcentajeDistribucion > 30.0;

  /// Retorna la intensidad como categoría (baja, media, alta)
  String get categoriaIntensidad {
    if (porcentajeDistribucion < 10) return 'Baja';
    if (porcentajeDistribucion < 25) return 'Media';
    return 'Alta';
  }

  /// Retorna el volumen formateado en toneladas si es >= 1000kg
  String get volumenFormateado {
    if (volumenTotal >= 1000) {
      return '${(volumenTotal / 1000).toStringAsFixed(1)}t';
    }
    return '${volumenTotal.toStringAsFixed(0)}kg';
  }

  /// Crea una copia del objeto con valores opcionales actualizados.
  ///
  /// Patrón copyWith manual obligatorio según arquitectura del proyecto.
  DistribucionMuscular copyWith({
    String? musculoId,
    String? nombreMusculo,
    String? imagenMusculo,
    double? volumenTotal,
    double? porcentajeDistribucion,
    int? frecuenciaSesiones,
    int? totalSeries,
    int? cantidadEjerciciosDiferentes,
    DateTime? fechaInicio,
    DateTime? fechaFin,
  }) =>
      DistribucionMuscular(
        musculoId: musculoId ?? this.musculoId,
        nombreMusculo: nombreMusculo ?? this.nombreMusculo,
        imagenMusculo: imagenMusculo ?? this.imagenMusculo,
        volumenTotal: volumenTotal ?? this.volumenTotal,
        porcentajeDistribucion:
            porcentajeDistribucion ?? this.porcentajeDistribucion,
        frecuenciaSesiones: frecuenciaSesiones ?? this.frecuenciaSesiones,
        totalSeries: totalSeries ?? this.totalSeries,
        cantidadEjerciciosDiferentes:
            cantidadEjerciciosDiferentes ?? this.cantidadEjerciciosDiferentes,
        fechaInicio: fechaInicio ?? this.fechaInicio,
        fechaFin: fechaFin ?? this.fechaFin,
      );

  @override
  String toString() {
    return 'DistribucionMuscular('
        'musculo: $nombreMusculo, '
        'volumen: $volumenFormateado, '
        'porcentaje: ${porcentajeDistribucion.toStringAsFixed(1)}%, '
        'frecuencia: $frecuenciaSesiones sesiones'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DistribucionMuscular &&
        other.musculoId == musculoId &&
        other.nombreMusculo == nombreMusculo &&
        other.volumenTotal == volumenTotal &&
        other.porcentajeDistribucion == porcentajeDistribucion;
  }

  @override
  int get hashCode {
    return musculoId.hashCode ^
        nombreMusculo.hashCode ^
        volumenTotal.hashCode ^
        porcentajeDistribucion.hashCode;
  }
}
