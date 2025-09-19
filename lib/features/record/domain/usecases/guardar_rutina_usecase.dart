import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/record/domain/entities/record_rutina.dart';
import 'package:gymaster/features/record/domain/repositories/repositories.dart';

class GuardarRutinaUseCase extends UseCase<void, GuardarRutinaParams> {
  final RecordRepository repository;

  GuardarRutinaUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(GuardarRutinaParams params) async {
    return await repository.guardarRutina(params.rutina);
  }
}

class GuardarRutinaParams {
  final RecordRutina rutina;

  GuardarRutinaParams({required this.rutina});
}
