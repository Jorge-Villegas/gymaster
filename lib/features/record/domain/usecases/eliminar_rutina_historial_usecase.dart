import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/record/domain/repositories/repositories.dart';

class EliminarRutinaHistorialUseCase
    extends UseCase<void, EliminarRutinaHistorialParams> {
  final RecordRepository repository;

  EliminarRutinaHistorialUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(
      EliminarRutinaHistorialParams params) async {
    return await repository.eliminarRutina(params.id);
  }
}

class EliminarRutinaHistorialParams {
  final String id;

  EliminarRutinaHistorialParams({required this.id});
}
