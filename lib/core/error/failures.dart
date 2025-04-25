/// Clase base para representar fallas en la aplicación.
///
/// Esta clase abstracta se utiliza para definir fallas que pueden ocurrir en
/// la aplicación. Cada falla tiene un mensaje de error asociado.
abstract class Failure {
  final String errorMessage;
  const Failure({required this.errorMessage});
}

/// Falla que ocurre cuando hay un error en el servidor.
///
/// Esta falla se utiliza para indicar que una operación que depende de un
/// servidor remoto ha fallado.
class ServerFailure extends Failure {
  ServerFailure({required super.errorMessage});
}

/// Falla que ocurre cuando hay un error al acceder a la caché.
///
/// Esta falla se utiliza para indicar que ha habido un problema al leer o
/// escribir datos en la caché local.
class CacheFailure extends Failure {
  CacheFailure({required super.errorMessage});
}

/// Falla que ocurre cuando no se encuentran registros en la base de datos.
///
/// Esta falla se utiliza para indicar que una consulta a la base de datos
/// no ha devuelto ningún resultado.
class NoRecordsFailure extends Failure {
  NoRecordsFailure({required super.errorMessage});
}

/// Falla que ocurre cuando no se encuentra un recurso solicitado.
///
/// Esta falla se utiliza para indicar que un recurso específico no ha sido
/// encontrado.
class NotFoundFailure extends Failure {
  NotFoundFailure({required super.errorMessage});
}

/// Falla que ocurre cuando hay un error inesperado.
///
/// Esta falla se utiliza para manejar errores que no están cubiertos por
/// otras fallas específicas.
class UnexpectedFailure extends Failure {
  UnexpectedFailure({required super.errorMessage});
}
