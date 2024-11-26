import 'package:uuid/uuid.dart';

/// Una interfaz para generar identificadores únicos.
/// 
/// Esta interfaz define un método `generateId` que debe ser implementado
/// por cualquier clase que desee proporcionar una funcionalidad de generación
/// de identificadores únicos. Esto permite cambiar fácilmente la implementación
/// del generador de ID sin modificar el código que lo utiliza.
abstract class IdGenerator {
  /// Genera un identificador único.
  /// 
  /// Este método debe ser implementado por cualquier clase que implemente
  /// la interfaz `IdGenerator`. Devuelve un `String` que representa un
  /// identificador único.
  String generateId();
}

/// Implementación de [IdGenerator] que utiliza UUID (Universally Unique Identifier).
/// 
/// Esta clase utiliza la biblioteca `uuid` para generar identificadores únicos
/// basados en el estándar UUID v4. Es una implementación concreta de la interfaz
/// `IdGenerator` y puede ser utilizada en cualquier lugar donde se necesite un
/// identificador único.
class UuidGenerator implements IdGenerator {
  static final UuidGenerator _instance = UuidGenerator._internal();

  UuidGenerator._internal();

  factory UuidGenerator() {
    return _instance;
  }

  @override
  String generateId() {
    return const Uuid().v4();
  }
}