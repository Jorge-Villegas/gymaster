import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/record/domain/entities/record_rutina.dart';
import 'package:gymaster/features/record/domain/repositories/repositories.dart';

class GetAllRutinasUseCase extends UseCase<List<RecordRutina>, NoParams> {
  final RecordRepository repository;

  GetAllRutinasUseCase({required this.repository});

  @override
  Future<Either<Failure, List<RecordRutina>>> call(NoParams params) async {
    return await repository.getAllRutinas();
  }
}
