import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gymaster/core/database/database_helper.dart';
import 'package:gymaster/features/setting/data/datasources/user_emotional_local_data_source.dart';
import 'package:gymaster/features/setting/domain/entities/user_motivation.dart';
import 'package:gymaster/features/setting/domain/entities/user_mood.dart';
import 'package:sqflite/sqflite.dart';

class UserEmotionalLocalDataSourceImpl implements UserEmotionalLocalDataSource {
  final DatabaseHelper databaseHelper;

  UserEmotionalLocalDataSourceImpl(this.databaseHelper);

  @override
  Future<void> saveUserMotivation(UserMotivation motivation) async {
    final db = await databaseHelper.database;

    try {
      // Convertir listas y objetos complejos a JSON strings para SQLite
      final dataToSave = {
        'id': DateTime.now()
            .millisecondsSinceEpoch
            .toString(), // Generar ID único
        'userId': motivation.userId,
        'motivations': jsonEncode(motivation.motivations),
        'challenges': jsonEncode(motivation.challenges),
        'postWorkoutFeelings': jsonEncode(motivation.postWorkoutFeelings),
        'notificationPreferences':
            jsonEncode(motivation.notificationPreferences.toJson()),
        'createdAt': motivation.createdAt.toIso8601String(),
        'updatedAt': motivation.updatedAt.toIso8601String(),
      };

      await db.insert(
        'user_motivation',
        dataToSave,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      // Si la tabla no tiene la estructura correcta, crearla
      if (e.toString().contains('no column named userId') ||
          e.toString().contains('no such table: user_motivation')) {
        debugPrint(
            '🔧 Recreando tabla user_motivation con estructura correcta...');

        // Eliminar tabla existente si existe
        await db.execute('DROP TABLE IF EXISTS user_motivation');

        // Crear nueva tabla con estructura correcta
        await db.execute('''
          CREATE TABLE user_motivation (
            id TEXT PRIMARY KEY,
            userId TEXT NOT NULL,
            motivations TEXT NOT NULL,
            challenges TEXT NOT NULL,
            postWorkoutFeelings TEXT NOT NULL,
            notificationPreferences TEXT NOT NULL,
            createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
            updatedAt DATETIME
          )
        ''');

        debugPrint('✅ Tabla user_motivation recreada');

        // Intentar insertar nuevamente
        final dataToSave = {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'userId': motivation.userId,
          'motivations': jsonEncode(motivation.motivations),
          'challenges': jsonEncode(motivation.challenges),
          'postWorkoutFeelings': jsonEncode(motivation.postWorkoutFeelings),
          'notificationPreferences':
              jsonEncode(motivation.notificationPreferences.toJson()),
          'createdAt': motivation.createdAt.toIso8601String(),
          'updatedAt': motivation.updatedAt.toIso8601String(),
        };

        await db.insert(
          'user_motivation',
          dataToSave,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        debugPrint('✅ Motivación guardada exitosamente');
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<UserMotivation?> getUserMotivation(String userId) async {
    final db = await databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'user_motivation',
      where: 'userId = ?',
      whereArgs: [userId],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      final rawData = maps.first;

      // Convertir JSON strings de vuelta a objetos
      final processedData = {
        'userId': rawData['userId'],
        'motivations': jsonDecode(rawData['motivations']),
        'challenges': jsonDecode(rawData['challenges']),
        'postWorkoutFeelings': jsonDecode(rawData['postWorkoutFeelings']),
        'notificationPreferences':
            jsonDecode(rawData['notificationPreferences']),
        'createdAt': rawData['createdAt'],
        'updatedAt': rawData['updatedAt'],
      };

      return UserMotivation.fromJson(processedData);
    }
    return null;
  }

  @override
  Future<void> updateUserMotivation(UserMotivation motivation) async {
    final db = await databaseHelper.database;

    // Convertir listas y objetos complejos a JSON strings para SQLite
    final dataToUpdate = {
      'userId': motivation.userId,
      'motivations': jsonEncode(motivation.motivations),
      'challenges': jsonEncode(motivation.challenges),
      'postWorkoutFeelings': jsonEncode(motivation.postWorkoutFeelings),
      'notificationPreferences':
          jsonEncode(motivation.notificationPreferences.toJson()),
      'createdAt': motivation.createdAt.toIso8601String(),
      'updatedAt': motivation.updatedAt.toIso8601String(),
    };

    await db.update(
      'user_motivation',
      dataToUpdate,
      where: 'userId = ?',
      whereArgs: [motivation.userId],
    );
  }

  @override
  Future<void> saveUserMood(UserMood mood) async {
    final db = await databaseHelper.database;

    await db.insert(
      'user_mood',
      mood.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<UserMood?> getLatestUserMood(String userId) async {
    final db = await databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'user_mood',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'timestamp DESC',
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return UserMood.fromJson(maps.first);
    }
    return null;
  }

  @override
  Future<List<UserMood>> getUserMoodHistory(String userId,
      {int limit = 30}) async {
    final db = await databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'user_mood',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'timestamp DESC',
      limit: limit,
    );

    return List.generate(maps.length, (i) {
      return UserMood.fromJson(maps[i]);
    });
  }

  @override
  Future<void> markOnboardingCompleted(String userId) async {
    final db = await databaseHelper.database;

    try {
      await db.insert(
        'user_onboarding',
        {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'usuario_id': userId,
          'completed': 1,
          'completedAt': DateTime.now().toIso8601String(),
          'createdAt': DateTime.now().toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      // Si la tabla no existe, crearla primero
      if (e.toString().contains('no such table: user_onboarding')) {
        debugPrint(
            '🔧 Creando tabla user_onboarding para markOnboardingCompleted...');
        await db.execute('''
          CREATE TABLE IF NOT EXISTS user_onboarding (
            id TEXT PRIMARY KEY,
            usuario_id TEXT NOT NULL,
            completed INTEGER DEFAULT 0,
            completedAt DATETIME,
            createdAt DATETIME DEFAULT CURRENT_TIMESTAMP
          )
        ''');

        // Intentar insertar nuevamente
        await db.insert(
          'user_onboarding',
          {
            'id': DateTime.now().millisecondsSinceEpoch.toString(),
            'usuario_id': userId,
            'completed': 1,
            'completedAt': DateTime.now().toIso8601String(),
            'createdAt': DateTime.now().toIso8601String(),
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        debugPrint('✅ Onboarding marcado como completado');
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<bool> isOnboardingCompleted(String userId) async {
    final db = await databaseHelper.database;

    try {
      final List<Map<String, dynamic>> maps = await db.query(
        'user_onboarding',
        where: 'usuario_id = ? AND completed = 1',
        whereArgs: [userId],
        limit: 1,
      );

      return maps.isNotEmpty;
    } catch (e) {
      // Si la tabla no existe, crearla y retornar false
      if (e.toString().contains('no such table: user_onboarding')) {
        debugPrint('🔧 Creando tabla user_onboarding...');
        await db.execute('''
          CREATE TABLE IF NOT EXISTS user_onboarding (
            id TEXT PRIMARY KEY,
            usuario_id TEXT NOT NULL,
            completed INTEGER DEFAULT 0,
            completedAt DATETIME,
            createdAt DATETIME DEFAULT CURRENT_TIMESTAMP
          )
        ''');
        debugPrint('✅ Tabla user_onboarding creada');
        return false; // Primera vez, onboarding no completado
      }
      rethrow; // Re-lanzar otros errores
    }
  }
}
