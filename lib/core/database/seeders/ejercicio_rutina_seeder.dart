import 'dart:math';
import 'package:gymaster/core/database/database_helper.dart';
import 'package:gymaster/core/database/models/models.dart';
import 'package:gymaster/core/database/models/rutina_sesion_db.dart';
import 'package:gymaster/shared/utils/enum.dart';
import 'package:gymaster/shared/utils/uuid_generator.dart';

import '../models/sesion_ejercicio_db.dart';

class EjercicioRutinaSeeder {
  final IdGenerator idGenerator;
  EjercicioRutinaSeeder({required this.idGenerator});

  // Future<void> addExercisesToExistingRoutines() async {
  Future<void> generateData() async {
    final db = await DatabaseHelper.instance.database;
    final random = Random();

    // Obtener todas las rutinas existentes
    final List<Map<String, dynamic>> routines = await db.query('routine');
    if (routines.isEmpty) {
      print("⚠️ No hay rutinas en la base de datos.");
      return;
    }

    // Obtener todos los ejercicios existentes
    final List<Map<String, dynamic>> exercises = await db.query('exercise');
    if (exercises.isEmpty) {
      print("⚠️ No hay ejercicios en la base de datos.");
      return;
    }

    for (var routine in routines) {
      String routineId = routine['id'];

      // Crear una nueva sesión para la rutina
      String sessionId = idGenerator.generateId();
      String status = random.nextBool()
          ? EstadoSesionRutina.completado.name
          : EstadoSesionRutina.pendiente.name;
      await db.insert(RutinaSesionDb.tabla, {
        RutinaSesionDb.columnaId: sessionId,
        RutinaSesionDb.columnaRutinaId: routineId,
        RutinaSesionDb.columnaHoraInicio: DateTime.now()
            .subtract(Duration(days: random.nextInt(30)))
            .toIso8601String(),
        RutinaSesionDb.columnaHoraFin:
            status == 'completado' ? DateTime.now().toIso8601String() : null,
        RutinaSesionDb.columnaEstado: status,
        RutinaSesionDb.columnaFechaCreacion: DateTime.now().toIso8601String(),
      });

      // Seleccionar entre 5 a 10 ejercicios aleatorios
      exercises.shuffle();
      int numExercises = (5 + random.nextInt(6));
      List<Map<String, dynamic>> selectedExercises =
          exercises.take(numExercises).toList();

      for (var exercise in selectedExercises) {
        String exerciseId = exercise['id'];

        // Crear un nuevo registro en session_exercise
        String sessionExerciseId = idGenerator.generateId();
        String exerciseStatus =
            status == '${EstadoEjercicio.completado.name}' ? '${EstadoEjercicio.completado.name}' : '${EstadoEjercicio.pendiente.name}';
        await db.insert('${SessionEjercicioDb.tabla}', {
          '${SessionEjercicioDb.columnId}': sessionExerciseId,
          '${SessionEjercicioDb.columnSessionId}': sessionId,
          '${SessionEjercicioDb.columnExerciseId}': exerciseId,
          '${SessionEjercicioDb.columnStatus}': exerciseStatus,
        });

        // Crear sets para el ejercicio
        int numSets = (3 + random.nextInt(3)); // Entre 3 y 5 sets
        for (int i = 0; i < numSets; i++) {
          await db.insert(SerieEjercicioDb.tabla, {
            SerieEjercicioDb.columnaId: idGenerator.generateId(),
            SerieEjercicioDb.columnaEjercicioSesionId: sessionExerciseId,
            SerieEjercicioDb.columnaPeso: 40 + random.nextInt(61), // Peso entre 40 y 100 kg
            SerieEjercicioDb.columnaRepeticiones: 6 + random.nextInt(9), // Repeticiones entre 6 y 14
            SerieEjercicioDb.columnaTiempoDescanso:
                30 + random.nextInt(31), // Descanso entre 30 y 60 segundos
            SerieEjercicioDb.columnaEstado:
                exerciseStatus == EstadoEjercicio.completado.name ? EstadoEjercicio.completado.name : EstadoEjercicio.pendiente.name
          });
        }
      }
    }

    print("📌 Se han agregado ejercicios a todas las rutinas existentes.");
  }
  // Future<void> generateData(DatabaseHelper dbHelper) async {
  //   final db = await dbHelper.database;
  //   var faker = Faker();

  //   // Obtener ejercicios y rutinas existentes
  //   List<Map<String, dynamic>> ejercicios = await db.query(
  //     EjercicioDbModel.table,
  //   );
  //   List<Exercise> ejerciciosdb = listaEjerciciosFromMapList(ejercicios);

  //   List<Map<String, dynamic>> rutinas = await db.query(
  //     RoutineDbModel.table,
  //   );
  //   List<Routine> rutinasdb = listaRutinasFromMapList(rutinas);

  //   for (var rutina in rutinasdb) {
  //     int cantidadEjercicios = faker.randomGenerator.integer(12, min: 8);

  //     // Determinar si la rutina tendrá todos los ejercicios terminados o no terminados
  //     bool rutinaTerminada = faker.randomGenerator.boolean();

  //     for (int i = 0; i < cantidadEjercicios; i++) {
  //       // Contar todos los ejercicios y escoger solo un ejercicio aleatoriamente
  //       int totalEjercicios = ejercicios.length;
  //       int index = faker.randomGenerator.integer(totalEjercicios - 1, min: 0);
  //       var ejercicio = ejerciciosdb[index];

  //       final detalleRutinaId = faker.guid.guid();

  //       final ejercicioMusculo = DetalleRutina(
  //         id: detalleRutinaId,
  //         rutinaId: rutina.id,
  //         ejercicioId: ejercicio.id,
  //       );

  //       int cantidadSeries = faker.randomGenerator.integer(5, min: 3);

  //       for (int j = 0; j < cantidadSeries; j++) {
  //         await db.insert(ExerciseSetDbModel.table, {
  //           'id': faker.guid.guid(),
  //           'peso': double.parse(
  //             (faker.randomGenerator.decimal(scale: 50)).toStringAsFixed(2),
  //           ),
  //           'repeticiones': faker.randomGenerator.integer(12, min: 1),
  //           'realizado':
  //               rutinaTerminada ? 1 : 0, // Todos terminados o no terminados
  //           'tiempo_descanso': faker.randomGenerator.integer(300, min: 30),
  //           'detalle_rutina_id': detalleRutinaId,
  //         });
  //       }

  //       // await db.insert(
  //       //   DatabaseHelper.tbDetalleRutina,
  //       //   ejercicioMusculo.toJson(),
  //       // );
  //     }
  //   }
  // }
}
