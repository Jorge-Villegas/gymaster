import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/record/domain/entities/record_rutina.dart';
import 'package:gymaster/features/record/domain/repositories/repositories.dart';

class GetRutinaByIdUseCase extends UseCase<RecordRutina, GetRutinaByIdParams> {
  final RecordRepository repository;

  GetRutinaByIdUseCase({required this.repository});

  @override
  Future<Either<Failure, RecordRutina>> call(GetRutinaByIdParams params) async {
    return await repository.getRutinaById(params.id);
  }
}

class GetRutinaByIdParams {
  final String id;

  GetRutinaByIdParams({required this.id});
}
