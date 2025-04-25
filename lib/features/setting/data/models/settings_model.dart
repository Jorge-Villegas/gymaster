class SettingsModel {
  final bool isDarkMode;
  final String locale;
  final String username;

  SettingsModel({
    required this.isDarkMode,
    required this.locale,
    required this.username,
  });
// Métodos de conversión a/desde JSON o Map
}

// settings/data/repositories/settings_repository.dart
abstract class SettingsRepository {
  Future<SettingsModel> loadSettings();
  Future<void> saveSettings(SettingsModel settings);
}
