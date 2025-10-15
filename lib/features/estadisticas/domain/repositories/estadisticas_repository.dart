import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/features/estadisticas/domain/entities/distribucion_muscular.dart';
import 'package:gymaster/features/estadisticas/domain/entities/progreso_ejercicio.dart';
import 'package:gymaster/features/estadisticas/domain/entities/ranking_ejercicio.dart';
import 'package:gymaster/features/estadisticas/domain/entities/recomendacion_muscular.dart';

abstract class EstadisticasRepository {
  Future<Either<Failure, ProgresoEjercicio>> obtenerProgresoEjercicio({
    required String ejercicioId,
    required DateTime fechaInicio,
    required DateTime fechaFin,
  });
  Future<Either<Failure, List<DistribucionMuscular>>>
      obtenerDistribucionMuscular({
    required DateTime fechaInicio,
    required DateTime fechaFin,
  });

  Future<Either<Failure, List<RankingEjercicio>>> obtenerRankingEjercicios({
    required DateTime fechaInicio,
    required DateTime fechaFin,
    int limite = 10,
  });

  Future<Either<Failure, List<RecomendacionMuscular>>>
      obtenerMusculosOlvidados({
    int diasLimite = 7,
  });

  Future<Either<Failure, Map<String, dynamic>>> obtenerResumenGeneral({
    required DateTime fechaInicio,
    required DateTime fechaFin,
  });
}
