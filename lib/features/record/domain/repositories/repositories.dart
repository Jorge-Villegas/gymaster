import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/features/record/domain/entities/record_rutina.dart';

abstract class RecordRepository {
  Future<Either<Failure, RecordRutina>> obtenerRutinaPorId(String id);
  Future<Either<Failure, void>> guardarRutina(RecordRutina rutina);
  Future<Either<Failure, void>> eliminarRutina(String id);
  Future<Either<Failure, List<RecordRutina>>>
      obtenerRutinasCompletadasConEjercicios();
}
