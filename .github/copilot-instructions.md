# AI Coding Assistant Instructions for GyMaster

Este es un proyecto Flutter de gestión de rutinas de gimnasio que implementa **Clean Architecture** con **BLoC/Cubit**, **SQLite local** y terminología específica del dominio fitness en español.

## � Objetivos del Proyecto

- **Código legible**: Fácil de entender para humanos e IA
- **Mantenimiento simple**: Cambios seguros y predecibles
- **Performance óptimo**: Aprovechando mejores prácticas de Flutter
- **Escalabilidad**: Arquitectura que crece con nuevas features
- **Funcionalidad robusta**: Gestión completa de rutinas, ejercicios y seguimiento

## �🏗️ Arquitectura del Proyecto

### Clean Architecture Obligatoria por Features

```
lib/
├── main.dart                    # Punto de entrada con MultiBlocProvider
├── app_router.dart             # Configuración de GoRouter
├── init_dependencies.dart      # Configuración de GetIt
├── core/                       # Funcionalidades compartidas
│   ├── database/               # DatabaseHelper singleton + modelos BD
│   ├── error/                  # Failures con Either pattern
│   ├── generated/              # Assets generados (Flutter Gen)
│   ├── theme/                  # AppTheme + fuentes custom
│   └── usecase/                # Interfaz base UseCase
├── features/                   # Features por dominio
│   ├── routine/               # Gestión de rutinas
│   ├── exercise/              # Catálogo de ejercicios
│   ├── record/                # Historial y seguimiento
│   └── setting/               # Configuraciones de usuario
│       ├── data/
│       │   ├── datasources/    # Acceso a datos (SQLite, SharedPreferences)
│       │   └── repositories/   # Implementaciones de repositorios
│       ├── domain/
│       │   ├── entities/       # Modelos de negocio puros (copyWith manual)
│       │   ├── repositories/   # Interfaces abstractas
│       │   └── usecases/       # Lógica de negocio (Either pattern)
│       └── presentation/
│           ├── cubits/         # Estado con BLoC/Cubit
│           └── pages/          # UI widgets
└── shared/                     # Utilidades y widgets compartidos
```

**Features principales**: `routine`, `exercise`, `record`, `setting`

### 🔄 Flujo de Datos Obligatorio

```
UI (Page/Widget) → Cubit → UseCase → Repository → DataSource → Database/API
                ←        ←         ←            ←             ←
```

**NUNCA** saltarse capas o acceder directamente a capas inferiores.

### Inyección de Dependencias

- **GetIt** como service locator (`serviceLocator` global)
- Configuración en `lib/init_dependencies.dart` organizada por features
- Patrón de registro: datasources → repositories → usecases → cubits
- **Factory** para nuevas instancias, **LazySingleton** para servicios compartidos

### Gestión de Estado

- **BLoC/Cubit** para toda la lógica de estado
- **Sealed classes** para estados inmutables
- MultiBlocProvider en `main.dart` registra todos los cubits
- Patrón: `emit()` estados desde cubits, `BlocBuilder`/`BlocConsumer` en UI

## 🗄️ Base de Datos y Persistencia

### SQLite con Sqflite

- **DatabaseHelper** singleton para manejo de BD (`DatabaseHelper.instance`)
- **Ubicación desarrollo**: `gymaster/dart_tool/sqflite_common_ffi/databases/gymaster.db`
- **Ubicación Android**: `/data/data/com.example.gymaster/databases/`
- **Inicialización obligatoria**: `await DatabaseHelper.instance.database` en main()
- **Modelos BD**: Separados de entities con sufijo `_db_model.dart`

### Manejo de Errores Funcional

- **fpdart Either** para programación funcional con `Either<Failure, Success>`
- **Failures específicos**: `ServerFailure`, `CacheFailure`, `NoRecordsFailure`, `DatabaseFailure`
- **Patrón obligatorio**: repositories retornan `Either`, usecases propagan errores
- **Mensajes de error**: En español para UI, técnicos para logging

```dart
// ✅ Patrón obligatorio para repositorios
@override
Future<Either<Failure, List<Routine>>> getAllRoutine() async {
  try {
    final rutinas = await localDataSource.getAllRoutines();
    return Right(rutinas);
  } on DatabaseException catch (e) {
    return Left(DatabaseFailure(errorMessage: 'Error de BD: ${e.toString()}'));
  } catch (e) {
    return Left(CacheFailure(errorMessage: 'Error inesperado: $e'));
  }
}
```

## 🔧 Comandos de Desarrollo Críticos

### Generación de Código Requerida

```bash
# EJECUTAR DESPUÉS de modificar modelos de datos o recursos
flutter pub run build_runner build

# Limpiar y regenerar si hay conflictos
flutter pub run build_runner build --delete-conflicting-outputs
```

**CRÍTICO**: Ejecutar después de cualquier cambio en:

- Modelos de datos (entities, database models)
- Assets (imágenes, iconos, fuentes)
- Configuraciones de internacionalización

### Flutter Gen (Recursos Typesafe)

- **Configuración**: `pubspec.yaml` → `flutter_gen.output: lib/core/generated/`
- **Genera**: `lib/core/generated/assets.gen.dart` para imágenes/iconos
- **Uso correcto**: `Assets.imagenes.musculos.pecho.bench_press` (typesafe)
- **Integración**: `flutter_svg: true` para SVGs

### Testing y Desarrollo

```bash
# Ejecutar tests
flutter test

# Análisis de código
flutter analyze

# Formateo automático
flutter format .

# Inspección de base de datos (desarrollo)
# Ubicación: gymaster/dart_tool/sqflite_common_ffi/databases/gymaster.db
```

## 🎨 Patrones Específicos del Proyecto

### Nomenclatura y Convenciones

**Terminología de Dominio (español)**:

- `rutina`, `ejercicio`, `musculo`, `serie` para entidades de negocio
- `agregarEjercicioARutina()`, `completarSerie()`, `iniciarSesionRutina()`

**Técnico (inglés)**:

- `DatabaseHelper`, `Either<Failure, T>`, `UseCase`, `Repository`

**Archivos**:

```dart
// ✅ Correcto
routine_cubit.dart              // Cubits con sufijo _cubit
routine_state.dart              // Estados con sufijo _state
routine_local_data_source.dart  // DataSources con sufijo _data_source
routine_repository_impl.dart    // Implementaciones con sufijo _impl
add_routine_usecase.dart        // UseCases con sufijo _usecase
routine_db_model.dart           // Modelos BD con sufijo _db_model
routine.dart                    // Entidades sin sufijo
```

### Usecase Pattern (Obligatorio)

```dart
class GetAllEjerciciosByMusculoUseCase
    implements UseCase<List<EjerciciosPorMusculo>, GetAllEjerciciosByMusculoParams> {
  final RoutineRepository repository;

  GetAllEjerciciosByMusculoUseCase(this.repository);

  @override
  Future<Either<Failure, List<EjerciciosPorMusculo>>> call(
    GetAllEjerciciosByMusculoParams params,
  ) async {
    return await repository.getAllEjerciciosByMusculo(
      musculoId: params.musculoId,
    );
  }
}

class GetAllEjerciciosByMusculoParams {
  final String musculoId;
  GetAllEjerciciosByMusculoParams({required this.musculoId});
}
```

### Cubit State Management (Sealed Classes)

```dart
// ✅ Correcto - Estados inmutables con sealed classes
@immutable
sealed class RoutineState {}

final class RoutineInitial extends RoutineState {}
final class RoutineLoading extends RoutineState {}
final class RoutineGetAllSuccess extends RoutineState {
  final List<Routine> routines;
  RoutineGetAllSuccess(this.routines);
}
final class RoutineError extends RoutineState {
  final String message;
  RoutineError(this.message);
}
```

### Inmutabilidad (copyWith Manual)

```dart
// ✅ OBLIGATORIO - copyWith manual para todas las entidades
class Routine {
  final String? id;
  final String name;
  final String? description;
  final DateTime fechaCreacion;
  final bool echo;
  final int color;

  const Routine({
    this.id,
    required this.name,
    this.description,
    required this.fechaCreacion,
    required this.echo,
    required this.color,
  });

  Routine copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? fechaCreacion,
    bool? echo,
    int? color,
  }) => Routine(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    echo: echo ?? this.echo,
    color: color ?? this.color,
  );
}
```

### Navegación con GoRouter

- **Configuración central**: `lib/app_router.dart`
- **Rutas con parámetros**: `/agregar-ejercicios/:rutinaId/:sesionId`
- **Navegación**: `context.pushNamed('routeName', pathParameters: {...})`

## 🚨 Problemas Conocidos y Soluciones

### Bug Historial Ejercicios (Documentado)

- **Problema**: Loading infinito en detalle de ejercicios desde historial
- **Causa**: `SelectedRoutineCubit` no inicializa estado
- **Solución**: Llamar `loadRoutine()` antes de navegar a detalle

### Assets por Categoría

- **Iconos**: `assets/icons/` (SVG con flutter_svg)
- **Músculos**: `assets/imagenes/musculos/{grupo}/` (estructurado por grupo muscular)
- **Lottie**: `assets/lottie/` para animaciones

## 💡 Principios de Desarrollo

### Simplicidad (DRY, YAGNI, KISS)

- **DRY**: Extraer funciones reutilizables para evitar duplicación
- **YAGNI**: Solo implementar lo que realmente se necesita ahora
- **KISS**: Preferir soluciones sencillas sobre complejidad innecesaria

### Funciones Pequeñas y Enfocadas

- **Una función = una responsabilidad**
- **Máximo 30 líneas por función**
- **Máximo 3 parámetros (usar objetos para más)**
- **Nombres que expresen la acción específica del dominio**

### Tipado Estricto

- **Tipado explícito para APIs públicas**
- **Null safety siempre habilitado**
- **Generics específicos para colecciones**
- **Verificación segura de null con patrones apropiados**

## 🔄 Inyección de Dependencias con GetIt

### Patrones de Registro

```dart
// LazySingleton - Para servicios compartidos (una sola instancia)
serviceLocator.registerLazySingleton<DatabaseHelper>(
  () => DatabaseHelper.instance,
);

// Factory - Para objetos que necesitan nuevas instancias
serviceLocator.registerFactory<RoutineLocalDataSource>(
  () => RoutineLocalDataSource(serviceLocator(), serviceLocator()),
);

// registerCachedFactory - Para operaciones costosas reutilizables
serviceLocator.registerCachedFactory(
  () => GetLastRoutineSessionByRoutineId(serviceLocator()),
);
```

### Organización por Features

```dart
// Estructura en init_dependencies.dart
void _initRoutine() {
  serviceLocator
    // Data Layer
    ..registerFactory<RoutineLocalDataSource>(/*...*/)
    // Domain Layer
    ..registerFactory<RoutineRepository>(/*...*/)
    ..registerFactory(() => AddRoutineUseCase(/*...*/))
    // Presentation Layer
    ..registerFactory(() => RoutineCubit(/*...*/));
}
```

## 🔍 Debugging y Testing

### Base de Datos

- **Inspección manual**: Usar SQLite browser en ruta de desarrollo
- **Logs**: `DatabaseHelper` tiene logging incorporado
- **Reset**: Eliminar archivo .db y reiniciar app

### Estado de Cubits

- **Debug**: Agregar `print()` en states para seguir flujo
- **BlocObserver**: Implementar para logging global de estados

## ⚙️ Configuraciones Específicas

### Temas

- **AppTheme**: `lib/core/theme/app_theme.dart`
- **Fuentes custom**: ZonaPro (principal), Montserrat (secundaria)
- **Dark/Light mode**: Persistido con SharedPreferences

### Localización

- **Solo español**: `locale: const Locale('es', 'US')`
- **Configuración**: GlobalMaterialLocalizations incluido

## 🎯 Reglas de Desarrollo

### 📁 Convenciones de Nomenclatura de Archivos

```dart
// ✅ Correcto - Features y archivos
routine_cubit.dart              // Cubits con sufijo _cubit
routine_state.dart              // Estados con sufijo _state
routine_local_data_source.dart  // DataSources con sufijo _data_source
routine_repository_impl.dart    // Implementaciones con sufijo _impl
add_routine_usecase.dart        // UseCases con sufijo _usecase
routine_db_model.dart           // Modelos BD con sufijo _db_model
routine.dart                    // Entidades sin sufijo

// ❌ Evitar - Nombres genéricos
data.dart
helper.dart
utils.dart
manager.dart
```

### 🏷️ Reglas de Nomenclatura

#### Variables y Métodos - Terminología de Dominio

```dart
// ✅ Correcto - Terminología del gimnasio en español para dominio
final List<Rutina> rutinas = await getAllRutinas();
final Musculo musculoSeleccionado = state.musculoSeleccionado;
final List<Ejercicio> ejerciciosPorMusculo = await getEjerciciosByMusculo();
final bool rutinaCompletada = state.rutinaCompletada;

Future<void> agregarEjercicioARutina(String ejercicioId, String rutinaId) async { }
Future<void> completarSerie(String serieId) async { }
Future<void> iniciarSesionRutina(String rutinaId) async { }

// ✅ Correcto - Términos técnicos en inglés
final DatabaseHelper databaseHelper = DatabaseHelper.instance;
final Either<Failure, List<Routine>> result = await repository.getAllRoutine();

// ❌ Evitar - Abreviaciones y nombres genéricos
final r = getRutinas();
final data = getData();
final info = getInfo();
void update(String id, int val) { }
```

#### Constantes y Configuración

```dart
// ✅ Correcto - Nombres descriptivos en UPPER_CASE
class RoutinePage extends StatefulWidget {
  static const double TIMER_FONT_SIZE = 24.0;
  static const double EXERCISE_CARD_HEIGHT = 120.0;
  static const int DEFAULT_REST_TIME_SECONDS = 60;
  static const int MAX_SERIES_PER_EXERCISE = 10;
  static const String DEFAULT_WEIGHT_UNIT = 'kg';
}

// Database tables
class RoutineDbModel {
  static const String table = 'routine';
  static const String columnId = 'id';
  static const String columnName = 'name';
}
```

### ⚡ Funciones Pequeñas y Enfocadas

**Reglas obligatorias**:

- **Una función = una responsabilidad**
- **Máximo 30 líneas por función**
- **Máximo 3 parámetros (usar objetos para más)**
- **Nombres que expresen la acción específica del dominio**

```dart
// ✅ Correcto - Funciones pequeñas y enfocadas para GyMaster
class RoutineCubit extends Cubit<RoutineState> {
  // Carga inicial de rutinas
  Future<void> getAllRoutine() async {
    emit(RoutineLoading());
    try {
      final result = await getAllRoutineUseCase(NoParams());
      result.fold(
        (failure) => emit(RoutineError(failure.errorMessage)),
        (rutinas) => emit(RoutineGetAllSuccess(rutinas)),
      );
    } catch (e) {
      emit(RoutineError('Error inesperado: $e'));
    }
  }

  // Agregar nueva rutina
  Future<void> addRoutine({
    required String name,
    String? description,
    required DateTime creationDate,
    required bool done,
    required int color,
    required String imagenDireccion,
  }) async {
    emit(RoutineLoading());
    try {
      final params = AddRoutineParams(
        name: name,
        description: description,
        creationDate: creationDate,
        done: done,
        color: color,
        imagenDireccion: imagenDireccion,
      );

      final result = await addRoutineUseCase(params);
      result.fold(
        (failure) => emit(RoutineError(failure.errorMessage)),
        (rutina) => emit(RoutineAddSuccess(rutina)),
      );
    } catch (e) {
      emit(RoutineError('Error al crear rutina: $e'));
    }
  }

  // Función auxiliar privada para resetear estado
  void _resetToInitial() {
    emit(RoutineInitial());
  }
}
```

### 🔐 Tipado Estricto y Null Safety

```dart
// ✅ Correcto - Tipado explícito en APIs públicas
abstract class RoutineRepository {
  Future<Either<Failure, List<Routine>>> getAllRoutine();
  Future<Either<Failure, Routine>> addRoutine({
    required String name,
    String? description,
    required DateTime creationDate,
    required bool done,
    required int color,
    required String imagenDireccion,
  });
  Future<Either<Failure, void>> deleteRoutine({required String id});
}

// ✅ Correcto - Manejo adecuado de null safety
class Routine {
  final String? id;        // Nullable: Se genera después de creación
  final String name;       // Non-null: Siempre requerido
  final String? description; // Nullable: Opcional
  final DateTime fechaCreacion; // Non-null: Siempre requerido
  final bool echo;         // Non-null: Tiene valor por defecto
  final int color;         // Non-null: Siempre requerido

  const Routine({
    this.id,                    // Opcional en constructor
    required this.name,         // Requerido
    this.description,           // Opcional
    required this.fechaCreacion,
    required this.echo,
    required this.color,
  });
}

// ✅ Correcto - Verificación segura de null
Routine? findRoutineById(List<Routine> rutinas, String id) {
  try {
    return rutinas.firstWhere((rutina) => rutina.id == id);
  } on StateError {
    return null; // Retorno explícito cuando no se encuentra
  }
}
```

### 📝 Documentación Inteligente

**Reglas**:

- **El código debe ser auto-explicativo con nombres descriptivos**
- **Comentarios solo para lógica de negocio compleja**
- **Documentar decisiones de arquitectura importantes**

```dart
// ✅ Correcto - Documentación útil para lógica de negocio del gimnasio
class RoutineLocalDataSource {
  Future<bool> startRoutineSession(String sessionId, String rutinaId) async {
    final db = await databaseHelper.database;

    // Lógica de negocio: Solo puede haber una sesión activa por vez
    // Verificar si hay sesiones activas y terminarlas antes de iniciar nueva
    await db.update(
      'routine_session',
      {'status': 'completed', 'ended_at': DateTime.now().toIso8601String()},
      where: 'status = ?',
      whereArgs: ['active'],
    );

    // Iniciar nueva sesión
    await db.insert('routine_session', {
      'id': sessionId,
      'routine_id': rutinaId,
      'status': 'active',
      'started_at': DateTime.now().toIso8601String(),
    });

    return true;
  }
}
```

### 🧪 Testing Orientado al Usuario

**Reglas**:

- **Probar comportamiento, no implementación**
- **Testing de casos de uso principales**
- **Mocks para dependencias externas**
- **Nombres descriptivos de tests**

```dart
// ✅ Correcto - Test de comportamiento
group('RoutineCubit', () {
  late RoutineCubit cubit;
  late MockGetAllRoutineUsecase mockGetAllRoutineUsecase;
  late MockAddRoutineUseCase mockAddRoutineUseCase;

  setUp(() {
    mockGetAllRoutineUsecase = MockGetAllRoutineUsecase();
    mockAddRoutineUseCase = MockAddRoutineUseCase();

    cubit = RoutineCubit(
      getAllRoutineUseCase: mockGetAllRoutineUsecase,
      addRoutineUseCase: mockAddRoutineUseCase,
      deleteRoutineUseCase: MockDeleteRoutineUseCase(),
    );
  });

  group('cuando se cargan las rutinas', () {
    test('debería emitir estado de loading y luego rutinas cargadas', () async {
      // Arrange
      final rutinas = [Routine(id: '1', name: 'Test')];
      when(() => mockGetAllRoutineUsecase(any()))
          .thenAnswer((_) async => Right(rutinas));

      // Act
      await cubit.getAllRoutine();

      // Assert
      expect(
        cubit.stream,
        emitsInOrder([
          isA<RoutineLoading>(),
          isA<RoutineGetAllSuccess>(),
        ]),
      );
    });
  });
});
```

### ✅ SIEMPRE Hacer

1. **Arquitectura**: Seguir Clean Architecture con 3 capas (data, domain, presentation)
2. **Estado**: Usar BLoC/Cubit para gestión de estado con sealed classes
3. **Inmutabilidad**: Todas las entidades con copyWith manual
4. **Either**: Usar fpdart Either para manejo funcional de errores
5. **Inyección**: GetIt organizado por features en init_dependencies
6. **Errores**: Capturar y manejar con Either en todas las capas
7. **Testing**: Casos de uso principales con comportamiento
8. **Tipado**: Dart estricto y null safety habilitado
9. **Nomenclatura**: Descriptivos en español para dominio (rutina, ejercicio, musculo)
10. **Base de Datos**: SQLite con DatabaseHelper singleton y modelos específicos

### ❌ NUNCA Hacer

1. **Saltarse capas** de Clean Architecture
2. **Mutar objetos** directamente (usar copyWith siempre)
3. **Acceso directo** a base de datos desde UI o Cubits
4. **Funciones grandes** (>30 líneas)
5. **Hardcodear valores** (usar constantes descriptivas)
6. **Ignorar errores** (always handle Either results)
7. **Usar any** o dynamic sin justificación
8. **Duplicar código** (aplicar DRY con métodos helper)
9. **Mixed languages** en terminología (español para dominio, inglés para técnico)
10. **Usar Freezed** (proyecto usa copyWith manual)

## 📋 Patrones Específicos del Proyecto

### Entidades de Dominio (Patrón Obligatorio)

```dart
// ✅ Patrón obligatorio para entidades
class Routine {
  final String? id;
  final String name;
  final String? description;
  final DateTime fechaCreacion;
  final bool echo;
  final int color;

  const Routine({
    this.id,
    required this.name,
    this.description,
    required this.fechaCreacion,
    required this.echo,
    required this.color,
  });

  Routine copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? fechaCreacion,
    bool? echo,
    int? color,
  }) => Routine(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    echo: echo ?? this.echo,
    color: color ?? this.color,
  );

  factory Routine.fromJson(Map<String, dynamic> json) => Routine(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    fechaCreacion: DateTime.parse(json["fechaCreacion"]),
    echo: json["echo"],
    color: json["color"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "fechaCreacion": fechaCreacion.toIso8601String(),
    "echo": echo,
    "color": color,
  };
}
```

### UseCase Pattern (Patrón Obligatorio)

```dart
// ✅ Patrón obligatorio para casos de uso
class GetAllEjerciciosByMusculoUseCase
    implements UseCase<List<EjerciciosPorMusculo>, GetAllEjerciciosByMusculoParams> {
  final RoutineRepository repository;

  GetAllEjerciciosByMusculoUseCase(this.repository);

  @override
  Future<Either<Failure, List<EjerciciosPorMusculo>>> call(
    GetAllEjerciciosByMusculoParams params,
  ) async {
    return await repository.getAllEjerciciosByMusculo(
      musculoId: params.musculoId,
    );
  }
}

class GetAllEjerciciosByMusculoParams {
  final String musculoId;
  GetAllEjerciciosByMusculoParams({required this.musculoId});
}
```

### Cubit Pattern (Patrón Obligatorio)

```dart
// ✅ Patrón obligatorio para Cubits
class RoutineCubit extends Cubit<RoutineState> {
  final AddRoutineUseCase addRoutineUseCase;
  final GetAllRoutineUsecase getAllRoutineUseCase;
  final DeleteRoutineUseCase deleteRoutineUseCase;

  RoutineCubit({
    required this.addRoutineUseCase,
    required this.getAllRoutineUseCase,
    required this.deleteRoutineUseCase,
  }) : super(RoutineInitial()) {
    getAllRoutine();
  }

  Future<void> getAllRoutine() async {
    emit(RoutineLoading());

    final result = await getAllRoutineUseCase(NoParams());
    result.fold(
      (failure) {
        debugPrint('Error: ${failure.errorMessage}');
        emit(RoutineError(_getUserFriendlyMessage(failure)));
      },
      (rutinas) => emit(RoutineGetAllSuccess(rutinas)),
    );
  }

  // Convierte errores técnicos en mensajes amigables para el usuario
  String _getUserFriendlyMessage(Failure failure) {
    switch (failure.runtimeType) {
      case DatabaseFailure:
        return 'Error de base de datos. Intenta de nuevo.';
      case NoRecordsFailure:
        return 'No tienes rutinas guardadas aún.';
      case ServerFailure:
        return 'Sin conexión a internet. Verifica tu conexión.';
      default:
        return 'Ocurrió un error inesperado. Intenta de nuevo.';
    }
  }
}
```

### Estados con Sealed Classes (Patrón Obligatorio)

```dart
// ✅ Patrón obligatorio para estados
@immutable
sealed class RoutineState {}

final class RoutineInitial extends RoutineState {}
final class RoutineLoading extends RoutineState {}
final class RoutineGetAllSuccess extends RoutineState {
  final List<Routine> routines;
  RoutineGetAllSuccess(this.routines);
}
final class RoutineAddSuccess extends RoutineState {
  final Routine rutina;
  RoutineAddSuccess(this.rutina);
}
final class RoutineError extends RoutineState {
  final String message;
  RoutineError(this.message);
}
```

### Repository Pattern con Either

```dart
// ✅ Patrón obligatorio para repositorios
class RoutineRepositoryImpl implements RoutineRepository {
  final RoutineLocalDataSource localDataSource;
  final IdGenerator idGenerator;

  RoutineRepositoryImpl({
    required this.localDataSource,
    required this.idGenerator,
  });

  @override
  Future<Either<Failure, List<Routine>>> getAllRoutine() async {
    try {
      final rutinas = await localDataSource.getAllRoutines();
      if (rutinas.isEmpty) {
        return Left(NoRecordsFailure(
          errorMessage: 'No hay rutinas guardadas'
        ));
      }
      return Right(rutinas);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(
        errorMessage: 'Error de base de datos: ${e.toString()}'
      ));
    } catch (e) {
      return Left(CacheFailure(
        errorMessage: 'Error inesperado al obtener rutinas: $e'
      ));
    }
  }
}
```

## 🎨 UI y Widgets

### Reglas de UI

```dart
// ✅ Correcto - Widget reutilizable y configurable
class ExerciseCard extends StatelessWidget {
  final String exerciseName;
  final String muscleName;
  final int series;
  final int repetitions;
  final VoidCallback? onTap;

  const ExerciseCard({
    super.key,
    required this.exerciseName,
    required this.muscleName,
    required this.series,
    required this.repetitions,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(exerciseName),
        subtitle: Text('$muscleName • $series series × $repetitions reps'),
        onTap: onTap,
      ),
    );
  }
}

// ✅ Correcto - Separación de responsabilidades en páginas
class RoutinePage extends StatefulWidget {
  @override
  _RoutinePageState createState() => _RoutinePageState();
}

class _RoutinePageState extends State<RoutinePage> {
  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    context.read<RoutineCubit>().getAllRoutine();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<RoutineCubit, RoutineState>(
        builder: (context, state) {
          return switch (state) {
            RoutineInitial() => _buildInitialWidget(),
            RoutineLoading() => _buildLoadingWidget(),
            RoutineGetAllSuccess() => _buildSuccessWidget(state.routines),
            RoutineError() => _buildErrorWidget(state.message),
          };
        },
      ),
    );
  }

  Widget _buildLoadingWidget() => const Center(child: CircularProgressIndicator());

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, size: 64, color: Colors.red),
          SizedBox(height: 16),
          Text(error, textAlign: TextAlign.center),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadInitialData,
            child: Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}
```

## 📱 Responsividad

```dart
// ✅ Correcto - Constantes para diferentes tamaños
class ResponsiveConstants {
  // Breakpoints
  static const double SMALL_SCREEN_MAX_WIDTH = 600;
  static const double LARGE_SCREEN_MIN_WIDTH = 601;

  // Font sizes
  static const double SMALL_SCREEN_FONT_SIZE = 14;
  static const double LARGE_SCREEN_FONT_SIZE = 18;

  // Paddings
  static const double SMALL_SCREEN_PADDING = 8.0;
  static const double LARGE_SCREEN_PADDING = 16.0;
}

class ResponsiveExerciseCard extends StatelessWidget {
  final String exerciseName;
  final String muscleName;

  const ResponsiveExerciseCard({
    super.key,
    required this.exerciseName,
    required this.muscleName,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth <= ResponsiveConstants.SMALL_SCREEN_MAX_WIDTH;

    return Padding(
      padding: EdgeInsets.all(
        isSmallScreen
          ? ResponsiveConstants.SMALL_SCREEN_PADDING
          : ResponsiveConstants.LARGE_SCREEN_PADDING
      ),
      child: Text(
        exerciseName,
        style: TextStyle(
          fontSize: isSmallScreen
            ? ResponsiveConstants.SMALL_SCREEN_FONT_SIZE
            : ResponsiveConstants.LARGE_SCREEN_FONT_SIZE,
        ),
      ),
    );
  }
}
```

### 📋 Checklist de Revisión

Antes de hacer commit, verificar:

- [ ] ¿Sigue Clean Architecture con estructura correcta?
- [ ] ¿Usa copyWith manual para inmutabilidad?
- [ ] ¿Maneja errores con Either correctamente?
- [ ] ¿Nombres descriptivos con terminología adecuada?
- [ ] ¿Funciones pequeñas (<30 líneas) y enfocadas?
- [ ] ¿Tipado explícito en APIs públicas?
- [ ] ¿GetIt organizado por features?
- [ ] ¿Estados usando sealed classes?
- [ ] ¿UseCase implementa interfaz base correctamente?
- [ ] ¿Database models separados de entities?

### Assets por Categoría

- **Iconos**: `assets/icons/` (SVG con flutter_svg)
- **Músculos**: `assets/imagenes/musculos/{grupo}/` (estructurado por grupo muscular)
- **Lottie**: `assets/lottie/` para animaciones

## 🔍 Debugging y Testing

### Base de Datos

- **Inspección manual**: Usar SQLite browser en ruta de desarrollo
- **Logs**: `DatabaseHelper` tiene logging incorporado
- **Reset**: Eliminar archivo .db y reiniciar app

### Estado de Cubits

- **Debug**: Agregar `print()` en states para seguir flujo
- **BlocObserver**: Implementar para logging global de estados

## ⚙️ Configuraciones Específicas

### Temas

- **AppTheme**: `lib/core/theme/app_theme.dart`
- **Fuentes custom**: ZonaPro (principal), Montserrat (secundaria)
- **Dark/Light mode**: Persistido con SharedPreferences

### Localización

- **Solo español**: `locale: const Locale('es', 'US')`
- **Configuración**: GlobalMaterialLocalizations incluido

## 🎯 Resumen de Mejores Prácticas GyMaster

### 💡 Principios de Desarrollo

#### Simplicidad (DRY, YAGNI, KISS)

- **DRY**: Extraer funciones reutilizables para evitar duplicación
- **YAGNI**: Solo implementar lo que realmente se necesita ahora
- **KISS**: Preferir soluciones sencillas sobre complejidad innecesaria

```dart
// ✅ Correcto - Evitar duplicación
class SettingsCubit extends Cubit<SettingsState> {
  // Método genérico para actualizar cualquier configuración
  Future<void> _updateSetting(Settings Function(Settings) updater) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      final updatedSettings = updater(currentState.settings);
      emit(SettingsLoaded(updatedSettings));
      await _persistSettings(updatedSettings);
    }
  }

  // Métodos específicos que usan el genérico
  Future<void> updateLanguage(String language) async {
    await _updateSetting((settings) => settings.copyWith(language: language));
  }

  Future<void> updateTheme(String theme) async {
    await _updateSetting((settings) => settings.copyWith(theme: theme));
  }
}
```

#### Funciones Pequeñas y Enfocadas

- **Una función = una responsabilidad**
- **Máximo 30 líneas por función**
- **Máximo 3 parámetros (usar objetos para más)**
- **Nombres que expresen la acción específica del dominio**

#### Tipado Estricto

- **Tipado explícito para APIs públicas**
- **Null safety siempre habilitado**
- **Generics específicos para colecciones**
- **Verificación segura de null con patrones apropiados**

### 🔄 Inyección de Dependencias Detallada

```dart
// ✅ Patrón completo de registro GetIt
final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initCore();
  _initRoutine();
  _initExercise();
  _initRecord();
  _initSetting();
}

void _initCore() {
  // Core dependencies - LazySingleton para servicios compartidos
  serviceLocator.registerLazySingleton<DatabaseHelper>(
    () => DatabaseHelper.instance,
  );
  serviceLocator.registerLazySingleton<IdGenerator>(
    () => UuidGenerator(),
  );
}

void _initRoutine() {
  serviceLocator
    // Data Layer - Factory para nuevas instancias
    ..registerFactory<RoutineLocalDataSource>(
      () => RoutineLocalDataSource(serviceLocator(), serviceLocator()),
    )

    // Domain Layer - Repository
    ..registerFactory<RoutineRepository>(
      () => RoutineRepositoryImpl(
        localDataSource: serviceLocator(),
        idGenerator: serviceLocator(),
      ),
    )

    // Domain Layer - Use Cases
    ..registerFactory(() => AddRoutineUseCase(serviceLocator()))
    ..registerFactory(() => GetAllRoutineUsecase(serviceLocator()))
    ..registerFactory(() => DeleteRoutineUseCase(serviceLocator()))

    // Presentation Layer - Cubits
    ..registerFactory(
      () => RoutineCubit(
        addRoutineUseCase: serviceLocator(),
        getAllRoutineUseCase: serviceLocator(),
        deleteRoutineUseCase: serviceLocator(),
      ),
    );
}
```

### 📋 Patrones de Registro GetIt

```dart
// LazySingleton - Para servicios compartidos (una sola instancia)
serviceLocator.registerLazySingleton<DatabaseHelper>(
  () => DatabaseHelper.instance,
);

// Factory - Para objetos que necesitan nuevas instancias
serviceLocator.registerFactory<RoutineLocalDataSource>(
  () => RoutineLocalDataSource(serviceLocator(), serviceLocator()),
);

// CachedFactory - Para operaciones costosas reutilizables
serviceLocator.registerCachedFactory(
  () => GetLastRoutineSessionByRoutineId(serviceLocator()),
);
```

# 🧠 Diseño Emocional en Apps de Fitness

---

## 1. Fundamentos Científicos del Diseño Emocional

**Conceptos clave:**

- **Teoría de los tres niveles de Donald Norman**

  - **Visceral:** Reacción inmediata a la estética (colores, sonidos, imágenes).
  - **Conductual:** Usabilidad y experiencia fluida durante el uso.
  - **Reflexivo:** Conexión emocional duradera con la marca y sentido de logro.

- **Neurociencia y emociones:**  
   Las emociones positivas activan la liberación de dopamina, reforzando motivación y engagement.

- **Conexión emoción-memoria:**  
   Las experiencias emocionales se recuerdan mejor y por más tiempo, crucial para la fidelización.

**Casos científicos comprobados:**

- **Estudio de Falk (2010):**  
   Visitantes de museos que experimentaron emociones intensas recordaban un 70% más de información.  
   _Aplicable a apps de fitness para retener usuarios._

- **Gamificación y dopamina:**  
   Apps como Strava y Duolingo usan recompensas (insignias, rankings) para activar el sistema de recompensa cerebral, aumentando la adherencia.

- **Personalización y autonomía:**  
   La teoría de la autodeterminación (Deci & Ryan) muestra que los usuarios se motivan más cuando sienten control sobre sus metas.

---

## 🛠️ 2. Implementación en una App de Gimnasio

### A. Nivel Visceral (Diseño Estético)

- **Colores y tipografía:**  
   Usar colores energéticos (naranja, rojo) para acciones motivacionales y tonos calmados (azul, verde) para secciones de recuperación.  
   Tipografía redondeada para transmitir cercanía (ej: Nunito, Roboto Rounded).

- **Imágenes y videos:**  
   Mostrar personas reales (no modelos) con cuerpos diversos para generar identificación.

- **Sonidos y vibraciones:**  
   Feedback auditivo positivo al completar un ejercicio (ej: sonido de aplausos).

---

### B. Nivel Conductual (Usabilidad y Experiencia)

- **Onboarding emocional:**  
   Preguntar sobre metas personales y miedos (ej: "¿Qué te detiene para entrenar?") para personalizar la experiencia.  
   Usar lenguaje empático ("Vamos a lograrlo juntos").

- **Microinteracciones:**  
   Animaciones al completar un ejercicio (ej: check animado con confeti).

- **Notificaciones inteligentes:**  
   "¡Hace 3 días que no entrenas, te echamos de menos!"

- **Gamificación:**  
   Sistema de recompensas por consistencia (ej: "Insignia de Tigre" por 7 días seguidos).  
   Retos sociales: Competir con amigos o grupos corporativos.

---

### C. Nivel Reflexivo (Conexión y Comunidad)

- **Historias de éxito:**  
   Incluir testimonios reales de usuarios con transformaciones físicas y emocionales.

- **Comunidad y apoyo:**  
   Foros moderados por entrenadores.  
   Eventos virtuales en vivo (ej: clases de yoga con influencers fitness).

- **Personalización profunda:**  
   Ajustar recomendaciones basadas en el estado anímico (ej: "Pareces cansado hoy, ¿un entrenamiento suave?").

---

## 📊 3. Métricas para Medir el Impacto Emocional

**Métricas cuantitativas:**

- **Tasa de retención a 30 días:**  
   Apps con diseño emocional retienen un 40% más de usuarios.

- **Net Promoter Score (NPS):**  
   Medir lealtad emocional con encuestas post-entrenamiento.

- **Tiempo de sesión:**  
   Mayores emociones positivas correlacionan con sesiones más largas.

**Métricas cualitativas:**

- **Análisis de sentimientos en comentarios:**  
   Usar IA para detectar emociones en reseñas.

- **Test de usabilidad con medición biométrica:**  
   Monitorear frecuencia cardíaca y expresiones faciales durante el uso para detectar frustración o alegría.

---

## 🚀 4. Guía Paso a Paso para Implementar

| **Fase**                       | **Acciones Clave**                                            | **Emoción Objetivo**     |
| ------------------------------ | ------------------------------------------------------------- | ------------------------ |
| **Investigación y Estrategia** | User Personas con enfoque emocional, Benchmark emocional      | Comprensión, empatía     |
| **Diseño y Prototipado**       | Mapa de viaje emocional, Prototipado con herramientas no-code | Anticipación, confianza  |
| **Desarrollo e Iteración**     | Integración de tecnologías, Pruebas A/B emocionales           | Motivación, engagement   |
| **Lanzamiento y Monitoreo**    | Storytelling en campaña, Panel de control emocional           | Inspiración, pertenencia |

---

## ⚠️ 5. Riesgos y Cómo Evitarlos

- **Sobrecarga emocional:**  
   Demasiadas notificaciones generan ansiedad.  
   _Solución:_ Permitir personalización de frecuencia.

- **Falta de autenticidad:**  
   Los usuarios detectan mensajes falsos.  
   _Solución:_ Usar lenguaje genuino y testimonios reales.

- **Brechas culturales:**  
   Emociones varían por región (ej: colores que significan algo distinto).  
   _Solución:_ Testear en mercados locales.

---

## 📌 6. Ejemplos de Éxito en Apps de Fitness

- **Strava:**  
   Usa competitividad social (tablas de líderes) para generar orgullo y pertenencia.

- **Fit Path:**  
   Ofrece planes personalizados con lenguaje empático ("Tú puedes") y seguimiento de hábitos.

- **Peloton:**  
   Combina hardware (bicicletas) con comunidad en vivo para crear experiencias emocionales intensas.

---

## 💎 7. Plantilla de Checklist para Implementación

| **Fase**      | **Acciones Clave**                                                | **Emoción Objetivo**      |
| ------------- | ----------------------------------------------------------------- | ------------------------- |
| Onboarding    | Preguntar sobre miedos y metas; usar imágenes diversas            | Confianza y esperanza     |
| Entrenamiento | Animaciones al completar ejercicios; mensajes de voz motivadores  | Orgullo y energía         |
| Comunidad     | Retos grupales; historias de éxito compartidas                    | Pertenencia e inspiración |
| Feedback      | Encuestas de sentimiento post-entreno; ajustes por estado anímico | Validación y apoyo        |

---

## 🔮 8. Tendencias Futuras

- **IA emocional:**  
   Apps que detectan emociones por la cámara para ajustar entrenamientos.

- **Realidad virtual (VR):**  
   Entrenamientos inmersivos en entornos emocionalmente estimulantes (ej: playas paradisíacas).

- **Biofeedback integrado:**  
   Wearables que miden cortisol y sugieren meditación si detectan estrés.

---

## 📚 Conclusión Final

El diseño emocional no es un lujo, sino una necesidad estratégica para apps de gimnasio en un mercado competitivo.  
Al conectar con las emociones de los usuarios, no solo mejoras la usabilidad, sino que construyes relaciones duraderas que se traducen en mayor retención y crecimiento orgánico.

> **Comienza con una investigación profunda de tus usuarios, diseña cada interacción para evocar emociones positivas y mide constantemente el impacto emocional.**

---

¿Necesitas ayuda para aplicar esto a tu app específica?  
¡Estaré encantado de asistirte! 😊
