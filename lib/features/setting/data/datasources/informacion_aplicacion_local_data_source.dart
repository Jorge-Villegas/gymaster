import 'package:gymaster/core/database/database_helper.dart';
import 'package:gymaster/core/database/models/informacion_aplicacion_db_model.dart';
import 'package:gymaster/features/setting/data/models/informacion_aplicacion.dart';
import 'package:sqflite/sqflite.dart';

abstract class InformacionAplicacionLocalDataSourceInterface {
  Future<InformacionAplicacion> obtenerInformacionAplicacion();
  Future<InformacionAplicacion> actualizarInformacionAplicacion(
      InformacionAplicacion informacion);
  Future<void> incrementarContadorInicioApp();
  Future<void> incrementarContadorRutinasCompletadas();
  Future<void> incrementarContadorEjerciciosRealizados();
  Future<void> actualizarRachaActual(int nuevaRacha);
  Future<void> reiniciarDatos();
}

class InformacionAplicacionLocalDataSource
    implements InformacionAplicacionLocalDataSourceInterface {
  final DatabaseHelper databaseHelper;

  InformacionAplicacionLocalDataSource({required this.databaseHelper});

  @override
  Future<InformacionAplicacion> obtenerInformacionAplicacion() async {
    final db = await databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      InformacionAplicacionDbModel.tabla,
      limit: 1,
    );

    if (maps.isEmpty) {
      // Si no existe, crear un registro inicial
      return await _crearRegistroInicial();
    }

    final dbModel = InformacionAplicacionDbModel.fromJson(maps.first);
    return _dbModelToEntity(dbModel);
  }

  @override
  Future<InformacionAplicacion> actualizarInformacionAplicacion(
      InformacionAplicacion informacion) async {
    final db = await databaseHelper.database;

    final dbModel = _entityToDbModel(informacion);

    await db.update(
      InformacionAplicacionDbModel.tabla,
      dbModel.toJson(),
      where: '${InformacionAplicacionDbModel.columnaId} = ?',
      whereArgs: [dbModel.id],
    );

    return informacion;
  }

  @override
  Future<void> incrementarContadorInicioApp() async {
    final informacion = await obtenerInformacionAplicacion();
    final informacionActualizada = informacion.copyWith(
      numeroIniciosSesion: informacion.numeroIniciosSesion + 1,
      fechaUltimoInicio: DateTime.now(),
    );
    await actualizarInformacionAplicacion(informacionActualizada);
  }

  @override
  Future<void> incrementarContadorRutinasCompletadas() async {
    final informacion = await obtenerInformacionAplicacion();
    final informacionActualizada = informacion.copyWith(
      totalRutinasCompletadas: informacion.totalRutinasCompletadas + 1,
    );
    await actualizarInformacionAplicacion(informacionActualizada);
  }

  @override
  Future<void> incrementarContadorEjerciciosRealizados() async {
    final informacion = await obtenerInformacionAplicacion();
    final informacionActualizada = informacion.copyWith(
      totalEjerciciosRealizados: informacion.totalEjerciciosRealizados + 1,
    );
    await actualizarInformacionAplicacion(informacionActualizada);
  }

  @override
  Future<void> actualizarRachaActual(int nuevaRacha) async {
    final informacion = await obtenerInformacionAplicacion();
    final mejorRacha = nuevaRacha > informacion.rachaMaxima
        ? nuevaRacha
        : informacion.rachaMaxima;

    final informacionActualizada = informacion.copyWith(
      rachaActual: nuevaRacha,
      rachaMaxima: mejorRacha,
    );
    await actualizarInformacionAplicacion(informacionActualizada);
  }

  @override
  Future<void> reiniciarDatos() async {
    final db = await databaseHelper.database;

    await db.delete(InformacionAplicacionDbModel.tabla);
    await _crearRegistroInicial();
  }

  /// Crea un registro inicial de información de la aplicación
  Future<InformacionAplicacion> _crearRegistroInicial() async {
    final db = await databaseHelper.database;

    final informacionInicial = InformacionAplicacion(
      id: _generarId(),
      versionApp: '1.0.0', // Obtener de package info en producción
      fechaInstalacion: DateTime.now(),
      fechaCreacion: DateTime.now(),
      numeroIniciosSesion: 1,
      fechaUltimoInicio: DateTime.now(),
      totalRutinasCompletadas: 0,
      totalEjerciciosRealizados: 0,
      tiempoTotalEntrenamiento: 0,
      rachaActual: 0,
      rachaMaxima: 0,
    );

    final dbModel = _entityToDbModel(informacionInicial);

    await db.insert(
      InformacionAplicacionDbModel.tabla,
      dbModel.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return informacionInicial;
  }

  /// Convierte un modelo de base de datos a entidad de dominio
  InformacionAplicacion _dbModelToEntity(InformacionAplicacionDbModel dbModel) {
    return InformacionAplicacion(
      id: dbModel.id,
      versionApp: dbModel.versionApp,
      fechaInstalacion: DateTime.parse(dbModel.fechaInstalacion),
      fechaUltimaActualizacion: dbModel.fechaUltimaActualizacion != null
          ? DateTime.parse(dbModel.fechaUltimaActualizacion!)
          : null,
      numeroIniciosSesion: dbModel.numeroIniciosSesion,
      fechaUltimoInicio: dbModel.fechaUltimoInicio != null
          ? DateTime.parse(dbModel.fechaUltimoInicio!)
          : null,
      rachaActual: dbModel.rachaActual,
      rachaMaxima: dbModel.rachaMaxima,
      totalRutinasCompletadas: dbModel.totalRutinasCompletadas,
      totalEjerciciosRealizados: dbModel.totalEjerciciosRealizados,
      tiempoTotalEntrenamiento: dbModel.tiempoTotalEntrenamiento,
      fechaCreacion: DateTime.parse(dbModel.fechaCreacion),
    );
  }

  /// Convierte una entidad de dominio a modelo de base de datos
  InformacionAplicacionDbModel _entityToDbModel(InformacionAplicacion entity) {
    return InformacionAplicacionDbModel(
      id: entity.id ?? _generarId(),
      versionApp: entity.versionApp,
      fechaInstalacion: entity.fechaInstalacion.toIso8601String(),
      fechaUltimaActualizacion:
          entity.fechaUltimaActualizacion?.toIso8601String(),
      numeroIniciosSesion: entity.numeroIniciosSesion,
      fechaUltimoInicio: entity.fechaUltimoInicio?.toIso8601String(),
      rachaActual: entity.rachaActual,
      rachaMaxima: entity.rachaMaxima,
      totalRutinasCompletadas: entity.totalRutinasCompletadas,
      totalEjerciciosRealizados: entity.totalEjerciciosRealizados,
      tiempoTotalEntrenamiento: entity.tiempoTotalEntrenamiento,
      fechaCreacion: entity.fechaCreacion.toIso8601String(),
    );
  }

  /// Genera un ID único para la información de la aplicación
  String _generarId() {
    return 'app_info_${DateTime.now().millisecondsSinceEpoch}';
  }
}
