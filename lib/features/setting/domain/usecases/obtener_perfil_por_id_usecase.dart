import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/setting/data/models/perfil_usuario.dart';
import 'package:gymaster/features/setting/domain/repositories/perfil_usuario_repository.dart';

class ObtenerPerfilPorIdUseCase
    implements UseCase<PerfilUsuario?, ObtenerPerfilPorIdParams> {
  final PerfilUsuarioRepository repository;

  ObtenerPerfilPorIdUseCase(this.repository);

  @override
  Future<Either<Failure, PerfilUsuario?>> call(
      ObtenerPerfilPorIdParams params) async {
    return await repository.obtenerPerfilPorId(params.usuarioId);
  }
}

class ObtenerPerfilPorIdParams {
  final String usuarioId;

  ObtenerPerfilPorIdParams({required this.usuarioId});
}
