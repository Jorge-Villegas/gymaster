import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/features/estadisticas/data/datasources/estadisticas_local_data_source.dart';
import 'package:gymaster/features/estadisticas/data/models/distribucion_muscular_model.dart';
import 'package:gymaster/features/estadisticas/data/models/progreso_ejercicio_model.dart';
import 'package:gymaster/features/estadisticas/data/models/ranking_ejercicio_model.dart';
import 'package:gymaster/features/estadisticas/data/models/recomendacion_muscular_model.dart';
import 'package:gymaster/features/estadisticas/domain/entities/distribucion_muscular.dart';
import 'package:gymaster/features/estadisticas/domain/entities/progreso_ejercicio.dart';
import 'package:gymaster/features/estadisticas/domain/entities/ranking_ejercicio.dart';
import 'package:gymaster/features/estadisticas/domain/entities/recomendacion_muscular.dart';
import 'package:gymaster/features/estadisticas/domain/repositories/estadisticas_repository.dart';
import 'package:sqflite/sqflite.dart';

/// Implementación del repositorio de estadísticas usando SQLite local.
///
/// Convierte datos crudos del DataSource en entidades de dominio,
/// maneja errores con Either pattern y aplica validaciones de negocio.
class EstadisticasRepositoryImpl implements EstadisticasRepository {
  final EstadisticasLocalDataSource _localDataSource;

  EstadisticasRepositoryImpl(this._localDataSource);

  @override
  Future<Either<Failure, ProgresoEjercicio>> obtenerProgresoEjercicio({
    required String ejercicioId,
    required DateTime fechaInicio,
    required DateTime fechaFin,
  }) async {
    try {
      // Validar parámetros
      if (ejercicioId.isEmpty) {
        return Left(CacheFailure(
          errorMessage: 'El ID del ejercicio no puede estar vacío',
        ));
      }

      if (fechaInicio.isAfter(fechaFin)) {
        return Left(CacheFailure(
          errorMessage:
              'La fecha de inicio debe ser anterior a la fecha de fin',
        ));
      }

      // Obtener datos del ejercicio
      final infoEjercicio =
          await _localDataSource.obtenerInfoEjercicio(ejercicioId);

      if (infoEjercicio == null) {
        return Left(NoRecordsFailure(
          errorMessage: 'Ejercicio no encontrado con ID: $ejercicioId',
        ));
      }

      // Obtener puntos de progreso
      final puntosRaw = await _localDataSource.obtenerProgresoEjercicio(
        ejercicioId: ejercicioId,
        fechaInicio: fechaInicio,
        fechaFin: fechaFin,
      );

      if (puntosRaw.isEmpty) {
        return Left(NoRecordsFailure(
          errorMessage:
              'No hay datos de progreso para este ejercicio en el periodo seleccionado',
        ));
      }

      // Crear modelo con métricas calculadas
      final progreso = ProgresoEjercicioModel.fromDatabase(
        ejercicioId: ejercicioId,
        puntosRaw: puntosRaw,
        infoEjercicio: infoEjercicio,
        fechaInicio: fechaInicio,
        fechaFin: fechaFin,
      );

      debugPrint(
          '✅ [EstadisticasRepository] Progreso obtenido: ${progreso.nombreEjercicio} - ${progreso.frecuenciaRealizacion} sesiones');

      return Right(progreso.toEntity());
    } on DatabaseException catch (e) {
      debugPrint(
          '❌ [EstadisticasRepository] Error de BD en obtenerProgresoEjercicio: $e');
      return Left(DatabaseFailure(
        errorMessage: 'Error de base de datos: ${e.toString()}',
      ));
    } catch (e) {
      debugPrint(
          '❌ [EstadisticasRepository] Error inesperado en obtenerProgresoEjercicio: $e');
      return Left(CacheFailure(
        errorMessage: 'Error inesperado al obtener progreso: $e',
      ));
    }
  }

  @override
  Future<Either<Failure, List<DistribucionMuscular>>>
      obtenerDistribucionMuscular({
    required DateTime fechaInicio,
    required DateTime fechaFin,
  }) async {
    try {
      // Validar parámetros
      if (fechaInicio.isAfter(fechaFin)) {
        return Left(CacheFailure(
          errorMessage:
              'La fecha de inicio debe ser anterior a la fecha de fin',
        ));
      }

      // Obtener distribución desde DataSource
      final musculosRaw = await _localDataSource.obtenerDistribucionMuscular(
        fechaInicio: fechaInicio,
        fechaFin: fechaFin,
      );

      if (musculosRaw.isEmpty) {
        return Left(NoRecordsFailure(
          errorMessage: 'No hay datos de músculos trabajados en este periodo',
        ));
      }

      // Crear modelos con porcentajes calculados
      final distribucion = DistribucionMuscularModel.fromDatabaseList(
        musculosRaw: musculosRaw,
        fechaInicio: fechaInicio,
        fechaFin: fechaFin,
      );

      debugPrint(
          '✅ [EstadisticasRepository] Distribución obtenida: ${distribucion.length} músculos');

      return Right(distribucion.map((m) => m.toEntity()).toList());
    } on DatabaseException catch (e) {
      debugPrint(
          '❌ [EstadisticasRepository] Error de BD en obtenerDistribucionMuscular: $e');
      return Left(DatabaseFailure(
        errorMessage: 'Error de base de datos: ${e.toString()}',
      ));
    } catch (e) {
      debugPrint(
          '❌ [EstadisticasRepository] Error inesperado en obtenerDistribucionMuscular: $e');
      return Left(CacheFailure(
        errorMessage: 'Error inesperado al obtener distribución muscular: $e',
      ));
    }
  }

  @override
  Future<Either<Failure, List<RankingEjercicio>>> obtenerRankingEjercicios({
    required DateTime fechaInicio,
    required DateTime fechaFin,
    int limite = 10,
  }) async {
    try {
      // Validar parámetros
      if (fechaInicio.isAfter(fechaFin)) {
        return Left(CacheFailure(
          errorMessage:
              'La fecha de inicio debe ser anterior a la fecha de fin',
        ));
      }

      if (limite <= 0) {
        return Left(CacheFailure(
          errorMessage: 'El límite debe ser mayor a 0',
        ));
      }

      // Obtener ranking desde DataSource
      final rankingRaw = await _localDataSource.obtenerRankingEjercicios(
        fechaInicio: fechaInicio,
        fechaFin: fechaFin,
        limite: limite,
      );

      if (rankingRaw.isEmpty) {
        return Left(NoRecordsFailure(
          errorMessage: 'No hay ejercicios registrados en este periodo',
        ));
      }

      // Crear modelos con posiciones asignadas
      final ranking = RankingEjercicioModel.fromDatabaseList(
        rankingRaw: rankingRaw,
        fechaInicio: fechaInicio,
        fechaFin: fechaFin,
      );

      debugPrint(
          '✅ [EstadisticasRepository] Ranking obtenido: ${ranking.length} ejercicios');

      return Right(ranking.map((r) => r.toEntity()).toList());
    } on DatabaseException catch (e) {
      debugPrint(
          '❌ [EstadisticasRepository] Error de BD en obtenerRankingEjercicios: $e');
      return Left(DatabaseFailure(
        errorMessage: 'Error de base de datos: ${e.toString()}',
      ));
    } catch (e) {
      debugPrint(
          '❌ [EstadisticasRepository] Error inesperado en obtenerRankingEjercicios: $e');
      return Left(CacheFailure(
        errorMessage: 'Error inesperado al obtener ranking: $e',
      ));
    }
  }

  @override
  Future<Either<Failure, List<RecomendacionMuscular>>>
      obtenerMusculosOlvidados({
    int diasLimite = 7,
  }) async {
    try {
      // Validar parámetros
      if (diasLimite <= 0) {
        return Left(CacheFailure(
          errorMessage: 'El límite de días debe ser mayor a 0',
        ));
      }

      // Obtener músculos olvidados desde DataSource
      final musculosOlvidadosRaw =
          await _localDataSource.obtenerMusculosOlvidados(
        diasLimite: diasLimite,
      );

      if (musculosOlvidadosRaw.isEmpty) {
        // No es error, simplemente no hay músculos olvidados (¡bien!)
        debugPrint(
            '✅ [EstadisticasRepository] No hay músculos olvidados (todos trabajados)');
        return const Right([]);
      }

      // Crear modelos con mensajes generados
      final recomendaciones = RecomendacionMuscularModel.fromDatabaseList(
        musculosOlvidadosRaw: musculosOlvidadosRaw,
      );

      debugPrint(
          '✅ [EstadisticasRepository] Recomendaciones obtenidas: ${recomendaciones.length} músculos olvidados');

      return Right(recomendaciones.map((r) => r.toEntity()).toList());
    } on DatabaseException catch (e) {
      debugPrint(
          '❌ [EstadisticasRepository] Error de BD en obtenerMusculosOlvidados: $e');
      return Left(DatabaseFailure(
        errorMessage: 'Error de base de datos: ${e.toString()}',
      ));
    } catch (e) {
      debugPrint(
          '❌ [EstadisticasRepository] Error inesperado en obtenerMusculosOlvidados: $e');
      return Left(CacheFailure(
        errorMessage: 'Error inesperado al obtener recomendaciones: $e',
      ));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> obtenerResumenGeneral({
    required DateTime fechaInicio,
    required DateTime fechaFin,
  }) async {
    try {
      // Validar parámetros
      if (fechaInicio.isAfter(fechaFin)) {
        return Left(CacheFailure(
          errorMessage:
              'La fecha de inicio debe ser anterior a la fecha de fin',
        ));
      }

      // Obtener resumen desde DataSource
      final resumen = await _localDataSource.obtenerResumenGeneral(
        fechaInicio: fechaInicio,
        fechaFin: fechaFin,
      );

      debugPrint(
          '✅ [EstadisticasRepository] Resumen general obtenido: ${resumen['total_sesiones']} sesiones');

      return Right(resumen);
    } on DatabaseException catch (e) {
      debugPrint(
          '❌ [EstadisticasRepository] Error de BD en obtenerResumenGeneral: $e');
      return Left(DatabaseFailure(
        errorMessage: 'Error de base de datos: ${e.toString()}',
      ));
    } catch (e) {
      debugPrint(
          '❌ [EstadisticasRepository] Error inesperado en obtenerResumenGeneral: $e');
      return Left(CacheFailure(
        errorMessage: 'Error inesperado al obtener resumen: $e',
      ));
    }
  }
}
