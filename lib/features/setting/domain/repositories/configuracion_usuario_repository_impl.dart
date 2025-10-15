import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/features/setting/data/datasources/configuracion_usuario_local_data_source.dart';
import 'package:gymaster/features/setting/data/models/configuracion_usuario.dart';
import 'package:gymaster/features/setting/domain/repositories/configuracion_usuario_repository.dart';
import 'package:sqflite/sqflite.dart';

class ConfiguracionUsuarioRepositoryImpl
    implements ConfiguracionUsuarioRepository {
  final ConfiguracionUsuarioLocalDataSource localDataSource;

  ConfiguracionUsuarioRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, ConfiguracionUsuario?>>
      obtenerConfiguracionPorUsuarioId(String usuarioId) async {
    try {
      final configuracion =
          await localDataSource.obtenerConfiguracionPorUsuarioId(usuarioId);
      return Right(configuracion);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(
          errorMessage:
              'Error de base de datos al obtener configuración: ${e.toString()}'));
    } catch (e) {
      return Left(CacheFailure(
          errorMessage: 'Error inesperado al obtener configuración: $e'));
    }
  }

  @override
  Future<Either<Failure, ConfiguracionUsuario>> crearConfiguracion(
      ConfiguracionUsuario configuracion) async {
    try {
      // Validación básica: verificar que tenga usuario ID
      if (configuracion.usuarioId.isEmpty) {
        return Left(CacheFailure(
            errorMessage:
                'El ID de usuario es requerido para la configuración'));
      }

      final configuracionCreada =
          await localDataSource.crearConfiguracion(configuracion);
      return Right(configuracionCreada);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(
          errorMessage:
              'Error de base de datos al crear configuración: ${e.toString()}'));
    } catch (e) {
      return Left(CacheFailure(
          errorMessage: 'Error inesperado al crear configuración: $e'));
    }
  }

  @override
  Future<Either<Failure, ConfiguracionUsuario>> actualizarConfiguracion(
      ConfiguracionUsuario configuracion) async {
    try {
      // Validación básica: verificar que tenga usuario ID
      if (configuracion.usuarioId.isEmpty) {
        return Left(CacheFailure(
            errorMessage:
                'El ID de usuario es requerido para la configuración'));
      }

      // Verificar que existe la configuración
      final existe =
          await localDataSource.existeConfiguracion(configuracion.usuarioId);
      if (!existe) {
        return Left(NoRecordsFailure(
            errorMessage: 'La configuración del usuario no existe'));
      }

      final configuracionActualizada =
          await localDataSource.actualizarConfiguracion(configuracion);
      return Right(configuracionActualizada);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(
          errorMessage:
              'Error de base de datos al actualizar configuración: ${e.toString()}'));
    } catch (e) {
      return Left(CacheFailure(
          errorMessage: 'Error inesperado al actualizar configuración: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> eliminarConfiguracion(String usuarioId) async {
    try {
      // Verificar que existe la configuración
      final existe = await localDataSource.existeConfiguracion(usuarioId);
      if (!existe) {
        return Left(NoRecordsFailure(
            errorMessage: 'La configuración del usuario no existe'));
      }

      await localDataSource.eliminarConfiguracion(usuarioId);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(
          errorMessage:
              'Error de base de datos al eliminar configuración: ${e.toString()}'));
    } catch (e) {
      return Left(CacheFailure(
          errorMessage: 'Error inesperado al eliminar configuración: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> existeConfiguracion(String usuarioId) async {
    try {
      final existe = await localDataSource.existeConfiguracion(usuarioId);
      return Right(existe);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(
          errorMessage:
              'Error de base de datos al verificar configuración: ${e.toString()}'));
    } catch (e) {
      return Left(CacheFailure(
          errorMessage: 'Error inesperado al verificar configuración: $e'));
    }
  }
}
