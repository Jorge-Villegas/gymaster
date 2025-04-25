import 'package:gymaster/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

/// Define una interfaz para un caso de uso genérico.
///
/// Un caso de uso es una operación específica que la aplicación puede realizar.
/// Esta interfaz define un método de llamada que toma un parámetro y devuelve
/// un resultado de éxito o un fallo.
///
/// Los tipos de éxito y parámetros son genéricos para permitir diferentes tipos de operaciones.
abstract class UseCase<SuccessType, Params> {
  /// Método de llamada para el caso de uso.
  ///
  /// Toma un parámetro de tipo [Params] y devuelve un [Future] que será
  /// un [Either] conteniendo un [Failure] o un tipo de éxito [SuccessType].
  Future<Either<Failure, SuccessType>> call(Params params);
}

/// Define una clase para representar la ausencia de parámetros.
///
/// Esta clase se puede utilizar cuando un caso de uso no requiere parámetros.
class NoParams {}
