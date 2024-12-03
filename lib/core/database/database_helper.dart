import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uuid/uuid.dart';

class DatabaseHelper {
  static const _databaseName = 'gymaster.db';
  static const _databaseVersion = 1;

  // Nombres de las tablas
  static const tbMusculo = 'musculo';
  static const tbEjercicio = 'ejercicio';
  static const tbSerie = 'serie';
  static const tbRutina = 'rutina';
  static const tbUsuario = 'usuario';
  static const tbEjercicioMusculo = 'ejercicio_musculo';
  static const tbDetalleRutina = 'detalle_rutina';

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
    // Inicializa FFI si es necesario
    // sqfliteFfiInit();

    // // Cambia la fábrica de base de datos predeterminada
    // databaseFactory = databaseFactoryFfi;
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

  // Crea las tablas de la base de datos
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tbMusculo (
        id TEXT PRIMARY KEY,
        nombre TEXT NOT NULL UNIQUE,
        imagen_direccion TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE $tbEjercicio (
        id TEXT PRIMARY KEY,
        nombre TEXT NOT NULL UNIQUE,
        descripcion TEXT,
        imagen_direccion TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE $tbSerie (
        id TEXT PRIMARY KEY,
        peso REAL NOT NULL,
        repeticiones INTEGER NOT NULL,
        realizado INTEGER NOT NULL,
        tiempo_descanso INTEGER NOT NULL,
        detalle_rutina_id TEXT NOT NULL,
        FOREIGN KEY (detalle_rutina_id) REFERENCES $tbDetalleRutina (id)
      );
    ''');

    await db.execute('''
      CREATE TABLE $tbRutina (
        id TEXT PRIMARY KEY,
        nombre TEXT NOT NULL UNIQUE,
        descripcion TEXT,
        fecha_creacion TEXT NOT NULL,
        realizado INTEGER NOT NULL,
        color INTEGER NOT NULL,
        fecha_realizacion TEXT,
        estado INTEGER NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE $tbUsuario (
        id TEXT PRIMARY KEY,
        nombre TEXT NOT NULL UNIQUE,
        correo TEXT NOT NULL UNIQUE,
        contrasenia TEXT NOT NULL,
        fecha_nacimiento TEXT,
        estatura REAL,
        peso REAL,
        activo INTEGER
      );
    ''');

    await db.execute('''
      CREATE TABLE $tbEjercicioMusculo (
        ejercicio_id TEXT NOT NULL,
        musculo_id TEXT NOT NULL,
        PRIMARY KEY (ejercicio_id, musculo_id),
        FOREIGN KEY (ejercicio_id) REFERENCES $tbEjercicio (id),
        FOREIGN KEY (musculo_id) REFERENCES $tbMusculo (id)
      );
    ''');

    await db.execute('''
      CREATE TABLE $tbDetalleRutina (
        id TEXT PRIMARY KEY,
        rutina_id TEXT NOT NULL,
        ejercicio_id TEXT NOT NULL,
        FOREIGN KEY (rutina_id) REFERENCES $tbRutina (id),
        FOREIGN KEY (ejercicio_id) REFERENCES $tbEjercicio (id)
      );
    ''');
  }

  // Genera un nuevo UUID
  String generateUUID() {
    return const Uuid().v4();
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