import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/setting/data/models/configuracion_usuario.dart';
import 'package:gymaster/features/setting/domain/repositories/configuracion_usuario_repository.dart';

class ActualizarConfiguracionUsuarioUseCase
    implements
        UseCase<ConfiguracionUsuario, ActualizarConfiguracionUsuarioParams> {
  final ConfiguracionUsuarioRepository repository;

  ActualizarConfiguracionUsuarioUseCase(this.repository);

  @override
  Future<Either<Failure, ConfiguracionUsuario>> call(
      ActualizarConfiguracionUsuarioParams params) async {
    return await repository.actualizarConfiguracion(params.configuracion);
  }
}

class ActualizarConfiguracionUsuarioParams {
  final ConfiguracionUsuario configuracion;

  ActualizarConfiguracionUsuarioParams({required this.configuracion});
}
