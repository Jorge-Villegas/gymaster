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
    final prefs = await SharedPreferences.getInstance();
    // false for light mode by default
    return prefs.getBool(_themeKey) ?? false;
  }

  Future<void> setLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, language);
  }

  Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    // 'en' for English by default
    return prefs.getString(_languageKey) ?? 'en';
  }
}
