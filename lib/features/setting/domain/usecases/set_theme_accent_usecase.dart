import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/setting/domain/repositories/repositories.dart';

class SetThemeAccentUseCase extends UseCase<void, String> {
  final SettingRepository repository;

  SetThemeAccentUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String accent) async {
    return await repository.setThemeAccent(accent);
  }
}
