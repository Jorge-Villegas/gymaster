class FavoritoEjercicio {
  final String? id;
  final String ejercicioId;
  final DateTime fechaAgregado;

  const FavoritoEjercicio({
    this.id,
    required this.ejercicioId,
    required this.fechaAgregado,
  });

  /// Copia la instancia con nuevos valores
  FavoritoEjercicio copyWith({
    String? id,
    String? ejercicioId,
    DateTime? fechaAgregado,
  }) =>
      FavoritoEjercicio(
        id: id ?? this.id,
        ejercicioId: ejercicioId ?? this.ejercicioId,
        fechaAgregado: fechaAgregado ?? this.fechaAgregado,
      );

  /// Convierte desde JSON para serialización
  factory FavoritoEjercicio.fromJson(Map<String, dynamic> json) =>
      FavoritoEjercicio(
        id: json["id"],
        ejercicioId: json["ejercicio_id"],
        fechaAgregado: DateTime.parse(json["fecha_agregado"]),
      );

  /// Convierte a JSON para serialización
  Map<String, dynamic> toJson() => {
        "id": id,
        "ejercicio_id": ejercicioId,
        "fecha_agregado": fechaAgregado.toIso8601String(),
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoritoEjercicio &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          ejercicioId == other.ejercicioId;

  @override
  int get hashCode => id.hashCode ^ ejercicioId.hashCode;

  @override
  String toString() {
    return 'FavoritoEjercicio{id: $id, ejercicioId: $ejercicioId, fechaAgregado: $fechaAgregado}';
  }
}
