import 'dart:convert';

Ejercicio ejercicioFromJson(String str) => Ejercicio.fromJson(json.decode(str));

String ejercicioToJson(Ejercicio data) => json.encode(data.toJson());

String ejerciciosToJson(List<Ejercicio> data) => json.encode(data.map((e) => e.toJson()).toList());

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
