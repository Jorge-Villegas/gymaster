class Musculo {
  final String id;
  final String nombre;
  final String imagenDirecion;

  Musculo({
    required this.id,
    required this.nombre,
    required this.imagenDirecion,
  });

  @override
  String toString() =>
      'Musculo(id: $id, nombre: $nombre, imagenDirecion: $imagenDirecion)';
}
