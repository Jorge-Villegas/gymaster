import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:gymaster/core/database/models/models.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class DatabaseHelper {
  static const _databaseName = 'gymaster.db';
  static const _databaseVersion = 1;

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
    if (kIsWeb) {
      var factory = databaseFactoryFfiWeb;
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, _databaseName);

      return await factory.openDatabase(
        path,
        options: OpenDatabaseOptions(
          version: _databaseVersion,
          onCreate: _onCreate,
          onUpgrade: _onUpgrade,
        ),
      );
    } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
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
      readOnly: false,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE ${UserDbModel.table} (
          ${UserDbModel.columnId}          TEXT PRIMARY KEY,
          ${UserDbModel.columnUserName}    TEXT UNIQUE NOT NULL,
          ${UserDbModel.columnEmain}       TEXT UNIQUE NOT NULL,
          ${UserDbModel.columnPassword}    TEXT NOT NULL,
          ${UserDbModel.columnCreatedAt}   DATETIME DEFAULT CURRENT_TIMESTAMP,
          ${UserDbModel.columnUpdatedAt}   DATETIME
        )
      ''');

    await db.execute('''
        CREATE TABLE ${RoutineDbModel.table} (
           ${RoutineDbModel.columnId}           TEXT PRIMARY KEY,
           ${RoutineDbModel.columnUserId}       TEXT NOT NULL,
           ${RoutineDbModel.columnName}         TEXT NOT NULL,
           ${RoutineDbModel.columnDescription}  TEXT,
           ${RoutineDbModel.columnColor}        INTEGER,
           ${RoutineDbModel.columnImagePath}    TEXT,
           ${RoutineDbModel.columnCreatedAt}    DATETIME DEFAULT CURRENT_TIMESTAMP,
           ${RoutineDbModel.columnUpdatedAt}    DATETIME,
          FOREIGN KEY (user_id)   REFERENCES user  (id)  ON DELETE CASCADE
        )
      ''');

    await db.execute('''
        CREATE TABLE  ${RoutineSessionDbModel.table} (
          ${RoutineSessionDbModel.columnId}          TEXT PRIMARY KEY,
          ${RoutineSessionDbModel.columnRoutineId}   TEXT NOT NULL,
          ${RoutineSessionDbModel.columnStartTime}   DATETIME,
          ${RoutineSessionDbModel.columnEndTime}     DATETIME,
          ${RoutineSessionDbModel.columnStatus}      TEXT CHECK(status IN ('pending','in_progress','completed','cancelled')),
          ${RoutineSessionDbModel.columnCreatedAt}   DATETIME DEFAULT CURRENT_TIMESTAMP,
          FOREIGN KEY (routine_id)   REFERENCES routine   (id)  ON DELETE CASCADE
        )
      ''');

    await db.execute('''
        CREATE TABLE ${ExerciseDbModel.table} (
          ${ExerciseDbModel.columnId}           TEXT PRIMARY KEY,
          ${ExerciseDbModel.columnName}         TEXT NOT NULL,
          ${ExerciseDbModel.columnDescription}  TEXT,
          ${ExerciseDbModel.columnImagePath}    TEXT,
          ${ExerciseDbModel.columnCreatedAt}    DATETIME DEFAULT CURRENT_TIMESTAMP,
          ${ExerciseDbModel.columnUpdatedAt}    DATETIME
        )
      ''');

    await db.execute('''
        CREATE TABLE ${MuscleDbModel.table} (
          ${MuscleDbModel.columnId}          TEXT PRIMARY KEY,
          ${MuscleDbModel.columnName}        TEXT NOT NULL,
          ${MuscleDbModel.columnImagePath}   TEXT,
          ${MuscleDbModel.columnCreatedAt}   DATETIME DEFAULT CURRENT_TIMESTAMP
        )
      ''');

    await db.execute('''
        CREATE TABLE  ${ExerciseMuscleDbModel.table} (
          ${ExerciseMuscleDbModel.columnExerciseId}  TEXT NOT NULL,
          ${ExerciseMuscleDbModel.columnMuscleId}    TEXT NOT NULL,
          PRIMARY KEY (exercise_id, muscle_id),
          FOREIGN KEY (exercise_id)  REFERENCES exercise  (id)  ON DELETE CASCADE,
          FOREIGN KEY (muscle_id)    REFERENCES muscle    (id)  ON DELETE CASCADE
        )
      ''');

    await db.execute('''
        CREATE TABLE ${SessionExerciseDbModel.table} (
          ${SessionExerciseDbModel.columnId}         TEXT PRIMARY KEY,
          ${SessionExerciseDbModel.columnSessionId}  TEXT NOT NULL,
          ${SessionExerciseDbModel.columnExerciseId} TEXT NOT NULL,
          ${SessionExerciseDbModel.columnOrderIndex} INTEGER DEFAULT 0,
          ${SessionExerciseDbModel.columnStatus}     TEXT CHECK(status IN ('pending','in_progress','completed','cancelled')),
          FOREIGN KEY (session_id)    REFERENCES routine_session  (id)   ON DELETE CASCADE,
          FOREIGN KEY (exercise_id)   REFERENCES exercise         (id)   ON DELETE CASCADE
        )
      ''');

    await db.execute('''
        CREATE TABLE ${ExerciseSetDbModel.table}  (
          ${ExerciseSetDbModel.columnId}                 TEXT PRIMARY KEY,
          ${ExerciseSetDbModel.columnSessionExerciseId}  TEXT NOT NULL,
          ${ExerciseSetDbModel.columnWeight}             REAL,
          ${ExerciseSetDbModel.columnRepetitions}        INTEGER,
          ${ExerciseSetDbModel.columnRestTime}           INTEGER,
          ${ExerciseSetDbModel.columnStatus}             TEXT CHECK(status IN ('pending','completed','failed')),
          FOREIGN KEY (session_exercise_id) REFERENCES session_exercise (id) ON DELETE CASCADE
        )
      ''');

    await db.execute('''
        CREATE TABLE ${AuditLogDbModel.table}  (
          ${AuditLogDbModel.columnId}          TEXT PRIMARY KEY,
          ${AuditLogDbModel.columnUserId}      TEXT NOT NULL,
          ${AuditLogDbModel.columnTableName}   TEXT NOT NULL,
          ${AuditLogDbModel.columnRecordId}    TEXT NOT NULL,
          ${AuditLogDbModel.columnAction}      TEXT CHECK(action IN ('INSERT','UPDATE','DELETE')),
          ${AuditLogDbModel.columnTimestamp}   DATETIME DEFAULT CURRENT_TIMESTAMP,
          FOREIGN KEY (user_id) REFERENCES user (id) ON DELETE CASCADE
        )
      ''');
    // Llama al seeder para llenar la base de datos con datos iniciales
    // await DatabaseSeeder(idGenerator: UuidGenerator()).seedGenerateDatabase();
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
