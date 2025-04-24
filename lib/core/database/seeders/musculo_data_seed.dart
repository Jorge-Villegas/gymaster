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
      List<MuscleDbModel> musculos = [
        MuscleDbModel(
          id: idGenerator.generateId(),
          name: 'trapecio',
          imagePath: Assets.imagenes.musculos.general.trapecio.path,
          createdAt: DateTime.now().toIso8601String(),
        ),
        MuscleDbModel(
          id: idGenerator.generateId(),
          name: 'hombro',
          imagePath: Assets.imagenes.musculos.general.hombro.path,
          createdAt: DateTime.now().toIso8601String(),
        ),
        MuscleDbModel(
          id: idGenerator.generateId(),
          name: 'pecho',
          imagePath: Assets.imagenes.musculos.general.pectoral.path,
          createdAt: DateTime.now().toIso8601String(),
        ),
        MuscleDbModel(
          id: idGenerator.generateId(),
          name: 'triceps',
          imagePath: Assets.imagenes.musculos.general.triceps.path,
          createdAt: DateTime.now().toIso8601String(),
        ),
        MuscleDbModel(
          id: idGenerator.generateId(),
          name: 'biceps',
          imagePath: Assets.imagenes.musculos.general.biceps.path,
          createdAt: DateTime.now().toIso8601String(),
        ),
        MuscleDbModel(
          id: idGenerator.generateId(),
          name: 'antebrazo',
          imagePath: Assets.imagenes.musculos.general.antebrazo.path,
          createdAt: DateTime.now().toIso8601String(),
        ),
        MuscleDbModel(
          id: idGenerator.generateId(),
          name: 'abdomen',
          imagePath: Assets.imagenes.musculos.general.abdomen.path,
          createdAt: DateTime.now().toIso8601String(),
        ),
        MuscleDbModel(
          id: idGenerator.generateId(),
          name: 'espalda',
          imagePath: Assets.imagenes.musculos.general.espalda.path,
          createdAt: DateTime.now().toIso8601String(),
        ),
        MuscleDbModel(
          id: idGenerator.generateId(),
          name: 'espalda baja',
          imagePath: Assets.imagenes.musculos.general.espaldaBaja.path,
          createdAt: DateTime.now().toIso8601String(),
        ),
        MuscleDbModel(
          id: idGenerator.generateId(),
          name: 'gluteo',
          imagePath: Assets.imagenes.musculos.general.gluteos.path,
          createdAt: DateTime.now().toIso8601String(),
        ),
        MuscleDbModel(
          id: idGenerator.generateId(),
          name: 'cuadriceps',
          imagePath: Assets.imagenes.musculos.general.cuadriceps.path,
          createdAt: DateTime.now().toIso8601String(),
        ),
        MuscleDbModel(
          id: idGenerator.generateId(),
          name: 'femorales',
          imagePath: Assets.imagenes.musculos.general.femorales.path,
          createdAt: DateTime.now().toIso8601String(),
        ),
        MuscleDbModel(
          id: idGenerator.generateId(),
          name: 'pantorrilla',
          imagePath: Assets.imagenes.musculos.general.pantorrilla.path,
          createdAt: DateTime.now().toIso8601String(),
        ),
      ];

      final database = await _databaseHelper.database;
      for (final musculo in musculos) {
        final existingMuscles = await database.query(
          MuscleDbModel.table,
          where: 'name = ?',
          whereArgs: [musculo.name],
        );

        if (existingMuscles.isEmpty) {
          await database.insert(MuscleDbModel.table, musculo.toJson());
          debugPrint('musculo guardado: ${musculo.name}');
        } else {
          debugPrint('musculo ya existe: ${musculo.name}');
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
