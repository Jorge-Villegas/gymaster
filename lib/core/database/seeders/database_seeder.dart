import 'package:gymaster/core/database/database_helper.dart';
import 'package:gymaster/core/database/seeders/ejercicio_data_seed.dart';
import 'package:gymaster/core/database/seeders/musculo_data_seed.dart';
import 'package:gymaster/shared/utils/uuid_generator.dart';

class DatabaseSeeder {
  final IdGenerator idGenerator;
  DatabaseSeeder({required this.idGenerator});

  Future<void> seedGenerateDatabase() async {
    final db = await DatabaseHelper.instance.database;

    // Verificar si ya existen datos en las tablas principales
    final muscles = await db.query(DatabaseHelper.tbMuscle);
    final exercises = await db.query(DatabaseHelper.tbExercise);

    // Solo ejecutar el seeding si no hay datos
    if (muscles.isEmpty && exercises.isEmpty) {
      await MusculosDataSeed(idGenerator: idGenerator).seedGenerateMusulos();
      await EjercicioDataSeed(
        idGenerator: idGenerator,
      ).seedGenerateEjercicios();
    }
  }
}
