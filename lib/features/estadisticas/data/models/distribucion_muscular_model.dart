import 'package:gymaster/features/estadisticas/domain/entities/distribucion_muscular.dart';

/// Modelo de data que extiende [DistribucionMuscular] con lógica de transformación
/// desde la base de datos y cálculo de porcentajes de distribución.
class DistribucionMuscularModel extends DistribucionMuscular {
  const DistribucionMuscularModel({
    required super.musculoId,
    required super.nombreMusculo,
    super.imagenMusculo,
    required super.volumenTotal,
    required super.porcentajeDistribucion,
    required super.frecuenciaSesiones,
    required super.totalSeries,
    required super.cantidadEjerciciosDiferentes,
    required super.fechaInicio,
    required super.fechaFin,
  });

  /// Crea un modelo desde los datos obtenidos del DataSource.
  ///
  /// [musculosRaw] Lista de mapas con datos de cada músculo trabajado
  /// [fechaInicio] Fecha de inicio del periodo analizado
  /// [fechaFin] Fecha de fin del periodo analizado
  ///
  /// Returns: Lista de [DistribucionMuscularModel] con porcentajes calculados
  static List<DistribucionMuscularModel> fromDatabaseList({
    required List<Map<String, dynamic>> musculosRaw,
    required DateTime fechaInicio,
    required DateTime fechaFin,
  }) {
    if (musculosRaw.isEmpty) return [];

    // Calcular volumen total de todos los músculos para porcentajes
    final volumenTotalGlobal = musculosRaw.fold<double>(
      0.0,
      (sum, musculo) =>
          sum + ((musculo['volumen_total'] as num?)?.toDouble() ?? 0.0),
    );

    // Transformar cada músculo con su porcentaje calculado
    return musculosRaw.map((musculo) {
      final volumenMusculo =
          (musculo['volumen_total'] as num?)?.toDouble() ?? 0.0;
      final porcentaje = volumenTotalGlobal > 0
          ? (volumenMusculo / volumenTotalGlobal) * 100
          : 0.0;

      return DistribucionMuscularModel(
        musculoId: musculo['musculo_id'] as String,
        nombreMusculo: musculo['musculo_nombre'] as String? ?? 'Desconocido',
        imagenMusculo: musculo['musculo_imagen'] as String?,
        volumenTotal: volumenMusculo,
        porcentajeDistribucion: porcentaje,
        frecuenciaSesiones: (musculo['frecuencia_sesiones'] as int?) ?? 0,
        totalSeries: (musculo['total_series'] as int?) ?? 0,
        cantidadEjerciciosDiferentes:
            (musculo['cantidad_ejercicios'] as int?) ?? 0,
        fechaInicio: fechaInicio,
        fechaFin: fechaFin,
      );
    }).toList();
  }

  /// Crea un modelo individual desde un mapa de datos
  factory DistribucionMuscularModel.fromDatabase({
    required Map<String, dynamic> data,
    required double porcentajeDistribucion,
    required DateTime fechaInicio,
    required DateTime fechaFin,
  }) {
    return DistribucionMuscularModel(
      musculoId: data['musculo_id'] as String,
      nombreMusculo: data['musculo_nombre'] as String? ?? 'Desconocido',
      imagenMusculo: data['musculo_imagen'] as String?,
      volumenTotal: (data['volumen_total'] as num?)?.toDouble() ?? 0.0,
      porcentajeDistribucion: porcentajeDistribucion,
      frecuenciaSesiones: (data['frecuencia_sesiones'] as int?) ?? 0,
      totalSeries: (data['total_series'] as int?) ?? 0,
      cantidadEjerciciosDiferentes: (data['cantidad_ejercicios'] as int?) ?? 0,
      fechaInicio: fechaInicio,
      fechaFin: fechaFin,
    );
  }

  /// Convierte el modelo a entidad de dominio pura
  DistribucionMuscular toEntity() {
    return DistribucionMuscular(
      musculoId: musculoId,
      nombreMusculo: nombreMusculo,
      imagenMusculo: imagenMusculo,
      volumenTotal: volumenTotal,
      porcentajeDistribucion: porcentajeDistribucion,
      frecuenciaSesiones: frecuenciaSesiones,
      totalSeries: totalSeries,
      cantidadEjerciciosDiferentes: cantidadEjerciciosDiferentes,
      fechaInicio: fechaInicio,
      fechaFin: fechaFin,
    );
  }
}
