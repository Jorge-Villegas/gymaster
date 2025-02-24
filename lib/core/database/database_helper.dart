import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static const _databaseName = 'gymaster.db';
  static const _databaseVersion = 1;

  // Nombres de las tablas
  static const tbUser = 'user';
  static const tbRoutine = 'routine';
  static const tbRoutineSession = 'routine_session';
  static const tbExercise = 'exercise';
  static const tbMuscle = 'muscle';
  static const tbExerciseMuscle = 'exercise_muscle';
  static const tbSessionExercise = 'session_exercise';
  static const tbExerciseSet = 'exercise_set';
  static const tbAuditLog = 'audit_log';

  // Singleton
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Inicializa la base de datos
  Future<Database> _initDatabase() async {
    if (Platform.isWindows) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    debugPrint(path);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE user (
          id TEXT PRIMARY KEY,
          username TEXT UNIQUE NOT NULL,
          email TEXT UNIQUE NOT NULL,
          password TEXT NOT NULL,
          created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
          updated_at DATETIME
        )
      ''');

    await db.execute('''
        CREATE TABLE routine (
          id TEXT PRIMARY KEY,
          user_id TEXT NOT NULL,
          name TEXT NOT NULL,
          description TEXT,
          color INTEGER,
          image_path TEXT,
          created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
          updated_at DATETIME,
          FOREIGN KEY (user_id) REFERENCES user (id) ON DELETE CASCADE
        )
      ''');

    await db.execute('''
        CREATE TABLE routine_session (
          id TEXT PRIMARY KEY,
          routine_id TEXT NOT NULL,
          start_time DATETIME,
          end_time DATETIME,
          status TEXT CHECK(status IN ('pending','in_progress','completed','cancelled')),
          created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
          FOREIGN KEY (routine_id) REFERENCES routine (id) ON DELETE CASCADE
        )
      ''');

    await db.execute('''
        CREATE TABLE exercise (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          description TEXT,
          image_path TEXT,
          created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
          updated_at DATETIME
        )
      ''');

    await db.execute('''
        CREATE TABLE muscle (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          image_path TEXT,
          created_at DATETIME DEFAULT CURRENT_TIMESTAMP
        )
      ''');

    await db.execute('''
        CREATE TABLE exercise_muscle (
          exercise_id TEXT NOT NULL,
          muscle_id TEXT NOT NULL,
          PRIMARY KEY (exercise_id, muscle_id),
          FOREIGN KEY (exercise_id) REFERENCES exercise (id) ON DELETE CASCADE,
          FOREIGN KEY (muscle_id) REFERENCES muscle (id) ON DELETE CASCADE
        )
      ''');

    await db.execute('''
        CREATE TABLE session_exercise (
          id TEXT PRIMARY KEY,
          session_id TEXT NOT NULL,
          exercise_id TEXT NOT NULL,
          status TEXT CHECK(status IN ('pending','in_progress','completed','cancelled')),
          FOREIGN KEY (session_id) REFERENCES routine_session (id) ON DELETE CASCADE,
          FOREIGN KEY (exercise_id) REFERENCES exercise (id) ON DELETE CASCADE
        )
      ''');

    await db.execute('''
        CREATE TABLE exercise_set (
          id TEXT PRIMARY KEY,
          session_exercise_id TEXT NOT NULL,
          weight REAL,
          repetitions INTEGER,
          rest_time INTEGER,
          status TEXT CHECK(status IN ('pending','completed','failed')),
          FOREIGN KEY (session_exercise_id) REFERENCES session_exercise (id) ON DELETE CASCADE
        )
      ''');

    await db.execute('''
        CREATE TABLE audit_log (
          id TEXT PRIMARY KEY,
          user_id TEXT NOT NULL,
          table_name TEXT NOT NULL,
          record_id TEXT NOT NULL,
          action TEXT CHECK(action IN ('INSERT','UPDATE','DELETE')),
          timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
          FOREIGN KEY (user_id) REFERENCES user (id) ON DELETE CASCADE
        )
      ''');
  }

  // Maneja las migraciones de la base de datos
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      // Agregar lógica para manejar cambios entre versiones.
      // Por ejemplo: db.execute('ALTER TABLE Ejercicio ADD COLUMN nuevaColumna TEXT');
    }
  }

  // Cierra la base de datos
  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
