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
      GetAllEjerciciosByRutinaParams params) async {
    final result = await repository.getAllEjercicioByRutinaId(rutinaId: params.id);
    return result;
  }
}

class GetAllEjerciciosByRutinaParams {
  final String id;

  GetAllEjerciciosByRutinaParams({required this.id});
}
