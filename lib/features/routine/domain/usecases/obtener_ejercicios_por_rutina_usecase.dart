import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/routine/domain/entities/ejercicios_de_rutina.dart';
import 'package:gymaster/features/routine/domain/repositories/routine_repository.dart';
import 'package:fpdart/fpdart.dart';

class ObtenerEjerciciosPorRutinaUseCase
    implements UseCase<EjerciciosDeRutina, ObtenerEjerciciosPorRutinaParams> {
  final RoutineRepository repository;

  ObtenerEjerciciosPorRutinaUseCase(this.repository);

  @override
  Future<Either<Failure, EjerciciosDeRutina>> call(
    ObtenerEjerciciosPorRutinaParams params,
  ) async {
    return await repository.getAllEjercicioByRutinaId(
      rutinaId: params.id,
      idRoutineSession: params.idRoutineSession,
    );
  }
}

class ObtenerEjerciciosPorRutinaParams {
  final String id;
  final String idRoutineSession;

  ObtenerEjerciciosPorRutinaParams({
    required this.id,
    required this.idRoutineSession,
  });
}
