import 'package:gymaster/core/database/database_helper.dart';
import 'package:gymaster/core/database/models/configuracion_usuario_db_model.dart';
import 'package:gymaster/features/setting/data/models/configuracion_usuario.dart';
import 'package:sqflite/sqflite.dart';

abstract class ConfiguracionUsuarioLocalDataSourceInterface {
  Future<ConfiguracionUsuario?> obtenerConfiguracionPorUsuarioId(
      String usuarioId);
  Future<ConfiguracionUsuario> crearConfiguracion(
      ConfiguracionUsuario configuracion);
  Future<ConfiguracionUsuario> actualizarConfiguracion(
      ConfiguracionUsuario configuracion);
  Future<void> eliminarConfiguracion(String usuarioId);
  Future<bool> existeConfiguracion(String usuarioId);
}

class ConfiguracionUsuarioLocalDataSource
    implements ConfiguracionUsuarioLocalDataSourceInterface {
  final DatabaseHelper databaseHelper;

  ConfiguracionUsuarioLocalDataSource({required this.databaseHelper});

  @override
  Future<ConfiguracionUsuario?> obtenerConfiguracionPorUsuarioId(
      String usuarioId) async {
    final db = await databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      ConfiguracionUsuarioDbModel.tabla,
      where: '${ConfiguracionUsuarioDbModel.columnaUsuarioId} = ?',
      whereArgs: [usuarioId],
    );

    if (maps.isEmpty) return null;

    final dbModel = ConfiguracionUsuarioDbModel.fromJson(maps.first);
    return _dbModelToEntity(dbModel);
  }

  @override
  Future<ConfiguracionUsuario> crearConfiguracion(
      ConfiguracionUsuario configuracion) async {
    final db = await databaseHelper.database;

    final dbModel = _entityToDbModel(configuracion);

    await db.insert(
      ConfiguracionUsuarioDbModel.tabla,
      dbModel.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return configuracion;
  }

  @override
  Future<ConfiguracionUsuario> actualizarConfiguracion(
      ConfiguracionUsuario configuracion) async {
    final db = await databaseHelper.database;

    final dbModel = _entityToDbModel(configuracion);
    final configuracionActualizada = configuracion.copyWith(
      fechaActualizacion: DateTime.now(),
    );

    final dbModelActualizado = _entityToDbModel(configuracionActualizada);

    await db.update(
      ConfiguracionUsuarioDbModel.tabla,
      dbModelActualizado.toJson(),
      where: '${ConfiguracionUsuarioDbModel.columnaUsuarioId} = ?',
      whereArgs: [configuracion.usuarioId],
    );

    return configuracionActualizada;
  }

  @override
  Future<void> eliminarConfiguracion(String usuarioId) async {
    final db = await databaseHelper.database;

    await db.delete(
      ConfiguracionUsuarioDbModel.tabla,
      where: '${ConfiguracionUsuarioDbModel.columnaUsuarioId} = ?',
      whereArgs: [usuarioId],
    );
  }

  @override
  Future<bool> existeConfiguracion(String usuarioId) async {
    final db = await databaseHelper.database;

    final List<Map<String, dynamic>> result = await db.query(
      ConfiguracionUsuarioDbModel.tabla,
      columns: [ConfiguracionUsuarioDbModel.columnaId],
      where: '${ConfiguracionUsuarioDbModel.columnaUsuarioId} = ?',
      whereArgs: [usuarioId],
      limit: 1,
    );

    return result.isNotEmpty;
  }

  /// Convierte un modelo de base de datos a entidad de dominio
  ConfiguracionUsuario _dbModelToEntity(ConfiguracionUsuarioDbModel dbModel) {
    return ConfiguracionUsuario(
      id: dbModel.id,
      usuarioId: dbModel.usuarioId,
      unidadPeso: dbModel.unidadPeso,
      unidadLongitud: dbModel.unidadLongitud,
      formatoHora: dbModel.formatoHora,
      formatoFecha: dbModel.formatoFecha,
      diaInicioSemana: dbModel.diaInicioSemana,
      unidadCalorias: dbModel.unidadCalorias,
      tiempoDescansoDefecto: dbModel.tiempoDescansoDefecto,
      sonidosHabilitados: dbModel.sonidosHabilitados == 1,
      vibracionHabilitada: dbModel.vibracionHabilitada == 1,
      volumenSonidos: dbModel.volumenSonidos,
      intensidadVibracion: dbModel.intensidadVibracion,
      autoSiguienteEjercicio: dbModel.autoSiguienteEjercicio == 1,
      notificacionesHabilitadas: dbModel.notificacionesHabilitadas == 1,
      recordatorioEntrenar: dbModel.recordatorioEntrenar == 1,
      recordatorioRacha: dbModel.recordatorioRacha == 1,
      recordatorioDescanso: dbModel.recordatorioDescanso == 1,
      horaRecordatorioManana: dbModel.horaRecordatorioManana,
      horaRecordatorioTarde: dbModel.horaRecordatorioTarde,
      modoOscuro: dbModel.modoOscuro == 1,
      idioma: dbModel.idioma,
      fechaCreacion: DateTime.parse(dbModel.fechaCreacion),
      fechaActualizacion: dbModel.fechaActualizacion != null
          ? DateTime.parse(dbModel.fechaActualizacion!)
          : null,
    );
  }

  /// Convierte una entidad de dominio a modelo de base de datos
  ConfiguracionUsuarioDbModel _entityToDbModel(ConfiguracionUsuario entity) {
    return ConfiguracionUsuarioDbModel(
      id: entity.id ?? _generarId(),
      usuarioId: entity.usuarioId,
      unidadPeso: entity.unidadPeso,
      unidadLongitud: entity.unidadLongitud,
      formatoHora: entity.formatoHora,
      formatoFecha: entity.formatoFecha,
      diaInicioSemana: entity.diaInicioSemana,
      unidadCalorias: entity.unidadCalorias,
      tiempoDescansoDefecto: entity.tiempoDescansoDefecto,
      sonidosHabilitados: entity.sonidosHabilitados ? 1 : 0,
      vibracionHabilitada: entity.vibracionHabilitada ? 1 : 0,
      volumenSonidos: entity.volumenSonidos,
      intensidadVibracion: entity.intensidadVibracion,
      autoSiguienteEjercicio: entity.autoSiguienteEjercicio ? 1 : 0,
      notificacionesHabilitadas: entity.notificacionesHabilitadas ? 1 : 0,
      recordatorioEntrenar: entity.recordatorioEntrenar ? 1 : 0,
      recordatorioRacha: entity.recordatorioRacha ? 1 : 0,
      recordatorioDescanso: entity.recordatorioDescanso ? 1 : 0,
      horaRecordatorioManana: entity.horaRecordatorioManana,
      horaRecordatorioTarde: entity.horaRecordatorioTarde,
      modoOscuro: entity.modoOscuro ? 1 : 0,
      idioma: entity.idioma,
      fechaCreacion: entity.fechaCreacion.toIso8601String(),
      fechaActualizacion: entity.fechaActualizacion?.toIso8601String(),
    );
  }

  /// Genera un ID único para la configuración
  String _generarId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
