import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/features/estadisticas/domain/entities/distribucion_muscular.dart';
import 'package:gymaster/features/estadisticas/domain/entities/progreso_ejercicio.dart';
import 'package:gymaster/features/estadisticas/domain/entities/ranking_ejercicio.dart';
import 'package:gymaster/features/estadisticas/domain/entities/recomendacion_muscular.dart';

/// Contrato abstracto para el repositorio de estadísticas.
///
/// Define todas las operaciones de negocio para obtener métricas,
/// progresos, rankings y recomendaciones de entrenamiento.
///
/// Todas las operaciones retornan [Either<Failure, T>] siguiendo
/// el patrón de programación funcional del proyecto.
abstract class EstadisticasRepository {
  /// Obtiene el progreso temporal de un ejercicio específico.
  ///
  /// [ejercicioId] ID único del ejercicio a analizar
  /// [fechaInicio] Fecha de inicio del periodo
  /// [fechaFin] Fecha de fin del periodo
  ///
  /// Returns:
  /// - [Right<ProgresoEjercicio>] con datos del progreso
  /// - [Left<Failure>] en caso de error (DatabaseFailure, NoRecordsFailure)
  Future<Either<Failure, ProgresoEjercicio>> obtenerProgresoEjercicio({
    required String ejercicioId,
    required DateTime fechaInicio,
    required DateTime fechaFin,
  });

  /// Obtiene la distribución de músculos trabajados en un periodo.
  ///
  /// [fechaInicio] Fecha de inicio del periodo
  /// [fechaFin] Fecha de fin del periodo
  ///
  /// Returns:
  /// - [Right<List<DistribucionMuscular>>] lista ordenada por volumen
  /// - [Left<Failure>] en caso de error o sin datos
  Future<Either<Failure, List<DistribucionMuscular>>>
      obtenerDistribucionMuscular({
    required DateTime fechaInicio,
    required DateTime fechaFin,
  });

  /// Obtiene el ranking de ejercicios más realizados.
  ///
  /// [fechaInicio] Fecha de inicio del periodo
  /// [fechaFin] Fecha de fin del periodo
  /// [limite] Número máximo de ejercicios en el ranking (default: 10)
  ///
  /// Returns:
  /// - [Right<List<RankingEjercicio>>] top ejercicios con métricas
  /// - [Left<Failure>] en caso de error
  Future<Either<Failure, List<RankingEjercicio>>> obtenerRankingEjercicios({
    required DateTime fechaInicio,
    required DateTime fechaFin,
    int limite = 10,
  });

  /// Obtiene recomendaciones de músculos olvidados.
  ///
  /// [diasLimite] Umbral de días sin trabajar (default: 7)
  ///
  /// Returns:
  /// - [Right<List<RecomendacionMuscular>>] músculos descuidados
  /// - [Left<Failure>] en caso de error
  Future<Either<Failure, List<RecomendacionMuscular>>>
      obtenerMusculosOlvidados({
    int diasLimite = 7,
  });

  /// Obtiene un resumen general de métricas del periodo.
  ///
  /// [fechaInicio] Fecha de inicio del periodo
  /// [fechaFin] Fecha de fin del periodo
  ///
  /// Returns:
  /// - [Right<Map<String, dynamic>>] con métricas agregadas
  /// - [Left<Failure>] en caso de error
  Future<Either<Failure, Map<String, dynamic>>> obtenerResumenGeneral({
    required DateTime fechaInicio,
    required DateTime fechaFin,
  });
}
