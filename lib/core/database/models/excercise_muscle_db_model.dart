import 'dart:convert';

EjercicioMusculoDbModel exerciseMuscleFromJson(String str) =>
    EjercicioMusculoDbModel.fromJson(json.decode(str));

String exerciseMuscleToJson(EjercicioMusculoDbModel data) =>
    json.encode(data.toJson());

class EjercicioMusculoDbModel {
  // Nombres de las columnas de la tabla
  static const String tabla = 'ejercicio_musculo';
  static const String columnaEjercicioId = 'ejercicio_id';
  static const String columnaMusculoId = 'musculo_id';

  final String ejercicioId;
  final String musculoId;

  EjercicioMusculoDbModel({required this.ejercicioId, required this.musculoId});

  EjercicioMusculoDbModel copyWith({String? ejercicioId, String? musculoId}) =>
      EjercicioMusculoDbModel(
        ejercicioId: ejercicioId ?? this.ejercicioId,
        musculoId: musculoId ?? this.musculoId,
      );

  factory EjercicioMusculoDbModel.fromJson(Map<String, dynamic> json) =>
      EjercicioMusculoDbModel(
        ejercicioId: json["ejercicio_id"],
        musculoId: json["musculo_id"],
      );

  Map<String, dynamic> toJson() => {
        "ejercicio_id": ejercicioId,
        "musculo_id": musculoId,
      };
}
