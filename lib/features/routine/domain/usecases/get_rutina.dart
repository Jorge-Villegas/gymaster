import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/routine/domain/entities/rutina_data.dart';
import 'package:gymaster/features/routine/domain/repositories/rutine_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetRutina extends UseCase<RutinaData, RutinaParam> {
  final RoutineRepository repository;

  GetRutina(this.repository);

  @override
  Future<Either<Failure, RutinaData>> call(RutinaParam params) async {
    return await repository.getRutina(params.idRuina);
  }
}

class RutinaParam {
  final int idRuina;

  RutinaParam({required this.idRuina});
}
