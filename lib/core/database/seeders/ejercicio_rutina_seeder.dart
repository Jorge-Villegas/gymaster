import 'package:faker/faker.dart';
import 'package:gymaster/core/database/database_helper.dart';
import 'package:gymaster/core/database/models/detalle_rutina.dart';
import 'package:gymaster/core/database/models/ejercicio.dart';
import 'package:gymaster/core/database/models/rutina.dart';

Future<void> generateData(DatabaseHelper dbHelper) async {
  final db = await dbHelper.database;
  var faker = Faker();

  // Obtener ejercicios y rutinas existentes
  List<Map<String, dynamic>> ejercicios =
      await db.query(DatabaseHelper.tbEjercicio);
  List<Ejercicio> ejerciciosdb = listaEjerciciosFromMapList(ejercicios);

  List<Map<String, dynamic>> rutinas = await db.query(DatabaseHelper.tbRutina);
  List<Rutina> rutinasdb = listaRutinasFromMapList(rutinas);

  for (var rutina in rutinasdb) {
    int cantidadEjercicios = faker.randomGenerator.integer(12, min: 8);

    // Determinar si la rutina tendrá todos los ejercicios terminados o no terminados
    bool rutinaTerminada = faker.randomGenerator.boolean();

    for (int i = 0; i < cantidadEjercicios; i++) {
      // Contar todos los ejercicios y escoger solo un ejercicio aleatoriamente
      int totalEjercicios = ejercicios.length;
      int index = faker.randomGenerator.integer(totalEjercicios - 1, min: 0);
      var ejercicio = ejerciciosdb[index];

      final detalleRutinaId = faker.guid.guid();

      final ejercicioMusculo = DetalleRutina(
        id: detalleRutinaId,
        rutinaId: rutina.id,
        ejercicioId: ejercicio.id,
      );

      int cantidadSeries = faker.randomGenerator.integer(5, min: 3);

      for (int j = 0; j < cantidadSeries; j++) {
        await db.insert(
          DatabaseHelper.tbSerie,
          {
            'id': faker.guid.guid(),
            'peso': double.parse(
                (faker.randomGenerator.decimal(scale: 50)).toStringAsFixed(2)),
            'repeticiones': faker.randomGenerator.integer(12, min: 1),
            'realizado':
                rutinaTerminada ? 1 : 0, // Todos terminados o no terminados
            'tiempo_descanso': faker.randomGenerator.integer(300, min: 30),
            'detalle_rutina_id': detalleRutinaId,
          },
        );
      }

      await db.insert(
        DatabaseHelper.tbDetalleRutina,
        ejercicioMusculo.toJson(),
      );
    }
  }
}
