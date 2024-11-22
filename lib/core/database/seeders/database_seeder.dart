import 'package:gymaster/core/database/seeders/ejercicio_data_seed.dart';
import 'package:gymaster/core/database/seeders/musculo_data_seed.dart';

class DatabaseSeeder {
  Future<void> seedGenerateDatabase() async {
    await MusculosDataSeed().seedGenerateMusulos();
    await EjercicioDataSeed().seedGenerateEjercicios();
  }
}
