import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/features/setting/data/sources/config_local_data_source.dart';
import 'package:gymaster/features/setting/domain/repositories/repositories.dart';

class SettingRepositoryImp implements SettingRepository {
  final SettingLocalDataSource localDataSource;
  SettingRepositoryImp({required this.localDataSource});

  @override
  Future<Either<Failure, String>> getLanguage() async {
    try {
      final language = await localDataSource.getLanguage();
      return Right(language);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> getThemeMode() async {
    try {
      final isDarkMode = await localDataSource.getThemeMode();
      return Right(isDarkMode);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> setLanguage(String language) async {
    try {
      await localDataSource.setLanguage(language);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> setThemeMode(bool isDarkMode) async {
    try {
      await localDataSource.setThemeMode(isDarkMode);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
