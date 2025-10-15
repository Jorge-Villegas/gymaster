import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/features/setting/data/datasources/perfil_usuario_completo_local_data_source.dart';
import 'package:gymaster/features/setting/domain/entities/perfil_usuario_completo.dart';
import 'package:gymaster/features/setting/domain/repositories/perfil_usuario_completo_repository.dart';
import 'package:sqflite/sqflite.dart';

class PerfilUsuarioCompletoRepositoryImpl
    implements PerfilUsuarioCompletoRepository {
  final PerfilUsuarioCompletoLocalDataSource localDataSource;

  PerfilUsuarioCompletoRepositoryImpl({
    required this.localDataSource,
  });

  @override
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
  }) async {
    try {
      final perfil = await localDataSource.crearPerfilCompleto(
        nombreUsuario: nombreUsuario,
        correo: correo,
        fotoPerfil: fotoPerfil,
        nombreCompleto: nombreCompleto,
        fechaNacimiento: fechaNacimiento,
        genero: genero,
        objetivoFitness: objetivoFitness,
        nivelExperiencia: nivelExperiencia,
        alturaCm: alturaCm,
        pesoActualKg: pesoActualKg,
        pesoObjetivoKg: pesoObjetivoKg,
      );
      return Right(perfil);
    } on DatabaseException catch (e) {
      if (e.toString().contains('UNIQUE constraint failed')) {
        return Left(DatabaseFailure(
          errorMessage: 'El nombre de usuario ya existe. Elige otro.',
        ));
      }
      return Left(DatabaseFailure(
        errorMessage: 'Error al crear perfil: ${e.toString()}',
      ));
    } catch (e) {
      return Left(CacheFailure(
        errorMessage: 'Error inesperado al crear perfil: $e',
      ));
    }
  }

  @override
  Future<Either<Failure, PerfilUsuarioCompleto?>>
      obtenerPerfilCompleto() async {
    try {
      final perfil = await localDataSource.obtenerPerfilCompleto();
      return Right(perfil);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(
        errorMessage: 'Error al obtener perfil: ${e.toString()}',
      ));
    } catch (e) {
      return Left(CacheFailure(
        errorMessage: 'Error inesperado al obtener perfil: $e',
      ));
    }
  }

  @override
  Future<Either<Failure, bool>> existePerfilCompleto() async {
    try {
      final existe = await localDataSource.existePerfilCompleto();
      return Right(existe);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(
        errorMessage: 'Error al verificar perfil: ${e.toString()}',
      ));
    } catch (e) {
      return Left(CacheFailure(
        errorMessage: 'Error inesperado al verificar perfil: $e',
      ));
    }
  }

  @override
  Future<Either<Failure, PerfilUsuarioCompleto>> actualizarPerfilCompleto(
    PerfilUsuarioCompleto perfil,
  ) async {
    try {
      final perfilActualizado =
          await localDataSource.actualizarPerfilCompleto(perfil);
      return Right(perfilActualizado);
    } on DatabaseException catch (e) {
      if (e.toString().contains('UNIQUE constraint failed')) {
        return Left(DatabaseFailure(
          errorMessage: 'El nombre de usuario ya existe. Elige otro.',
        ));
      }
      return Left(DatabaseFailure(
        errorMessage: 'Error al actualizar perfil: ${e.toString()}',
      ));
    } catch (e) {
      return Left(CacheFailure(
        errorMessage: 'Error inesperado al actualizar perfil: $e',
      ));
    }
  }

  @override
  Future<Either<Failure, bool>> eliminarPerfilCompleto() async {
    try {
      final eliminado = await localDataSource.eliminarPerfilCompleto();
      return Right(eliminado);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(
        errorMessage: 'Error al eliminar perfil: ${e.toString()}',
      ));
    } catch (e) {
      return Left(CacheFailure(
        errorMessage: 'Error inesperado al eliminar perfil: $e',
      ));
    }
  }
}
