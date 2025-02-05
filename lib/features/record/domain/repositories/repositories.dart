import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/features/record/domain/entities/record_rutina.dart';

abstract class RecordRepository {
  Future<Either<Failure, List<RecordRutina>>> getAllRutinas();
  Future<Either<Failure, RecordRutina>> getRutinaById(String id);
  Future<Either<Failure, void>> saveRutina(RecordRutina rutina);
  Future<Either<Failure, void>> deleteRutina(String id);
  Future<Either<Failure, List<RecordRutina>>>
      getAllCompletedRoutinesWithExercises();
}
