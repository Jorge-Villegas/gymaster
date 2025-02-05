import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/setting/domain/repositories/repositories.dart';

class SetThemeModeUseCase extends UseCase<void, bool> {
  final SettingRepository repository;

  SetThemeModeUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(bool isDarkMode) async {
    return await repository.setThemeMode(isDarkMode);
  }
}
