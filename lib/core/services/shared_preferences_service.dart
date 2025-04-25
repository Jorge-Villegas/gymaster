import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences _prefs;

  SharedPreferencesService(this._prefs);

  // Guardar un valor booleano
  Future<void> saveBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  // Leer un valor booleano
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  // Guardar un valor string
  Future<void> saveString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  // Leer un valor string
  String? getString(String key) {
    return _prefs.getString(key);
  }

  // Guardar un valor entero
  Future<void> saveInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  // Leer un valor entero
  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  // Eliminar un valor
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  // Limpiar todas las preferencias
  Future<void> clear() async {
    await _prefs.clear();
  }
}
