import 'dart:convert';

ConfiguracionUsuarioDbModel configuracionUsuarioDbModelFromJson(String str) =>
    ConfiguracionUsuarioDbModel.fromJson(json.decode(str));

String configuracionUsuarioDbModelToJson(ConfiguracionUsuarioDbModel data) =>
    json.encode(data.toJson());

class ConfiguracionUsuarioDbModel {
  // Nombres de las columnas de la tabla
  static const String tabla = 'configuracion_usuario';
  static const String columnaId = 'id';
  static const String columnaUsuarioId = 'usuario_id';

  // Unidades de medida
  static const String columnaUnidadPeso = 'unidad_peso';
  static const String columnaUnidadLongitud = 'unidad_longitud';
  static const String columnaFormatoHora = 'formato_hora';
  static const String columnaFormatoFecha = 'formato_fecha';
  static const String columnaDiaInicioSemana = 'dia_inicio_semana';
  static const String columnaUnidadCalorias = 'unidad_calorias';

  // Configuraciones de entrenamiento
  static const String columnaTiempoDescansoDefecto = 'tiempo_descanso_defecto';
  static const String columnaSonidosHabilitados = 'sonidos_habilitados';
  static const String columnaVibracionHabilitada = 'vibracion_habilitada';
  static const String columnaVolumenSonidos = 'volumen_sonidos';
  static const String columnaIntensidadVibracion = 'intensidad_vibracion';
  static const String columnaAutoSiguienteEjercicio =
      'auto_siguiente_ejercicio';

  // Notificaciones
  static const String columnaNotificacionesHabilitadas =
      'notificaciones_habilitadas';
  static const String columnaRecordatorioEntrenar = 'recordatorio_entrenar';
  static const String columnaRecordatorioRacha = 'recordatorio_racha';
  static const String columnaRecordatorioDescanso = 'recordatorio_descanso';
  static const String columnaHoraRecordatorioManana =
      'hora_recordatorio_manana';
  static const String columnaHoraRecordatorioTarde = 'hora_recordatorio_tarde';

  // Tema y personalización
  static const String columnaModoOscuro = 'modo_oscuro';
  static const String columnaIdioma = 'idioma';

  // Auditoria
  static const String columnaFechaCreacion = 'fecha_creacion';
  static const String columnaFechaActualizacion = 'fecha_actualizacion';

  final String id;
  final String usuarioId;

  // Unidades
  final String unidadPeso;
  final String unidadLongitud;
  final String formatoHora;
  final String formatoFecha;
  final String diaInicioSemana;
  final String unidadCalorias;

  // Entrenamiento
  final int tiempoDescansoDefecto;
  final int sonidosHabilitados; // Boolean como int (0/1)
  final int vibracionHabilitada; // Boolean como int (0/1)
  final int volumenSonidos;
  final String intensidadVibracion;
  final int autoSiguienteEjercicio; // Boolean como int (0/1)

  // Notificaciones
  final int notificacionesHabilitadas; // Boolean como int (0/1)
  final int recordatorioEntrenar; // Boolean como int (0/1)
  final int recordatorioRacha; // Boolean como int (0/1)
  final int recordatorioDescanso; // Boolean como int (0/1)
  final String horaRecordatorioManana;
  final String horaRecordatorioTarde;

  // Personalización
  final int modoOscuro; // Boolean como int (0/1)
  final String idioma;

  // Auditoria
  final String fechaCreacion;
  final String? fechaActualizacion;

  ConfiguracionUsuarioDbModel({
    required this.id,
    required this.usuarioId,
    required this.unidadPeso,
    required this.unidadLongitud,
    required this.formatoHora,
    required this.formatoFecha,
    required this.diaInicioSemana,
    required this.unidadCalorias,
    required this.tiempoDescansoDefecto,
    required this.sonidosHabilitados,
    required this.vibracionHabilitada,
    required this.volumenSonidos,
    required this.intensidadVibracion,
    required this.autoSiguienteEjercicio,
    required this.notificacionesHabilitadas,
    required this.recordatorioEntrenar,
    required this.recordatorioRacha,
    required this.recordatorioDescanso,
    required this.horaRecordatorioManana,
    required this.horaRecordatorioTarde,
    required this.modoOscuro,
    required this.idioma,
    required this.fechaCreacion,
    this.fechaActualizacion,
  });

  ConfiguracionUsuarioDbModel copyWith({
    String? id,
    String? usuarioId,
    String? unidadPeso,
    String? unidadLongitud,
    String? formatoHora,
    String? formatoFecha,
    String? diaInicioSemana,
    String? unidadCalorias,
    int? tiempoDescansoDefecto,
    int? sonidosHabilitados,
    int? vibracionHabilitada,
    int? volumenSonidos,
    String? intensidadVibracion,
    int? autoSiguienteEjercicio,
    int? notificacionesHabilitadas,
    int? recordatorioEntrenar,
    int? recordatorioRacha,
    int? recordatorioDescanso,
    String? horaRecordatorioManana,
    String? horaRecordatorioTarde,
    int? modoOscuro,
    String? idioma,
    String? fechaCreacion,
    String? fechaActualizacion,
  }) =>
      ConfiguracionUsuarioDbModel(
        id: id ?? this.id,
        usuarioId: usuarioId ?? this.usuarioId,
        unidadPeso: unidadPeso ?? this.unidadPeso,
        unidadLongitud: unidadLongitud ?? this.unidadLongitud,
        formatoHora: formatoHora ?? this.formatoHora,
        formatoFecha: formatoFecha ?? this.formatoFecha,
        diaInicioSemana: diaInicioSemana ?? this.diaInicioSemana,
        unidadCalorias: unidadCalorias ?? this.unidadCalorias,
        tiempoDescansoDefecto:
            tiempoDescansoDefecto ?? this.tiempoDescansoDefecto,
        sonidosHabilitados: sonidosHabilitados ?? this.sonidosHabilitados,
        vibracionHabilitada: vibracionHabilitada ?? this.vibracionHabilitada,
        volumenSonidos: volumenSonidos ?? this.volumenSonidos,
        intensidadVibracion: intensidadVibracion ?? this.intensidadVibracion,
        autoSiguienteEjercicio:
            autoSiguienteEjercicio ?? this.autoSiguienteEjercicio,
        notificacionesHabilitadas:
            notificacionesHabilitadas ?? this.notificacionesHabilitadas,
        recordatorioEntrenar: recordatorioEntrenar ?? this.recordatorioEntrenar,
        recordatorioRacha: recordatorioRacha ?? this.recordatorioRacha,
        recordatorioDescanso: recordatorioDescanso ?? this.recordatorioDescanso,
        horaRecordatorioManana:
            horaRecordatorioManana ?? this.horaRecordatorioManana,
        horaRecordatorioTarde:
            horaRecordatorioTarde ?? this.horaRecordatorioTarde,
        modoOscuro: modoOscuro ?? this.modoOscuro,
        idioma: idioma ?? this.idioma,
        fechaCreacion: fechaCreacion ?? this.fechaCreacion,
        fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
      );

  factory ConfiguracionUsuarioDbModel.fromJson(Map<String, dynamic> json) =>
      ConfiguracionUsuarioDbModel(
        id: json[columnaId],
        usuarioId: json[columnaUsuarioId],
        unidadPeso: json[columnaUnidadPeso],
        unidadLongitud: json[columnaUnidadLongitud],
        formatoHora: json[columnaFormatoHora],
        formatoFecha: json[columnaFormatoFecha],
        diaInicioSemana: json[columnaDiaInicioSemana],
        unidadCalorias: json[columnaUnidadCalorias],
        tiempoDescansoDefecto: json[columnaTiempoDescansoDefecto],
        sonidosHabilitados: json[columnaSonidosHabilitados],
        vibracionHabilitada: json[columnaVibracionHabilitada],
        volumenSonidos: json[columnaVolumenSonidos],
        intensidadVibracion: json[columnaIntensidadVibracion],
        autoSiguienteEjercicio: json[columnaAutoSiguienteEjercicio],
        notificacionesHabilitadas: json[columnaNotificacionesHabilitadas],
        recordatorioEntrenar: json[columnaRecordatorioEntrenar],
        recordatorioRacha: json[columnaRecordatorioRacha],
        recordatorioDescanso: json[columnaRecordatorioDescanso],
        horaRecordatorioManana: json[columnaHoraRecordatorioManana],
        horaRecordatorioTarde: json[columnaHoraRecordatorioTarde],
        modoOscuro: json[columnaModoOscuro],
        idioma: json[columnaIdioma],
        fechaCreacion: json[columnaFechaCreacion],
        fechaActualizacion: json[columnaFechaActualizacion],
      );

  Map<String, dynamic> toJson() => {
        columnaId: id,
        columnaUsuarioId: usuarioId,
        columnaUnidadPeso: unidadPeso,
        columnaUnidadLongitud: unidadLongitud,
        columnaFormatoHora: formatoHora,
        columnaFormatoFecha: formatoFecha,
        columnaDiaInicioSemana: diaInicioSemana,
        columnaUnidadCalorias: unidadCalorias,
        columnaTiempoDescansoDefecto: tiempoDescansoDefecto,
        columnaSonidosHabilitados: sonidosHabilitados,
        columnaVibracionHabilitada: vibracionHabilitada,
        columnaVolumenSonidos: volumenSonidos,
        columnaIntensidadVibracion: intensidadVibracion,
        columnaAutoSiguienteEjercicio: autoSiguienteEjercicio,
        columnaNotificacionesHabilitadas: notificacionesHabilitadas,
        columnaRecordatorioEntrenar: recordatorioEntrenar,
        columnaRecordatorioRacha: recordatorioRacha,
        columnaRecordatorioDescanso: recordatorioDescanso,
        columnaHoraRecordatorioManana: horaRecordatorioManana,
        columnaHoraRecordatorioTarde: horaRecordatorioTarde,
        columnaModoOscuro: modoOscuro,
        columnaIdioma: idioma,
        columnaFechaCreacion: fechaCreacion,
        columnaFechaActualizacion: fechaActualizacion,
      };
}
