import 'package:flutter/foundation.dart';
import 'package:gymaster/features/estadisticas/domain/entities/distribucion_muscular.dart';
import 'package:gymaster/features/estadisticas/domain/entities/periodo_tiempo.dart';
import 'package:gymaster/features/estadisticas/domain/entities/ranking_ejercicio.dart';
import 'package:gymaster/features/estadisticas/domain/entities/recomendacion_muscular.dart';

/// Estados inmutables del Cubit de estadísticas usando sealed classes.
///
/// Representa todos los posibles estados de la feature de estadísticas
/// siguiendo el patrón BLoC del proyecto.
@immutable
sealed class EstadisticasState {}

/// Estado inicial cuando el Cubit se crea por primera vez.
final class EstadisticasInitial extends EstadisticasState {}

/// Estado de carga cuando se están obteniendo datos.
final class EstadisticasLoading extends EstadisticasState {}

/// Estado exitoso con todos los datos de estadísticas cargados.
final class EstadisticasLoaded extends EstadisticasState {
  /// Periodo de tiempo seleccionado actualmente
  final PeriodoTiempo periodoSeleccionado;

  /// Rango de fechas personalizado (solo si periodoSeleccionado == rangoPersonalizado)
  final (DateTime, DateTime)? rangoPersonalizado;

  /// Distribución de músculos trabajados
  final List<DistribucionMuscular> distribucionMuscular;

  /// Top 10 ejercicios más realizados
  final List<RankingEjercicio> rankingEjercicios;

  /// Músculos olvidados con recomendaciones
  final List<RecomendacionMuscular> musculosOlvidados;

  /// Resumen general de métricas
  final Map<String, dynamic> resumenGeneral;

  EstadisticasLoaded({
    required this.periodoSeleccionado,
    this.rangoPersonalizado,
    required this.distribucionMuscular,
    required this.rankingEjercicios,
    required this.musculosOlvidados,
    required this.resumenGeneral,
  });

  /// Crea una copia con valores actualizados
  EstadisticasLoaded copyWith({
    PeriodoTiempo? periodoSeleccionado,
    (DateTime, DateTime)? rangoPersonalizado,
    List<DistribucionMuscular>? distribucionMuscular,
    List<RankingEjercicio>? rankingEjercicios,
    List<RecomendacionMuscular>? musculosOlvidados,
    Map<String, dynamic>? resumenGeneral,
  }) {
    return EstadisticasLoaded(
      periodoSeleccionado: periodoSeleccionado ?? this.periodoSeleccionado,
      rangoPersonalizado: rangoPersonalizado ?? this.rangoPersonalizado,
      distribucionMuscular: distribucionMuscular ?? this.distribucionMuscular,
      rankingEjercicios: rankingEjercicios ?? this.rankingEjercicios,
      musculosOlvidados: musculosOlvidados ?? this.musculosOlvidados,
      resumenGeneral: resumenGeneral ?? this.resumenGeneral,
    );
  }
}

/// Estado de error con mensaje descriptivo.
final class EstadisticasError extends EstadisticasState {
  final String message;

  EstadisticasError(this.message);
}

/// Estado de carga vacío cuando no hay datos en el periodo seleccionado.
final class EstadisticasEmpty extends EstadisticasState {
  final String message;

  EstadisticasEmpty(this.message);
}
