import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/routine/domain/repositories/rutine_repository.dart';
import 'package:fpdart/fpdart.dart';

class AddEjercicioRutinaUsecase
    extends UseCase<void, AddEjercicioRutinaParams> {
  final RoutineRepository _routineRepository;

  AddEjercicioRutinaUsecase(this._routineRepository);

  @override
  Future<Either<Failure, void>> call(AddEjercicioRutinaParams params) async {
    return await _routineRepository.addEjericioRutina(
      idRutina: params.idRutina,
      idEjercicio: params.idEjercicio,
      dataSeries: params.dataSeries,
    );
  }
}

class AddEjercicioRutinaParams {
  int? id;
  final String idRutina;
  final String idEjercicio;
  final List<DataSerie> dataSeries;

  AddEjercicioRutinaParams({
    this.id,
    required this.idRutina,
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

  DataSerie({
    required this.peso,
    required this.numeroRepeticon,
  });
  @override
  String toString() {
    return 'DataSerie(peso: $peso, numeroRepeticon: $numeroRepeticon)';
  }
}
