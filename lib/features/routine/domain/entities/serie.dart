import 'package:equatable/equatable.dart';

class Serie extends Equatable {
  final String id;
  final bool realizado;
  final int tiempoDescanso;
  final List<Ejercicio>? ejercicios;

  const Serie({
    required this.id,
    required this.realizado,
    required this.tiempoDescanso,
    this.ejercicios,
  });

  @override
  String toString() {
    return 'Serie{id: $id, realizado: $realizado, tiempoDescanso: $tiempoDescanso, ejercicios: $ejercicios}';
  }

  @override
  List<Object?> get props => [id, realizado, tiempoDescanso, ejercicios];
}

class Ejercicio extends Equatable {
  final String id;
  final String nombre;

  const Ejercicio({
    required this.id,
    required this.nombre,
  });

  @override
  String toString() {
    return 'Ejercicio{id: $id, nombre: $nombre}';
  }

  @override
  List<Object?> get props => [id, nombre];
}
