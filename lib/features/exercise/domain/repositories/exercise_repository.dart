import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/features/exercise/domain/entities/exercise.dart';

abstract interface class ExerciseRepository {
  Future<Either<Failure, List<Exercise>>> obtenerTodosLosEjercicios();
  Future<Either<Failure, Exercise>> obtenerEjercicioPorId(String id);
  Future<Either<Failure, List<Exercise>>> obtenerEjerciciosPorMusculo(
      String musculoId);
  Future<Either<Failure, List<Exercise>>> buscarEjercicios(String query);
  Future<Either<Failure, Exercise>> actualizarEjercicio(Exercise ejercicio);
  Future<Either<Failure, List<Exercise>>> obtenerEjerciciosRecomendados({
    required String grupoMuscular,
    required String dificultad,
    String? equipo,
  });
}
