import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/features/setting/data/models/informacion_aplicacion.dart';

abstract class InformacionAplicacionRepository {
  Future<Either<Failure, InformacionAplicacion>> obtenerInformacionAplicacion();
  Future<Either<Failure, InformacionAplicacion>>
      actualizarInformacionAplicacion(InformacionAplicacion informacion);
  Future<Either<Failure, void>> incrementarContadorInicioApp();
  Future<Either<Failure, void>> incrementarContadorRutinasCompletadas();
  Future<Either<Failure, void>> incrementarContadorEjerciciosRealizados();
  Future<Either<Failure, void>> actualizarRachaActual(int nuevaRacha);
  Future<Either<Failure, void>> reiniciarDatos();
}
