import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/features/setting/data/datasources/informacion_aplicacion_local_data_source.dart';
import 'package:gymaster/features/setting/data/models/informacion_aplicacion.dart';
import 'package:gymaster/features/setting/domain/repositories/informacion_aplicacion_repository.dart';
import 'package:sqflite/sqflite.dart';

class InformacionAplicacionRepositoryImpl
    implements InformacionAplicacionRepository {
  final InformacionAplicacionLocalDataSource localDataSource;

  InformacionAplicacionRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, InformacionAplicacion>>
      obtenerInformacionAplicacion() async {
    try {
      final informacion = await localDataSource.obtenerInformacionAplicacion();
      return Right(informacion);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(
          errorMessage:
              'Error de base de datos al obtener información de la aplicación: ${e.toString()}'));
    } catch (e) {
      return Left(CacheFailure(
          errorMessage:
              'Error inesperado al obtener información de la aplicación: $e'));
    }
  }

  @override
  Future<Either<Failure, InformacionAplicacion>>
      actualizarInformacionAplicacion(InformacionAplicacion informacion) async {
    try {
      // Validación básica: verificar campos requeridos
      if (informacion.versionApp.isEmpty) {
        return Left(CacheFailure(
            errorMessage: 'La versión de la aplicación es requerida'));
      }

      final informacionActualizada =
          await localDataSource.actualizarInformacionAplicacion(informacion);
      return Right(informacionActualizada);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(
          errorMessage:
              'Error de base de datos al actualizar información de la aplicación: ${e.toString()}'));
    } catch (e) {
      return Left(CacheFailure(
          errorMessage:
              'Error inesperado al actualizar información de la aplicación: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> incrementarContadorInicioApp() async {
    try {
      await localDataSource.incrementarContadorInicioApp();
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(
          errorMessage:
              'Error de base de datos al incrementar contador de inicios: ${e.toString()}'));
    } catch (e) {
      return Left(CacheFailure(
          errorMessage:
              'Error inesperado al incrementar contador de inicios: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> incrementarContadorRutinasCompletadas() async {
    try {
      await localDataSource.incrementarContadorRutinasCompletadas();
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(
          errorMessage:
              'Error de base de datos al incrementar contador de rutinas: ${e.toString()}'));
    } catch (e) {
      return Left(CacheFailure(
          errorMessage:
              'Error inesperado al incrementar contador de rutinas: $e'));
    }
  }

  @override
  Future<Either<Failure, void>>
      incrementarContadorEjerciciosRealizados() async {
    try {
      await localDataSource.incrementarContadorEjerciciosRealizados();
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(
          errorMessage:
              'Error de base de datos al incrementar contador de ejercicios: ${e.toString()}'));
    } catch (e) {
      return Left(CacheFailure(
          errorMessage:
              'Error inesperado al incrementar contador de ejercicios: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> actualizarRachaActual(int nuevaRacha) async {
    try {
      // Validación básica: la racha no puede ser negativa
      if (nuevaRacha < 0) {
        return Left(CacheFailure(
            errorMessage: 'La racha no puede ser un número negativo'));
      }

      await localDataSource.actualizarRachaActual(nuevaRacha);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(
          errorMessage:
              'Error de base de datos al actualizar racha: ${e.toString()}'));
    } catch (e) {
      return Left(CacheFailure(
          errorMessage: 'Error inesperado al actualizar racha: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> reiniciarDatos() async {
    try {
      await localDataSource.reiniciarDatos();
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(
          errorMessage:
              'Error de base de datos al reiniciar datos: ${e.toString()}'));
    } catch (e) {
      return Left(CacheFailure(
          errorMessage: 'Error inesperado al reiniciar datos: $e'));
    }
  }
}
