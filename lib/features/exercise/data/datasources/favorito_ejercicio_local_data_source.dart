import 'package:gymaster/core/database/database_helper.dart';
import 'package:gymaster/core/database/models/favorito_ejercicio_db_model.dart';
import 'package:gymaster/features/exercise/domain/entities/favorito_ejercicio.dart';
import 'package:gymaster/shared/utils/uuid_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

/// DataSource local para manejo de ejercicios favoritos
/// Implementa storage mixto: SQLite para persistencia + SharedPreferences para cache
class FavoritoEjercicioLocalDataSource {
  final DatabaseHelper databaseHelper;
  final UuidGenerator uuidGenerator;

  // Keys para SharedPreferences cache
  static const String _cacheKey = 'favoritos_ejercicios_ids';
  static const String _lastSyncKey = 'favoritos_last_sync';

  FavoritoEjercicioLocalDataSource({
    required this.databaseHelper,
    required this.uuidGenerator,
  });

  // === MÉTODOS CRUD PRINCIPALES ===

  /// Agregar un ejercicio a favoritos
  /// Usa transacción para consistencia y actualiza cache automáticamente
  Future<FavoritoEjercicio> agregarEjercicioAFavoritos(
      String ejercicioId) async {
    final db = await databaseHelper.database;

    try {
      final favorito = FavoritoEjercicio(
        id: uuidGenerator.generateId(),
        ejercicioId: ejercicioId,
        fechaAgregado: DateTime.now(),
      );

      final favoritoDbModel = FavoritoEjercicioDbModel.fromEntity(favorito);

      await db.transaction((txn) async {
        await txn.insert(
          FavoritoEjercicioDbModel.table,
          favoritoDbModel.toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      });

      // Actualizar cache después de la operación exitosa
      await _actualizarCacheFavoritos();

      return favorito;
    } catch (e) {
      throw DatabaseException('Error al agregar ejercicio a favoritos: $e');
    }
  }

  /// Remover un ejercicio de favoritos
  /// Retorna true si se removió exitosamente, false si no existía
  Future<bool> removerEjercicioDeFavoritos(String ejercicioId) async {
    final db = await databaseHelper.database;

    try {
      final filasAfectadas = await db.delete(
        FavoritoEjercicioDbModel.table,
        where: '${FavoritoEjercicioDbModel.columnEjercicioId} = ?',
        whereArgs: [ejercicioId],
      );

      // Actualizar cache después de la operación
      await _actualizarCacheFavoritos();

      return filasAfectadas > 0;
    } catch (e) {
      throw DatabaseException('Error al remover ejercicio de favoritos: $e');
    }
  }

  /// Verificar si un ejercicio está en favoritos
  /// Usa cache inteligente para mejor performance
  Future<bool> esEjercicioFavorito(String ejercicioId) async {
    try {
      // Primero intentar desde cache si está disponible
      final cachedIds = await _obtenerIdsFavoritosDesdeCache();
      if (cachedIds != null) {
        return cachedIds.contains(ejercicioId);
      }

      // Si no está en cache, consultar BD directamente
      final db = await databaseHelper.database;
      final result = await db.query(
        FavoritoEjercicioDbModel.table,
        where: '${FavoritoEjercicioDbModel.columnEjercicioId} = ?',
        whereArgs: [ejercicioId],
        limit: 1,
      );

      return result.isNotEmpty;
    } catch (e) {
      throw DatabaseException(
          'Error al verificar si ejercicio es favorito: $e');
    }
  }

  /// Obtener todos los ejercicios favoritos
  /// Retorna lista ordenada por fecha de agregado (más recientes primero)
  Future<List<FavoritoEjercicio>> obtenerTodosLosFavoritos() async {
    final db = await databaseHelper.database;

    try {
      final maps = await db.query(
        FavoritoEjercicioDbModel.table,
        orderBy: '${FavoritoEjercicioDbModel.columnFechaAgregado} DESC',
      );

      return maps
          .map((map) => FavoritoEjercicioDbModel.fromMap(map).toEntity())
          .toList();
    } catch (e) {
      throw DatabaseException('Error al obtener ejercicios favoritos: $e');
    }
  }

  /// Obtener solo los IDs de ejercicios favoritos
  /// Método optimizado para verificaciones rápidas
  Future<List<String>> obtenerIdsFavoritos() async {
    final db = await databaseHelper.database;

    try {
      final maps = await db.query(
        FavoritoEjercicioDbModel.table,
        columns: [FavoritoEjercicioDbModel.columnEjercicioId],
        orderBy: '${FavoritoEjercicioDbModel.columnFechaAgregado} DESC',
      );

      return maps
          .map((map) =>
              map[FavoritoEjercicioDbModel.columnEjercicioId] as String)
          .toList();
    } catch (e) {
      throw DatabaseException('Error al obtener IDs de favoritos: $e');
    }
  }

  /// Obtener cantidad total de favoritos
  /// Útil para mostrar badges y estadísticas en la UI
  Future<int> obtenerCantidadFavoritos() async {
    final db = await databaseHelper.database;

    try {
      final result = await db.rawQuery(
          'SELECT COUNT(*) as count FROM ${FavoritoEjercicioDbModel.table}');

      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      throw DatabaseException('Error al obtener cantidad de favoritos: $e');
    }
  }

  /// Limpiar todos los ejercicios favoritos
  /// Para casos de reset completo o limpieza
  Future<bool> limpiarTodosLosFavoritos() async {
    final db = await databaseHelper.database;

    try {
      await db.delete(FavoritoEjercicioDbModel.table);
      await _limpiarCacheFavoritos();
      return true;
    } catch (e) {
      throw DatabaseException('Error al limpiar todos los favoritos: $e');
    }
  }

  /// Obtener los IDs de ejercicios favoritos para usar con ExerciseRepository
  /// Este método es específico para obtener datos completos de ejercicios
  Future<List<String>> obtenerIdsFavoritosParaEjercicios() async {
    try {
      // Primero intentar desde cache
      final cachedIds = await _obtenerIdsFavoritosDesdeCache();
      if (cachedIds != null) {
        return cachedIds;
      }

      // Si no está en cache, obtener desde BD
      return await obtenerIdsFavoritos();
    } catch (e) {
      throw DatabaseException(
          'Error al obtener IDs de ejercicios favoritos: $e');
    }
  }

  // === MÉTODOS PRIVADOS PARA CACHE ===

  /// Actualiza el cache de SharedPreferences con los IDs actuales
  Future<void> _actualizarCacheFavoritos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ids = await obtenerIdsFavoritos();

      await prefs.setStringList(_cacheKey, ids);
      await prefs.setInt(_lastSyncKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      // Log error pero no fallar la operación principal
      print('Warning: Error al actualizar cache de favoritos: $e');
    }
  }

  /// Obtiene los IDs desde cache si están disponibles y frescos
  Future<List<String>?> _obtenerIdsFavoritosDesdeCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastSync = prefs.getInt(_lastSyncKey) ?? 0;

      // Cache válido por 5 minutos
      const cacheValidityDuration = Duration(minutes: 5);
      final isValid = DateTime.now().millisecondsSinceEpoch - lastSync <
          cacheValidityDuration.inMilliseconds;

      if (isValid) {
        return prefs.getStringList(_cacheKey);
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  /// Limpia el cache de SharedPreferences
  Future<void> _limpiarCacheFavoritos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cacheKey);
      await prefs.remove(_lastSyncKey);
    } catch (e) {
      print('Warning: Error al limpiar cache de favoritos: $e');
    }
  }
}

/// Excepción específica para errores de base de datos
class DatabaseException implements Exception {
  final String message;
  DatabaseException(this.message);

  @override
  String toString() => 'DatabaseException: $message';
}
