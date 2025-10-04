import 'package:gymaster/features/estadisticas/domain/entities/punto_progreso.dart';
import 'package:gymaster/features/estadisticas/domain/entities/tendencia_progreso.dart';

/// Entidad que representa el progreso completo de un ejercicio específico
/// a lo largo de un periodo de tiempo determinado.
///
/// Contiene todas las métricas agregadas y la evolución temporal del ejercicio.
class ProgresoEjercicio {
  /// ID único del ejercicio
  final String ejercicioId;

  /// Nombre del ejercicio (ej: "Press Banca", "Sentadilla")
  final String nombreEjercicio;

  /// Ruta de la imagen representativa del ejercicio
  final String? imagenEjercicio;

  /// Lista cronológica de puntos de progreso (cada sesión registrada)
  final List<PuntoProgreso> puntosProgreso;

  /// Peso máximo alcanzado en todo el periodo (1RM estimado)
  final double pesoMaximoAbsoluto;

  /// Volumen total acumulado = Σ(peso × reps × series) de todas las sesiones
  final double volumenTotalAcumulado;

  /// Promedio de peso levantado por sesión
  final double promedioPesoPorSesion;

  /// Total de repeticiones realizadas en el periodo
  final int totalRepeticionesAcumuladas;

  /// Número de veces que se realizó el ejercicio (frecuencia)
  final int frecuenciaRealizacion;

  /// Tendencia calculada del progreso (mejorando, estable, decayendo)
  final TendenciaProgreso tendencia;

  /// Fecha de inicio del periodo analizado
  final DateTime fechaInicio;

  /// Fecha de fin del periodo analizado
  final DateTime fechaFin;

  const ProgresoEjercicio({
    required this.ejercicioId,
    required this.nombreEjercicio,
    this.imagenEjercicio,
    required this.puntosProgreso,
    required this.pesoMaximoAbsoluto,
    required this.volumenTotalAcumulado,
    required this.promedioPesoPorSesion,
    required this.totalRepeticionesAcumuladas,
    required this.frecuenciaRealizacion,
    required this.tendencia,
    required this.fechaInicio,
    required this.fechaFin,
  });

  /// Valida que los datos sean consistentes
  bool get esValido {
    return ejercicioId.isNotEmpty &&
        nombreEjercicio.isNotEmpty &&
        pesoMaximoAbsoluto >= 0 &&
        volumenTotalAcumulado >= 0 &&
        totalRepeticionesAcumuladas >= 0 &&
        frecuenciaRealizacion >= 0 &&
        fechaInicio.isBefore(fechaFin.add(const Duration(days: 1)));
  }

  /// Retorna true si hay suficientes datos para análisis significativo
  /// (mínimo 3 sesiones registradas)
  bool get tieneDatosSuficientes => puntosProgreso.length >= 3;

  /// Calcula el porcentaje de cambio del volumen entre primera y última sesión
  double get porcentajeCambioVolumen {
    if (puntosProgreso.length < 2) return 0.0;

    final volumenInicial = puntosProgreso.first.volumenTotal;
    final volumenFinal = puntosProgreso.last.volumenTotal;

    if (volumenInicial == 0) return 0.0;

    return ((volumenFinal - volumenInicial) / volumenInicial) * 100;
  }

  /// Calcula el porcentaje de cambio del peso máximo
  double get porcentajeCambioPeso {
    if (puntosProgreso.length < 2) return 0.0;

    final pesoInicial = puntosProgreso.first.pesoMaximo;
    final pesoFinal = puntosProgreso.last.pesoMaximo;

    if (pesoInicial == 0) return 0.0;

    return ((pesoFinal - pesoInicial) / pesoInicial) * 100;
  }

  /// Crea una copia del objeto con valores opcionales actualizados.
  ///
  /// Patrón copyWith manual obligatorio según arquitectura del proyecto.
  ProgresoEjercicio copyWith({
    String? ejercicioId,
    String? nombreEjercicio,
    String? imagenEjercicio,
    List<PuntoProgreso>? puntosProgreso,
    double? pesoMaximoAbsoluto,
    double? volumenTotalAcumulado,
    double? promedioPesoPorSesion,
    int? totalRepeticionesAcumuladas,
    int? frecuenciaRealizacion,
    TendenciaProgreso? tendencia,
    DateTime? fechaInicio,
    DateTime? fechaFin,
  }) =>
      ProgresoEjercicio(
        ejercicioId: ejercicioId ?? this.ejercicioId,
        nombreEjercicio: nombreEjercicio ?? this.nombreEjercicio,
        imagenEjercicio: imagenEjercicio ?? this.imagenEjercicio,
        puntosProgreso: puntosProgreso ?? this.puntosProgreso,
        pesoMaximoAbsoluto: pesoMaximoAbsoluto ?? this.pesoMaximoAbsoluto,
        volumenTotalAcumulado:
            volumenTotalAcumulado ?? this.volumenTotalAcumulado,
        promedioPesoPorSesion:
            promedioPesoPorSesion ?? this.promedioPesoPorSesion,
        totalRepeticionesAcumuladas:
            totalRepeticionesAcumuladas ?? this.totalRepeticionesAcumuladas,
        frecuenciaRealizacion:
            frecuenciaRealizacion ?? this.frecuenciaRealizacion,
        tendencia: tendencia ?? this.tendencia,
        fechaInicio: fechaInicio ?? this.fechaInicio,
        fechaFin: fechaFin ?? this.fechaFin,
      );

  @override
  String toString() {
    return 'ProgresoEjercicio('
        'ejercicio: $nombreEjercicio, '
        'pesoMax: $pesoMaximoAbsoluto kg, '
        'volumen: $volumenTotalAcumulado kg, '
        'frecuencia: $frecuenciaRealizacion, '
        'tendencia: ${tendencia.descripcion}'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProgresoEjercicio &&
        other.ejercicioId == ejercicioId &&
        other.nombreEjercicio == nombreEjercicio &&
        other.pesoMaximoAbsoluto == pesoMaximoAbsoluto &&
        other.volumenTotalAcumulado == volumenTotalAcumulado;
  }

  @override
  int get hashCode {
    return ejercicioId.hashCode ^
        nombreEjercicio.hashCode ^
        pesoMaximoAbsoluto.hashCode ^
        volumenTotalAcumulado.hashCode;
  }
}
