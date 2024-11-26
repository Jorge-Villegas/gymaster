import 'package:equatable/equatable.dart';

class Ejercicio extends Equatable {
  final String id;
  final String nombre;
  final String imagenDireccion;
  final String descripcion;

  Ejercicio({
    required this.id,
    required this.nombre,
    required this.imagenDireccion,
    required this.descripcion,
  });

  Ejercicio copyWith({
    String? id,
    String? nombre,
    String? imagenDireccion,
    String? descripcion,
  }) {
    return Ejercicio(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      imagenDireccion: imagenDireccion ?? this.imagenDireccion,
      descripcion: descripcion ?? this.descripcion,
    );
  }

  @override
  List<Object> get props => [id, nombre, imagenDireccion, descripcion];
}

class Serie extends Equatable {
  final String id;
  final double peso;
  final int repeticiones;
  final int timpoDescanso;
  final bool realizado;

  Serie({
    required this.id,
    required this.peso,
    required this.repeticiones,
    required this.timpoDescanso,
    required this.realizado,
  });

  Serie copyWith({
    String? id,
    double? peso,
    int? repeticiones,
    int? timpoDescanso,
    bool? realizado,
  }) {
    return Serie(
      id: id ?? this.id,
      peso: peso ?? this.peso,
      repeticiones: repeticiones ?? this.repeticiones,
      timpoDescanso: timpoDescanso ?? this.timpoDescanso,
      realizado: realizado ?? this.realizado,
    );
  }

  @override
  List<Object> get props => [id, peso, repeticiones, timpoDescanso, realizado];
}
