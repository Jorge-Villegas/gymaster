import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/routine/domain/repositories/routine_repository.dart';
import 'package:fpdart/fpdart.dart';

class AgregarEjercicioARutinaUseCase
    extends UseCase<void, AgregarEjercicioARutinaParams> {
  final RoutineRepository repositorio;

  AgregarEjercicioARutinaUseCase(this.repositorio);

  @override
  Future<Either<Failure, void>> call(
      AgregarEjercicioARutinaParams params) async {
    return await repositorio.addEjericioRutina(
      idRutina: params.idRutina,
      idSesion: params.idSesion,
      idEjercicio: params.idEjercicio,
      dataSeries: params.dataSeries,
    );
  }
}

class AgregarEjercicioARutinaParams {
  int? id;
  final String idRutina;
  final String idEjercicio;
  final String idSesion;
  final List<DataSerie> dataSeries;

  AgregarEjercicioARutinaParams({
    this.id,
    required this.idRutina,
    required this.idSesion,
    required this.idEjercicio,
    required this.dataSeries,
  });
  @override
  String toString() {
    return 'AddEjercicioRutinaParams(id: $id, idRutina: $idRutina, idEjercicio: $idEjercicio, dataSeries: $dataSeries)';
  }
}

class DataSerie {
  final double peso;
  final int numeroRepeticon;

  DataSerie({required this.peso, required this.numeroRepeticon});
  @override
  String toString() {
    return 'DataSerie(peso: $peso, numeroRepeticon: $numeroRepeticon)';
  }
}
