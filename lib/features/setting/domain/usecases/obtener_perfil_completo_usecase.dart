import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/setting/domain/entities/perfil_usuario_completo.dart';
import 'package:gymaster/features/setting/domain/repositories/perfil_usuario_completo_repository.dart';

class ObtenerPerfilCompletoUseCase
    implements UseCase<PerfilUsuarioCompleto?, NoParams> {
  final PerfilUsuarioCompletoRepository repository;

  ObtenerPerfilCompletoUseCase(this.repository);

  @override
  Future<Either<Failure, PerfilUsuarioCompleto?>> call(NoParams params) async {
    return await repository.obtenerPerfilCompleto();
  }
}
