import 'dart:convert';

SerieEjercicioDbModel exerciseSetFromJson(String str) =>
    SerieEjercicioDbModel.fromJson(json.decode(str));

String exerciseSetToJson(SerieEjercicioDbModel data) =>
    json.encode(data.toJson());

class SerieEjercicioDbModel {
  // Nombres de las columnas de la tabla
  static const String tabla = 'serie_ejercicio';
  static const String columnaId = 'id';
  static const String columnaEjercicioSesionId = 'session_exercise_id';
  static const String columnaPeso = 'peso';
  static const String columnaRepeticiones = 'repeticiones';
  static const String columnaTiempoDescanso = 'tiempo_descanso';
  static const String columnaEstado = 'estado';

  final String id;
  final String ejercicioSesionId;
  final double? peso;
  final int? repeticiones;
  final int? tiempoDescanso;
  final String estado;

  SerieEjercicioDbModel({
    required this.id,
    required this.ejercicioSesionId,
    this.peso,
    this.repeticiones,
    this.tiempoDescanso,
    required this.estado,
  });

  SerieEjercicioDbModel copyWith({
    String? id,
    String? ejercicioSesionId,
    double? peso,
    int? repeticiones,
    int? tiempoDescanso,
    String? estado,
  }) =>
      SerieEjercicioDbModel(
        id: id ?? this.id,
        ejercicioSesionId: ejercicioSesionId ?? this.ejercicioSesionId,
        peso: peso ?? this.peso,
        repeticiones: repeticiones ?? this.repeticiones,
        tiempoDescanso: tiempoDescanso ?? this.tiempoDescanso,
        estado: estado ?? this.estado,
      );

  factory SerieEjercicioDbModel.fromJson(Map<String, dynamic> json) =>
      SerieEjercicioDbModel(
        id: json["id"],
        ejercicioSesionId: json["session_exercise_id"],
        peso: json["peso"],
        repeticiones: json["repeticiones"],
        tiempoDescanso: json["tiempo_descanso"],
        estado: json["estado"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "session_exercise_id": ejercicioSesionId,
        "peso": peso,
        "repeticiones": repeticiones,
        "tiempo_descanso": tiempoDescanso,
        "estado": estado,
      };
}
