import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/routine/domain/entities/rutina_data.dart';
import 'package:gymaster/features/routine/domain/repositories/rutine_repository.dart';
import 'package:fpdart/fpdart.dart';

class ObtenerRutinaUseCase extends UseCase<RutinaData, ObtenerRutinaParam> {
  final RoutineRepository repository;

  ObtenerRutinaUseCase(this.repository);

  @override
  Future<Either<Failure, RutinaData>> call(ObtenerRutinaParam params) async {
    return await repository.getRutina(params.idRuina);
  }
}

class ObtenerRutinaParam {
  final int idRuina;

  ObtenerRutinaParam({required this.idRuina});
}
