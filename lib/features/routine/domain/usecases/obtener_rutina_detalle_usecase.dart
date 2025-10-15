//creame el caso de uso obtener_rutina_detalle.dart

import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/routine/domain/entities/rutina_data.dart';
import 'package:gymaster/features/routine/domain/repositories/routine_repository.dart';
import 'package:fpdart/fpdart.dart';

class ObtenerDetalleRutinaUseCase
    implements UseCase<RutinaData, ObtenerRutinaDetalleParams> {
  final RoutineRepository repository;

  ObtenerDetalleRutinaUseCase(this.repository);

  @override
  Future<Either<Failure, RutinaData>> call(
    ObtenerRutinaDetalleParams params,
  ) async {
    return await repository.obtenerRutinaDetalles(idRutina: params.id);
  }
}

class ObtenerRutinaDetalleParams {
  final String id;

  ObtenerRutinaDetalleParams({required this.id});
}
