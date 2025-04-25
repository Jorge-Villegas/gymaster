import 'package:gymaster/shared/utils/uuid_generator.dart';

import '../database_helper.dart';
import '../models/excercise_muscle_db_model.dart';
import '../models/exercise_db_model.dart';
import 'ejercicio_data_seed.dart';
import 'musculo_data_seed.dart';

class DatabaseSeeder {
  final IdGenerator idGenerator;
  DatabaseSeeder({required this.idGenerator});

  Future<void> seedGenerateDatabase() async {
    final db = await DatabaseHelper.instance.database;

    // Verificar si ya existen datos en las tablas principales
    final muscles = await db.query(ExerciseMuscleDbModel.table);
    final exercises = await db.query(ExerciseDbModel.table);

    // Solo ejecutar el seeding si no hay datos
    if (muscles.isEmpty) {
      await MusculosDataSeed(idGenerator: idGenerator).seedGenerateMusulos();
    }

    if (exercises.isEmpty) {
      await EjercicioDataSeed(
        idGenerator: idGenerator,
      ).seedGenerateEjercicios();
    }
  }
}
