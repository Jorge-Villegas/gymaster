import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/setting/data/models/informacion_aplicacion.dart';
import 'package:gymaster/features/setting/domain/repositories/informacion_aplicacion_repository.dart';

class ObtenerInformacionAplicacionUseCase
    implements UseCase<InformacionAplicacion, NoParams> {
  final InformacionAplicacionRepository repository;

  ObtenerInformacionAplicacionUseCase(this.repository);

  @override
  Future<Either<Failure, InformacionAplicacion>> call(NoParams params) async {
    return await repository.obtenerInformacionAplicacion();
  }
}
