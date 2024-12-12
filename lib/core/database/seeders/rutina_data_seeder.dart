import 'package:faker/faker.dart';
import 'package:gymaster/core/database/database_helper.dart';
import 'package:gymaster/core/database/models/rutina.dart';

Future<List<Rutina>> generateFakeRutinas(DatabaseHelper dbHelper) async {
  final db = await dbHelper.database;
  var faker = Faker();
  List<Rutina> rutinas = [];
  List<String> nombresRutinas = [
    'Rutina de Fuerza', 'Rutina de Cardio', 'Rutina de Resistencia', 'Rutina de Flexibilidad',
    'Rutina de HIIT', 'Rutina de Yoga', 'Rutina de Pilates', 'Rutina de CrossFit',
    'Rutina de Ciclismo', 'Rutina de Natación', 'Rutina de Boxeo', 'Rutina de Kickboxing',
    'Rutina de Artes Marciales', 'Rutina de Calistenia', 'Rutina de Gimnasia', 'Rutina de Atletismo',
    'Rutina de Escalada', 'Rutina de Senderismo', 'Rutina de Esquí', 'Rutina de Snowboard',
    'Rutina de Surf', 'Rutina de Remo', 'Rutina de Triatlón', 'Rutina de Maratón',
    'Rutina de Media Maratón', 'Rutina de Sprint', 'Rutina de Velocidad', 'Rutina de Potencia',
    'Rutina de Agilidad', 'Rutina de Equilibrio', 'Rutina de Coordinación', 'Rutina de Movilidad',
    'Rutina de Recuperación', 'Rutina de Rehabilitación', 'Rutina de Prevención de Lesiones',
    'Rutina de Pérdida de Peso', 'Rutina de Ganancia de Masa', 'Rutina de Definición', 'Rutina de Tono Muscular',
    'Rutina de Endurance', 'Rutina de Core', 'Rutina de Glúteos'
  ];
  List<int> colores = [
    0xFFF48FB1, 0xFFB39DDB, 0xFF90CAF9, 0xFF80DEEA, 0xFFA5D6A7,
    0xFFE6EE9C, 0xFFFFE082, 0xFFFFAB91, 0xFFB0BEC5, 0xFFBCAAA4,
    0xFFFFCC80, 0xFFFFF59D, 0xFFC5E1A5, 0xFF80CBC4, 0xFF81D4FA,
    0xFFEF9A9A, 0xFF9FA8DA, 0xFFCE93D8, 0xFFD1C4E9, 0xFFBBDEFB,
    0xFFB2EBF2, 0xFFAED581, 0xFFFFF176, 0xFFFF8A65, 0xFFCFD8DC,
    0xFFD7CCC8, 0xFFFFE0B2, 0xFFFFF9C4, 0xFFE6EE9C, 0xFFDCEDC8,
    0xFFB3E5FC, 0xFFB2DFDB, 0xFFB3E5FC, 0xFFFFCDD2, 0xFFC5CAE9,
    0xFFE1BEE7, 0xFFD7CCC8, 0xFFB0BEC5, 0xFFBCAAA4, 0xFFFFCC80,
    0xFFFFF59D, 0xFFC5E1A5, 0xFF80CBC4, 0xFF81D4FA, 0xFFEF9A9A,
    0xFF9FA8DA, 0xFFCE93D8, 0xFFD1C4E9, 0xFFBBDEFB, 0xFFB2EBF2
  ];

  for (int i = 0; i < nombresRutinas.length; i++) {
    DateTime fechaCreacion = faker.date.dateTime();
    DateTime fechaRealizacion = fechaCreacion
        .add(Duration(days: faker.randomGenerator.integer(30, min: 1)));

    await db.insert(
        DatabaseHelper.tbRutina,
        Rutina(
          id: faker.guid.guid(),
          nombre: nombresRutinas[i],
          descripcion: faker.lorem.sentence(),
          fechaCreacion: fechaCreacion.toIso8601String(),
          realizado: faker.randomGenerator.integer(2), // 0 o 1
          color: colores[i],
          fechaRealizacion: fechaRealizacion.toIso8601String(),
          estado: faker.randomGenerator.integer(2), // 0 o 1
        ).toJson());
  }

  return rutinas;
}
