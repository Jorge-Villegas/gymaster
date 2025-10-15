import 'package:gymaster/core/database/database_helper.dart';
import 'package:gymaster/core/database/models/usuario_db.dart';
import 'package:gymaster/features/setting/data/models/perfil_usuario.dart';

abstract class PerfilUsuarioLocalDataSourceInterface {
  Future<PerfilUsuario?> obtenerPerfilPorId(String usuarioId);
  Future<PerfilUsuario> actualizarPerfil(PerfilUsuario perfil);
  Future<void> eliminarPerfil(String usuarioId);
  Future<bool> existePerfil(String usuarioId);
}

class PerfilUsuarioLocalDataSource
    implements PerfilUsuarioLocalDataSourceInterface {
  final DatabaseHelper databaseHelper;

  PerfilUsuarioLocalDataSource({required this.databaseHelper});

  @override
  Future<PerfilUsuario?> obtenerPerfilPorId(String usuarioId) async {
    final db = await databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      UsuarioDb.tabla,
      where: '${UsuarioDb.columnaId} = ?',
      whereArgs: [usuarioId],
    );

    if (maps.isEmpty) return null;

    final dbModel = UsuarioDb.fromJson(maps.first);
    return _dbModelToEntity(dbModel);
  }

  @override
  Future<PerfilUsuario> actualizarPerfil(PerfilUsuario perfil) async {
    final db = await databaseHelper.database;

    // Solo actualizar campos de perfil, manteniendo campos de autenticación
    final camposActualizar = {
      UsuarioDb.columnaNombreUsuario: perfil.nombreUsuario,
      UsuarioDb.columnaCorreo: perfil.correo,
      UsuarioDb.columnaNombreCompleto: perfil.nombreCompleto,
      UsuarioDb.columnaFotoPerfil: perfil.fotoPerfil,
      UsuarioDb.columnaFechaNacimiento:
          perfil.fechaNacimiento?.toIso8601String(),
      UsuarioDb.columnaGenero: perfil.genero,
      UsuarioDb.columnaPesoActualKg: perfil.pesoActualKg,
      UsuarioDb.columnaPesoObjetivoKg: perfil.pesoObjetivoKg,
      UsuarioDb.columnaAlturaCm: perfil.alturaCm,
      UsuarioDb.columnaNivelExperiencia: perfil.nivelExperiencia,
      UsuarioDb.columnaObjetivoFitness: perfil.objetivoFitness,
      UsuarioDb.columnaFechaActualizacionPerfil:
          DateTime.now().toIso8601String(),
    };

    await db.update(
      UsuarioDb.tabla,
      camposActualizar,
      where: '${UsuarioDb.columnaId} = ?',
      whereArgs: [perfil.id],
    );

    return perfil.copyWith(fechaActualizacionPerfil: DateTime.now());
  }

  @override
  Future<void> eliminarPerfil(String usuarioId) async {
    final db = await databaseHelper.database;

    await db.delete(
      UsuarioDb.tabla,
      where: '${UsuarioDb.columnaId} = ?',
      whereArgs: [usuarioId],
    );
  }

  @override
  Future<bool> existePerfil(String usuarioId) async {
    final db = await databaseHelper.database;

    final List<Map<String, dynamic>> result = await db.query(
      UsuarioDb.tabla,
      columns: [UsuarioDb.columnaId],
      where: '${UsuarioDb.columnaId} = ?',
      whereArgs: [usuarioId],
      limit: 1,
    );

    return result.isNotEmpty;
  }

  /// Convierte un modelo de base de datos a entidad de dominio
  PerfilUsuario _dbModelToEntity(UsuarioDb dbModel) {
    return PerfilUsuario(
      id: dbModel.id,
      nombreUsuario: dbModel.nombreUsuario,
      correo: dbModel.correo,
      nombreCompleto: dbModel.nombreCompleto,
      fotoPerfil: dbModel.fotoPerfil,
      fechaNacimiento: dbModel.fechaNacimiento != null
          ? DateTime.parse(dbModel.fechaNacimiento!)
          : null,
      genero: dbModel.genero,
      pesoActualKg: dbModel.pesoActualKg,
      pesoObjetivoKg: dbModel.pesoObjetivoKg,
      alturaCm: dbModel.alturaCm,
      nivelExperiencia: dbModel.nivelExperiencia,
      objetivoFitness: dbModel.objetivoFitness,
      fechaCreacion: DateTime.parse(dbModel.fechaCreacion),
      fechaActualizacionPerfil: dbModel.fechaActualizacionPerfil != null
          ? DateTime.parse(dbModel.fechaActualizacionPerfil!)
          : null,
    );
  }
}
