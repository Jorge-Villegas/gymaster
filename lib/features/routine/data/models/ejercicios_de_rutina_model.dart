import 'package:gymaster/features/routine/domain/entities/ejercicios_de_rutina.dart';

class EjerciciosDeRutinaModel extends EjerciciosDeRutina {
  EjerciciosDeRutinaModel({
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

  @override
  List<Object?> get props => [rutinaId, nombre, ejercicios];
}

class EjercicioModel extends Ejercicio {
  EjercicioModel({
    required super.id,
    required super.nombre,
    required super.imagenDireccion,
    required super.descripcion,
    required super.series,
    super.musculos,
  });

  @override
  List<Object?> get props => [
        id,
        nombre,
        imagenDireccion,
        series,
        descripcion,
        musculos,
      ];
}

class SeriesDelEjercicioModel extends Serie {
  SeriesDelEjercicioModel({
    required super.id,
    required super.peso,
    required super.repeticiones,
    required super.timpoDescanso,
    required super.realizado,
  });
  @override
  List<Object?> get props => [
        id,
        peso,
        repeticiones,
        timpoDescanso,
        realizado,
      ];
}

class MusculoModel extends Musculo {
  MusculoModel({
    required super.id,
    required super.nombre,
    required super.imagenDireccion,
  });
}
