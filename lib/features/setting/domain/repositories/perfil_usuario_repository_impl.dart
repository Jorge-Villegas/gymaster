import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/features/setting/data/datasources/perfil_usuario_local_data_source.dart';
import 'package:gymaster/features/setting/data/models/perfil_usuario.dart';
import 'package:gymaster/features/setting/domain/repositories/perfil_usuario_repository.dart';

import 'package:sqflite/sqflite.dart';

class PerfilUsuarioRepositoryImpl implements PerfilUsuarioRepository {
  final PerfilUsuarioLocalDataSource localDataSource;

  PerfilUsuarioRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, PerfilUsuario?>> obtenerPerfilPorId(
      String usuarioId) async {
    try {
      final perfil = await localDataSource.obtenerPerfilPorId(usuarioId);
      return Right(perfil);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(
          errorMessage:
              'Error de base de datos al obtener perfil: ${e.toString()}'));
    } catch (e) {
      return Left(
          CacheFailure(errorMessage: 'Error inesperado al obtener perfil: $e'));
    }
  }

  @override
  Future<Either<Failure, PerfilUsuario>> actualizarPerfil(
      PerfilUsuario perfil) async {
    try {
      // Validación básica: verificar campos requeridos
      if (perfil.nombreUsuario.isEmpty || perfil.correo.isEmpty) {
        return Left(CacheFailure(
            errorMessage: 'El nombre de usuario y correo son requeridos'));
      }

      // Verificar que el perfil existe
      final existe = await localDataSource.existePerfil(perfil.id!);
      if (!existe) {
        return Left(
            NoRecordsFailure(errorMessage: 'El perfil del usuario no existe'));
      }

      final perfilActualizado = await localDataSource.actualizarPerfil(perfil);
      return Right(perfilActualizado);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(
          errorMessage:
              'Error de base de datos al actualizar perfil: ${e.toString()}'));
    } catch (e) {
      return Left(CacheFailure(
          errorMessage: 'Error inesperado al actualizar perfil: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> eliminarPerfil(String usuarioId) async {
    try {
      // Verificar que el perfil existe
      final existe = await localDataSource.existePerfil(usuarioId);
      if (!existe) {
        return Left(
            NoRecordsFailure(errorMessage: 'El perfil del usuario no existe'));
      }

      await localDataSource.eliminarPerfil(usuarioId);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(
          errorMessage:
              'Error de base de datos al eliminar perfil: ${e.toString()}'));
    } catch (e) {
      return Left(CacheFailure(
          errorMessage: 'Error inesperado al eliminar perfil: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> existePerfil(String usuarioId) async {
    try {
      final existe = await localDataSource.existePerfil(usuarioId);
      return Right(existe);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(
          errorMessage:
              'Error de base de datos al verificar perfil: ${e.toString()}'));
    } catch (e) {
      return Left(CacheFailure(
          errorMessage: 'Error inesperado al verificar perfil: $e'));
    }
  }
}
