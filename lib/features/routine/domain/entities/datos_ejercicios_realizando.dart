class DatosEjerciciosRealizando {
  final String id;
  final String nombre;
  final String imagenDireccion;
  final String descripcion;
  final List<SeriesDelEjercicio> seriesDelEjercicio;
  final int serieActual;
  final int cantidadSeries; //Sumatoria de las series

  DatosEjerciciosRealizando({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.seriesDelEjercicio,
    required this.cantidadSeries,
    required this.serieActual,
    required this.imagenDireccion,
  });

  DatosEjerciciosRealizando copyWith({
    String? id,
    String? nombre,
    String? imagenDireccion,
    String? descripcion,
    List<SeriesDelEjercicio>? seriesDelEjercicio,
    int? serieActual,
    int? cantidadSeries,
  }) {
    return DatosEjerciciosRealizando(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      imagenDireccion: imagenDireccion ?? this.imagenDireccion,
      descripcion: descripcion ?? this.descripcion,
      seriesDelEjercicio: seriesDelEjercicio ?? this.seriesDelEjercicio,
      serieActual: serieActual ?? this.serieActual,
      cantidadSeries: cantidadSeries ?? this.cantidadSeries,
    );
  }
}

class SeriesDelEjercicio {
  final String id;
  final double peso;
  final int repeticiones;
  final int timpoDescanso;
  final bool realizado;

  SeriesDelEjercicio({
    required this.id,
    required this.peso,
    required this.repeticiones,
    required this.timpoDescanso,
    required this.realizado,
  });

  SeriesDelEjercicio copyWith({
    String? id,
    double? peso,
    int? repeticiones,
    int? timpoDescanso,
    bool? realizado,
  }) {
    return SeriesDelEjercicio(
      id: id ?? this.id,
      peso: peso ?? this.peso,
      repeticiones: repeticiones ?? this.repeticiones,
      timpoDescanso: timpoDescanso ?? this.timpoDescanso,
      realizado: realizado ?? this.realizado,
    );
  }
}
