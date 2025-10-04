/// Enumeración que representa los diferentes periodos de tiempo
/// disponibles para filtrar las estadísticas de ejercicios.
enum PeriodoTiempo {
  /// Muestra estadísticas del día actual (desde las 00:00 hasta ahora)
  hoy,

  /// Muestra estadísticas de los últimos 7 días
  semanaActual,

  /// Muestra estadísticas de los últimos 30 días
  mesActual,

  /// Muestra estadísticas de los últimos 365 días
  anoActual,

  /// Muestra todas las estadísticas históricas sin límite de tiempo
  todoElTiempo,

  /// Permite seleccionar un rango personalizado de fechas
  rangoPersonalizado;

  /// Obtiene el rango de fechas (inicio, fin) correspondiente a este periodo.
  ///
  /// Para [rangoPersonalizado], retorna null y debe manejarse externamente.
  ///
  /// Returns:
  /// - (DateTime inicio, DateTime fin) para periodos predefinidos
  /// - null para rangoPersonalizado (debe proporcionarse externamente)
  (DateTime, DateTime)? obtenerRangoFechas() {
    final ahora = DateTime.now();

    switch (this) {
      case PeriodoTiempo.hoy:
        final inicioDelDia = DateTime(ahora.year, ahora.month, ahora.day);
        return (inicioDelDia, ahora);

      case PeriodoTiempo.semanaActual:
        final hace7Dias = ahora.subtract(const Duration(days: 7));
        return (hace7Dias, ahora);

      case PeriodoTiempo.mesActual:
        final hace30Dias = ahora.subtract(const Duration(days: 30));
        return (hace30Dias, ahora);

      case PeriodoTiempo.anoActual:
        final hace365Dias = ahora.subtract(const Duration(days: 365));
        return (hace365Dias, ahora);

      case PeriodoTiempo.todoElTiempo:
        // Fecha inicial arbitraria muy antigua (1 de enero de 2020)
        final inicioHistorico = DateTime(2020, 1, 1);
        return (inicioHistorico, ahora);

      case PeriodoTiempo.rangoPersonalizado:
        // Debe manejarse externamente
        return null;
    }
  }

  /// Retorna una etiqueta legible en español para mostrar en UI
  String get etiqueta {
    switch (this) {
      case PeriodoTiempo.hoy:
        return 'Hoy';
      case PeriodoTiempo.semanaActual:
        return 'Semana';
      case PeriodoTiempo.mesActual:
        return 'Mes';
      case PeriodoTiempo.anoActual:
        return 'Año';
      case PeriodoTiempo.todoElTiempo:
        return 'Todo';
      case PeriodoTiempo.rangoPersonalizado:
        return 'Rango';
    }
  }
}
