import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/setting/domain/repositories/repositories.dart';

class SetLanguageUseCase extends UseCase<void, String> {
  final SettingRepository repository;

  SetLanguageUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(String language) async {
    return await repository.setLanguage(language);
  }
}
