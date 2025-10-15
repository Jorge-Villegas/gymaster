import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/features/setting/data/models/perfil_usuario.dart';

abstract class PerfilUsuarioRepository {
  Future<Either<Failure, PerfilUsuario?>> obtenerPerfilPorId(String usuarioId);
  Future<Either<Failure, PerfilUsuario>> actualizarPerfil(PerfilUsuario perfil);
  Future<Either<Failure, void>> eliminarPerfil(String usuarioId);
  Future<Either<Failure, bool>> existePerfil(String usuarioId);
}
