import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/record/domain/repositories/repositories.dart';

class DeleteRutinaUseCase extends UseCase<void, DeleteRutinaParams> {
  final RecordRepository repository;

  DeleteRutinaUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(DeleteRutinaParams params) async {
    return await repository.deleteRutina(params.id);
  }
}

class DeleteRutinaParams {
  final String id;

  DeleteRutinaParams({required this.id});
}
