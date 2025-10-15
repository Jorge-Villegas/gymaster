import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/features/setting/data/models/configuracion_usuario.dart';

abstract class ConfiguracionUsuarioRepository {
  Future<Either<Failure, ConfiguracionUsuario?>>
      obtenerConfiguracionPorUsuarioId(String usuarioId);
  Future<Either<Failure, ConfiguracionUsuario>> crearConfiguracion(
      ConfiguracionUsuario configuracion);
  Future<Either<Failure, ConfiguracionUsuario>> actualizarConfiguracion(
      ConfiguracionUsuario configuracion);
  Future<Either<Failure, void>> eliminarConfiguracion(String usuarioId);
  Future<Either<Failure, bool>> existeConfiguracion(String usuarioId);
}
