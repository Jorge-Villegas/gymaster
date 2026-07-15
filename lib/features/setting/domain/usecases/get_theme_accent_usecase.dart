import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/setting/domain/repositories/repositories.dart';

class GetThemeAccentUseCase extends UseCase<String, NoParams> {
  final SettingRepository repository;

  GetThemeAccentUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return await repository.getThemeAccent();
  }
}
