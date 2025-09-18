import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/setting/domain/entities/logro.dart';
import 'package:gymaster/features/setting/domain/repositories/achievement_repository.dart';

class GetAchievementUseCase
    implements UseCase<List<Logro>, GetAchievementParams> {
  final AchievementRepository repository;

  GetAchievementUseCase(this.repository);

  @override
  Future<Either<Failure, List<Logro>>> call(GetAchievementParams params) async {
    if (params.type != null) {
      return await repository.getAchievementsByType(params.type!);
    } else if (params.rarity != null) {
      return await repository.getAchievementsByRarity(params.rarity!);
    } else if (params.unlockedOnly) {
      return await repository.getUnlockedAchievements();
    } else {
      return await repository.getAllAchievements();
    }
  }
}

class GetAchievementParams {
  final TipoLogro? type;
  final RarezaLogro? rarity;
  final bool unlockedOnly;

  GetAchievementParams({
    this.type,
    this.rarity,
    this.unlockedOnly = false,
  });
}
