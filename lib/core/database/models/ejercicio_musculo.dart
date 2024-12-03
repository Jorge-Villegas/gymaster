class EjercicioMusculo {
  String ejercicioId;
  String musculoId;

  EjercicioMusculo({required this.ejercicioId, required this.musculoId});

  factory EjercicioMusculo.fromJson(Map<String, dynamic> json) {
    return EjercicioMusculo(
      ejercicioId: json['ejercicio_id'],
      musculoId: json['musculo_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ejercicio_id': ejercicioId,
      'musculo_id': musculoId,
    };
  }

  @override
  String toString() {
    return 'EjercicioMusculo{ejercicioId: $ejercicioId, musculoId: $musculoId}';
  }
}