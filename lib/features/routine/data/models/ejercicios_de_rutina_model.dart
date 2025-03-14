import 'dart:convert';

import 'package:gymaster/core/database/models/models.dart';
import 'package:gymaster/features/routine/domain/entities/ejercicios_de_rutina.dart';

EjerciciosDeRutinaModel ejerciciosDeRutinaModelFromJson(String str) =>
    EjerciciosDeRutinaModel.fromJson(json.decode(str));

String ejerciciosDeRutinaModelToJson(EjerciciosDeRutinaModel data) =>
    json.encode(data.toJson());

String ejerciciosDeRutinaModelListToJson(List<EjerciciosDeRutinaModel> data) =>
    json.encode(data.map((e) => e.toJson()).toList());

class EjerciciosDeRutinaModel extends EjerciciosDeRutina {
  const EjerciciosDeRutinaModel({
    required super.rutinaId,
    required super.ejercicios,
    required super.nombre,
    required super.id,
    required super.descripcion,
    required super.fechaCreacion,
    required super.realizado,
    required super.color,
    required super.fechaRealizacion,
    required super.estado,
    required super.session,
  });

  factory EjerciciosDeRutinaModel.fromJson(Map<String, dynamic> json) {
    return EjerciciosDeRutinaModel(
      session: json['session'],
      rutinaId: json['rutinaId'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      fechaCreacion: DateTime.parse(json['fecha_creacion']),
      color: json['color'],
      ejercicios:
          (json['ejercicios'] as List)
              .map((e) => EjercicioModel.fromJson(e))
              .toList(),
      estado: json['estado'],
      id: json['id'],
      realizado: json['realizado'],
      fechaRealizacion:
          json['fecha_realizacion'] != null
              ? DateTime.parse(json['fecha_realizacion'])
              : null,
    );
  }

  factory EjerciciosDeRutinaModel.fromDatabase({
    required Routine rutinaDB,
    required String status,
    required List<EjercicioModel> ejercicios,
    required String session,
  }) {
    return EjerciciosDeRutinaModel(
      session: session,
      rutinaId: rutinaDB.id,
      nombre: rutinaDB.name,
      descripcion: rutinaDB.description,
      fechaCreacion: DateTime.parse(rutinaDB.createdAt),
      color: rutinaDB.color ?? 0,
      ejercicios: ejercicios,
      estado: status,
      id: rutinaDB.id,
      realizado: true, //TODO: Cambiar
      fechaRealizacion:
          rutinaDB.createdAt != rutinaDB.updatedAt
              ? DateTime.parse(rutinaDB.createdAt)
              : null, //TODO: Cambiar
    );
  }
}

class EjercicioModel extends Ejercicio {
  const EjercicioModel({
    required super.id,
    required super.nombre,
    required super.estado,
    required super.imagenDireccion,
    required super.descripcion,
    required super.series,
    required super.orderIndex,
    super.musculos,
  });

  factory EjercicioModel.fromDatabase({
    required Exercise ejercicioDB,
    required String status,
    required int orderIndex,
    List<SeriesDelEjercicioModel>? series,
    List<MusculoModel>? musculos,
  }) {
    return EjercicioModel(
      estado: status,
      id: ejercicioDB.id,
      nombre: ejercicioDB.name,
      imagenDireccion: ejercicioDB.imagePath ?? '',
      descripcion: ejercicioDB.description ?? '',
      series: series ?? [],
      musculos: musculos ?? [],
      orderIndex: orderIndex,
    );
  }

  factory EjercicioModel.fromJson(Map<String, dynamic> json) => EjercicioModel(
    id: json["id"],
    nombre: json["nombre"],
    imagenDireccion: json["imagen_direccion"],
    descripcion: json["descripcion"],
    estado: json["estado"],
    orderIndex: json["order_index"],
    series: List<SeriesDelEjercicioModel>.from(
      json["series"].map((x) => SeriesDelEjercicioModel.fromJson(x)),
    ),
    musculos: List<MusculoModel>.from(
      json["musculos"].map((x) => MusculoModel.fromJson(x)),
    ),
  );

  @override
  Map<String, dynamic> toJson() => {
    "id": id,
    "nombre": nombre,
    "imagen_direccion": imagenDireccion,
    "descripcion": descripcion,
    "estado": estado,
    "order_index": orderIndex,
    "series": List<dynamic>.from(series.map((x) => x.toJson())),
    "musculos": List<dynamic>.from(musculos!.map((x) => x.toJson())),
  };
}

class SeriesDelEjercicioModel extends Serie {
  const SeriesDelEjercicioModel({
    required super.id,
    required super.peso,
    required super.repeticiones,
    required super.timpoDescanso,
    required super.estado,
  });

  factory SeriesDelEjercicioModel.fromJson(Map<String, dynamic> json) =>
      SeriesDelEjercicioModel(
        id: json['id'],
        peso: json['peso'],
        repeticiones: json['repeticiones'],
        timpoDescanso: json['timpo_descanso'],
        estado: json['realizado'],
      );

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'peso': peso,
    'repeticiones': repeticiones,
    'timpo_descanso': timpoDescanso,
    'realizado': estado,
  };

  factory SeriesDelEjercicioModel.fromDatabase(ExerciseSet serieDB) {
    return SeriesDelEjercicioModel(
      id: serieDB.id,
      peso: serieDB.weight ?? 0,
      repeticiones: serieDB.repetitions ?? 0,
      timpoDescanso: serieDB.restTime ?? 0,
      estado: serieDB.status,
    );
  }
}

class MusculoModel extends Musculo {
  const MusculoModel({
    required super.id,
    required super.nombre,
    required super.imagenDireccion,
  });

  factory MusculoModel.fromDatabase(Muscle musculoDB) {
    return MusculoModel(
      id: musculoDB.id,
      nombre: musculoDB.name,
      imagenDireccion: musculoDB.imagePath ?? '',
    );
  }

  factory MusculoModel.fromJson(Map<String, dynamic> json) {
    return MusculoModel(
      id: json['id'],
      nombre: json['nombre'],
      imagenDireccion: json['imagen_direccion'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {'id': id, 'nombre': nombre, 'imagen_direccion': imagenDireccion};
  }
}
