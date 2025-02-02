/// Convierte una lista de mapas a una lista de objetos Rutina
List<Rutina> listaRutinasFromMapList(List<Map<String, dynamic>> mapList) {
  return mapList.map((map) => Rutina.fromJson(map)).toList();
}

class Rutina {
  String id;
  String nombre;
  String? descripcion;
  String fechaCreacion;
  int realizado;
  int color;
  String? fechaRealizacion;
  String imageDireccion;
  int estado;

  Rutina({
    required this.id,
    required this.nombre,
    this.descripcion,
    required this.fechaCreacion,
    required this.realizado,
    required this.color,
    this.fechaRealizacion,
    required this.estado,
    required this.imageDireccion,
  });

  // Convierte un JSON a un objeto Rutina
  factory Rutina.fromJson(Map<String, dynamic> json) {
    return Rutina(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      fechaCreacion: json['fecha_creacion'],
      realizado: json['realizado'],
      color: json['color'],
      fechaRealizacion: json['fecha_realizacion'],
      estado: json['estado'],
      imageDireccion: json['imagen_direccion'],
    );
  }

  // Convierte un objeto Rutina a un JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'fecha_creacion': fechaCreacion,
      'realizado': realizado,
      'color': color,
      'fecha_realizacion': fechaRealizacion,
      'estado': estado,
      'imagen_direccion': imageDireccion,
    };
  }

  @override
  String toString() {
    return 'Rutina{id: $id, nombre: $nombre, descripcion: $descripcion, fechaCreacion: $fechaCreacion, realizado: $realizado, color: $color, fechaRealizacion: $fechaRealizacion, estado: $estado, imagen_direccion: $imageDireccion}';
  }
}
