import 'package:gymaster/features/estadisticas/domain/entities/progreso_ejercicio.dart';
import 'package:gymaster/features/estadisticas/domain/entities/punto_progreso.dart';
import 'package:gymaster/features/estadisticas/domain/entities/tendencia_progreso.dart';

/// Modelo de data que extiende [ProgresoEjercicio] con lógica de transformación
/// desde la base de datos y cálculo de métricas agregadas.
class ProgresoEjercicioModel extends ProgresoEjercicio {
  const ProgresoEjercicioModel({
    required super.ejercicioId,
    required super.nombreEjercicio,
    super.imagenEjercicio,
    required super.puntosProgreso,
    required super.pesoMaximoAbsoluto,
    required super.volumenTotalAcumulado,
    required super.promedioPesoPorSesion,
    required super.totalRepeticionesAcumuladas,
    required super.frecuenciaRealizacion,
    required super.tendencia,
    required super.fechaInicio,
    required super.fechaFin,
  });

  /// Crea un modelo desde los datos obtenidos del DataSource.
  ///
  /// [puntosRaw] Lista de mapas con datos de cada sesión del ejercicio
  /// [infoEjercicio] Mapa con información del ejercicio (nombre, imagen)
  /// [fechaInicio] Fecha de inicio del periodo analizado
  /// [fechaFin] Fecha de fin del periodo analizado
  ///
  /// Returns: [ProgresoEjercicioModel] con todas las métricas calculadas
  factory ProgresoEjercicioModel.fromDatabase({
    required String ejercicioId,
    required List<Map<String, dynamic>> puntosRaw,
    required Map<String, dynamic> infoEjercicio,
    required DateTime fechaInicio,
    required DateTime fechaFin,
  }) {
    // Transformar puntos individuales
    final puntos = puntosRaw.map((punto) {
      return PuntoProgreso(
        fecha: DateTime.parse(punto['fecha_sesion'] as String),
        pesoMaximo: (punto['peso_maximo'] as num?)?.toDouble() ?? 0.0,
        volumenTotal: (punto['volumen_total'] as num?)?.toDouble() ?? 0.0,
        totalRepeticiones: (punto['total_repeticiones'] as int?) ?? 0,
        totalSeries: (punto['total_series'] as int?) ?? 0,
      );
    }).toList();

    // Calcular métricas agregadas
    final pesoMaximo = puntos.isNotEmpty
        ? puntos.map((p) => p.pesoMaximo).reduce((a, b) => a > b ? a : b)
        : 0.0;

    final volumenTotal =
        puntos.fold<double>(0.0, (sum, p) => sum + p.volumenTotal);

    final promedioPeso = puntos.isNotEmpty ? volumenTotal / puntos.length : 0.0;

    final totalReps =
        puntos.fold<int>(0, (sum, p) => sum + p.totalRepeticiones);

    final frecuencia = puntos.length;

    // Calcular tendencia
    final tendencia = _calcularTendencia(puntos);

    return ProgresoEjercicioModel(
      ejercicioId: ejercicioId,
      nombreEjercicio: infoEjercicio['name'] as String? ?? 'Desconocido',
      imagenEjercicio: infoEjercicio['imagePath'] as String?,
      puntosProgreso: puntos,
      pesoMaximoAbsoluto: pesoMaximo,
      volumenTotalAcumulado: volumenTotal,
      promedioPesoPorSesion: promedioPeso,
      totalRepeticionesAcumuladas: totalReps,
      frecuenciaRealizacion: frecuencia,
      tendencia: tendencia,
      fechaInicio: fechaInicio,
      fechaFin: fechaFin,
    );
  }

  /// Calcula la tendencia del progreso basada en la evolución de peso y volumen.
  ///
  /// Lógica:
  /// - Si hay menos de 3 puntos: insuficienteDatos
  /// - Compara primera mitad vs segunda mitad del periodo
  /// - Variación > 5%: mejorando/decayendo
  /// - Variación ≤ 5%: estable
  static TendenciaProgreso _calcularTendencia(List<PuntoProgreso> puntos) {
    if (puntos.length < 3) return TendenciaProgreso.insuficienteDatos;

    final mitad = puntos.length ~/ 2;
    final primeraMitad = puntos.sublist(0, mitad);
    final segundaMitad = puntos.sublist(mitad);

    // Promedio de volumen en cada mitad
    final promedioInicial =
        primeraMitad.fold<double>(0.0, (sum, p) => sum + p.volumenTotal) /
            primeraMitad.length;

    final promedioFinal =
        segundaMitad.fold<double>(0.0, (sum, p) => sum + p.volumenTotal) /
            segundaMitad.length;

    if (promedioInicial == 0) return TendenciaProgreso.estable;

    final porcentajeCambio =
        ((promedioFinal - promedioInicial) / promedioInicial) * 100;

    if (porcentajeCambio > 5) return TendenciaProgreso.mejorando;
    if (porcentajeCambio < -5) return TendenciaProgreso.decayendo;
    return TendenciaProgreso.estable;
  }

  /// Convierte el modelo a entidad de dominio pura
  ProgresoEjercicio toEntity() {
    return ProgresoEjercicio(
      ejercicioId: ejercicioId,
      nombreEjercicio: nombreEjercicio,
      imagenEjercicio: imagenEjercicio,
      puntosProgreso: puntosProgreso,
      pesoMaximoAbsoluto: pesoMaximoAbsoluto,
      volumenTotalAcumulado: volumenTotalAcumulado,
      promedioPesoPorSesion: promedioPesoPorSesion,
      totalRepeticionesAcumuladas: totalRepeticionesAcumuladas,
      frecuenciaRealizacion: frecuenciaRealizacion,
      tendencia: tendencia,
      fechaInicio: fechaInicio,
      fechaFin: fechaFin,
    );
  }
}
