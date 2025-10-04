import 'package:gymaster/features/estadisticas/domain/entities/recomendacion_muscular.dart';

/// Modelo de data que extiende [RecomendacionMuscular] con lógica de transformación
/// desde la base de datos y generación de mensajes contextuales.
class RecomendacionMuscularModel extends RecomendacionMuscular {
  const RecomendacionMuscularModel({
    required super.musculoId,
    required super.nombreMusculo,
    super.imagenMusculo,
    required super.diasSinTrabajar,
    required super.nivelPrioridad,
    required super.mensajeRecomendacion,
    required super.ejerciciosSugeridos,
    super.ultimaFechaTrabajo,
  });

  /// Crea un modelo desde los datos obtenidos del DataSource.
  ///
  /// [musculosOlvidadosRaw] Lista de mapas con músculos olvidados
  ///
  /// Returns: Lista de [RecomendacionMuscularModel] con mensajes generados
  static List<RecomendacionMuscularModel> fromDatabaseList({
    required List<Map<String, dynamic>> musculosOlvidadosRaw,
  }) {
    if (musculosOlvidadosRaw.isEmpty) return [];

    return musculosOlvidadosRaw.map((musculo) {
      final diasSinTrabajar = (musculo['dias_sin_trabajar'] as int?) ?? 999;
      final ultimaFecha = musculo['ultima_fecha_trabajo'] != null
          ? DateTime.parse(musculo['ultima_fecha_trabajo'] as String)
          : null;

      // Calcular nivel de prioridad (1-5)
      final prioridad = _calcularPrioridad(diasSinTrabajar);

      // Generar mensaje contextual
      final mensaje = _generarMensaje(
        nombreMusculo: musculo['musculo_nombre'] as String,
        diasSinTrabajar: diasSinTrabajar,
      );

      return RecomendacionMuscularModel(
        musculoId: musculo['musculo_id'] as String,
        nombreMusculo: musculo['musculo_nombre'] as String? ?? 'Desconocido',
        imagenMusculo: musculo['musculo_imagen'] as String?,
        diasSinTrabajar: diasSinTrabajar,
        nivelPrioridad: prioridad,
        mensajeRecomendacion: mensaje,
        ejerciciosSugeridos: [], // TODO: Agregar lógica de sugerencias
        ultimaFechaTrabajo: ultimaFecha,
      );
    }).toList();
  }

  /// Calcula el nivel de prioridad basado en días sin trabajar
  ///
  /// Escala:
  /// - 1-7 días: prioridad 1 (baja)
  /// - 8-14 días: prioridad 2 (media-baja)
  /// - 15-21 días: prioridad 3 (media)
  /// - 22-30 días: prioridad 4 (media-alta)
  /// - 31+ días: prioridad 5 (crítica)
  static int _calcularPrioridad(int diasSinTrabajar) {
    if (diasSinTrabajar <= 7) return 1;
    if (diasSinTrabajar <= 14) return 2;
    if (diasSinTrabajar <= 21) return 3;
    if (diasSinTrabajar <= 30) return 4;
    return 5;
  }

  /// Genera un mensaje motivacional contextual según los días sin trabajar
  static String _generarMensaje({
    required String nombreMusculo,
    required int diasSinTrabajar,
  }) {
    if (diasSinTrabajar <= 7) {
      return 'Considera trabajar $nombreMusculo pronto para mantener el equilibrio.';
    } else if (diasSinTrabajar <= 14) {
      return '$nombreMusculo necesita atención. ¡Agrégalo a tu próxima rutina!';
    } else if (diasSinTrabajar <= 21) {
      return '⚠️ $nombreMusculo está descuidado. Es momento de retomarlo.';
    } else if (diasSinTrabajar <= 30) {
      return '🔴 $nombreMusculo lleva mucho tiempo sin trabajar. ¡Prioritario!';
    } else {
      return '🚨 ¡Crítico! $nombreMusculo necesita atención urgente para evitar desequilibrios.';
    }
  }

  /// Convierte el modelo a entidad de dominio pura
  RecomendacionMuscular toEntity() {
    return RecomendacionMuscular(
      musculoId: musculoId,
      nombreMusculo: nombreMusculo,
      imagenMusculo: imagenMusculo,
      diasSinTrabajar: diasSinTrabajar,
      nivelPrioridad: nivelPrioridad,
      mensajeRecomendacion: mensajeRecomendacion,
      ejerciciosSugeridos: ejerciciosSugeridos,
      ultimaFechaTrabajo: ultimaFechaTrabajo,
    );
  }
}
