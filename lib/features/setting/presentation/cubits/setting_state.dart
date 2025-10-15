abstract class SettingState {}

class SettingInitial extends SettingState {}

class SettingLoading extends SettingState {}

class SettingLoaded extends SettingState {
  final bool isDarkMode;
  final bool isNotificationEnabled;
  final String language;
  final String theme;
  final String weightUnit;
  final String lengthUnit;
  final String timeFormat;
  final String dateFormat;
  final String weekStart;
  final String calories;
  final List<String> languages;

  SettingLoaded({
    required this.isDarkMode,
    required this.isNotificationEnabled,
    required this.language,
    required this.theme,
    required this.weightUnit,
    required this.lengthUnit,
    required this.timeFormat,
    required this.dateFormat,
    required this.weekStart,
    required this.calories,
    required this.languages,
  });

  SettingLoaded copyWith({
    bool? isDarkMode,
    bool? isNotificationEnabled,
    String? language,
    String? theme,
    String? weightUnit,
    String? lengthUnit,
    String? timeFormat,
    String? dateFormat,
    String? weekStart,
    String? calories,
    List<String>? languages,
  }) {
    return SettingLoaded(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isNotificationEnabled:
          isNotificationEnabled ?? this.isNotificationEnabled,
      language: language ?? this.language,
      theme: theme ?? this.theme,
      weightUnit: weightUnit ?? this.weightUnit,
      lengthUnit: lengthUnit ?? this.lengthUnit,
      timeFormat: timeFormat ?? this.timeFormat,
      dateFormat: dateFormat ?? this.dateFormat,
      weekStart: weekStart ?? this.weekStart,
      calories: calories ?? this.calories,
      languages: languages ?? this.languages,
    );
  }
}

class SettingError extends SettingState {
  final String message;

  SettingError(this.message);
}
