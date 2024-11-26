class Ejercicio {
  int? isarId;
  final String id;
  final String nombre;
  final String descripcion;
  final String imagenDireccion;
  final int cantidadRepeticiones;
  final int cantidadSeries;
  final bool estado;

  Ejercicio({
    this.isarId,
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.imagenDireccion,
    required this.cantidadRepeticiones,
    required this.cantidadSeries,
    required this.estado,
  });

  Ejercicio copyWith({
    int? isarId,
    String? id,
    String? nombre,
    String? descripcion,
    String? imagenDireccion,
    int? cantidadRepeticiones,
    int? cantidadSeries,
    bool? estado,
  }) {
    return Ejercicio(
      isarId: isarId ?? this.isarId,
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      imagenDireccion: imagenDireccion ?? this.imagenDireccion,
      cantidadRepeticiones: cantidadRepeticiones ?? this.cantidadRepeticiones,
      cantidadSeries: cantidadSeries ?? this.cantidadSeries,
      estado: estado ?? this.estado,
    );
  }

  @override
  String toString() {
    return 'Ejercicio(isarId: $isarId, id: $id, nombre: $nombre, descripcion: $descripcion, imagen: $imagenDireccion, repeticiones: $cantidadRepeticiones, series: $cantidadSeries, estado: $estado)';
  }
}
