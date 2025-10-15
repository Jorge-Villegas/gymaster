import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/setting/data/models/perfil_usuario.dart';
import 'package:gymaster/features/setting/domain/repositories/perfil_usuario_repository.dart';

class ActualizarPerfilUsuarioUseCase
    implements UseCase<PerfilUsuario, ActualizarPerfilUsuarioParams> {
  final PerfilUsuarioRepository repository;

  ActualizarPerfilUsuarioUseCase(this.repository);

  @override
  Future<Either<Failure, PerfilUsuario>> call(
      ActualizarPerfilUsuarioParams params) async {
    return await repository.actualizarPerfil(params.perfil);
  }
}

class ActualizarPerfilUsuarioParams {
  final PerfilUsuario perfil;

  ActualizarPerfilUsuarioParams({required this.perfil});
}
