import 'package:gymaster/core/database/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingLocalDataSource {
  final DatabaseHelper databaseHelper;

  SettingLocalDataSource(this.databaseHelper);

  static const _themeKey = 'theme_mode';
  static const _languageKey = 'language';

  Future<void> setThemeMode(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDarkMode);
  }

  Future<bool> getThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_themeKey) ?? false;
    } catch (e) {
      return false; // Default theme
    }
  }

  Future<void> setLanguage(String language) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, language);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_languageKey) ?? 'Spanish';
    } catch (e) {
      return 'Spanish'; // Default fallback
    }
  }
}
