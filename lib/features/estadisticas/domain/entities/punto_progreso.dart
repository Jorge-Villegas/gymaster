/// Representa un punto individual en el gráfico de progreso temporal.
///
/// Cada punto contiene las métricas de un ejercicio en una fecha específica,
/// permitiendo visualizar la evolución del rendimiento a lo largo del tiempo.
class PuntoProgreso {
  /// Fecha y hora de la sesión de entrenamiento
  final DateTime fecha;

  /// Peso máximo levantado en esta sesión (en kg)
  final double pesoMaximo;

  /// Volumen total = Σ(peso × repeticiones) de todas las series
  final double volumenTotal;

  /// Número total de repeticiones realizadas en esta sesión
  final int totalRepeticiones;

  /// Número total de series completadas
  final int totalSeries;

  const PuntoProgreso({
    required this.fecha,
    required this.pesoMaximo,
    required this.volumenTotal,
    required this.totalRepeticiones,
    required this.totalSeries,
  });

  /// Crea una copia del objeto con valores opcionales actualizados.
  ///
  /// Patrón copyWith manual obligatorio según arquitectura del proyecto.
  PuntoProgreso copyWith({
    DateTime? fecha,
    double? pesoMaximo,
    double? volumenTotal,
    int? totalRepeticiones,
    int? totalSeries,
  }) =>
      PuntoProgreso(
        fecha: fecha ?? this.fecha,
        pesoMaximo: pesoMaximo ?? this.pesoMaximo,
        volumenTotal: volumenTotal ?? this.volumenTotal,
        totalRepeticiones: totalRepeticiones ?? this.totalRepeticiones,
        totalSeries: totalSeries ?? this.totalSeries,
      );

  @override
  String toString() {
    return 'PuntoProgreso('
        'fecha: $fecha, '
        'pesoMaximo: $pesoMaximo kg, '
        'volumen: $volumenTotal kg, '
        'reps: $totalRepeticiones, '
        'series: $totalSeries'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PuntoProgreso &&
        other.fecha == fecha &&
        other.pesoMaximo == pesoMaximo &&
        other.volumenTotal == volumenTotal &&
        other.totalRepeticiones == totalRepeticiones &&
        other.totalSeries == totalSeries;
  }

  @override
  int get hashCode {
    return fecha.hashCode ^
        pesoMaximo.hashCode ^
        volumenTotal.hashCode ^
        totalRepeticiones.hashCode ^
        totalSeries.hashCode;
  }
}
