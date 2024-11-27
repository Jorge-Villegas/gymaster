import 'package:gymaster/core/database/database_helper.dart';
import 'package:gymaster/core/database/models/rutina.dart';
import 'package:gymaster/core/database/seeders/database_seeder.dart';
import 'package:gymaster/core/error/exceptions.dart';
import 'package:gymaster/core/error/failures.dart';
import 'package:gymaster/features/routine/data/datasources/routine_local_data_source.dart';
import 'package:gymaster/features/routine/data/models/ejercicios_de_rutina_model.dart'
    as ejercicioDeRutina;
import 'package:gymaster/features/routine/data/models/ejercicios_por_musculo.dart';
import 'package:gymaster/features/routine/data/models/musculo_model.dart';
import 'package:gymaster/features/routine/data/models/routine_model.dart';
import 'package:gymaster/features/routine/data/models/rutina_data_model.dart';
import 'package:gymaster/features/routine/data/models/serie_model.dart';
import 'package:gymaster/features/routine/domain/entities/datos_ejercicios_realizando.dart';
import 'package:gymaster/features/routine/domain/entities/ejercicio.dart'
    as ejericicioEntity;
import 'package:gymaster/features/routine/domain/entities/ejercicios_de_rutina.dart';
import 'package:gymaster/features/routine/domain/entities/routine.dart';
import 'package:gymaster/features/routine/domain/entities/rutina_data.dart';
import 'package:gymaster/features/routine/domain/repositories/rutine_repository.dart';
import 'package:gymaster/features/routine/domain/usecases/add_ejercicio_rutina_usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:gymaster/shared/utils/uuid_generator.dart';
import 'package:gymaster/core/database/models/serie.dart' as serieDB;

class RoutineRepositoryImpl implements RoutineRepository {
  final RoutineLocalDataSource localDataSource;
  final IdGenerator idGenerator;

  RoutineRepositoryImpl({
    required this.localDataSource,
    required this.idGenerator,
  });

  @override
  Future<Either<Failure, List<RoutineModel>>> getAllRoutine() async {
    try {
      final result = await localDataSource.getAllRutinas();
      List<RoutineModel> routines = [];
      for (var rutina in result) {
        final cantEjercicio =
            await localDataSource.getEjerciciosByRutinaId(rutina.id);
        routines.add(RoutineModel.fromDatabase(
          serieDB: rutina,
          cantidadEjercicios: cantEjercicio.length,
        ));
      }
      return right(routines);
    } on LocalFailure {
      return Left(LocalFailure());
    }
  }

  @override
  Future<Either<Failure, RoutineModel>> addRoutine({
    required String name,
    String? description,
    required DateTime creationDate,
    required bool done,
    required int color,
  }) async {
    try {
      final rutina = Rutina(
        id: idGenerator.generateId(),
        nombre: name,
        descripcion: description,
        fechaCreacion: creationDate.toString(),
        realizado: done ? 1 : 0,
        color: color,
        estado: 1,
      );
      final result = await localDataSource.createRutina(rutina: rutina);

      if (result == 0) {
        return left(Failure());
      }
      return right(RoutineModel.fromDatabase(serieDB: rutina));
    } on LocalFailure {
      return Left(LocalFailure());
    }
  }

  @override
  Future<Either<Failure, List<MusculoModel>>> getAllMusculos() async {
    try {
      final result = await localDataSource.getAllMusculos();

      if (result.isEmpty) {
        await DatabaseSeeder().seedGenerateDatabase();
        final musculos = result
            .map((musculo) => MusculoModel(
                  id: musculo.id,
                  nombre: musculo.nombre,
                  imagenDirecion: musculo.imagenDireccion ?? '',
                ))
            .toList();
        print('getAllMusculos -> $musculos');
        return right(musculos);
      }
      return right(result
          .map((musculo) => MusculoModel(
                id: musculo.id,
                nombre: musculo.nombre,
                imagenDirecion: musculo.imagenDireccion ?? '',
              ))
          .toList());
    } on LocalFailure {
      return Left(LocalFailure());
    }
  }

  @override
  Future<Either<Failure, List<EjerciciosPorMusculoModel>>>
      getAllEjerciciosByMusculo({
    required String musculoId,
  }) async {
    try {
      final ejercicios = await localDataSource.getEjerciciosPorMusculo(
        musculoId,
      );
      return right(ejercicios
          .map((ejercicio) => EjerciciosPorMusculoModel(
                id: ejercicio.id,
                nombre: ejercicio.nombre,
                descripcion: ejercicio.descripcion,
                imagenDireccion: ejercicio.imagenDireccion ?? '',
                musculos: ejercicio.musculos,
              ))
          .toList());
    } on LocalFailure {
      return Left(LocalFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addEjericioRutina({
    required String idRutina,
    required String idEjercicio,
    required List<DataSerie> dataSeries,
  }) async {
    try {
      final rutina = await localDataSource.getRutinaById(idRutina);

      final ejercicio = await localDataSource.getEjercicioById(idEjercicio);

      final series = dataSeries.map((dataSerie) {
        return serieDB.Serie(
          id: idGenerator.generateId(),
          rutinaId: rutina.id,
          ejercicioId: ejercicio.id,
          repeticiones: dataSerie.numeroRepeticon,
          peso: dataSerie.peso,
          realizado: 0,
          tiempoDescanso: 0,
        );
      }).toList();

      for (var serie in series) {
        await localDataSource.createSerie(serie: serie);
      }

      return left(Failure());
    } on LocalFailure {
      return Left(LocalFailure());
    }
  }

  @override
  Future<Either<Failure, ejercicioDeRutina.EjerciciosDeRutinaModel>>
      getAllEjercicioByRutinaId({
    required String rutinaId,
  }) async {
    try {
      final rutinaDB = await localDataSource.getRutinaById(rutinaId);

      final ejerciciosDB =
          await localDataSource.getEjerciciosByRutinaId(rutinaId);

      List<ejercicioDeRutina.EjercicioModel> ejerciciosConDetalles = [];

      for (var ejercicio in ejerciciosDB) {
        List<ejercicioDeRutina.SeriesDelEjercicioModel> series = [];
        List<ejercicioDeRutina.MusculoModel> musculos = [];

        final seriesDB =
            await localDataSource.getSeriesByEjercicioId(ejercicio.id);
        final musculosDB =
            await localDataSource.getMusculosByEjercicioId(ejercicio.id);

        for (var serie in seriesDB) {
          series.add(
              ejercicioDeRutina.SeriesDelEjercicioModel.fromDatabase(serie));
        }

        for (var musculo in musculosDB) {
          musculos.add(ejercicioDeRutina.MusculoModel.fromDatabase(musculo));
        }

        final ejercicioConDetalles =
            ejercicioDeRutina.EjercicioModel.fromDatabase(
          ejercicioDB: ejercicio,
          series: series,
          musculos: musculos,
        );

        ejerciciosConDetalles.add(ejercicioConDetalles);
      }

      final ejerciciosDeRutinaConDetalles =
          ejercicioDeRutina.EjerciciosDeRutinaModel.fromDatabase(
        rutinaDB,
        ejerciciosConDetalles,
      );

      print(
          'getAllEjercicioByRutinaId() -> ${ejercicioDeRutina.ejerciciosDeRutinaModelToJson(ejerciciosDeRutinaConDetalles)}');

      return Right(ejerciciosDeRutinaConDetalles);
    } on LocalFailure {
      return Left(LocalFailure());
    }
  }

  @override
  Future<Either<Failure, SerieModel>> updateSerie({
    required String id,
    double? peso,
    int? repeticiones,
    bool? realizado,
    int? tiempoDescanso,
  }) async {
    try {
      final serieDB = await localDataSource.getSerieById(id);

      final updatedSerie = serieDB.copyWith(
        peso: peso,
        repeticiones: repeticiones,
        realizado: realizado != null ? (realizado ? 1 : 0) : null,
        tiempoDescanso: tiempoDescanso,
      );

      final success = await localDataSource.updateSerie(updatedSerie);


      final result  = SerieModel.fromDatabase(serieDB: updatedSerie);  
      if (success) {
        return Right(result);
      } else {
        return Left(Failure());
      }
    } on LocalFailure {
      return Left(LocalFailure());
    }
  }

  @override
  Future<Either<Failure, List<SerieModel>>> getSeriesByRoutineId({
    required String rutinaId,
  }) async {
    try {
      return left(Failure());
    } on LocalFailure {
      return Left(LocalFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteRoutine({required String id}) async {
    try {
      return left(Failure());
    } on LocalFailure {
      return Left(LocalFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateRoutine({
    required String id,
    String? name,
    DateTime? creationDate,
    bool? done,
    int? color,
  }) async {
    try {
      return left(Failure());
    } on LocalFailure {
      return Left(LocalFailure());
    }
  }

  @override
  Future<Either<Failure, Routine>> getRoutineById({required String id}) async {
    try {
      return left(Failure());
    } on LocalFailure {
      return Left(LocalFailure());
    }
  }

  @override
  Future<Either<Failure, List<Routine>>> getRoutineByName({
    required String name,
  }) async {
    try {
      return left(Failure());
    } on LocalFailure {
      return Left(LocalFailure());
    }
  }

  @override
  Future<Either<Failure, SerieModel>> getSerieById(String id) async {
    try {
      return left(Failure());
    } on LocalFailure {
      return Left(LocalFailure());
    }
  }

  @override
  Future<Either<Failure, RutinaDataModel>> getRutina(int id) async {
    try {
      return left(Failure());
    } on LocalFailure {
      return Left(LocalFailure());
    }
  }

  @override
  Future<Either<Failure, RutinaData>> obtenerRutinaDetalles({
    required String idRutina,
  }) async {
    try {
      return left(Failure());
    } on LocalFailure {
      return Left(LocalFailure());
    }
  }
}
