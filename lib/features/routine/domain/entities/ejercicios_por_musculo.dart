class EjerciciosPorMusculo {
  final String id;
  final String nombre;
  String? descripcion;
  String? imagenDireccion;
  final List<String> musculos;

  EjerciciosPorMusculo({
    required this.id,
    required this.nombre,
    this.descripcion,
    this.imagenDireccion,
    required this.musculos,
  });

  EjerciciosPorMusculo copyWith({
    String? id,
    String? nombre,
    String? descripcion,
    String? imagenDireccion,
    List<String>? musculos,
  }) =>
      EjerciciosPorMusculo(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        descripcion: descripcion ?? this.descripcion,
        imagenDireccion: imagenDireccion ?? this.imagenDireccion,
        musculos: musculos ?? this.musculos,
      );

  @override
  String toString() {
    return 'EjerciciosPorMusculo{id: $id, nombre: $nombre, musculos: $musculos}';
  }
}
