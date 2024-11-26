/// Clase `TextFormatter` que contiene métodos útiles para el formateo de texto.
///
/// Esta es una clase abstracta y no puede ser instanciada.
/// Todos sus métodos son estáticos y pueden ser llamados directamente.
abstract class TextFormatter {
  /// Convierte la primera letra de la cadena [texto] a mayúscula.
  ///
  /// Si la cadena [texto] está vacía, devuelve una cadena vacía.
  ///
  /// Ejemplo:
  /// ```dart
  /// String capitalizedString = TextFormatter.capitalize("mi texto");
  /// print(capitalizedString);  // Imprime: Mi texto
  /// ```
  static String capitalize(String texto) {
    if (texto.isEmpty) {
      return "";
    }
    return texto[0].toUpperCase() + texto.substring(1);
  }

  /// Convierte la cadena [texto] a un valor `double`.
  static double? stringToDouble(String text) {
    try {
      return double.parse(text);
    } catch (e) {
      return null;
    }
  }

  /// Convierte la cadena [texto] a un valor `int`.
  static int? stringToInt(String text) {
    try {
      return int.parse(text);
    } catch (e) {
      return null;
    }
  }
}
