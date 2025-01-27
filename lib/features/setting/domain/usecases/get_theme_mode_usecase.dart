import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/setting/domain/repositories/repositories.dart';

class GetThemeModeUseCase extends UseCase<bool, NoParams> {
  final SettingRepository repository;

  GetThemeModeUseCase({required this.repository});

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.getThemeMode();
  }
}
