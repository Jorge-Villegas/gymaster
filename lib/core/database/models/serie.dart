import 'dart:convert';

Serie serieFromJson(String str) => Serie.fromJson(json.decode(str));

String serieToJson(Serie data) => json.encode(data.toJson());

String seriesListToJson(List<Serie> data) =>
    json.encode(data.map((e) => e.toJson()).toList());

class Serie {
  final String id;
  final double peso;
  final int repeticiones;
  final int realizado;
  final int tiempoDescanso;
  final String detalleRutinaId;

  Serie({
    required this.id,
    required this.peso,
    required this.repeticiones,
    required this.realizado,
    required this.tiempoDescanso,
    required this.detalleRutinaId,
  });

  factory Serie.fromJson(Map<String, dynamic> json) {
    return Serie(
      id: json['id'],
      peso: json['peso'],
      repeticiones: json['repeticiones'],
      realizado: json['realizado'],
      tiempoDescanso: json['tiempo_descanso'],
      detalleRutinaId: json['detalle_rutina_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'peso': peso,
      'repeticiones': repeticiones,
      'realizado': realizado,
      'tiempo_descanso': tiempoDescanso,
      'detalle_rutina_id': detalleRutinaId,
    };
  }

  Serie copyWith(
      {String? id,
      double? peso,
      int? repeticiones,
      int? realizado,
      int? tiempoDescanso}) {
    return Serie(
      id: id ?? this.id,
      peso: peso ?? this.peso,
      repeticiones: repeticiones ?? this.repeticiones,
      realizado: realizado ?? this.realizado,
      tiempoDescanso: tiempoDescanso ?? this.tiempoDescanso,
      detalleRutinaId: detalleRutinaId,
    );
  }
}
