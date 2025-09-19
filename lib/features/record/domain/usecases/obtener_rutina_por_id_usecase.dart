import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/record/domain/entities/record_rutina.dart';
import 'package:gymaster/features/record/domain/repositories/repositories.dart';

class ObtenerRutinaPorIdUseCase
    extends UseCase<RecordRutina, ObtenerRutinaPorIdParams> {
  final RecordRepository repository;

  ObtenerRutinaPorIdUseCase({required this.repository});

  @override
  Future<Either<Failure, RecordRutina>> call(
      ObtenerRutinaPorIdParams params) async {
    return await repository.obtenerRutinaPorId(params.id);
  }
}

class ObtenerRutinaPorIdParams {
  final String id;

  ObtenerRutinaPorIdParams({required this.id});
}
