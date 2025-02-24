import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/routine/domain/entities/ejercicios_de_rutina.dart';
import 'package:gymaster/features/routine/domain/repositories/rutine_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetAllEjerciciosByRutinaUseCase
    implements UseCase<EjerciciosDeRutina, GetAllEjerciciosByRutinaParams> {
  final RoutineRepository repository;

  GetAllEjerciciosByRutinaUseCase(this.repository);

  @override
  Future<Either<Failure, EjerciciosDeRutina>> call(
    GetAllEjerciciosByRutinaParams params,
  ) async {
    return await repository.getAllEjercicioByRutinaId(
      rutinaId: params.id,
      idRoutineSession: params.idRoutineSession,
    );
  }
}

class GetAllEjerciciosByRutinaParams {
  final String id;
  final String idRoutineSession;

  GetAllEjerciciosByRutinaParams({
    required this.id,
    required this.idRoutineSession,
  });
}
