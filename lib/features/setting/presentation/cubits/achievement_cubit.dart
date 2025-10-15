import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/features/setting/data/models/logro.dart';
import 'package:gymaster/features/setting/domain/repositories/achievement_repository.dart';
import 'package:gymaster/features/setting/domain/usecases/get_achievement_usecase.dart';

part 'achievement_state.dart';

class AchievementCubit extends Cubit<AchievementState> {
  final GetAchievementUseCase getAchievementUseCase;
  final AchievementRepository achievementRepository;

  AchievementCubit({
    required this.getAchievementUseCase,
    required this.achievementRepository,
  }) : super(AchievementInitial()) {
    _initializeAchievements();
  }

  Future<void> _initializeAchievements() async {
    await achievementRepository.initializePredefinedAchievements();
    await getAllAchievements();
  }

  Future<void> getAllAchievements() async {
    emit(AchievementLoading());

    final result = await getAchievementUseCase(GetAchievementParams());
    result.fold(
      (failure) {
        debugPrint('Error al cargar logros: ${failure.errorMessage}');
        emit(AchievementError(_getUserFriendlyMessage(failure)));
      },
      (achievements) => emit(AchievementLoaded(achievements)),
    );
  }

  Future<void> getAchievementsByType(TipoLogro type) async {
    emit(AchievementLoading());

    final result =
        await getAchievementUseCase(GetAchievementParams(type: type));
    result.fold(
      (failure) {
        debugPrint('Error al cargar logros por tipo: ${failure.errorMessage}');
        emit(AchievementError(_getUserFriendlyMessage(failure)));
      },
      (achievements) => emit(AchievementLoaded(achievements)),
    );
  }

  Future<void> getUnlockedAchievements() async {
    emit(AchievementLoading());

    final result =
        await getAchievementUseCase(GetAchievementParams(unlockedOnly: true));
    result.fold(
      (failure) {
        debugPrint(
            'Error al cargar logros desbloqueados: ${failure.errorMessage}');
        emit(AchievementError(_getUserFriendlyMessage(failure)));
      },
      (achievements) => emit(AchievementLoaded(achievements)),
    );
  }

  Future<void> unlockAchievement(String achievementId) async {
    final result = await achievementRepository.unlockAchievement(achievementId);
    result.fold(
      (failure) {
        debugPrint('Error al desbloquear logro: ${failure.errorMessage}');
        emit(AchievementError(_getUserFriendlyMessage(failure)));
      },
      (achievement) {
        emit(AchievementUnlocked(achievement));
        // Recargar todos los logros después de desbloquear uno
        getAllAchievements();
      },
    );
  }

  Future<void> checkAndUnlockAchievements(
      Map<String, dynamic> userStats) async {
    final result =
        await achievementRepository.checkAchievementsToUnlock(userStats);
    result.fold(
      (failure) {
        debugPrint('Error al verificar logros: ${failure.errorMessage}');
      },
      (newAchievements) {
        if (newAchievements.isNotEmpty) {
          emit(MultipleAchievementsUnlocked(newAchievements));
          // Recargar todos los logros
          getAllAchievements();
        }
      },
    );
  }

  Future<void> getAchievementStats() async {
    final result = await achievementRepository.getAchievementStats();
    result.fold(
      (failure) {
        debugPrint('Error al obtener estadísticas: ${failure.errorMessage}');
        emit(AchievementError(_getUserFriendlyMessage(failure)));
      },
      (stats) => emit(AchievementStatsLoaded(stats)),
    );
  }

  /// Convierte errores técnicos en mensajes amigables para el usuario
  String _getUserFriendlyMessage(Failure failure) {
    return switch (failure) {
      CacheFailure _ => 'Error de base de datos. Intenta de nuevo.',
      NoRecordsFailure _ =>
        'No tienes logros aún. ¡Comienza a entrenar para desbloquearlos!',
      ServerFailure _ => 'Sin conexión a internet. Verifica tu conexión.',
      _ => 'Ocurrió un error inesperado. Intenta de nuevo.',
    };
  }
}
