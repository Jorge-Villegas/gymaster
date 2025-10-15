import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/setting/domain/entities/perfil_usuario_completo.dart';
import 'package:gymaster/features/setting/domain/repositories/perfil_usuario_completo_repository.dart';

class CrearPerfilCompletoUseCase
    implements UseCase<PerfilUsuarioCompleto, CrearPerfilCompletoParams> {
  final PerfilUsuarioCompletoRepository repository;

  CrearPerfilCompletoUseCase(this.repository);

  @override
  Future<Either<Failure, PerfilUsuarioCompleto>> call(
      CrearPerfilCompletoParams params) async {
    // Validaciones de negocio
    if (params.nombreUsuario.trim().isEmpty) {
      return Left(
          CacheFailure(errorMessage: 'El nombre de usuario es requerido'));
    }

    if (params.nombreCompleto.trim().isEmpty) {
      return Left(
          CacheFailure(errorMessage: 'El nombre completo es requerido'));
    }

    if (params.fotoPerfil.trim().isEmpty) {
      return Left(CacheFailure(errorMessage: 'Debes seleccionar un avatar'));
    }

    // Validar edad si se proporciona fecha de nacimiento
    if (params.fechaNacimiento != null) {
      final edad = _calcularEdad(params.fechaNacimiento!);
      if (edad < 13) {
        return Left(CacheFailure(errorMessage: 'Debes tener al menos 13 años'));
      }
      if (edad > 120) {
        return Left(CacheFailure(errorMessage: 'Fecha de nacimiento inválida'));
      }
    }

    // Validar medidas físicas
    if (params.alturaCm != null &&
        (params.alturaCm! < 50 || params.alturaCm! > 300)) {
      return Left(
          CacheFailure(errorMessage: 'La altura debe estar entre 50 y 300 cm'));
    }

    if (params.pesoActualKg != null &&
        (params.pesoActualKg! < 20 || params.pesoActualKg! > 500)) {
      return Left(CacheFailure(
          errorMessage: 'El peso actual debe estar entre 20 y 500 kg'));
    }

    if (params.pesoObjetivoKg != null &&
        (params.pesoObjetivoKg! < 20 || params.pesoObjetivoKg! > 500)) {
      return Left(CacheFailure(
          errorMessage: 'El peso objetivo debe estar entre 20 y 500 kg'));
    }

    return await repository.crearPerfilCompleto(
      nombreUsuario: params.nombreUsuario.trim(),
      correo: params.correo?.trim(),
      fotoPerfil: params.fotoPerfil,
      nombreCompleto: params.nombreCompleto.trim(),
      fechaNacimiento: params.fechaNacimiento,
      genero: params.genero,
      objetivoFitness: params.objetivoFitness,
      nivelExperiencia: params.nivelExperiencia,
      alturaCm: params.alturaCm,
      pesoActualKg: params.pesoActualKg,
      pesoObjetivoKg: params.pesoObjetivoKg,
    );
  }

  int _calcularEdad(DateTime fechaNacimiento) {
    final hoy = DateTime.now();
    int edad = hoy.year - fechaNacimiento.year;
    if (hoy.month < fechaNacimiento.month ||
        (hoy.month == fechaNacimiento.month && hoy.day < fechaNacimiento.day)) {
      edad--;
    }
    return edad;
  }
}

class CrearPerfilCompletoParams {
  final String nombreUsuario;
  final String? correo;
  final String fotoPerfil;
  final String nombreCompleto;
  final DateTime? fechaNacimiento;
  final Genero genero;
  final ObjetivoFitness objetivoFitness;
  final NivelExperiencia nivelExperiencia;
  final int? alturaCm;
  final double? pesoActualKg;
  final double? pesoObjetivoKg;

  CrearPerfilCompletoParams({
    required this.nombreUsuario,
    this.correo,
    required this.fotoPerfil,
    required this.nombreCompleto,
    this.fechaNacimiento,
    required this.genero,
    required this.objetivoFitness,
    required this.nivelExperiencia,
    this.alturaCm,
    this.pesoActualKg,
    this.pesoObjetivoKg,
  });
}
