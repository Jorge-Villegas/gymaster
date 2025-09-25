import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:gymaster/core/database/models/favorito_ejercicio_db_model.dart';
import 'package:gymaster/core/database/models/logro_db_model.dart';
import 'package:gymaster/core/database/models/models.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class DatabaseHelper {
  static const _databaseName = 'database_gymaster.db';
  static const _databaseVersion =
      4; // Incrementamos la versión para ejercicios_favoritos

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
    print(path);

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
        CREATE TABLE ${UsuarioDb.tabla} (
          ${UsuarioDb.columnaId}                TEXT PRIMARY KEY,
          ${UsuarioDb.columnaNombreUsuario}     TEXT UNIQUE NOT NULL,
          ${UsuarioDb.columnaCorreo}            TEXT UNIQUE NOT NULL,
          ${UsuarioDb.columnaContrasena}        TEXT NOT NULL,
          ${UsuarioDb.columnaFechaCreacion}     DATETIME DEFAULT CURRENT_TIMESTAMP,
          ${UsuarioDb.columnaFechaActualizacion}   DATETIME
        )
      ''');

    await db.execute('''
        CREATE TABLE ${RutinaDb.tabla} (
           ${RutinaDb.columnaId}              TEXT PRIMARY KEY,
           ${RutinaDb.columnaUsuarioId}       TEXT NOT NULL,
           ${RutinaDb.columnaNombre}          TEXT NOT NULL,
           ${RutinaDb.columnaDescripcion}     TEXT,
           ${RutinaDb.columnaColor}           INTEGER,
           ${RutinaDb.columnaRutaImagen}      TEXT,
           ${RutinaDb.columnaFechaCreacion}   DATETIME DEFAULT CURRENT_TIMESTAMP,
           ${RutinaDb.columnaFechaActualizacion}    DATETIME,
          FOREIGN KEY (${RutinaDb.columnaUsuarioId})   REFERENCES user  (id)  ON DELETE CASCADE
        )
      ''');

    await db.execute('''
        CREATE TABLE  ${RutinaSesionDb.tabla} (
          ${RutinaSesionDb.columnaId}           TEXT PRIMARY KEY,
          ${RutinaSesionDb.columnaRutinaId}     TEXT NOT NULL,
          ${RutinaSesionDb.columnaHoraInicio}   DATETIME,
          ${RutinaSesionDb.columnaHoraFin}      DATETIME,
          ${RutinaSesionDb.columnaEstado}       TEXT CHECK(${RutinaSesionDb.columnaEstado}  IN ('pendiente','en_progreso','completado','cancelado')),
          ${RutinaSesionDb.columnaFechaCreacion}   DATETIME DEFAULT CURRENT_TIMESTAMP,
          FOREIGN KEY (${RutinaSesionDb.columnaRutinaId})   REFERENCES ${RutinaDb.tabla}   (id)  ON DELETE CASCADE
        )
      ''');

    await db.execute('''
        CREATE TABLE ${EjercicioDb.tabla} (
          ${EjercicioDb.columnId}                 TEXT PRIMARY KEY,
          ${EjercicioDb.columnaNombre}            TEXT NOT NULL,
          ${EjercicioDb.columnaDescripcion}       TEXT,
          ${EjercicioDb.columnaRutaImagen}        TEXT,
          ${EjercicioDb.columnaFechaCreacion}     DATETIME DEFAULT CURRENT_TIMESTAMP,
          ${EjercicioDb.columnaFechaActualizacion}    DATETIME
        )
      ''');

    await db.execute('''
        CREATE TABLE ${MusculoDb.tabla} (
          ${MusculoDb.columnaId}              TEXT PRIMARY KEY,
          ${MusculoDb.columnaNombre}          TEXT NOT NULL,
          ${MusculoDb.columnaRutaImagen}      TEXT,
          ${MusculoDb.columnaFechaCreacion}   DATETIME DEFAULT CURRENT_TIMESTAMP
        )
      ''');

    await db.execute('''
        CREATE TABLE  ${EjercicioMusculoDbModel.tabla} (
          ${EjercicioMusculoDbModel.columnaEjercicioId}     TEXT NOT NULL,
          ${EjercicioMusculoDbModel.columnaMusculoId}       TEXT NOT NULL,
          PRIMARY KEY (${EjercicioMusculoDbModel.columnaEjercicioId}, ${EjercicioMusculoDbModel.columnaMusculoId}),
          FOREIGN KEY (${EjercicioMusculoDbModel.columnaEjercicioId})  REFERENCES ${EjercicioDb.tabla}  (id)  ON DELETE CASCADE,
          FOREIGN KEY (${EjercicioMusculoDbModel.columnaMusculoId})    REFERENCES ${MusculoDb.tabla} (id)  ON DELETE CASCADE
        )
      ''');

    await db.execute('''
        CREATE TABLE ${SessionEjercicioDb.tabla} (
          ${SessionEjercicioDb.columnId}         TEXT PRIMARY KEY,
          ${SessionEjercicioDb.columnSessionId}  TEXT NOT NULL,
          ${SessionEjercicioDb.columnExerciseId} TEXT NOT NULL,
          ${SessionEjercicioDb.columnOrderIndex} INTEGER DEFAULT 0,
          ${SessionEjercicioDb.columnStatus}     TEXT CHECK(${SessionEjercicioDb.columnStatus} IN ('pendiente','en_progreso','completado','cancelado')),
          FOREIGN KEY (${SessionEjercicioDb.columnSessionId})    REFERENCES ${RutinaSesionDb.tabla}  (id)   ON DELETE CASCADE,
          FOREIGN KEY (${SessionEjercicioDb.columnExerciseId})   REFERENCES ${EjercicioDb.tabla}     (id)   ON DELETE CASCADE
        )
      ''');

    await db.execute('''
        CREATE TABLE ${SerieEjercicioDb.tabla}  (
          ${SerieEjercicioDb.columnaId}                 TEXT PRIMARY KEY,
          ${SerieEjercicioDb.columnaEjercicioSesionId}  TEXT NOT NULL,
          ${SerieEjercicioDb.columnaPeso}               REAL,
          ${SerieEjercicioDb.columnaRepeticiones}       INTEGER,
          ${SerieEjercicioDb.columnaTiempoDescanso}     INTEGER,
          ${SerieEjercicioDb.columnaEstado}             TEXT CHECK(${SerieEjercicioDb.columnaEstado} IN ('pendiente','completado','fallida')),
          FOREIGN KEY (${SerieEjercicioDb.columnaEjercicioSesionId}) REFERENCES ${SessionEjercicioDb.tabla} (id) ON DELETE CASCADE
        )
      ''');

    await db.execute('''
        CREATE TABLE ${AuditLogDb.table}  (
          ${AuditLogDb.columnId}          TEXT PRIMARY KEY,
          ${AuditLogDb.columnUserId}      TEXT NOT NULL,
          ${AuditLogDb.columnTableName}   TEXT NOT NULL,
          ${AuditLogDb.columnRecordId}    TEXT NOT NULL,
          ${AuditLogDb.columnAction}      TEXT CHECK(action IN ('INSERT','UPDATE','DELETE')),
          ${AuditLogDb.columnTimestamp}   DATETIME DEFAULT CURRENT_TIMESTAMP,
          FOREIGN KEY (${AuditLogDb.columnUserId}) REFERENCES ${UsuarioDb.tabla} (id) ON DELETE CASCADE
        )
      ''');

    await db.execute('''
        CREATE TABLE ${LogroDbModel.tabla} (
          ${LogroDbModel.columnaId}                TEXT PRIMARY KEY,
          ${LogroDbModel.columnaTipo}              TEXT NOT NULL,
          ${LogroDbModel.columnaTitulo}            TEXT NOT NULL,
          ${LogroDbModel.columnaDescripcion}       TEXT,
          ${LogroDbModel.columnaIcono}             TEXT,
          ${LogroDbModel.columnaColor}             INTEGER,
          ${LogroDbModel.columnaPuntos}            INTEGER,
          ${LogroDbModel.columnaFechaDesbloqueo}   DATETIME,
          ${LogroDbModel.columnaDesbloqueado}      INTEGER DEFAULT 0,
          ${LogroDbModel.columnaCriterios}         TEXT,
          ${LogroDbModel.columnaProgreso}          REAL DEFAULT 0.0,
          ${LogroDbModel.columnaRareza}            TEXT,
          ${LogroDbModel.columnaFechaCreacion}     DATETIME DEFAULT CURRENT_TIMESTAMP
        )
      ''');

    await db.execute('''
        CREATE TABLE user_motivation (
          id            TEXT PRIMARY KEY,
          ${RutinaDb.columnaUsuarioId}       TEXT NOT NULL,
          motivations   TEXT NOT NULL,
          challenges    TEXT NOT NULL,
          postWorkoutFeelings TEXT NOT NULL,
          notificationPreferences TEXT NOT NULL,
          createdAt     DATETIME DEFAULT CURRENT_TIMESTAMP,
          updatedAt     DATETIME,
          FOREIGN KEY (${RutinaDb.columnaUsuarioId}) REFERENCES ${RutinaDb.tabla} (id) ON DELETE CASCADE
        )
      ''');

    await db.execute('''
        CREATE TABLE user_mood (
          id            TEXT PRIMARY KEY,
          ${RutinaDb.columnaUsuarioId}       TEXT NOT NULL,
          mood_type     TEXT NOT NULL,
          recorded_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
          FOREIGN KEY (${RutinaDb.columnaUsuarioId}) REFERENCES ${RutinaDb.tabla} (id) ON DELETE CASCADE
        )
      ''');

    await db.execute('''
        CREATE TABLE user_onboarding (
          id TEXT PRIMARY KEY,
          ${RutinaDb.columnaUsuarioId}      TEXT NOT NULL,
          completed   INTEGER DEFAULT 0,
          completedAt DATETIME,
          createdAt   DATETIME DEFAULT CURRENT_TIMESTAMP,
          FOREIGN KEY (${RutinaDb.columnaUsuarioId}) REFERENCES ${RutinaDb.tabla} (id) ON DELETE CASCADE
        )
      ''');

    // Crear tabla de ejercicios favoritos
    await db.execute(FavoritoEjercicioDbModel.createTableSql);

    // Crear índices para performance
    for (String indexSql in FavoritoEjercicioDbModel.createIndexesSql) {
      await db.execute(indexSql);
    }

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
          ${RutinaDb.columnaUsuarioId}      TEXT NOT NULL,
          completed   INTEGER DEFAULT 0,
          completedAt DATETIME,
          createdAt   DATETIME DEFAULT CURRENT_TIMESTAMP,
          FOREIGN KEY (${RutinaDb.columnaUsuarioId}) REFERENCES ${RutinaDb.tabla} (id) ON DELETE CASCADE
        )
      ''');
      debugPrint('🔄 Migración completada: Tabla user_onboarding agregada');
    }

    if (oldVersion < 3) {
      // Migrar user_motivation para la nueva estructura en versión 3
      debugPrint('🔄 Iniciando migración de user_motivation...');

      // Hacer backup de datos existentes (no usado por ahora)
      // final List<Map<String, dynamic>> existingData =
      //     await db.query('user_motivation');

      // Eliminar tabla antigua
      await db.execute('DROP TABLE IF EXISTS user_motivation');

      // Crear nueva tabla con estructura correcta
      await db.execute('''
        CREATE TABLE user_motivation (
          id          TEXT PRIMARY KEY,
          ${RutinaDb.columnaUsuarioId}      TEXT NOT NULL,
          motivations TEXT NOT NULL,
          challenges  TEXT NOT NULL,
          postWorkoutFeelings TEXT NOT NULL,
          notificationPreferences TEXT NOT NULL,
          createdAt   DATETIME DEFAULT CURRENT_TIMESTAMP,
          updatedAt   DATETIME,
          FOREIGN KEY (${RutinaDb.columnaUsuarioId}) REFERENCES ${RutinaDb.tabla} (id) ON DELETE CASCADE
        )
      ''');

      debugPrint('🔄 Migración completada: Tabla user_motivation actualizada');
    }

    if (oldVersion < 4) {
      // Agregar tabla ejercicios_favoritos en versión 4
      debugPrint('🔄 Iniciando migración para ejercicios_favoritos...');

      await db.execute(FavoritoEjercicioDbModel.createTableSql);

      // Crear índices para performance
      for (String indexSql in FavoritoEjercicioDbModel.createIndexesSql) {
        await db.execute(indexSql);
      }

      debugPrint(
          '🔄 Migración completada: Tabla ejercicios_favoritos agregada');
    }
  }

  // Cierra la base de datos
  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
