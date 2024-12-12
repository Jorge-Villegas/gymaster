import 'dart:convert';

/// Convierte un JSON string a un objeto Ejercicio
Ejercicio ejercicioFromJson(String str) => Ejercicio.fromJson(json.decode(str));

/// Convierte un objeto Ejercicio a un JSON string
String ejercicioToJson(Ejercicio data) => json.encode(data.toJson());

/// Convierte una lista de objetos Ejercicio a un JSON string
String ejerciciosToJson(List<Ejercicio> data) =>
    json.encode(data.map((e) => e.toJson()).toList());

/// Convierte un JSON string a una lista de objetos Ejercicio
List<Ejercicio> listaEjerciciosFromJson(String str) {
  final jsonData = json.decode(str) as List;
  return jsonData.map((item) => Ejercicio.fromJson(item)).toList();
}

/// Convierte una lista de objetos Ejercicio a un JSON string
String listaEjerciciosToJson(List<Ejercicio> data) {
  final jsonData = data.map((item) => item.toJson()).toList();
  return json.encode(jsonData);
}

/// Convierte una lista de mapas a una lista de objetos Ejercicio
List<Ejercicio> listaEjerciciosFromMapList(List<Map<String, dynamic>> mapList) {
  return mapList.map((map) => Ejercicio.fromJson(map)).toList();
}


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

  // Convierte un JSON a un objeto Ejercicio
  factory Ejercicio.fromJson(Map<String, dynamic> json) {
    return Ejercicio(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      imagenDireccion: json['imagen_direccion'],
    );
  }

  // Convierte un objeto Ejercicio a un JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'imagen_direccion': imagenDireccion,
    };
  }

  @override
  String toString() {
    return 'Ejercicio{id: $id, nombre: $nombre, descripcion: $descripcion, imagenDireccion: $imagenDireccion}';
  }
}
