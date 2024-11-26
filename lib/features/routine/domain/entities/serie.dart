class Serie {
  int? id;
  final bool realizado;
  final int tiempoDescanso;
  List<Ejercicio>? ejercicios;

  Serie({
    this.id,
    required this.realizado,
    required this.tiempoDescanso,
    this.ejercicios,
  });

  @override
  String toString() {
    return 'Serie{id: $id, realizado: $realizado, tiempoDescanso: $tiempoDescanso, ejercicios: $ejercicios}';
  }
}

class Ejercicio {
  final int id;
  final String nombre;

  Ejercicio({
    required this.id,
    required this.nombre,
  });

  @override
  String toString() {
    return 'Ejercicio{id: $id, nombre: $nombre}';
  }
}
