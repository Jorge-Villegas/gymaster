import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:gymaster/core/database/models/models.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class DatabaseHelper {
  static const _databaseName = 'database_gymaster.db';
  static const _databaseVersion =
      3; // Incrementamos la versión para user_motivation

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
        CREATE TABLE ${UsuarioDbModel.tabla} (
          ${UsuarioDbModel.columnaId}          TEXT PRIMARY KEY,
          ${UsuarioDbModel.columnaNombreUsuario}    TEXT UNIQUE NOT NULL,
          ${UsuarioDbModel.columnaCorreo}       TEXT UNIQUE NOT NULL,
          ${UsuarioDbModel.columnaContrasena}    TEXT NOT NULL,
          ${UsuarioDbModel.columnaFechaCreacion}   DATETIME DEFAULT CURRENT_TIMESTAMP,
          ${UsuarioDbModel.columnaFechaActualizacion}   DATETIME
        )
      ''');

    await db.execute('''
        CREATE TABLE ${RoutineDbModel.tabla} (
           ${RoutineDbModel.columnaId}           TEXT PRIMARY KEY,
           ${RoutineDbModel.columnaUsuarioId}       TEXT NOT NULL,
           ${RoutineDbModel.columnaNombre}         TEXT NOT NULL,
           ${RoutineDbModel.columnaDescripcion}  TEXT,
           ${RoutineDbModel.columnaColor}        INTEGER,
           ${RoutineDbModel.columnaRutaImagen}    TEXT,
           ${RoutineDbModel.columnaFechaCreacion}    DATETIME DEFAULT CURRENT_TIMESTAMP,
           ${RoutineDbModel.columnaFechaActualizacion}    DATETIME,
          FOREIGN KEY (user_id)   REFERENCES user  (id)  ON DELETE CASCADE
        )
      ''');

    await db.execute('''
        CREATE TABLE  ${RoutineSessionDbModel.table} (
          ${RoutineSessionDbModel.columnId}          TEXT PRIMARY KEY,
          ${RoutineSessionDbModel.columnRoutineId}   TEXT NOT NULL,
          ${RoutineSessionDbModel.columnStartTime}   DATETIME,
          ${RoutineSessionDbModel.columnEndTime}     DATETIME,
          ${RoutineSessionDbModel.columnStatus}      TEXT CHECK(status IN ('pendiente','en_progreso','completado','cancelado')),
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
          ${SessionExerciseDbModel.columnStatus}     TEXT CHECK(status IN ('pendiente','en_progreso','completado','cancelado')),
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
          ${ExerciseSetDbModel.columnStatus}             TEXT CHECK(status IN ('pendiente','completado','fallida')),
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

    // Tablas del sistema emocional
    await db.execute('''
        CREATE TABLE achievement (
          id            TEXT PRIMARY KEY,
          name          TEXT NOT NULL,
          description   TEXT,
          icon          TEXT,
          is_unlocked   INTEGER DEFAULT 0,
          unlocked_at   DATETIME,
          created_at    DATETIME DEFAULT CURRENT_TIMESTAMP
        )
      ''');

    await db.execute('''
        CREATE TABLE user_motivation (
          id            TEXT PRIMARY KEY,
          userId       TEXT NOT NULL,
          motivations   TEXT NOT NULL,
          challenges    TEXT NOT NULL,
          postWorkoutFeelings TEXT NOT NULL,
          notificationPreferences TEXT NOT NULL,
          createdAt     DATETIME DEFAULT CURRENT_TIMESTAMP,
          updatedAt     DATETIME,
          FOREIGN KEY (userId) REFERENCES user (id) ON DELETE CASCADE
        )
      ''');

    await db.execute('''
        CREATE TABLE user_mood (
          id            TEXT PRIMARY KEY,
          user_id       TEXT NOT NULL,
          mood_type     TEXT NOT NULL,
          recorded_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
          FOREIGN KEY (user_id) REFERENCES user (id) ON DELETE CASCADE
        )
      ''');

    await db.execute('''
        CREATE TABLE user_onboarding (
          id TEXT PRIMARY KEY,
          userId      TEXT NOT NULL,
          completed   INTEGER DEFAULT 0,
          completedAt DATETIME,
          createdAt   DATETIME DEFAULT CURRENT_TIMESTAMP,
          FOREIGN KEY (userId) REFERENCES user (id) ON DELETE CASCADE
        )
      ''');

    // Llama al seeder para llenar la base de datos con datos iniciales
    // await DatabaseSeeder(idGenerator: UuidGenerator()).seedGenerateDatabase();
  }

  // Maneja las migraciones de la base de datos
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Agregar tabla user_onboarding en versión 2
      await db.execute('''
        CREATE TABLE user_onboarding (
          id          TEXT PRIMARY KEY,
          userId      TEXT NOT NULL,
          completed   INTEGER DEFAULT 0,
          completedAt DATETIME,
          createdAt   DATETIME DEFAULT CURRENT_TIMESTAMP,
          FOREIGN KEY (userId) REFERENCES user (id) ON DELETE CASCADE
        )
      ''');
      debugPrint('🔄 Migración completada: Tabla user_onboarding agregada');
    }

    if (oldVersion < 3) {
      // Migrar user_motivation para la nueva estructura en versión 3
      debugPrint('🔄 Iniciando migración de user_motivation...');

      // Hacer backup de datos existentes
      final List<Map<String, dynamic>> existingData =
          await db.query('user_motivation');

      // Eliminar tabla antigua
      await db.execute('DROP TABLE IF EXISTS user_motivation');

      // Crear nueva tabla con estructura correcta
      await db.execute('''
        CREATE TABLE user_motivation (
          id          TEXT PRIMARY KEY,
          userId      TEXT NOT NULL,
          motivations TEXT NOT NULL,
          challenges  TEXT NOT NULL,
          postWorkoutFeelings TEXT NOT NULL,
          notificationPreferences TEXT NOT NULL,
          createdAt   DATETIME DEFAULT CURRENT_TIMESTAMP,
          updatedAt   DATETIME,
          FOREIGN KEY (userId) REFERENCES user (id) ON DELETE CASCADE
        )
      ''');

      debugPrint('🔄 Migración completada: Tabla user_motivation actualizada');
    }
  }

  // Cierra la base de datos
  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
