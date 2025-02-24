import 'package:gymaster/core/database/seeders/ejercicio_data_seed.dart';
import 'package:gymaster/core/database/seeders/musculo_data_seed.dart';
import 'package:gymaster/shared/utils/uuid_generator.dart';

class DatabaseSeeder {
  final IdGenerator idGenerator;
  DatabaseSeeder({required this.idGenerator});

  Future<void> seedGenerateDatabase() async {
    await MusculosDataSeed(idGenerator: idGenerator).seedGenerateMusulos();
    await EjercicioDataSeed(idGenerator: idGenerator).seedGenerateEjercicios();
  }
}
