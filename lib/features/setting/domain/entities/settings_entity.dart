// settings/domain/entities/settings_entity.dart
class SettingsEntity {
  final bool isDarkMode;
  final String locale;
  final String username;

  SettingsEntity({
    required this.isDarkMode,
    required this.locale,
    required this.username,
  });
}
