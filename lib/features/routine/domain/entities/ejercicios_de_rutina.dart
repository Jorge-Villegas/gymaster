import 'dart:convert';

import 'package:equatable/equatable.dart';

EjerciciosDeRutina ejerciciosDeRutinaModelFromJson(String str) =>
    EjerciciosDeRutina.fromJson(json.decode(str));

String ejerciciosDeRutinaModelToJson(EjerciciosDeRutina data) =>
    json.encode(data.toJson());

String ejerciciosDeRutinaModelListToJson(List<EjerciciosDeRutina> data) =>
    json.encode(data.map((e) => e.toJson()).toList());

class EjerciciosDeRutina extends Equatable {
  final String id;
  final String? descripcion;
  final DateTime fechaCreacion;
  final bool realizado;
  final int color;
  final DateTime? fechaRealizacion;
  final String estado;
  final String rutinaId;
  final String nombre;
  final String session;
  final List<Ejercicio> ejercicios;

  const EjerciciosDeRutina({
    required this.rutinaId,
    required this.ejercicios,
    required this.nombre,
    required this.id,
    this.descripcion,
    required this.fechaCreacion,
    required this.realizado,
    required this.color,
    this.fechaRealizacion,
    required this.estado,
    required this.session,
  });

  EjerciciosDeRutina copyWith({
    String? rutinaId,
    List<Ejercicio>? ejercicios,
    String? nombre,
    String? id,
    String? descripcion,
    DateTime? fechaCreacion,
    bool? realizado,
    int? color,
    DateTime? fechaRealizacion,
    String? estado,
    String? session,
  }) {
    return EjerciciosDeRutina(
      session: session ?? this.session,
      rutinaId: rutinaId ?? this.rutinaId,
      ejercicios: ejercicios ?? this.ejercicios,
      nombre: nombre ?? this.nombre,
      id: id ?? this.id,
      descripcion: descripcion ?? this.descripcion,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      realizado: realizado ?? this.realizado,
      color: color ?? this.color,
      fechaRealizacion: fechaRealizacion ?? this.fechaRealizacion,
      estado: estado ?? this.estado,
    );
  }

  //tojson
  Map<String, dynamic> toJson() {
    return {
      'rutinaId': rutinaId,
      'ejercicios': ejercicios.map((e) => e.toJson()).toList(),
      'nombre': nombre,
      'id': id,
      'descripcion': descripcion,
      'fechaCreacion': fechaCreacion.toIso8601String(),
      'realizado': realizado,
      'color': color,
      'fechaRealizacion': fechaRealizacion?.toIso8601String(),
      'estado': estado,
      'session': session,
    };
  }

  factory EjerciciosDeRutina.fromJson(Map<String, dynamic> json) {
    return EjerciciosDeRutina(
      session: json['session'],
      rutinaId: json['rutinaId'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      fechaCreacion: DateTime.parse(json['fecha_creacion']),
      color: json['color'],
      ejercicios:
          (json['ejercicios'] as List)
              .map((e) => Ejercicio.fromJson(e))
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

  @override
  List<Object?> get props => [
    rutinaId,
    ejercicios,
    nombre,
    id,
    descripcion,
    fechaCreacion,
    realizado,
    color,
    fechaRealizacion,
    estado,
    session,
  ];

  @override
  String toString() =>
      'EjerciciosDeRutina(rutinaId: $rutinaId,nombre: $nombre, ejercicios: $ejercicios)';
}

class Ejercicio extends Equatable {
  final String id;
  final String nombre;
  final String imagenDireccion;
  final String descripcion;
  final String estado;
  final List<Serie> series;
  final List<Musculo>? musculos;
  final int cantidadSeries;
  final int orderIndex;

  const Ejercicio({
    required this.id,
    required this.nombre,
    required this.imagenDireccion,
    required this.descripcion,
    required this.series,
    this.musculos,
    required this.estado,
    required this.orderIndex,
  }) : cantidadSeries = series.length;

  //tojson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'imagenDireccion': imagenDireccion,
      'descripcion': descripcion,
      'series': series.map((e) => e.toJson()).toList(),
      'musculos': musculos?.map((e) => e.toJson()).toList(),
      'estado': estado,
      'orderIndex': orderIndex,
    };
  }

  Ejercicio copyWith({
    String? id,
    String? nombre,
    String? imagenDireccion,
    String? descripcion,
    String? estado,
    int? orderIndex,
    List<Serie>? series,
    List<Musculo>? musculos,
  }) {
    return Ejercicio(
      estado: estado ?? this.estado,
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      imagenDireccion: imagenDireccion ?? this.imagenDireccion,
      descripcion: descripcion ?? this.descripcion,
      series: series ?? this.series,
      musculos: musculos ?? this.musculos,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }

  @override
  List<Object?> get props => [
    id,
    nombre,
    imagenDireccion,
    descripcion,
    series,
    estado,
  ];

  factory Ejercicio.fromJson(Map<String, dynamic> json) => Ejercicio(
    id: json["id"],
    nombre: json["nombre"],
    imagenDireccion: json["imagen_direccion"],
    descripcion: json["descripcion"],
    estado: json["estado"],
    orderIndex: json['orderIndex'],
    series: List<Serie>.from(json["series"].map((x) => Serie.fromJson(x))),
    musculos: List<Musculo>.from(
      json["musculos"].map((x) => Musculo.fromJson(x)),
    ),
  );

  @override
  String toString() {
    return 'Ejercicio(id: $id, nombre: $nombre, imagenDireccion: $imagenDireccion, '
        'descripcion: $descripcion, series: $series, musculos: $musculos, estado: $estado)';
  }
}

class Serie extends Equatable {
  final String id;
  final double peso;
  final int repeticiones;
  final int timpoDescanso;
  final String estado;

  const Serie({
    required this.id,
    required this.peso,
    required this.repeticiones,
    required this.timpoDescanso,
    required this.estado,
  });

  //tojson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'peso': peso,
      'repeticiones': repeticiones,
      'tiempoDescanso': timpoDescanso,
      'estado': estado,
    };
  }

  Serie copyWith({
    String? id,
    double? peso,
    int? repeticiones,
    int? timpoDescanso,
    String? estado,
  }) {
    return Serie(
      id: id ?? this.id,
      peso: peso ?? this.peso,
      repeticiones: repeticiones ?? this.repeticiones,
      timpoDescanso: timpoDescanso ?? this.timpoDescanso,
      estado: estado ?? this.estado,
    );
  }

  @override
  List<Object?> get props => [id, peso, repeticiones, timpoDescanso, estado];

  @override
  String toString() =>
      'SeriesDelEjercicio(id: $id, peso: $peso, repeticiones: $repeticiones, '
      'timpoDescanso: $timpoDescanso, estado: $estado)';

  //fromjson
  factory Serie.fromJson(Map<String, dynamic> json) => Serie(
    id: json['id'],
    peso: json['peso'],
    repeticiones: json['repeticiones'],
    timpoDescanso: json['tiempoDescanso'],
    estado: json['estado'],
  );
}

class Musculo extends Equatable {
  final String id;
  final String? nombre;
  final String? imagenDireccion;

  const Musculo({required this.id, this.nombre, this.imagenDireccion});

  //tojson
  Map<String, dynamic> toJson() {
    return {'id': id, 'nombre': nombre, 'imagenDireccion': imagenDireccion};
  }

  Musculo copyWith({String? id, String? nombre, String? imagenDireccion}) {
    return Musculo(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      imagenDireccion: imagenDireccion ?? this.imagenDireccion,
    );
  }

  @override
  List<Object?> get props => [id, nombre, imagenDireccion];

  //fromjson
  factory Musculo.fromJson(Map<String, dynamic> json) => Musculo(
    id: json['id'],
    nombre: json['nombre'],
    imagenDireccion: json['imagen_direccion'],
  );
}
