class Serie {
  final String id;
  final double peso;
  final int repeticiones;
  final int realizado;
  final int tiempoDescanso;
  final String rutinaId;
  final String ejercicioId;

  Serie({
    required this.id,
    required this.peso,
    required this.repeticiones,
    required this.realizado,
    required this.tiempoDescanso,
    required this.rutinaId,
    required this.ejercicioId,
  });

  // Convierte un JSON a un objeto Serie
  factory Serie.fromJson(Map<String, dynamic> json) {
    return Serie(
      id: json['id'],
      peso: json['peso'],
      repeticiones: json['repeticiones'],
      realizado: json['realizado'],
      tiempoDescanso: json['tiempoDescanso'],
      rutinaId: json['rutinaId'],
      ejercicioId: json['ejercicioId'],
    );
  }

  // Convierte un objeto Serie a un JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'peso': peso,
      'repeticiones': repeticiones,
      'realizado': realizado,
      'tiempoDescanso': tiempoDescanso,
      'rutinaId': rutinaId,
      'ejercicioId': ejercicioId,
    };
  }

  @override
  String toString() {
    return 'Serie(id: $id, peso: $peso, repeticiones: $repeticiones, realizado: $realizado, tiempoDescanso: $tiempoDescanso, rutinaId: $rutinaId, ejercicioId: $ejercicioId)';
  }
}
