/// Este archivo contiene una función para generar un hash rápido de una cadena de texto.
///
/// La función [fastHash] utiliza el algoritmo FNV-1a 64bit hash, optimizado para Dart Strings.
/// Es útil para generar identificadores únicos o para realizar operaciones de hash en cadenas de texto.
///
/// Ejemplo de uso:
/// ```dart
/// int hash = fastHash("mi_cadena_de_texto");
/// ```
library hash_utils;

/// Genera un hash rápido de una cadena de texto utilizando el algoritmo FNV-1a 64bit hash.
///
/// La función [fastHash] toma una cadena de texto como entrada y devuelve un entero que
/// representa el hash de la cadena.
///
/// Ejemplo de uso:
/// ```dart
/// int hash = fastHash("mi_cadena_de_texto");
/// ```
/// https://isar.dev/es/recipes/string_ids.html#funcion-rapida-de-hash
int fastHash(String string) {
  var hash = 0xcbf29ce484222325;

  var i = 0;
  while (i < string.length) {
    final codeUnit = string.codeUnitAt(i++);
    hash ^= codeUnit >> 8;
    hash *= 0x100000001b3;
    hash ^= codeUnit & 0xFF;
    hash *= 0x100000001b3;
  }

  return hash;
}
