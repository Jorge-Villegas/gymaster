import 'package:flutter/cupertino.dart';
import 'package:gymaster/core/database/database_helper.dart';
import 'package:gymaster/core/database/models/models.dart';
import 'package:gymaster/core/generated/assets.gen.dart';
import 'package:gymaster/shared/utils/logger.dart';
import 'package:gymaster/shared/utils/uuid_generator.dart';

class MusculosDataSeed {
  final IdGenerator idGenerator;

  MusculosDataSeed({required this.idGenerator});

  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<void> seedGenerateMusulos() async {
    try {
      List<MusculoDbModel> musculos = [
        MusculoDbModel(
          id: idGenerator.generateId(),
          nombre: 'trapecio',
          rutaImagen: Assets.imagenes.musculos.general.trapecio.path,
          fechaCreacion: DateTime.now().toIso8601String(),
        ),
        MusculoDbModel(
          id: idGenerator.generateId(),
          nombre: 'hombro',
          rutaImagen: Assets.imagenes.musculos.general.hombro.path,
          fechaCreacion: DateTime.now().toIso8601String(),
        ),
        MusculoDbModel(
          id: idGenerator.generateId(),
          nombre: 'pecho',
          rutaImagen: Assets.imagenes.musculos.general.pectoral.path,
          fechaCreacion: DateTime.now().toIso8601String(),
        ),
        MusculoDbModel(
          id: idGenerator.generateId(),
          nombre: 'triceps',
          rutaImagen: Assets.imagenes.musculos.general.triceps.path,
          fechaCreacion: DateTime.now().toIso8601String(),
        ),
        MusculoDbModel(
          id: idGenerator.generateId(),
          nombre: 'biceps',
          rutaImagen: Assets.imagenes.musculos.general.biceps.path,
          fechaCreacion: DateTime.now().toIso8601String(),
        ),
        MusculoDbModel(
          id: idGenerator.generateId(),
          nombre: 'antebrazo',
          rutaImagen: Assets.imagenes.musculos.general.antebrazo.path,
          fechaCreacion: DateTime.now().toIso8601String(),
        ),
        MusculoDbModel(
          id: idGenerator.generateId(),
          nombre: 'abdomen',
          rutaImagen: Assets.imagenes.musculos.general.abdomen.path,
          fechaCreacion: DateTime.now().toIso8601String(),
        ),
        MusculoDbModel(
          id: idGenerator.generateId(),
          nombre: 'espalda',
          rutaImagen: Assets.imagenes.musculos.general.espalda.path,
          fechaCreacion: DateTime.now().toIso8601String(),
        ),
        MusculoDbModel(
          id: idGenerator.generateId(),
          nombre: 'espalda baja',
          rutaImagen: Assets.imagenes.musculos.general.espaldaBaja.path,
          fechaCreacion: DateTime.now().toIso8601String(),
        ),
        MusculoDbModel(
          id: idGenerator.generateId(),
          nombre: 'gluteo',
          rutaImagen: Assets.imagenes.musculos.general.gluteos.path,
          fechaCreacion: DateTime.now().toIso8601String(),
        ),
        MusculoDbModel(
          id: idGenerator.generateId(),
          nombre: 'cuadriceps',
          rutaImagen: Assets.imagenes.musculos.general.cuadriceps.path,
          fechaCreacion: DateTime.now().toIso8601String(),
        ),
        MusculoDbModel(
          id: idGenerator.generateId(),
          nombre: 'femorales',
          rutaImagen: Assets.imagenes.musculos.general.femorales.path,
          fechaCreacion: DateTime.now().toIso8601String(),
        ),
        MusculoDbModel(
          id: idGenerator.generateId(),
          nombre: 'pantorrilla',
          rutaImagen: Assets.imagenes.musculos.general.pantorrilla.path,
          fechaCreacion: DateTime.now().toIso8601String(),
        ),
      ];

      final database = await _databaseHelper.database;
      for (final musculo in musculos) {
        final existingMuscles = await database.query(
          MusculoDbModel.tabla,
          where: 'name = ?',
          whereArgs: [musculo.nombre],
        );

        if (existingMuscles.isEmpty) {
          await database.insert(MusculoDbModel.tabla, musculo.toJson());
          debugPrint('musculo guardado: ${musculo.nombre}');
        } else {
          debugPrint('musculo ya existe: ${musculo.nombre}');
        }
      }
    } catch (e) {
      logger.e(e);
      debugPrint('Error al almacenar los músculos en la base de datos: $e');
      return;
      // throw Exception('Error al almacenar los músculos en la base de datos');
    }
  }
}
