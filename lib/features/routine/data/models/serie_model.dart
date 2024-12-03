import 'package:gymaster/features/routine/domain/entities/serie.dart';
import 'package:gymaster/core/database/models/serie.dart' as serieDB;
import 'package:gymaster/core/database/models/ejercicio.dart' as ejercicioDB;

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
    required serieDB.Serie serieDB,
    List<EjercicioModel>? ejercicios,
  }) {
    return SerieModel(
      id: serieDB.id,
      realizado: serieDB.realizado == 1,
      tiempoDescanso: serieDB.tiempoDescanso,
      ejercicios: ejercicios,
    );
  }
}

class EjercicioModel extends Ejercicio {
  const EjercicioModel({
    required super.id,
    required super.nombre,
  });

  EjercicioModel copyWith({
    String? id,
    String? nombre,
  }) {
    return EjercicioModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
    );
  }

  factory EjercicioModel.fromDatabase(ejercicioDB.Ejercicio ejercicioDB) {
    return EjercicioModel(
      id: ejercicioDB.id,
      nombre: ejercicioDB.nombre,
    );
  }
}
