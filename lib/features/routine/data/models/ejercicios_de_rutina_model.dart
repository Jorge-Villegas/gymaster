import 'package:gymaster/features/routine/domain/entities/ejercicios_de_rutina.dart';
import 'package:gymaster/core/database/models/musculo.dart' as musculo_db;
import 'package:gymaster/core/database/models/rutina.dart' as rutina_db;
import 'package:gymaster/core/database/models/serie.dart' as serie_db;
import 'package:gymaster/core/database/models/ejercicio.dart' as ejercicio_db;
import 'dart:convert';

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
  });

  factory EjerciciosDeRutinaModel.fromJson(Map<String, dynamic> json) {
    return EjerciciosDeRutinaModel(
      rutinaId: json['rutinaId'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      fechaCreacion: DateTime.parse(json['fecha_creacion']),
      color: json['color'],
      ejercicios: (json['ejercicios'] as List)
          .map((e) => EjercicioModel.fromJson(e))
          .toList(),
      estado: json['estado'],
      id: json['id'],
      realizado: json['realizado'],
      fechaRealizacion: json['fecha_realizacion'] != null
          ? DateTime.parse(json['fecha_realizacion'])
          : null,
    );
  }

  factory EjerciciosDeRutinaModel.fromDatabase(
    rutina_db.Rutina rutinaDB,
    List<EjercicioModel> ejercicios,
  ) {
    return EjerciciosDeRutinaModel(
      rutinaId: rutinaDB.id,
      nombre: rutinaDB.nombre,
      descripcion: rutinaDB.descripcion,
      fechaCreacion: DateTime.parse(rutinaDB.fechaCreacion),
      color: rutinaDB.color,
      ejercicios: ejercicios,
      estado: rutinaDB.estado == 1,
      id: rutinaDB.id,
      realizado: rutinaDB.realizado == 1,
      fechaRealizacion: rutinaDB.fechaRealizacion != null
          ? DateTime.parse(rutinaDB.fechaRealizacion!)
          : null,
    );
  }
}

class EjercicioModel extends Ejercicio {
  const EjercicioModel({
    required super.id,
    required super.nombre,
    required super.imagenDireccion,
    required super.descripcion,
    required super.series,
    super.musculos,
  });

  factory EjercicioModel.fromDatabase({
    required ejercicio_db.Ejercicio ejercicioDB,
    List<SeriesDelEjercicioModel>? series,
    List<MusculoModel>? musculos,
  }) {
    return EjercicioModel(
      id: ejercicioDB.id,
      nombre: ejercicioDB.nombre,
      imagenDireccion: ejercicioDB.imagenDireccion ?? '',
      descripcion: ejercicioDB.descripcion ?? '',
      series: series ?? [],
      musculos: musculos ?? [],
    );
  }

  factory EjercicioModel.fromJson(Map<String, dynamic> json) => EjercicioModel(
        id: json["id"],
        nombre: json["nombre"],
        imagenDireccion: json["imagen_direccion"],
        descripcion: json["descripcion"],
        series: List<SeriesDelEjercicioModel>.from(
            json["series"].map((x) => SeriesDelEjercicioModel.fromJson(x))),
        musculos: List<MusculoModel>.from(
            json["musculos"].map((x) => MusculoModel.fromJson(x))),
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "imagen_direccion": imagenDireccion,
        "descripcion": descripcion,
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
    required super.realizado,
  });

  factory SeriesDelEjercicioModel.fromJson(Map<String, dynamic> json) =>
      SeriesDelEjercicioModel(
        id: json['id'],
        peso: json['peso'],
        repeticiones: json['repeticiones'],
        timpoDescanso: json['timpo_descanso'],
        realizado: json['realizado'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'peso': peso,
        'repeticiones': repeticiones,
        'timpo_descanso': timpoDescanso,
        'realizado': realizado,
      };

  factory SeriesDelEjercicioModel.fromDatabase(serie_db.Serie serieDB) {
    return SeriesDelEjercicioModel(
      id: serieDB.id,
      peso: serieDB.peso,
      repeticiones: serieDB.repeticiones,
      timpoDescanso: serieDB.tiempoDescanso,
      realizado: serieDB.realizado == 1,
    );
  }
}

class MusculoModel extends Musculo {
 const  MusculoModel({
    required super.id,
    required super.nombre,
    required super.imagenDireccion,
  });

  factory MusculoModel.fromDatabase(musculo_db.Musculo musculoDB) {
    return MusculoModel(
      id: musculoDB.id,
      nombre: musculoDB.nombre,
      imagenDireccion: musculoDB.imagenDireccion ?? '',
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
    return {
      'id': id,
      'nombre': nombre,
      'imagen_direccion': imagenDireccion,
    };
  }
}
