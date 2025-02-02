import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/features/routine/domain/entities/ejercicios_de_rutina.dart'
    as ejercicios_de_rutina;
import 'package:gymaster/features/routine/domain/entities/ejercicios_por_musculo.dart';
import 'package:gymaster/features/routine/domain/entities/musculo.dart';
import 'package:gymaster/features/routine/domain/entities/routine.dart';
import 'package:gymaster/features/routine/domain/entities/rutina_data.dart';
import 'package:gymaster/features/routine/domain/entities/serie.dart';
import 'package:fpdart/fpdart.dart';

import '../usecases/add_ejercicio_rutina_usecase.dart';

abstract interface class RoutineRepository {
  Future<Either<Failure, Routine>> addRoutine({
    required String name,
    String? description,
    required DateTime creationDate,
    required bool done,
    required int color,
    required String imagenDireccion,
  });

  Future<Either<Failure, void>> deleteRoutine({
    required String id,
  });

  Future<Either<Failure, void>> updateRoutine({
    required String id,
    String? name,
    DateTime? creationDate,
    bool? done,
    int? color,
  });

  Future<Either<Failure, List<Routine>>> getAllRoutine();

  Future<Either<Failure, Routine>> getRoutineById({required String id});

  Future<Either<Failure, List<Routine>>> getRoutineByName({
    required String name,
  });

  Future<Either<Failure, List<Musculo>>> getAllMusculos();

  Future<Either<Failure, List<EjerciciosPorMusculo>>>
      getAllEjerciciosByMusculo({
    required String musculoId,
  });

  Future<Either<Failure, void>> addEjericioRutina({
    required String idRutina,
    required String idEjercicio,
    required List<DataSerie> dataSeries,
  });

  Future<Either<Failure, ejercicios_de_rutina.EjerciciosDeRutina>>
      getAllEjercicioByRutinaId({
    required String rutinaId,
  });

  Future<Either<Failure, Serie>> updateSerie({
    required String id,
    double? peso,
    int? repeticiones,
    bool? realizado,
    int? tiempoDescanso,
  });

  Future<Either<Failure, Serie>> getSerieById(String id);

  Future<Either<Failure, RutinaData>> getRutina(int id);

  Future<Either<Failure, RutinaData>> obtenerRutinaDetalles({
    required String idRutina,
  });
}
