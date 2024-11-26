
import 'package:gymaster/features/routine/domain/entities/serie.dart';

class SerieModel extends Serie {
  SerieModel({
    required super.id,
    required super.realizado,
    required super.tiempoDescanso,
    super.ejercicios,
  });

  SerieModel copyWith({
    int? id,
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
      tiempoDescanso: map['tiempoDescanso'],
      ejercicios: map['ejercicios'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'realizado': realizado,
      'tiempoDescanso': tiempoDescanso,
    };
  }

}

class EjercicioModel extends Ejercicio {
  EjercicioModel({
    required super.id,
    required super.nombre,
  });

  EjercicioModel copyWith({
    int? id,
    String? nombre,
  }) {
    return EjercicioModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
    );
  }
}
