import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:gymaster/core/database/models/favorito_ejercicio_db_model.dart';
import 'package:gymaster/core/database/models/logro_db_model.dart';
import 'package:gymaster/core/database/models/models.dart';
import 'package:gymaster/features/setting/data/models/perfil_usuario_completo_db_model.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class DatabaseHelper {
  static const _databaseName = 'database_gymaster.db';
  static const _databaseVersion =
      8; // Incrementamos para forzar migración de perfil de usuario completo

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

    debugPrint('📱 Ruta de base de datos: $path');
    debugPrint('🔧 Versión esperada: $_databaseVersion');

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) async {
        debugPrint('🆕 Creando nueva base de datos versión $version');
        await _onCreate(db, version);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        debugPrint(
            '⬆️ Actualizando base de datos de v$oldVersion a v$newVersion');
        await _onUpgrade(db, oldVersion, newVersion);
      },
      readOnly: false,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    debugPrint('🆕 Iniciando creación de base de datos versión $version');
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
           ${RutinaDb.columnaFechaEliminacion}      DATETIME,
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

    // Crear tabla perfil_usuario_completo para nuevas instalaciones
    await db.execute(PerfilUsuarioCompletoDbModel.createTableSql);
    debugPrint('✅ Tabla perfil_usuario_completo creada en nueva instalación');

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

    if (oldVersion < 5) {
      // Agregar columna deleted_at para eliminación lógica en versión 5
      debugPrint(
          '🔄 Iniciando migración para eliminación lógica de rutinas...');

      await db.execute('''
        ALTER TABLE ${RutinaDb.tabla} 
        ADD COLUMN ${RutinaDb.columnaFechaEliminacion} DATETIME
      ''');

      debugPrint(
          '🔄 Migración completada: Columna deleted_at agregada a rutinas');
    }

    if (oldVersion < 6) {
      // Migración para configuración completa de settings - versión 6
      debugPrint('🔄 Iniciando migración para settings completo...');

      // Extender tabla usuario con perfil completo
      await db.execute(
          'ALTER TABLE ${UsuarioDb.tabla} ADD COLUMN foto_perfil TEXT');
      await db.execute(
          'ALTER TABLE ${UsuarioDb.tabla} ADD COLUMN nombre_completo TEXT');
      await db.execute(
          'ALTER TABLE ${UsuarioDb.tabla} ADD COLUMN fecha_nacimiento DATE');
      await db.execute(
          'ALTER TABLE ${UsuarioDb.tabla} ADD COLUMN genero TEXT CHECK(genero IN (\'masculino\', \'femenino\', \'otro\', \'prefiero_no_decir\'))');
      await db.execute(
          'ALTER TABLE ${UsuarioDb.tabla} ADD COLUMN objetivo_fitness TEXT CHECK(objetivo_fitness IN (\'perder_peso\', \'ganar_musculo\', \'mantenimiento\', \'fuerza\', \'resistencia\', \'tonificar\'))');
      await db.execute(
          'ALTER TABLE ${UsuarioDb.tabla} ADD COLUMN nivel_experiencia TEXT CHECK(nivel_experiencia IN (\'principiante\', \'intermedio\', \'avanzado\'))');
      await db.execute(
          'ALTER TABLE ${UsuarioDb.tabla} ADD COLUMN altura_cm INTEGER');
      await db.execute(
          'ALTER TABLE ${UsuarioDb.tabla} ADD COLUMN peso_actual_kg REAL');
      await db.execute(
          'ALTER TABLE ${UsuarioDb.tabla} ADD COLUMN peso_objetivo_kg REAL');
      await db.execute(
          'ALTER TABLE ${UsuarioDb.tabla} ADD COLUMN fecha_actualizacion_perfil DATETIME');

      // Crear tabla configuracion_usuario
      await db.execute('''
        CREATE TABLE configuracion_usuario (
          id TEXT PRIMARY KEY,
          usuario_id TEXT NOT NULL,
          -- Unidades de medida
          unidad_peso TEXT DEFAULT 'kg' CHECK(unidad_peso IN ('kg', 'lb')),
          unidad_longitud TEXT DEFAULT 'cm' CHECK(unidad_longitud IN ('cm', 'in')),
          formato_hora TEXT DEFAULT '24h' CHECK(formato_hora IN ('24h', '12h')),
          formato_fecha TEXT DEFAULT '31.01' CHECK(formato_fecha IN ('31.01', '01/31')),
          dia_inicio_semana TEXT DEFAULT 'lunes' CHECK(dia_inicio_semana IN ('lunes', 'domingo')),
          unidad_calorias TEXT DEFAULT 'kcal' CHECK(unidad_calorias IN ('kcal', 'kj')),
          
          -- Configuraciones de entrenamiento
          tiempo_descanso_defecto INTEGER DEFAULT 60,
          sonidos_habilitados INTEGER DEFAULT 1,
          vibracion_habilitada INTEGER DEFAULT 1,
          volumen_sonidos INTEGER DEFAULT 80,
          intensidad_vibracion TEXT DEFAULT 'media' CHECK(intensidad_vibracion IN ('baja', 'media', 'alta')),
          auto_siguiente_ejercicio INTEGER DEFAULT 0,
          
          -- Notificaciones
          notificaciones_habilitadas INTEGER DEFAULT 1,
          recordatorio_entrenar INTEGER DEFAULT 1,
          recordatorio_racha INTEGER DEFAULT 1,
          recordatorio_descanso INTEGER DEFAULT 1,
          hora_recordatorio_manana TEXT DEFAULT '08:00',
          hora_recordatorio_tarde TEXT DEFAULT '18:00',
          
          -- Tema y personalización
          modo_oscuro INTEGER DEFAULT 0,
          idioma TEXT DEFAULT 'es' CHECK(idioma IN ('es', 'en')),
          
          -- Auditoria
          fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
          fecha_actualizacion DATETIME,
          
          FOREIGN KEY (usuario_id) REFERENCES ${UsuarioDb.tabla} (id) ON DELETE CASCADE
        )
      ''');

      // Crear tabla informacion_aplicacion
      await db.execute('''
        CREATE TABLE informacion_aplicacion (
          id TEXT PRIMARY KEY,
          version_app TEXT NOT NULL,
          fecha_instalacion DATETIME DEFAULT CURRENT_TIMESTAMP,
          fecha_ultima_actualizacion DATETIME,
          numero_inicios_sesion INTEGER DEFAULT 0,
          fecha_ultimo_inicio DATETIME,
          racha_actual INTEGER DEFAULT 0,
          racha_maxima INTEGER DEFAULT 0,
          total_rutinas_completadas INTEGER DEFAULT 0,
          total_ejercicios_realizados INTEGER DEFAULT 0,
          tiempo_total_entrenamiento INTEGER DEFAULT 0,
          fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP
        )
      ''');

      debugPrint('🔄 Migración completada: Settings completo implementado');
    }

    if (oldVersion < 7) {
      // Crear tabla perfil_usuario_completo en versión 7
      debugPrint('🔄 Iniciando migración para perfil de usuario completo...');
      debugPrint(
          '📋 SQL de creación: ${PerfilUsuarioCompletoDbModel.createTableSql}');

      try {
        await db.execute(PerfilUsuarioCompletoDbModel.createTableSql);

        // Verificar que la tabla se creó correctamente
        final result = await db.rawQuery(
            "SELECT name FROM sqlite_master WHERE type='table' AND name='perfil_usuario_completo'");

        if (result.isNotEmpty) {
          debugPrint('✅ Tabla perfil_usuario_completo creada exitosamente');
        } else {
          debugPrint('❌ Error: Tabla perfil_usuario_completo no se creó');
        }
      } catch (e) {
        debugPrint('❌ Error creando tabla perfil_usuario_completo: $e');
        rethrow;
      }

      debugPrint(
          '🔄 Migración completada: Tabla perfil_usuario_completo agregada');
    }

    if (oldVersion < 8) {
      // Migración v8: Asegurar que tabla perfil_usuario_completo existe
      debugPrint('🔄 Verificando tabla perfil_usuario_completo en v8...');

      try {
        // Verificar si la tabla existe
        final result = await db.rawQuery(
            "SELECT name FROM sqlite_master WHERE type='table' AND name='perfil_usuario_completo'");

        if (result.isEmpty) {
          debugPrint(
              '🔄 Tabla perfil_usuario_completo no existe, creándola...');
          await db.execute(PerfilUsuarioCompletoDbModel.createTableSql);

          // Verificar nuevamente
          final checkResult = await db.rawQuery(
              "SELECT name FROM sqlite_master WHERE type='table' AND name='perfil_usuario_completo'");

          if (checkResult.isNotEmpty) {
            debugPrint(
                '✅ Tabla perfil_usuario_completo creada exitosamente en v8');
          } else {
            debugPrint(
                '❌ Error: Tabla perfil_usuario_completo no se pudo crear en v8');
          }
        } else {
          debugPrint('✅ Tabla perfil_usuario_completo ya existe en v8');
        }
      } catch (e) {
        debugPrint('❌ Error en migración v8: $e');
        rethrow;
      }
    }
  }

  // Cierra la base de datos
  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
