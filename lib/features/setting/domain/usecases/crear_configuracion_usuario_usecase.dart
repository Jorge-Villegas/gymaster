import 'package:fpdart/fpdart.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/setting/data/models/configuracion_usuario.dart';
import 'package:gymaster/features/setting/domain/repositories/configuracion_usuario_repository.dart';

class CrearConfiguracionUsuarioUseCase
    implements UseCase<ConfiguracionUsuario, CrearConfiguracionUsuarioParams> {
  final ConfiguracionUsuarioRepository repository;

  CrearConfiguracionUsuarioUseCase(this.repository);

  @override
  Future<Either<Failure, ConfiguracionUsuario>> call(
      CrearConfiguracionUsuarioParams params) async {
    final configuracion = ConfiguracionUsuario(
      usuarioId: params.usuarioId,
      unidadPeso: params.unidadPeso,
      unidadLongitud: params.unidadLongitud,
      formatoHora: params.formatoHora,
      formatoFecha: params.formatoFecha,
      diaInicioSemana: params.diaInicioSemana,
      unidadCalorias: params.unidadCalorias,
      tiempoDescansoDefecto: params.tiempoDescansoDefecto,
      sonidosHabilitados: params.sonidosHabilitados,
      vibracionHabilitada: params.vibracionHabilitada,
      volumenSonidos: params.volumenSonidos,
      intensidadVibracion: params.intensidadVibracion,
      autoSiguienteEjercicio: params.autoSiguienteEjercicio,
      notificacionesHabilitadas: params.notificacionesHabilitadas,
      recordatorioEntrenar: params.recordatorioEntrenar,
      recordatorioRacha: params.recordatorioRacha,
      recordatorioDescanso: params.recordatorioDescanso,
      horaRecordatorioManana: params.horaRecordatorioManana ?? '08:00',
      horaRecordatorioTarde: params.horaRecordatorioTarde ?? '18:00',
      modoOscuro: params.modoOscuro,
      idioma: params.idioma,
      fechaCreacion: DateTime.now(),
    );

    return await repository.crearConfiguracion(configuracion);
  }
}

class CrearConfiguracionUsuarioParams {
  final String usuarioId;
  final String unidadPeso;
  final String unidadLongitud;
  final String formatoHora;
  final String formatoFecha;
  final String diaInicioSemana;
  final String unidadCalorias;
  final int tiempoDescansoDefecto;
  final bool sonidosHabilitados;
  final bool vibracionHabilitada;
  final int volumenSonidos;
  final String intensidadVibracion;
  final bool autoSiguienteEjercicio;
  final bool notificacionesHabilitadas;
  final bool recordatorioEntrenar;
  final bool recordatorioRacha;
  final bool recordatorioDescanso;
  final String? horaRecordatorioManana;
  final String? horaRecordatorioTarde;
  final bool modoOscuro;
  final String idioma;

  CrearConfiguracionUsuarioParams({
    required this.usuarioId,
    this.unidadPeso = 'kg',
    this.unidadLongitud = 'cm',
    this.formatoHora = '24h',
    this.formatoFecha = 'dd/mm/yyyy',
    this.diaInicioSemana = 'lunes',
    this.unidadCalorias = 'kcal',
    this.tiempoDescansoDefecto = 60,
    this.sonidosHabilitados = true,
    this.vibracionHabilitada = true,
    this.volumenSonidos = 80,
    this.intensidadVibracion = 'media',
    this.autoSiguienteEjercicio = false,
    this.notificacionesHabilitadas = true,
    this.recordatorioEntrenar = true,
    this.recordatorioRacha = true,
    this.recordatorioDescanso = false,
    this.horaRecordatorioManana = '08:00',
    this.horaRecordatorioTarde = '18:00',
    this.modoOscuro = false,
    this.idioma = 'es',
  });
}
