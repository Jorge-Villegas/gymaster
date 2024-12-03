class DetalleRutina {
  final String id;
  final String rutinaId;
  final String ejercicioId;

  DetalleRutina({
    required this.id,
    required this.rutinaId,
    required this.ejercicioId,
  });

  factory DetalleRutina.fromJson(Map<String, dynamic> json) {
    return DetalleRutina(
      id: json['id'],
      rutinaId: json['rutina_id'],
      ejercicioId: json['ejercicio_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rutina_id': rutinaId,
      'ejercicio_id': ejercicioId,
    };
  }

  DetalleRutina copyWith({
    String? id,
    String? rutinaId,
    String? ejercicioId,
    String? serieId,
  }) {
    return DetalleRutina(
      id: id ?? this.id,
      rutinaId: rutinaId ?? this.rutinaId,
      ejercicioId: ejercicioId ?? this.ejercicioId,
    );
  }

  @override
  String toString() {
    return 'DetalleRutina{id: $id, rutinaId: $rutinaId, ejercicioId: $ejercicioId}';
  }
}