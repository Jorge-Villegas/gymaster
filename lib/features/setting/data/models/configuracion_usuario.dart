import 'package:equatable/equatable.dart';

class ConfiguracionUsuario extends Equatable {
  final String? id;
  final String usuarioId;
  
  // Unidades de medida
  final String unidadPeso; // 'kg', 'lb'
  final String unidadLongitud; // 'cm', 'in'
  final String formatoHora; // '24h', '12h'
  final String formatoFecha; // '31.01', '01/31'
  final String diaInicioSemana; // 'lunes', 'domingo'
  final String unidadCalorias; // 'kcal', 'kj'
  
  // Configuraciones de entrenamiento
  final int tiempoDescansoDefecto; // En segundos
  final bool sonidosHabilitados;
  final bool vibracionHabilitada;
  final int volumenSonidos; // 0-100
  final String intensidadVibracion; // 'baja', 'media', 'alta'
  final bool autoSiguienteEjercicio;
  
  // Notificaciones
  final bool notificacionesHabilitadas;
  final bool recordatorioEntrenar;
  final bool recordatorioRacha;
  final bool recordatorioDescanso;
  final String horaRecordatorioManana; // 'HH:MM'
  final String horaRecordatorioTarde; // 'HH:MM'
  
  // Personalización
  final bool modoOscuro;
  final String idioma; // 'es', 'en'
  
  // Auditoria
  final DateTime fechaCreacion;
  final DateTime? fechaActualizacion;

  const ConfiguracionUsuario({
    this.id,
    required this.usuarioId,
    this.unidadPeso = 'kg',
    this.unidadLongitud = 'cm',
    this.formatoHora = '24h',
    this.formatoFecha = '31.01',
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
    this.recordatorioDescanso = true,
    this.horaRecordatorioManana = '08:00',
    this.horaRecordatorioTarde = '18:00',
    this.modoOscuro = false,
    this.idioma = 'es',
    required this.fechaCreacion,
    this.fechaActualizacion,
  });

  ConfiguracionUsuario copyWith({
    String? id,
    String? usuarioId,
    String? unidadPeso,
    String? unidadLongitud,
    String? formatoHora,
    String? formatoFecha,
    String? diaInicioSemana,
    String? unidadCalorias,
    int? tiempoDescansoDefecto,
    bool? sonidosHabilitados,
    bool? vibracionHabilitada,
    int? volumenSonidos,
    String? intensidadVibracion,
    bool? autoSiguienteEjercicio,
    bool? notificacionesHabilitadas,
    bool? recordatorioEntrenar,
    bool? recordatorioRacha,
    bool? recordatorioDescanso,
    String? horaRecordatorioManana,
    String? horaRecordatorioTarde,
    bool? modoOscuro,
    String? idioma,
    DateTime? fechaCreacion,
    DateTime? fechaActualizacion,
  }) =>
      ConfiguracionUsuario(
        id: id ?? this.id,
        usuarioId: usuarioId ?? this.usuarioId,
        unidadPeso: unidadPeso ?? this.unidadPeso,
        unidadLongitud: unidadLongitud ?? this.unidadLongitud,
        formatoHora: formatoHora ?? this.formatoHora,
        formatoFecha: formatoFecha ?? this.formatoFecha,
        diaInicioSemana: diaInicioSemana ?? this.diaInicioSemana,
        unidadCalorias: unidadCalorias ?? this.unidadCalorias,
        tiempoDescansoDefecto: tiempoDescansoDefecto ?? this.tiempoDescansoDefecto,
        sonidosHabilitados: sonidosHabilitados ?? this.sonidosHabilitados,
        vibracionHabilitada: vibracionHabilitada ?? this.vibracionHabilitada,
        volumenSonidos: volumenSonidos ?? this.volumenSonidos,
        intensidadVibracion: intensidadVibracion ?? this.intensidadVibracion,
        autoSiguienteEjercicio: autoSiguienteEjercicio ?? this.autoSiguienteEjercicio,
        notificacionesHabilitadas: notificacionesHabilitadas ?? this.notificacionesHabilitadas,
        recordatorioEntrenar: recordatorioEntrenar ?? this.recordatorioEntrenar,
        recordatorioRacha: recordatorioRacha ?? this.recordatorioRacha,
        recordatorioDescanso: recordatorioDescanso ?? this.recordatorioDescanso,
        horaRecordatorioManana: horaRecordatorioManana ?? this.horaRecordatorioManana,
        horaRecordatorioTarde: horaRecordatorioTarde ?? this.horaRecordatorioTarde,
        modoOscuro: modoOscuro ?? this.modoOscuro,
        idioma: idioma ?? this.idioma,
        fechaCreacion: fechaCreacion ?? this.fechaCreacion,
        fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
      );

  @override
  List<Object?> get props => [
        id,
        usuarioId,
        unidadPeso,
        unidadLongitud,
        formatoHora,
        formatoFecha,
        diaInicioSemana,
        unidadCalorias,
        tiempoDescansoDefecto,
        sonidosHabilitados,
        vibracionHabilitada,
        volumenSonidos,
        intensidadVibracion,
        autoSiguienteEjercicio,
        notificacionesHabilitadas,
        recordatorioEntrenar,
        recordatorioRacha,
        recordatorioDescanso,
        horaRecordatorioManana,
        horaRecordatorioTarde,
        modoOscuro,
        idioma,
        fechaCreacion,
        fechaActualizacion,
      ];

  /// Configuración por defecto para un nuevo usuario
  factory ConfiguracionUsuario.porDefecto(String usuarioId) {
    return ConfiguracionUsuario(
      usuarioId: usuarioId,
      fechaCreacion: DateTime.now(),
    );
  }

  /// Validación de valores permitidos
  bool get esConfiguracionValida {
    final unidadesPesoValidas = ['kg', 'lb'];
    final unidadesLongitudValidas = ['cm', 'in'];
    final formatosHoraValidos = ['24h', '12h'];
    final formatosFechaValidos = ['31.01', '01/31'];
    final diasInicioValidos = ['lunes', 'domingo'];
    final unidadesCaloriasValidas = ['kcal', 'kj'];
    final intensidadesVibracionValidas = ['baja', 'media', 'alta'];
    final idiomasValidos = ['es', 'en'];

    return unidadesPesoValidas.contains(unidadPeso) &&
        unidadesLongitudValidas.contains(unidadLongitud) &&
        formatosHoraValidos.contains(formatoHora) &&
        formatosFechaValidos.contains(formatoFecha) &&
        diasInicioValidos.contains(diaInicioSemana) &&
        unidadesCaloriasValidas.contains(unidadCalorias) &&
        intensidadesVibracionValidas.contains(intensidadVibracion) &&
        idiomasValidos.contains(idioma) &&
        tiempoDescansoDefecto >= 30 &&
        tiempoDescansoDefecto <= 300 &&
        volumenSonidos >= 0 &&
        volumenSonidos <= 100;
  }
}