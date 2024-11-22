class EjercicioMusculo {
  String ejercicioId;
  String musculoId;

  EjercicioMusculo({required this.ejercicioId, required this.musculoId});

  factory EjercicioMusculo.fromJson(Map<String, dynamic> json) {
    return EjercicioMusculo(
      ejercicioId: json['ejercicioId'],
      musculoId: json['musculoId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ejercicioId': ejercicioId,
      'musculoId': musculoId,
    };
  }

  @override
  String toString() {
    return 'EjercicioMusculo{ejercicioId: $ejercicioId, musculoId: $musculoId}';
  }
}