import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class DatabaseHelper {
  static const _databaseName = 'gymaster.db';
  static const _databaseVersion = 1;

  // Nombres de las tablas
  static const tableMusculo = 'musculo';
  static const tableEjercicio = 'rjercicio';
  static const tableSerie = 'serie';
  static const tableRutina = 'rutina';
  static const tableUsuario = 'usuario';
  static const tableEjercicioMusculo = 'ejercicioMusculo';

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
      CREATE TABLE $tableMusculo (
        id TEXT PRIMARY KEY,
        nombre TEXT NOT NULL UNIQUE,
        imagenDireccion TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE $tableEjercicio (
        id TEXT PRIMARY KEY,
        nombre TEXT NOT NULL UNIQUE,
        descripcion TEXT,
        imagenDireccion TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE $tableSerie (
        id TEXT PRIMARY KEY,
        peso REAL NOT NULL,
        repeticiones INTEGER NOT NULL,
        realizado INTEGER NOT NULL,
        tiempoDescanso INTEGER NOT NULL,
        rutinaId TEXT NOT NULL,
        ejercicioId TEXT NOT NULL,
        FOREIGN KEY (rutinaId) REFERENCES $tableRutina (id),
        FOREIGN KEY (ejercicioId) REFERENCES $tableEjercicio (id)
      );
    ''');

    await db.execute('''
      CREATE TABLE $tableRutina (
        id TEXT PRIMARY KEY,
        nombre TEXT NOT NULL UNIQUE,
        descripcion TEXT,
        fechaCreacion TEXT NOT NULL,
        realizado INTEGER NOT NULL,
        color INTEGER NOT NULL,
        fechaRealizacion TEXT,
        estado INTEGER NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE $tableUsuario (
        id TEXT PRIMARY KEY,
        nombre TEXT NOT NULL UNIQUE,
        correo TEXT NOT NULL UNIQUE,
        contrasenia TEXT NOT NULL,
        fechaNacimiento TEXT,
        estatura REAL,
        peso REAL,
        activo INTEGER
      );
    ''');

    await db.execute('''
      CREATE TABLE $tableEjercicioMusculo (
        ejercicioId TEXT NOT NULL,
        musculoId TEXT NOT NULL,
        PRIMARY KEY (ejercicioId, musculoId),
        FOREIGN KEY (ejercicioId) REFERENCES $tableEjercicio (id),
        FOREIGN KEY (musculoId) REFERENCES $tableMusculo (id)
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
