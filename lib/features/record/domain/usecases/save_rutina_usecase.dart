import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/record/domain/entities/record_rutina.dart';
import 'package:gymaster/features/record/domain/repositories/repositories.dart';

class SaveRutinaUseCase extends UseCase<void, SaveRutinaParams> {
  final RecordRepository repository;

  SaveRutinaUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(SaveRutinaParams params) async {
    return await repository.saveRutina(params.rutina);
  }
}

class SaveRutinaParams {
  final RecordRutina rutina;

  SaveRutinaParams({required this.rutina});
}
