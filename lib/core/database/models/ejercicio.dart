class Ejercicio {
  String id;
  String nombre;
  String? descripcion;
  String? imagenDireccion;

  Ejercicio({
    required this.id,
    required this.nombre,
    this.descripcion,
    this.imagenDireccion,
  });

  factory Ejercicio.fromJson(Map<String, dynamic> json) {
    return Ejercicio(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      imagenDireccion: json['imagenDireccion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'imagenDireccion': imagenDireccion,
    };
  }
  
  @override
  String toString() {
    return 'Ejercicio{id: $id, nombre: $nombre, descripcion: $descripcion, imagenDireccion: $imagenDireccion}';
  }
}
