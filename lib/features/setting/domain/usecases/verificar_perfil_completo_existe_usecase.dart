import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/setting/domain/repositories/perfil_usuario_completo_repository.dart';

class VerificarPerfilCompletoExisteUseCase implements UseCase<bool, NoParams> {
  final PerfilUsuarioCompletoRepository repository;

  VerificarPerfilCompletoExisteUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.existePerfilCompleto();
  }
}
