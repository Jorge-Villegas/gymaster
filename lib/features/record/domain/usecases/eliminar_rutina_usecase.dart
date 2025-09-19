import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/record/domain/repositories/repositories.dart';

class EliminarRutinaUseCase extends UseCase<void, EliminarRutinaParams> {
  final RecordRepository repository;

  EliminarRutinaUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(EliminarRutinaParams params) async {
    return await repository.eliminarRutina(params.id);
  }
}

class EliminarRutinaParams {
  final String id;

  EliminarRutinaParams({required this.id});
}
