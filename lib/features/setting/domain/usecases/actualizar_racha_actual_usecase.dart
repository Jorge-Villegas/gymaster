import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/setting/domain/repositories/informacion_aplicacion_repository.dart';

class ActualizarRachaActualUseCase
    implements UseCase<void, ActualizarRachaActualParams> {
  final InformacionAplicacionRepository repository;

  ActualizarRachaActualUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ActualizarRachaActualParams params) async {
    return await repository.actualizarRachaActual(params.nuevaRacha);
  }
}

class ActualizarRachaActualParams {
  final int nuevaRacha;

  ActualizarRachaActualParams({required this.nuevaRacha});
}
