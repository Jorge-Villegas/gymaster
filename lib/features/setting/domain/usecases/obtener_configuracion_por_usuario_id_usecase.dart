import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/setting/data/models/configuracion_usuario.dart';
import 'package:gymaster/features/setting/domain/repositories/configuracion_usuario_repository.dart';

class ObtenerConfiguracionPorUsuarioIdUseCase
    implements
        UseCase<ConfiguracionUsuario?, ObtenerConfiguracionPorUsuarioIdParams> {
  final ConfiguracionUsuarioRepository repository;

  ObtenerConfiguracionPorUsuarioIdUseCase(this.repository);

  @override
  Future<Either<Failure, ConfiguracionUsuario?>> call(
      ObtenerConfiguracionPorUsuarioIdParams params) async {
    return await repository.obtenerConfiguracionPorUsuarioId(params.usuarioId);
  }
}

class ObtenerConfiguracionPorUsuarioIdParams {
  final String usuarioId;

  ObtenerConfiguracionPorUsuarioIdParams({required this.usuarioId});
}
