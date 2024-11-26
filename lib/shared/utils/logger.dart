import 'package:logger/logger.dart';

/// Una instancia global de [Logger] para registrar mensajes de log.
/// 
/// Esta instancia de `Logger` se puede utilizar en toda la aplicación para
/// registrar mensajes de depuración, información, advertencias, errores, etc.
/// Utiliza la biblioteca `logger` que proporciona una forma fácil y estructurada
/// de manejar los logs en la aplicación.
///
/// Ejemplo de uso:
/// ```dart
/// logger.d('Mensaje de depuración');
/// logger.i('Mensaje de información');
/// logger.w('Mensaje de advertencia');
/// logger.e('Mensaje de error');
/// ```
final logger = Logger();