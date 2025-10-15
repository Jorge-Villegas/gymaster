import 'package:gymaster/core/database/database_helper.dart';
import 'package:gymaster/features/setting/data/models/perfil_usuario_completo_db_model.dart';
import 'package:gymaster/features/setting/domain/entities/perfil_usuario_completo.dart';
import 'package:gymaster/shared/utils/uuid_generator.dart';
import 'package:sqflite/sqflite.dart';

abstract class PerfilUsuarioCompletoLocalDataSource {
  Future<PerfilUsuarioCompleto> crearPerfilCompleto({
    required String nombreUsuario,
    String? correo,
    required String fotoPerfil,
    required String nombreCompleto,
    DateTime? fechaNacimiento,
    required Genero genero,
    required ObjetivoFitness objetivoFitness,
    required NivelExperiencia nivelExperiencia,
    int? alturaCm,
    double? pesoActualKg,
    double? pesoObjetivoKg,
  });

  Future<PerfilUsuarioCompleto?> obtenerPerfilCompleto();
  Future<bool> existePerfilCompleto();
  Future<PerfilUsuarioCompleto> actualizarPerfilCompleto(
      PerfilUsuarioCompleto perfil);
  Future<bool> eliminarPerfilCompleto();
}

class PerfilUsuarioCompletoLocalDataSourceImpl
    implements PerfilUsuarioCompletoLocalDataSource {
  final DatabaseHelper databaseHelper;
  final IdGenerator idGenerator;

  PerfilUsuarioCompletoLocalDataSourceImpl({
    required this.databaseHelper,
    required this.idGenerator,
  });

  @override
  Future<PerfilUsuarioCompleto> crearPerfilCompleto({
    required String nombreUsuario,
    String? correo,
    required String fotoPerfil,
    required String nombreCompleto,
    DateTime? fechaNacimiento,
    required Genero genero,
    required ObjetivoFitness objetivoFitness,
    required NivelExperiencia nivelExperiencia,
    int? alturaCm,
    double? pesoActualKg,
    double? pesoObjetivoKg,
  }) async {
    final db = await databaseHelper.database;

    final perfil = PerfilUsuarioCompleto(
      id: idGenerator.generateId(),
      nombreUsuario: nombreUsuario,
      correo: correo,
      fotoPerfil: fotoPerfil,
      nombreCompleto: nombreCompleto,
      fechaNacimiento: fechaNacimiento,
      genero: genero,
      objetivoFitness: objetivoFitness,
      nivelExperiencia: nivelExperiencia,
      alturaCm: alturaCm,
      pesoActualKg: pesoActualKg,
      pesoObjetivoKg: pesoObjetivoKg,
      fechaCreacion: DateTime.now(),
    );

    final dbModel = PerfilUsuarioCompletoDbModel.fromEntity(perfil);

    await db.insert(
      PerfilUsuarioCompletoDbModel.table,
      dbModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return perfil;
  }

  @override
  Future<PerfilUsuarioCompleto?> obtenerPerfilCompleto() async {
    final db = await databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      PerfilUsuarioCompletoDbModel.table,
      limit: 1, // Solo debería haber un perfil
    );

    if (maps.isEmpty) return null;

    final dbModel = PerfilUsuarioCompletoDbModel.fromMap(maps.first);
    return dbModel.toEntity();
  }

  @override
  Future<bool> existePerfilCompleto() async {
    final db = await databaseHelper.database;

    final List<Map<String, dynamic>> result = await db.query(
      PerfilUsuarioCompletoDbModel.table,
      columns: [PerfilUsuarioCompletoDbModel.columnId],
      limit: 1,
    );

    return result.isNotEmpty;
  }

  @override
  Future<PerfilUsuarioCompleto> actualizarPerfilCompleto(
    PerfilUsuarioCompleto perfil,
  ) async {
    final db = await databaseHelper.database;

    final perfilActualizado = perfil.copyWith(
      fechaActualizacion: DateTime.now(),
    );

    final dbModel = PerfilUsuarioCompletoDbModel.fromEntity(perfilActualizado);

    await db.update(
      PerfilUsuarioCompletoDbModel.table,
      dbModel.toMap(),
      where: '${PerfilUsuarioCompletoDbModel.columnId} = ?',
      whereArgs: [perfil.id],
    );

    return perfilActualizado;
  }

  @override
  Future<bool> eliminarPerfilCompleto() async {
    final db = await databaseHelper.database;

    final rowsDeleted = await db.delete(
      PerfilUsuarioCompletoDbModel.table,
    );

    return rowsDeleted > 0;
  }
}
