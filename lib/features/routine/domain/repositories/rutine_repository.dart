import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/features/routine/domain/entities/ejercicio.dart'
    as ejericicioEntity;
import 'package:gymaster/features/routine/domain/entities/ejercicios_de_rutina.dart'
    as ejerciciosDeRutina;
import 'package:gymaster/features/routine/domain/entities/ejercicios_por_musculo.dart';
import 'package:gymaster/features/routine/domain/entities/musculo.dart';
import 'package:gymaster/features/routine/domain/entities/routine.dart';
import 'package:gymaster/features/routine/domain/entities/rutina_data.dart';
import 'package:gymaster/features/routine/domain/entities/serie.dart';
import 'package:fpdart/fpdart.dart';

import '../usecases/add_ejercicio_rutina_usecase.dart';

abstract interface class RoutineRepository {
  /// Agrega una nueva rutina.
  ///
  /// Parámetros:
  /// - [name]: Nombre de la rutina.
  /// - [description]: Descripción opcional de la rutina.
  /// - [creationDate]: Fecha de creación de la rutina.
  /// - [done]: Booleano que indica si la rutina está completada.
  /// - [color]: Entero que representa el color asignado a la rutina.
  ///
  /// Retorna:
  /// - Un [Future] que contiene un [Either] con un [Failure] en caso de error,
  ///   o un booleano que indica si la operación fue exitosa.
  Future<Either<Failure, Routine>> addRoutine({
    required String name,
    String? description,
    required DateTime creationDate,
    required bool done,
    required int color,
  });

  /// Elimina una rutina existente.
  ///
  /// Parámetros:
  /// - [id]: ID de la rutina a eliminar.
  ///
  /// Retorna:
  /// - Un [Future] que contiene un [Either] con un [Failure] en caso de error,
  ///   o [void] si la operación fue exitosa.
  Future<Either<Failure, void>> deleteRoutine({
    required String id,
  });

  /// Actualiza una rutina existente.
  ///
  /// Parámetros:
  /// - [id]: ID de la rutina a actualizar.
  /// - [name]: Nombre opcional de la rutina.
  /// - [creationDate]: Fecha de creación opcional de la rutina.
  /// - [done]: Booleano opcional que indica si la rutina está completada.
  /// - [color]: Entero opcional que representa el color asignado a la rutina.
  ///
  /// Retorna:
  /// - Un [Future] que contiene un [Either] con un [Failure] en caso de error,
  ///   o [void] si la operación fue exitosa.
  Future<Either<Failure, void>> updateRoutine({
    required String id,
    String? name,
    DateTime? creationDate,
    bool? done,
    int? color,
  });

  /// Obtiene todas las rutinas.
  ///
  /// Retorna:
  /// - Un [Future] que contiene un [Either] con un [Failure] en caso de error,
  ///   o una lista de [Routine] si la operación fue exitosa.
  Future<Either<Failure, List<Routine>>> getAllRoutine();

  /// Obtiene una rutina por su ID.
  ///
  /// Parámetros:
  /// - [id]: ID de la rutina.
  ///
  /// Retorna:
  /// - Un [Future] que contiene un [Either] con un [Failure] en caso de error,
  ///   o una [Routine] si la operación fue exitosa.
  Future<Either<Failure, Routine>> getRoutineById({required String id});

  /// Obtiene rutinas por su nombre.
  ///
  /// Parámetros:
  /// - [name]: Nombre de la rutina.
  ///
  /// Retorna:
  /// - Un [Future] que contiene un [Either] con un [Failure] en caso de error,
  ///   o una lista de [Routine] si la operación fue exitosa.
  Future<Either<Failure, List<Routine>>> getRoutineByName({
    required String name,
  });

  /// Obtiene todos los músculos.
  ///
  /// Retorna:
  /// - Un [Future] que contiene un [Either] con un [Failure] en caso de error,
  ///   o una lista de [Musculo] si la operación fue exitosa.
  Future<Either<Failure, List<Musculo>>> getAllMusculos();

  /// Obtiene todos los ejercicios por el ID del músculo.
  ///
  /// Parámetros:
  /// - [musculoId]: ID del músculo.
  ///
  /// Retorna:
  /// - Un [Future] que contiene un [Either] con un [Failure] en caso de error,
  ///   o una lista de [Ejercicio] si la operación fue exitosa.
  Future<Either<Failure, List<EjerciciosPorMusculo>>> 
      getAllEjerciciosByMusculo({
     required String musculoId,
  });

  Future<Either<Failure, void>> addEjericioRutina({
    required String idRutina,
    required String idEjercicio,
    required List<DataSerie> dataSeries,
  });

  Future<Either<Failure, ejerciciosDeRutina.EjerciciosDeRutina>>
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
