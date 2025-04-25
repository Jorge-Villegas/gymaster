/// Excepción lanzada cuando ocurre un error en el servidor.
///
/// Esta excepción se utiliza para indicar que una operación que depende de un
/// servidor remoto ha fallado. Puede ser causada por problemas de conectividad,
/// errores en el servidor, o respuestas inesperadas.
class ServerException implements Exception {}

/// Excepción lanzada cuando ocurre un error al acceder a la caché.
///
/// Esta excepción se utiliza para indicar que ha habido un problema al leer o
/// escribir datos en la caché local. Puede ser causada por corrupción de datos
/// o problemas de almacenamiento.
class CacheException implements Exception {}

/// Excepción lanzada cuando no se encuentran registros en la base de datos.
///
/// Esta excepción se utiliza para indicar que una consulta a la base de datos
/// no ha devuelto ningún resultado. Es útil para manejar casos donde se espera
/// que existan registros pero no se encuentran.
class NoRecordsException implements Exception {}

/// Excepción lanzada cuando no se encuentra un recurso solicitado.
///
/// Esta excepción se utiliza para indicar que un recurso específico no ha sido
/// encontrado. Puede ser utilizada cuando se intenta acceder a un recurso que
/// no existe o ha sido eliminado.
class NotFoundException implements Exception {}

/// Excepción lanzada cuando ocurre un error inesperado.
///
/// Esta excepción se utiliza para manejar errores que no están cubiertos por
/// otras excepciones específicas. Es útil para capturar y manejar errores
/// imprevistos en la aplicación.
class UnexpectedException implements Exception {}
