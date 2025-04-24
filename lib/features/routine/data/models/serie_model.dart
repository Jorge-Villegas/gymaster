import 'package:gymaster/core/database/models/exercise_db_model.dart'
    as ejercicio_db;
import 'package:gymaster/core/database/models/exercise_set_db_model.dart'
    as serie_db;
import 'package:gymaster/features/routine/domain/entities/serie.dart';

class SerieModel extends Serie {
  const SerieModel({
    required super.id,
    required super.realizado,
    required super.tiempoDescanso,
    super.ejercicios,
  });

  SerieModel copyWith({
    String? id,
    int? cantidad,
    bool? realizado,
    int? tiempoDescanso,
    List<EjercicioModel>? ejercicios,
  }) {
    return SerieModel(
      id: id ?? this.id,
      realizado: realizado ?? this.realizado,
      tiempoDescanso: tiempoDescanso ?? this.tiempoDescanso,
      ejercicios: ejercicios ?? this.ejercicios,
    );
  }

  factory SerieModel.fromJson(Map<String, dynamic> map) {
    return SerieModel(
      id: map['id'],
      realizado: map['realizado'],
      tiempoDescanso: map['tiempo_descanso'],
      ejercicios: map['ejercicios'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'realizado': realizado,
      'tiempo_descanso': tiempoDescanso,
    };
  }

  factory SerieModel.fromDatabase({
    required serie_db.ExerciseSetDbModel serieDB,
    List<EjercicioModel>? ejercicios,
  }) {
    return SerieModel(
      id: serieDB.id,
      realizado: false, //TODO: Cambiar
      tiempoDescanso: serieDB.restTime ?? 0,
      ejercicios: ejercicios,
    );
  }
}

class EjercicioModel extends Ejercicio {
  const EjercicioModel({required super.id, required super.nombre});

  EjercicioModel copyWith({String? id, String? nombre}) {
    return EjercicioModel(id: id ?? this.id, nombre: nombre ?? this.nombre);
  }

  factory EjercicioModel.fromDatabase(
      ejercicio_db.ExerciseDbModel ejercicioDB) {
    return EjercicioModel(id: ejercicioDB.id, nombre: ejercicioDB.name);
  }
}
