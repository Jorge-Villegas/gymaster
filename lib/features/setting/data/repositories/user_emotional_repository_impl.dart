import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/features/setting/data/datasources/user_emotional_local_data_source.dart';
import 'package:gymaster/features/setting/domain/entities/user_motivation.dart';
import 'package:gymaster/features/setting/domain/entities/user_mood.dart';
import 'package:gymaster/features/setting/domain/repositories/user_emotional_repository.dart';

class UserEmotionalRepositoryImpl implements UserEmotionalRepository {
  final UserEmotionalLocalDataSource localDataSource;

  UserEmotionalRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, void>> saveUserMotivation(
      UserMotivation motivation) async {
    try {
      await localDataSource.saveUserMotivation(motivation);
      return const Right(null);
    } on Exception catch (e) {
      return Left(CacheFailure(
          errorMessage: 'Error al guardar motivación: ${e.toString()}'));
    } catch (e) {
      return Left(CacheFailure(
          errorMessage: 'Error inesperado al guardar motivación: $e'));
    }
  }

  @override
  Future<Either<Failure, UserMotivation?>> getUserMotivation(
      String userId) async {
    try {
      final motivation = await localDataSource.getUserMotivation(userId);
      return Right(motivation);
    } on Exception catch (e) {
      return Left(CacheFailure(
          errorMessage: 'Error al obtener motivación: ${e.toString()}'));
    } catch (e) {
      return Left(CacheFailure(
          errorMessage: 'Error inesperado al obtener motivación: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserMotivation(
      UserMotivation motivation) async {
    try {
      await localDataSource.updateUserMotivation(motivation);
      return const Right(null);
    } on Exception catch (e) {
      return Left(CacheFailure(
          errorMessage: 'Error al actualizar motivación: ${e.toString()}'));
    } catch (e) {
      return Left(CacheFailure(
          errorMessage: 'Error inesperado al actualizar motivación: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveUserMood(UserMood mood) async {
    try {
      await localDataSource.saveUserMood(mood);
      return const Right(null);
    } on Exception catch (e) {
      return Left(CacheFailure(
          errorMessage: 'Error al guardar estado anímico: ${e.toString()}'));
    } catch (e) {
      return Left(CacheFailure(
          errorMessage: 'Error inesperado al guardar estado anímico: $e'));
    }
  }

  @override
  Future<Either<Failure, UserMood?>> getLatestUserMood(String userId) async {
    try {
      final mood = await localDataSource.getLatestUserMood(userId);
      return Right(mood);
    } on Exception catch (e) {
      return Left(CacheFailure(
          errorMessage: 'Error al obtener estado anímico: ${e.toString()}'));
    } catch (e) {
      return Left(CacheFailure(
          errorMessage: 'Error inesperado al obtener estado anímico: $e'));
    }
  }

  @override
  Future<Either<Failure, List<UserMood>>> getUserMoodHistory(String userId,
      {int limit = 30}) async {
    try {
      final moodHistory =
          await localDataSource.getUserMoodHistory(userId, limit: limit);
      return Right(moodHistory);
    } on Exception catch (e) {
      return Left(CacheFailure(
          errorMessage: 'Error al obtener historial anímico: ${e.toString()}'));
    } catch (e) {
      return Left(CacheFailure(
          errorMessage: 'Error inesperado al obtener historial anímico: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> markOnboardingCompleted(String userId) async {
    try {
      await localDataSource.markOnboardingCompleted(userId);
      return const Right(null);
    } on Exception catch (e) {
      return Left(CacheFailure(
          errorMessage: 'Error al marcar onboarding: ${e.toString()}'));
    } catch (e) {
      return Left(CacheFailure(
          errorMessage: 'Error inesperado al marcar onboarding: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> isOnboardingCompleted(String userId) async {
    try {
      final isCompleted = await localDataSource.isOnboardingCompleted(userId);
      return Right(isCompleted);
    } on Exception catch (e) {
      return Left(CacheFailure(
          errorMessage: 'Error al verificar onboarding: ${e.toString()}'));
    } catch (e) {
      return Left(CacheFailure(
          errorMessage: 'Error inesperado al verificar onboarding: $e'));
    }
  }
}
