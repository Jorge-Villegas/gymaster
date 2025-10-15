import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/features/setting/domain/entities/perfil_usuario_completo.dart';

abstract class PerfilUsuarioCompletoRepository {
  Future<Either<Failure, PerfilUsuarioCompleto>> crearPerfilCompleto({
    required String nombreUsuario,
    String? correo,
    required String fotoPerfil,
    required String nombreCompleto,
    DateTime? fechaNacimiento,
    required Genero genero,
    required ObjetivoFitness objetivoFitness,
    required NivelExperiencia nivelExperiencia,
    int? alturaCm,
    double? pesoActualKg,
    double? pesoObjetivoKg,
  });

  Future<Either<Failure, PerfilUsuarioCompleto?>> obtenerPerfilCompleto();
  Future<Either<Failure, bool>> existePerfilCompleto();
  Future<Either<Failure, PerfilUsuarioCompleto>> actualizarPerfilCompleto(
      PerfilUsuarioCompleto perfil);
  Future<Either<Failure, bool>> eliminarPerfilCompleto();
}
