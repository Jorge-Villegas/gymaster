import 'package:equatable/equatable.dart';

class EjerciciosDeRutina extends Equatable {
  final String id;
  final String? descripcion;
  final DateTime fechaCreacion;
  final bool realizado;
  final int color;
  final DateTime? fechaRealizacion;
  final bool estado;

  final String rutinaId;
  final String nombre;
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
    bool? estado,
  }) {
    return EjerciciosDeRutina(
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
    };
  }

  @override
  List<Object?> get props => [rutinaId, ejercicios, nombre];

  @override
  String toString() =>
      'EjerciciosDeRutina(rutinaId: $rutinaId,nombre: $nombre, ejercicios: $ejercicios)';
}

class Ejercicio extends Equatable {
  final String id;
  final String nombre;
  final String imagenDireccion;
  final String descripcion;
  final List<Serie> series;
  final List<Musculo>? musculos;
  final int cantidadSeries;

  const Ejercicio({
    required this.id,
    required this.nombre,
    required this.imagenDireccion,
    required this.descripcion,
    required this.series,
    this.musculos,
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
    };
  }

  Ejercicio copyWith({
    String? id,
    String? nombre,
    String? imagenDireccion,
    String? descripcion,
    List<Serie>? series,
    List<Musculo>? musculos,
  }) {
    return Ejercicio(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      imagenDireccion: imagenDireccion ?? this.imagenDireccion,
      descripcion: descripcion ?? this.descripcion,
      series: series ?? this.series,
      musculos: musculos ?? this.musculos,
    );
  }

  @override
  List<Object?> get props => [
        id,
        nombre,
        imagenDireccion,
        descripcion,
        series,
      ];

  @override
  String toString() {
    return 'Ejercicio(id: $id, nombre: $nombre, imagenDireccion: $imagenDireccion, '
        'descripcion: $descripcion, '
        'seriesDelEjercicio: $series)';
  }
}

class Serie extends Equatable {
  final String id;
  final double peso;
  final int repeticiones;
  final int timpoDescanso;
  final bool realizado;

  const Serie({
    required this.id,
    required this.peso,
    required this.repeticiones,
    required this.timpoDescanso,
    required this.realizado,
  });

  //tojson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'peso': peso,
      'repeticiones': repeticiones,
      'tiempoDescanso': timpoDescanso,
      'realizado': realizado,
    };
  }

  Serie copyWith({
    String? id,
    double? peso,
    int? repeticiones,
    int? timpoDescanso,
    bool? realizado,
  }) {
    return Serie(
      id: id ?? this.id,
      peso: peso ?? this.peso,
      repeticiones: repeticiones ?? this.repeticiones,
      timpoDescanso: timpoDescanso ?? this.timpoDescanso,
      realizado: realizado ?? this.realizado,
    );
  }

  @override
  List<Object?> get props => [id, peso, repeticiones, timpoDescanso, realizado];

  @override
  String toString() =>
      'SeriesDelEjercicio(id: $id, peso: $peso, repeticiones: $repeticiones, '
      'timpoDescanso: $timpoDescanso, realizado: $realizado)';
}

class Musculo extends Equatable {
  final String id;
  final String? nombre;
  final String? imagenDireccion;

  const Musculo({
    required this.id,
    this.nombre,
    this.imagenDireccion,
  });

  //tojson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'imagenDireccion': imagenDireccion,
    };
  }

  Musculo copyWith({
    String? id,
    String? nombre,
    String? imagenDireccion,
  }) {
    return Musculo(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        imagenDireccion: imagenDireccion ?? this.imagenDireccion);
  }

  @override
  List<Object?> get props => [id, nombre, imagenDireccion];
}
