import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';

abstract class SettingRepository {
  Future<Either<Failure, bool>> getThemeMode();
  Future<Either<Failure, void>> setThemeMode(bool isDarkMode);
  Future<Either<Failure, String>> getLanguage();
  Future<Either<Failure, void>> setLanguage(String language);
}
