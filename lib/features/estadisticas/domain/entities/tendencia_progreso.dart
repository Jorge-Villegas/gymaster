/// Enumeración que representa la tendencia del progreso de un ejercicio
/// basada en la comparación de métricas entre periodos de tiempo.
enum TendenciaProgreso {
  /// Indica que el progreso está mejorando (↑)
  /// Ejemplo: Peso o volumen aumentando consistentemente
  mejorando,

  /// Indica que el progreso se mantiene estable (→)
  /// Ejemplo: Variación menor al 5% en peso o volumen
  estable,

  /// Indica que el progreso está decayendo (↓)
  /// Ejemplo: Peso o volumen disminuyendo
  decayendo,

  /// No hay suficientes datos para determinar tendencia
  /// Ejemplo: Solo 1-2 sesiones registradas
  insuficienteDatos;

  /// Retorna el símbolo visual para mostrar en UI
  String get simbolo {
    switch (this) {
      case TendenciaProgreso.mejorando:
        return '↑';
      case TendenciaProgreso.estable:
        return '→';
      case TendenciaProgreso.decayendo:
        return '↓';
      case TendenciaProgreso.insuficienteDatos:
        return '·';
    }
  }

  /// Retorna una descripción legible en español
  String get descripcion {
    switch (this) {
      case TendenciaProgreso.mejorando:
        return 'Mejorando';
      case TendenciaProgreso.estable:
        return 'Estable';
      case TendenciaProgreso.decayendo:
        return 'Decayendo';
      case TendenciaProgreso.insuficienteDatos:
        return 'Sin datos';
    }
  }

  /// Retorna true si la tendencia es positiva (mejorando o estable)
  bool get esPositiva =>
      this == TendenciaProgreso.mejorando || this == TendenciaProgreso.estable;

  /// Retorna true si la tendencia requiere atención (decayendo)
  bool get requiereAtencion => this == TendenciaProgreso.decayendo;
}
