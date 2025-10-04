import 'package:flutter/foundation.dart';
import 'package:gymaster/core/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';

/// DataSource local para obtener estadísticas de ejercicios desde SQLite.
///
/// Ejecuta queries complejas con JOINs y agregaciones para calcular
/// métricas de progreso, distribución muscular, rankings y recomendaciones.
class EstadisticasLocalDataSource {
  final DatabaseHelper _databaseHelper;

  EstadisticasLocalDataSource(this._databaseHelper);

  /// Obtiene el progreso temporal de un ejercicio específico en un rango de fechas.
  ///
  /// Query que agrupa por sesión y calcula:
  /// - Peso máximo de la sesión
  /// - Volumen total (Σ peso × repeticiones)
  /// - Total de repeticiones y series
  ///
  /// Returns: Lista de mapas con datos de cada sesión del ejercicio
  Future<List<Map<String, dynamic>>> obtenerProgresoEjercicio({
    required String ejercicioId,
    required DateTime fechaInicio,
    required DateTime fechaFin,
  }) async {
    try {
      final db = await _databaseHelper.database;

      final resultado = await db.rawQuery('''
        SELECT
          rs.hora_inicio AS fecha_sesion,
          MAX(se.peso) AS peso_maximo,
          SUM(se.peso * se.repeticiones) AS volumen_total,
          SUM(se.repeticiones) AS total_repeticiones,
          COUNT(se.id) AS total_series
        FROM serie_ejercicio se
        JOIN session_exercise sex ON se.session_exercise_id = sex.id
        JOIN routine_session rs ON sex.session_id = rs.id
        WHERE
          sex.exercise_id = ?
          AND se.estado = 'completado'
          AND rs.estado = 'completado'
          AND rs.hora_inicio BETWEEN ? AND ?
        GROUP BY rs.id, rs.hora_inicio
        ORDER BY rs.hora_inicio ASC
      ''', [
        ejercicioId,
        fechaInicio.toIso8601String(),
        fechaFin.toIso8601String(),
      ]);

      debugPrint(
          '✅ [EstadisticasDataSource] Progreso ejercicio: ${resultado.length} sesiones encontradas');
      return resultado;
    } catch (e) {
      debugPrint(
          '❌ [EstadisticasDataSource] Error en obtenerProgresoEjercicio: $e');
      rethrow;
    }
  }

  /// Obtiene la distribución de músculos trabajados en un periodo.
  ///
  /// Query que calcula por grupo muscular:
  /// - Volumen total acumulado
  /// - Frecuencia de sesiones
  /// - Total de series
  /// - Cantidad de ejercicios diferentes
  ///
  /// Returns: Lista de mapas con métricas por músculo
  Future<List<Map<String, dynamic>>> obtenerDistribucionMuscular({
    required DateTime fechaInicio,
    required DateTime fechaFin,
  }) async {
    try {
      final db = await _databaseHelper.database;

      final resultado = await db.rawQuery('''
        SELECT
          m.id AS musculo_id,
          m.name AS musculo_nombre,
          m.ruta_imagen AS musculo_imagen,
          SUM(se.peso * se.repeticiones) AS volumen_total,
          COUNT(DISTINCT rs.id) AS frecuencia_sesiones,
          COUNT(se.id) AS total_series,
          COUNT(DISTINCT e.id) AS cantidad_ejercicios
        FROM muscle m
        JOIN ejercicio_musculo em ON m.id = em.musculo_id
        JOIN ejercicio e ON em.ejercicio_id = e.id
        JOIN session_exercise sex ON e.id = sex.exercise_id
        JOIN routine_session rs ON sex.session_id = rs.id
        JOIN serie_ejercicio se ON sex.id = se.session_exercise_id
        WHERE
          rs.estado = 'completado'
          AND se.estado = 'completado'
          AND rs.hora_inicio BETWEEN ? AND ?
        GROUP BY m.id, m.name, m.ruta_imagen
        ORDER BY volumen_total DESC
      ''', [
        fechaInicio.toIso8601String(),
        fechaFin.toIso8601String(),
      ]);

      debugPrint(
          '✅ [EstadisticasDataSource] Distribución muscular: ${resultado.length} músculos trabajados');
      return resultado;
    } catch (e) {
      debugPrint(
          '❌ [EstadisticasDataSource] Error en obtenerDistribucionMuscular: $e');
      rethrow;
    }
  }

  /// Obtiene el ranking de ejercicios más realizados en un periodo.
  ///
  /// Query que ordena ejercicios por:
  /// 1. Frecuencia de realización (veces realizadas)
  /// 2. Volumen total acumulado
  /// 3. Peso máximo alcanzado
  ///
  /// Returns: Top 10 ejercicios con métricas agregadas
  Future<List<Map<String, dynamic>>> obtenerRankingEjercicios({
    required DateTime fechaInicio,
    required DateTime fechaFin,
    int limite = 10,
  }) async {
    try {
      final db = await _databaseHelper.database;

      final resultado = await db.rawQuery('''
        SELECT
          e.id AS ejercicio_id,
          e.nombre AS ejercicio_nombre,
          e.ruta_imagen AS ejercicio_imagen,
          m.name AS musculo_principal,
          COUNT(DISTINCT rs.id) AS veces_realizado,
          SUM(se.peso * se.repeticiones) AS volumen_total,
          MAX(se.peso) AS peso_maximo,
          AVG(se.peso) AS peso_promedio,
          COUNT(se.id) AS total_series,
          SUM(se.repeticiones) AS total_repeticiones
        FROM ejercicio e
        JOIN session_exercise sex ON e.id = sex.exercise_id
        JOIN routine_session rs ON sex.session_id = rs.id
        JOIN serie_ejercicio se ON sex.id = se.session_exercise_id
        LEFT JOIN ejercicio_musculo em ON e.id = em.ejercicio_id
        LEFT JOIN muscle m ON em.musculo_id = m.id
        WHERE
          rs.estado = 'completado'
          AND se.estado = 'completado'
          AND rs.hora_inicio BETWEEN ? AND ?
        GROUP BY e.id, e.nombre, e.ruta_imagen, m.name
        ORDER BY veces_realizado DESC, volumen_total DESC
        LIMIT ?
      ''', [
        fechaInicio.toIso8601String(),
        fechaFin.toIso8601String(),
        limite,
      ]);

      debugPrint(
          '✅ [EstadisticasDataSource] Ranking ejercicios: ${resultado.length} ejercicios en top');
      return resultado;
    } catch (e) {
      debugPrint(
          '❌ [EstadisticasDataSource] Error en obtenerRankingEjercicios: $e');
      rethrow;
    }
  }

  /// Identifica músculos que no han sido trabajados en los últimos N días.
  ///
  /// Query con LEFT JOIN para incluir músculos sin registros recientes.
  /// Calcula días transcurridos desde el último entrenamiento.
  ///
  /// [diasLimite] Umbral de días sin trabajar (por defecto 7 días)
  ///
  /// Returns: Lista de músculos olvidados con días sin trabajar
  Future<List<Map<String, dynamic>>> obtenerMusculosOlvidados({
    int diasLimite = 7,
  }) async {
    try {
      final db = await _databaseHelper.database;

      final resultado = await db.rawQuery('''
        SELECT
          m.id AS musculo_id,
          m.name AS musculo_nombre,
          m.ruta_imagen AS musculo_imagen,
          MAX(rs.hora_inicio) AS ultima_fecha_trabajo,
          CAST(julianday('now') - julianday(MAX(rs.hora_inicio)) AS INTEGER) AS dias_sin_trabajar
        FROM muscle m
        LEFT JOIN ejercicio_musculo em ON m.id = em.musculo_id
        LEFT JOIN ejercicio e ON em.ejercicio_id = e.id
        LEFT JOIN session_exercise sex ON e.id = sex.exercise_id
        LEFT JOIN routine_session rs ON sex.session_id = rs.id AND rs.estado = 'completado'
        GROUP BY m.id, m.name, m.ruta_imagen
        HAVING dias_sin_trabajar > ? OR dias_sin_trabajar IS NULL
        ORDER BY dias_sin_trabajar DESC NULLS FIRST
      ''', [diasLimite]);

      debugPrint(
          '✅ [EstadisticasDataSource] Músculos olvidados: ${resultado.length} músculos sin trabajar >$diasLimite días');
      return resultado;
    } catch (e) {
      debugPrint(
          '❌ [EstadisticasDataSource] Error en obtenerMusculosOlvidados: $e');
      rethrow;
    }
  }

  /// Obtiene métricas de resumen general para un periodo.
  ///
  /// Calcula:
  /// - Total de series completadas
  /// - Volumen total levantado
  /// - Total de sesiones realizadas
  /// - Racha actual de días consecutivos
  ///
  /// Returns: Mapa con métricas generales del periodo
  Future<Map<String, dynamic>> obtenerResumenGeneral({
    required DateTime fechaInicio,
    required DateTime fechaFin,
  }) async {
    try {
      final db = await _databaseHelper.database;

      // Métricas principales
      final metricas = await db.rawQuery('''
        SELECT
          COUNT(DISTINCT rs.id) AS total_sesiones,
          COUNT(se.id) AS total_series,
          SUM(se.peso * se.repeticiones) AS volumen_total,
          COUNT(DISTINCT e.id) AS ejercicios_diferentes
        FROM routine_session rs
        JOIN session_exercise sex ON rs.id = sex.session_id
        JOIN serie_ejercicio se ON sex.id = se.session_exercise_id
        JOIN ejercicio e ON sex.exercise_id = e.id
        WHERE
          rs.estado = 'completado'
          AND se.estado = 'completado'
          AND rs.hora_inicio BETWEEN ? AND ?
      ''', [
        fechaInicio.toIso8601String(),
        fechaFin.toIso8601String(),
      ]);

      // Racha actual de días consecutivos
      final racha = await _calcularRachaActual(db);

      final resultado = {
        'total_sesiones': metricas.first['total_sesiones'] ?? 0,
        'total_series': metricas.first['total_series'] ?? 0,
        'volumen_total': metricas.first['volumen_total'] ?? 0.0,
        'ejercicios_diferentes': metricas.first['ejercicios_diferentes'] ?? 0,
        'racha_dias': racha,
      };

      debugPrint('✅ [EstadisticasDataSource] Resumen general obtenido: '
          '${resultado['total_sesiones']} sesiones, '
          '${resultado['total_series']} series, '
          'racha: ${resultado['racha_dias']} días');

      return resultado;
    } catch (e) {
      debugPrint(
          '❌ [EstadisticasDataSource] Error en obtenerResumenGeneral: $e');
      rethrow;
    }
  }

  /// Calcula la racha actual de días consecutivos con entrenamientos.
  ///
  /// Algoritmo:
  /// 1. Obtiene todas las fechas únicas de sesiones completadas (últimos 30 días)
  /// 2. Cuenta días consecutivos hacia atrás desde hoy
  /// 3. Se detiene al encontrar un día sin entrenamiento
  ///
  /// Returns: Número de días consecutivos con al menos una sesión
  Future<int> _calcularRachaActual(Database db) async {
    try {
      final hace30Dias = DateTime.now().subtract(const Duration(days: 30));

      // Obtener fechas únicas de entrenamientos (solo la parte de la fecha, sin hora)
      final fechas = await db.rawQuery('''
        SELECT DISTINCT DATE(rs.hora_inicio) AS fecha
        FROM routine_session rs
        WHERE
          rs.estado = 'completado'
          AND rs.hora_inicio >= ?
        ORDER BY fecha DESC
      ''', [hace30Dias.toIso8601String()]);

      if (fechas.isEmpty) return 0;

      // Convertir a lista de DateTime (solo fechas sin hora)
      final fechasEntrenamientos = fechas.map((row) {
        final fechaStr = row['fecha'] as String;
        return DateTime.parse(fechaStr);
      }).toList();

      // Contar días consecutivos desde hoy hacia atrás
      int racha = 0;
      final hoy = DateTime.now();
      final hoyFecha = DateTime(hoy.year, hoy.month, hoy.day);

      DateTime fechaVerificar = hoyFecha;

      for (int i = 0; i < 30; i++) {
        final tieneSesion = fechasEntrenamientos.any((fecha) {
          return fecha.year == fechaVerificar.year &&
              fecha.month == fechaVerificar.month &&
              fecha.day == fechaVerificar.day;
        });

        if (tieneSesion) {
          racha++;
          fechaVerificar =
              fechaVerificar.subtract(const Duration(days: 1)); // Día anterior
        } else {
          break; // Se rompe la racha
        }
      }

      return racha;
    } catch (e) {
      debugPrint('❌ [EstadisticasDataSource] Error calculando racha: $e');
      return 0;
    }
  }

  /// Obtiene información detallada de un ejercicio específico.
  ///
  /// Útil para obtener nombre e imagen del ejercicio al crear entidades.
  ///
  /// Returns: Mapa con datos del ejercicio o null si no existe
  Future<Map<String, dynamic>?> obtenerInfoEjercicio(String ejercicioId) async {
    try {
      final db = await _databaseHelper.database;

      final resultado = await db.query(
        'ejercicio',
        where: 'id = ?',
        whereArgs: [ejercicioId],
        limit: 1,
      );

      return resultado.isNotEmpty ? resultado.first : null;
    } catch (e) {
      debugPrint(
          '❌ [EstadisticasDataSource] Error en obtenerInfoEjercicio: $e');
      return null;
    }
  }

  /// Obtiene información detallada de un músculo específico.
  ///
  /// Returns: Mapa con datos del músculo o null si no existe
  Future<Map<String, dynamic>?> obtenerInfoMusculo(String musculoId) async {
    try {
      final db = await _databaseHelper.database;

      final resultado = await db.query(
        'muscle',
        where: 'id = ?',
        whereArgs: [musculoId],
        limit: 1,
      );

      return resultado.isNotEmpty ? resultado.first : null;
    } catch (e) {
      debugPrint('❌ [EstadisticasDataSource] Error en obtenerInfoMusculo: $e');
      return null;
    }
  }
}
