import 'package:flutter/cupertino.dart';
import 'package:gymaster/core/database/database_helper.dart';
import 'package:gymaster/core/database/models/musculo.dart';
import 'package:gymaster/core/generated/assets.gen.dart';
import 'package:gymaster/shared/utils/logger.dart';

class MusculosDataSeed {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  List<Musculo> musculos = [
    Musculo(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'trapecio',
      imagenDireccion: Assets.imagenes.musculos.general.trapecio.path,
    ),
    Musculo(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'hombro',
      imagenDireccion: Assets.imagenes.musculos.general.hombro.path,
    ),
    Musculo(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'pecho',
      imagenDireccion: Assets.imagenes.musculos.general.pectoral.path,
    ),
    Musculo(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'triceps',
      imagenDireccion: Assets.imagenes.musculos.general.triceps.path,
    ),
    Musculo(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'biceps',
      imagenDireccion: Assets.imagenes.musculos.general.biceps.path,
    ),
    Musculo(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'antebrazo',
      imagenDireccion: Assets.imagenes.musculos.general.antebrazo.path,
    ),
    Musculo(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'abdomen',
      imagenDireccion: Assets.imagenes.musculos.general.abdomen.path,
    ),
    Musculo(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'espalda',
      imagenDireccion: Assets.imagenes.musculos.general.espalda.path,
    ),
    Musculo(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'espalda baja',
      imagenDireccion: Assets.imagenes.musculos.general.espaldaBaja.path,
    ),
    Musculo(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'gluteo',
      imagenDireccion: Assets.imagenes.musculos.general.gluteos.path,
    ),
    Musculo(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'cuadriceps',
      imagenDireccion: Assets.imagenes.musculos.general.cuadriceps.path,
    ),
    Musculo(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'femorales',
      imagenDireccion: Assets.imagenes.musculos.general.femorales.path,
    ),
    Musculo(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'pantorrilla',
      imagenDireccion: Assets.imagenes.musculos.general.pantorrilla.path,
    ),
  ];

  Future<void> seedGenerateMusulos() async {
    try {
      final database = await _databaseHelper.database;
      for (final musculo in musculos) {
        await database.insert(DatabaseHelper.tbMusculo, musculo.toJson());
        debugPrint('musculo guardado: ${musculo.nombre}');
      }
    } catch (e) {
      logger.e(e);
      debugPrint('Error al almacenar los músculos en la base de datos: $e');
      return;
      // throw Exception('Error al almacenar los músculos en la base de datos');
    }
  }
}
