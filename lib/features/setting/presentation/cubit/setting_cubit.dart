import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/setting/domain/usecases/get_language_usecase.dart';
import 'package:gymaster/features/setting/domain/usecases/get_theme_mode_usecase.dart';
import 'package:gymaster/features/setting/domain/usecases/set_lenguage_usecase.dart';
import 'package:gymaster/features/setting/domain/usecases/set_theme_mode_usecase.dart';
import 'package:gymaster/features/setting/presentation/cubit/setting_state.dart';

class SettingCubit extends Cubit<SettingState> {
  final GetLanguageUseCase getLanguageUseCase;
  final SetLanguageUseCase setLanguageUseCase;
  final GetThemeModeUseCase getThemeModeUseCase;
  final SetThemeModeUseCase setThemeModeUseCase;

  SettingCubit({
    required this.getLanguageUseCase,
    required this.setLanguageUseCase,
    required this.getThemeModeUseCase,
    required this.setThemeModeUseCase,
  }) : super(SettingInitial());
  Future<void> loadSettings() async {
    try {
      emit(SettingLoading());
      final languageResult = await getLanguageUseCase(NoParams());
      final themeModeResult = await getThemeModeUseCase(NoParams());

      final language =
          languageResult.fold((failure) => 'English', (language) => language);
      final themeMode =
          themeModeResult.fold((failure) => false, (themeMode) => themeMode);

      // Define the list of available languages
      final languages = ['English', 'Spanish', 'French'];

      emit(SettingLoaded(
        isDarkMode: themeMode,
        isNotificationEnabled: false,
        language: language,
        theme: themeMode ? 'Oscuro' : 'Claro',
        weightUnit: 'kg',
        lengthUnit: 'cm',
        timeFormat: '24h',
        dateFormat: '31.01',
        weekStart: 'Lunes',
        calories: 'kcal',
        languages: languages,
      ));
    } catch (e) {
      emit(SettingError('Failed to load settings'));
    }
  }

  void toggleDarkMode() {
    final currentState = state;
    if (currentState is SettingLoaded) {
      final newMode = !currentState.isDarkMode;
      emit(currentState.copyWith(isDarkMode: newMode));
      setThemeModeUseCase(newMode);
    }
  }

  void toggleNotification(bool isEnabled) {
    final currentState = state;
    if (currentState is SettingLoaded) {
      emit(currentState.copyWith(isNotificationEnabled: isEnabled));
    }
  }

  void updateLanguage(String language) {
    final currentState = state;
    if (currentState is SettingLoaded) {
      emit(currentState.copyWith(language: language));
      setLanguageUseCase(language);
    }
  }

  void setTheme(String theme) {
    final currentState = state;
    if (currentState is SettingLoaded) {
      emit(currentState.copyWith(theme: theme));
    }
  }

  void setWeightUnit(String unit) {
    final currentState = state;
    if (currentState is SettingLoaded) {
      emit(currentState.copyWith(weightUnit: unit));
    }
  }

  void setLengthUnit(String unit) {
    final currentState = state;
    if (currentState is SettingLoaded) {
      emit(currentState.copyWith(lengthUnit: unit));
    }
  }

  void setTimeFormat(String format) {
    final currentState = state;
    if (currentState is SettingLoaded) {
      emit(currentState.copyWith(timeFormat: format));
    }
  }

  void setDateFormat(String format) {
    final currentState = state;
    if (currentState is SettingLoaded) {
      emit(currentState.copyWith(dateFormat: format));
    }
  }

  void setCalories(String unit) {
    final currentState = state;
    if (currentState is SettingLoaded) {
      emit(currentState.copyWith(calories: unit));
    }
  }
}
