class Rutina {
  String id;
  String nombre;
  String? descripcion;
  String fechaCreacion;
  int realizado;
  int color;
  String? fechaRealizacion;
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
  });

  factory Rutina.fromJson(Map<String, dynamic> json) {
    return Rutina(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      fechaCreacion: json['fechaCreacion'],
      realizado: json['realizado'],
      color: json['color'],
      fechaRealizacion: json['fechaRealizacion'],
      estado: json['estado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'fechaCreacion': fechaCreacion,
      'realizado': realizado,
      'color': color,
      'fechaRealizacion': fechaRealizacion,
      'estado': estado,
    };
  }

  @override
  String toString() {
    return 'Rutina{id: $id, nombre: $nombre, descripcion: $descripcion, fechaCreacion: $fechaCreacion, realizado: $realizado, color: $color, fechaRealizacion: $fechaRealizacion, estado: $estado}';
  }
}