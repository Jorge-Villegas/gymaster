import 'package:gymaster/features/estadisticas/domain/entities/ranking_ejercicio.dart';

/// Modelo de data que extiende [RankingEjercicio] con lógica de transformación
/// desde la base de datos y asignación automática de posiciones.
class RankingEjercicioModel extends RankingEjercicio {
  const RankingEjercicioModel({
    required super.posicion,
    required super.ejercicioId,
    required super.nombreEjercicio,
    super.imagenEjercicio,
    required super.musculoPrincipal,
    required super.vecesRealizado,
    required super.volumenTotal,
    required super.pesoMaximo,
    required super.promedioPeso,
    required super.totalSeries,
    required super.totalRepeticiones,
    required super.fechaInicio,
    required super.fechaFin,
  });

  /// Crea un modelo desde los datos obtenidos del DataSource.
  ///
  /// [rankingRaw] Lista de mapas con datos de ejercicios ordenados por ranking
  /// [fechaInicio] Fecha de inicio del periodo analizado
  /// [fechaFin] Fecha de fin del periodo analizado
  ///
  /// Returns: Lista de [RankingEjercicioModel] con posiciones asignadas (1, 2, 3...)
  static List<RankingEjercicioModel> fromDatabaseList({
    required List<Map<String, dynamic>> rankingRaw,
    required DateTime fechaInicio,
    required DateTime fechaFin,
  }) {
    if (rankingRaw.isEmpty) return [];

    // Asignar posiciones automáticamente (1, 2, 3...)
    return List.generate(rankingRaw.length, (index) {
      final ejercicio = rankingRaw[index];

      return RankingEjercicioModel(
        posicion: index + 1, // Posición 1-indexed
        ejercicioId: ejercicio['ejercicio_id'] as String,
        nombreEjercicio:
            ejercicio['ejercicio_nombre'] as String? ?? 'Desconocido',
        imagenEjercicio: ejercicio['ejercicio_imagen'] as String?,
        musculoPrincipal:
            ejercicio['musculo_principal'] as String? ?? 'General',
        vecesRealizado: (ejercicio['veces_realizado'] as int?) ?? 0,
        volumenTotal: (ejercicio['volumen_total'] as num?)?.toDouble() ?? 0.0,
        pesoMaximo: (ejercicio['peso_maximo'] as num?)?.toDouble() ?? 0.0,
        promedioPeso: (ejercicio['peso_promedio'] as num?)?.toDouble() ?? 0.0,
        totalSeries: (ejercicio['total_series'] as int?) ?? 0,
        totalRepeticiones: (ejercicio['total_repeticiones'] as int?) ?? 0,
        fechaInicio: fechaInicio,
        fechaFin: fechaFin,
      );
    });
  }

  /// Crea un modelo individual desde un mapa de datos
  factory RankingEjercicioModel.fromDatabase({
    required int posicion,
    required Map<String, dynamic> data,
    required DateTime fechaInicio,
    required DateTime fechaFin,
  }) {
    return RankingEjercicioModel(
      posicion: posicion,
      ejercicioId: data['ejercicio_id'] as String,
      nombreEjercicio: data['ejercicio_nombre'] as String? ?? 'Desconocido',
      imagenEjercicio: data['ejercicio_imagen'] as String?,
      musculoPrincipal: data['musculo_principal'] as String? ?? 'General',
      vecesRealizado: (data['veces_realizado'] as int?) ?? 0,
      volumenTotal: (data['volumen_total'] as num?)?.toDouble() ?? 0.0,
      pesoMaximo: (data['peso_maximo'] as num?)?.toDouble() ?? 0.0,
      promedioPeso: (data['peso_promedio'] as num?)?.toDouble() ?? 0.0,
      totalSeries: (data['total_series'] as int?) ?? 0,
      totalRepeticiones: (data['total_repeticiones'] as int?) ?? 0,
      fechaInicio: fechaInicio,
      fechaFin: fechaFin,
    );
  }

  /// Convierte el modelo a entidad de dominio pura
  RankingEjercicio toEntity() {
    return RankingEjercicio(
      posicion: posicion,
      ejercicioId: ejercicioId,
      nombreEjercicio: nombreEjercicio,
      imagenEjercicio: imagenEjercicio,
      musculoPrincipal: musculoPrincipal,
      vecesRealizado: vecesRealizado,
      volumenTotal: volumenTotal,
      pesoMaximo: pesoMaximo,
      promedioPeso: promedioPeso,
      totalSeries: totalSeries,
      totalRepeticiones: totalRepeticiones,
      fechaInicio: fechaInicio,
      fechaFin: fechaFin,
    );
  }
}
