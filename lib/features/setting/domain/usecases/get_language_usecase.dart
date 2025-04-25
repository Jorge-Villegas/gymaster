import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/setting/domain/repositories/repositories.dart';
import 'package:gymaster/shared/utils/language.dart';

class GetLanguageUseCase extends UseCase<String, NoParams> {
  final SettingRepository repository;

  GetLanguageUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return await repository.getLanguage();
  }
}

class GetLanguageUseCaseParams {
  final Language language;

  GetLanguageUseCaseParams({required this.language});
}
