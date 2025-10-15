import 'dart:convert';

InformacionAplicacionDbModel informacionAplicacionDbModelFromJson(String str) =>
    InformacionAplicacionDbModel.fromJson(json.decode(str));

String informacionAplicacionDbModelToJson(InformacionAplicacionDbModel data) =>
    json.encode(data.toJson());

class InformacionAplicacionDbModel {
  // Nombres de las columnas de la tabla
  static const String tabla = 'informacion_aplicacion';
  static const String columnaId = 'id';
  static const String columnaVersionApp = 'version_app';
  static const String columnaFechaInstalacion = 'fecha_instalacion';
  static const String columnaFechaUltimaActualizacion =
      'fecha_ultima_actualizacion';
  static const String columnaNumeroIniciosSesion = 'numero_inicios_sesion';
  static const String columnaFechaUltimoInicio = 'fecha_ultimo_inicio';
  static const String columnaRachaActual = 'racha_actual';
  static const String columnaRachaMaxima = 'racha_maxima';
  static const String columnaTotalRutinasCompletadas =
      'total_rutinas_completadas';
  static const String columnaTotalEjerciciosRealizados =
      'total_ejercicios_realizados';
  static const String columnaTiempoTotalEntrenamiento =
      'tiempo_total_entrenamiento';
  static const String columnaFechaCreacion = 'fecha_creacion';

  final String id;
  final String versionApp;
  final String fechaInstalacion;
  final String? fechaUltimaActualizacion;
  final int numeroIniciosSesion;
  final String? fechaUltimoInicio;
  final int rachaActual;
  final int rachaMaxima;
  final int totalRutinasCompletadas;
  final int totalEjerciciosRealizados;
  final int tiempoTotalEntrenamiento; // En segundos
  final String fechaCreacion;

  InformacionAplicacionDbModel({
    required this.id,
    required this.versionApp,
    required this.fechaInstalacion,
    this.fechaUltimaActualizacion,
    required this.numeroIniciosSesion,
    this.fechaUltimoInicio,
    required this.rachaActual,
    required this.rachaMaxima,
    required this.totalRutinasCompletadas,
    required this.totalEjerciciosRealizados,
    required this.tiempoTotalEntrenamiento,
    required this.fechaCreacion,
  });

  InformacionAplicacionDbModel copyWith({
    String? id,
    String? versionApp,
    String? fechaInstalacion,
    String? fechaUltimaActualizacion,
    int? numeroIniciosSesion,
    String? fechaUltimoInicio,
    int? rachaActual,
    int? rachaMaxima,
    int? totalRutinasCompletadas,
    int? totalEjerciciosRealizados,
    int? tiempoTotalEntrenamiento,
    String? fechaCreacion,
  }) =>
      InformacionAplicacionDbModel(
        id: id ?? this.id,
        versionApp: versionApp ?? this.versionApp,
        fechaInstalacion: fechaInstalacion ?? this.fechaInstalacion,
        fechaUltimaActualizacion:
            fechaUltimaActualizacion ?? this.fechaUltimaActualizacion,
        numeroIniciosSesion: numeroIniciosSesion ?? this.numeroIniciosSesion,
        fechaUltimoInicio: fechaUltimoInicio ?? this.fechaUltimoInicio,
        rachaActual: rachaActual ?? this.rachaActual,
        rachaMaxima: rachaMaxima ?? this.rachaMaxima,
        totalRutinasCompletadas:
            totalRutinasCompletadas ?? this.totalRutinasCompletadas,
        totalEjerciciosRealizados:
            totalEjerciciosRealizados ?? this.totalEjerciciosRealizados,
        tiempoTotalEntrenamiento:
            tiempoTotalEntrenamiento ?? this.tiempoTotalEntrenamiento,
        fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      );

  factory InformacionAplicacionDbModel.fromJson(Map<String, dynamic> json) =>
      InformacionAplicacionDbModel(
        id: json[columnaId],
        versionApp: json[columnaVersionApp],
        fechaInstalacion: json[columnaFechaInstalacion],
        fechaUltimaActualizacion: json[columnaFechaUltimaActualizacion],
        numeroIniciosSesion: json[columnaNumeroIniciosSesion],
        fechaUltimoInicio: json[columnaFechaUltimoInicio],
        rachaActual: json[columnaRachaActual],
        rachaMaxima: json[columnaRachaMaxima],
        totalRutinasCompletadas: json[columnaTotalRutinasCompletadas],
        totalEjerciciosRealizados: json[columnaTotalEjerciciosRealizados],
        tiempoTotalEntrenamiento: json[columnaTiempoTotalEntrenamiento],
        fechaCreacion: json[columnaFechaCreacion],
      );

  Map<String, dynamic> toJson() => {
        columnaId: id,
        columnaVersionApp: versionApp,
        columnaFechaInstalacion: fechaInstalacion,
        columnaFechaUltimaActualizacion: fechaUltimaActualizacion,
        columnaNumeroIniciosSesion: numeroIniciosSesion,
        columnaFechaUltimoInicio: fechaUltimoInicio,
        columnaRachaActual: rachaActual,
        columnaRachaMaxima: rachaMaxima,
        columnaTotalRutinasCompletadas: totalRutinasCompletadas,
        columnaTotalEjerciciosRealizados: totalEjerciciosRealizados,
        columnaTiempoTotalEntrenamiento: tiempoTotalEntrenamiento,
        columnaFechaCreacion: fechaCreacion,
      };
}
