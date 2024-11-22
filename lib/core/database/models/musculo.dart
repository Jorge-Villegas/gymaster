class Musculo {
  String id;
  String nombre;
  String? imagenDireccion;

  Musculo({
    required this.id,
    required this.nombre,
    this.imagenDireccion,
  });

  factory Musculo.fromJson(Map<String, dynamic> json) {
    return Musculo(
      id: json['id'],
      nombre: json['nombre'],
      imagenDireccion: json['imagenDireccion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'imagenDireccion': imagenDireccion,
    };
  }
  @override
  String toString() {
    return 'Musculo{id: $id, nombre: $nombre, imagenDireccion: $imagenDireccion}';
  }
}
