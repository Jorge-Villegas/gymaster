import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/setting/domain/repositories/informacion_aplicacion_repository.dart';

class IncrementarContadorInicioAppUseCase implements UseCase<void, NoParams> {
  final InformacionAplicacionRepository repository;

  IncrementarContadorInicioAppUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.incrementarContadorInicioApp();
  }
}
