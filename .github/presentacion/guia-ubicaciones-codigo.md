# 🎯 Guía de Ubicaciones en el Código - GyMaster

> **Objetivo:** Saber exactamente dónde ver cada concepto teórico aplicado en tu código GyMaster  
> **Cómo usar:** Ve archivo por archivo, línea por línea, para entender cada implementación  
> **Complementa:** guia-fundamentos-teoricos.md + guia-presentacion-tecnica.md

---

## 📋 ÍNDICE DE UBICACIONES

1. [Clean Architecture](#1-clean-architecture)
2. [Principios SOLID](#2-principios-solid)
3. [Patrones de Diseño](#3-patrones-de-diseño)
4. [Flutter/Dart Avanzado](#4-flutterdart-avanzado)
5. [Gestión de Estado BLoC](#5-gestión-de-estado-bloc)
6. [Either Pattern](#6-either-pattern)
7. [Inyección de Dependencias](#7-inyección-de-dependencias)
8. [Base de Datos](#8-base-de-datos)
9. [UI/UX y Design System](#9-uiux-y-design-system)
10. [Arquitectura Empresarial](#10-arquitectura-empresarial)

---

## 🏗️ **1. CLEAN ARCHITECTURE**

### **📂 Estructura por Features**

**Ubicación:** `lib/features/`

```
📁 lib/features/routine/
├── 📂 data/               ← CAPA EXTERNA (Frameworks & Drivers)
│   ├── datasources/       ← Acceso directo a SQLite
│   ├── models/            ← Modelos para persistencia
│   └── repositories/      ← Implementaciones concretas
├── 📂 domain/             ← CAPA INTERNA (Business Rules)
│   ├── entities/          ← Reglas de negocio puras
│   ├── repositories/      ← Contratos abstractos
│   └── usecases/         ← Casos de uso específicos
└── 📂 presentation/       ← CAPA MEDIA (Interface Adapters)
    ├── cubits/           ← Gestión de estado
    └── pages/            ← UI y widgets
```

**🔍 Examinar:**

- `lib/features/routine/` - Estructura completa
- `lib/features/exercise/` - Otro ejemplo
- `lib/features/setting/` - Configuraciones

### **🎯 Regla de Dependencias**

**Ver en:** `lib/features/routine/presentation/cubits/routine_cubit.dart`

```dart
// ✅ Presentation depende de Domain (UseCase)
class RoutineCubit extends Cubit<RoutineState> {
  final GetAllRoutineUsecase getAllRoutineUseCase;  // ← Domain
  final AddRoutineUseCase addRoutineUseCase;        // ← Domain

  // ❌ NO depende de Data (RoutineLocalDataSource)
}
```

**Ver en:** `lib/features/routine/domain/usecases/get_all_routine_usecase.dart`

```dart
// ✅ Domain depende solo de abstracciones
class GetAllRoutineUsecase {
  final RoutineRepository repository; // ← Interfaz abstracta, no implementación
}
```

---

## 🔧 **2. PRINCIPIOS SOLID**

### **🔸 Single Responsibility Principle (SRP)**

**Ver en:** `lib/features/routine/domain/usecases/`

- `add_routine_usecase.dart` - Solo agregar rutinas
- `get_all_routine_usecase.dart` - Solo obtener rutinas
- `delete_routine_usecase.dart` - Solo eliminar rutinas

**Líneas específicas:**

```dart
// lib/features/routine/domain/usecases/add_routine_usecase.dart
class AddRoutineUseCase implements UseCase<Routine, AddRoutineParams> {
  // ✅ UNA sola responsabilidad: agregar rutinas
  @override
  Future<Either<Failure, Routine>> call(AddRoutineParams params) async {
    return await repository.addRoutine(/* ... */);
  }
}
```

### **🔸 Open/Closed Principle (OCP)**

**Ver en:** `lib/features/routine/domain/repositories/routine_repository.dart`

```dart
// ✅ Abierto para extensión (nuevas implementaciones)
abstract class RoutineRepository {
  Future<Either<Failure, List<Routine>>> getAllRoutine();
  // Cerrado para modificación (esta interfaz no cambia)
}
```

**Extensiones en:** `lib/features/routine/data/repositories/routine_repository_impl.dart`

```dart
// ✅ Nueva implementación sin modificar la interfaz
class RoutineRepositoryImpl implements RoutineRepository {
  @override
  Future<Either<Failure, List<Routine>>> getAllRoutine() async {
    // Implementación específica para SQLite
  }
}
```

### **🔸 Liskov Substitution Principle (LSP)**

**Ver en:** `lib/init_dependencies.dart` líneas ~50-60

```dart
// ✅ Cualquier implementación de RoutineRepository es intercambiable
serviceLocator.registerFactory<RoutineRepository>(
  () => RoutineRepositoryImpl(/* ... */), // ← Implementación 1
);

// Podrías cambiar a:
// () => RoutineApiRepository(/* ... */), // ← Implementación 2
// Sin afectar ningún UseCase
```

### **🔸 Interface Segregation Principle (ISP)**

**Comparar:**

- `lib/features/routine/domain/repositories/routine_repository.dart` - Solo métodos de rutinas
- `lib/features/exercise/domain/repositories/exercise_repository.dart` - Solo métodos de ejercicios
- `lib/features/setting/domain/repositories/setting_repository.dart` - Solo métodos de configuración

### **🔸 Dependency Inversion Principle (DIP)**

**Ver en:** `lib/features/routine/presentation/cubits/routine_cubit.dart`

```dart
class RoutineCubit extends Cubit<RoutineState> {
  // ✅ Depende de abstracción (UseCase)
  final GetAllRoutineUsecase getAllRoutineUseCase;

  // ❌ NO depende de implementación concreta
  // final RoutineLocalDataSource dataSource; // ← Esto sería violación
}
```

---

## 🔄 **3. PATRONES DE DISEÑO**

### **🏪 Repository Pattern**

**Interfaz:** `lib/features/routine/domain/repositories/routine_repository.dart`
**Implementación:** `lib/features/routine/data/repositories/routine_repository_impl.dart`

**Líneas clave en routine_repository_impl.dart:**

```dart
class RoutineRepositoryImpl implements RoutineRepository {
  final RoutineLocalDataSource localDataSource; // ← Delegación
  final IdGenerator idGenerator;

  @override
  Future<Either<Failure, List<Routine>>> getAllRoutine() async {
    try {
      final rutinas = await localDataSource.getAllRoutines(); // ← Delegación
      return Right(rutinas);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(errorMessage: e.toString()));
    }
  }
}
```

### **⚡ UseCase Pattern**

**Ver:** `lib/core/usecase/usecase.dart`

```dart
// ✅ Interfaz base para todos los casos de uso
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
```

**Implementación:** `lib/features/routine/domain/usecases/get_all_routine_usecase.dart`

```dart
class GetAllRoutineUsecase implements UseCase<List<Routine>, NoParams> {
  final RoutineRepository repository;

  @override
  Future<Either<Failure, List<Routine>>> call(NoParams params) async {
    return await repository.getAllRoutine();
  }
}
```

### **🏭 Singleton Pattern**

**Ver:** `lib/core/database/database_helper.dart` líneas ~10-25

```dart
class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  // ✅ Constructor privado
  DatabaseHelper._internal();

  // ✅ Getter que garantiza una sola instancia
  static DatabaseHelper get instance {
    _instance ??= DatabaseHelper._internal();
    return _instance!;
  }
}
```

### **🏭 Factory Pattern**

**Ver:** `lib/init_dependencies.dart` líneas ~40-80

```dart
void _initRoutine() {
  serviceLocator
    // ✅ Factory: nueva instancia cada vez
    ..registerFactory<RoutineLocalDataSource>(
      () => RoutineLocalDataSource(serviceLocator(), serviceLocator()),
    )

    // ✅ LazySingleton: una instancia compartida
    ..registerLazySingleton<DatabaseHelper>(
      () => DatabaseHelper.instance,
    );
}
```

### **👀 Observer Pattern (BLoC)**

**Observable:** `lib/features/routine/presentation/cubits/routine_cubit.dart`

```dart
class RoutineCubit extends Cubit<RoutineState> {
  Future<void> getAllRoutine() async {
    emit(RoutineLoading()); // ← Notifica a todos los observadores

    final result = await getAllRoutineUseCase(NoParams());
    result.fold(
      (failure) => emit(RoutineError(failure.errorMessage)), // ← Notifica error
      (rutinas) => emit(RoutineGetAllSuccess(rutinas)),      // ← Notifica éxito
    );
  }
}
```

**Observer:** `lib/features/routine/presentation/pages/routine_page.dart` (buscar BlocBuilder)

```dart
BlocBuilder<RoutineCubit, RoutineState>(
  builder: (context, state) {
    // ✅ Reacciona automáticamente a cambios
    return switch (state) {
      RoutineLoading() => CircularProgressIndicator(),
      RoutineGetAllSuccess() => /* mostrar rutinas */,
      RoutineError() => /* mostrar error */,
    };
  },
)
```

---

## 📱 **4. FLUTTER/DART AVANZADO**

### **🛡️ Null Safety**

**Ver:** `lib/features/routine/domain/entities/routine.dart`

```dart
class Routine {
  final String? id;        // ✅ Puede ser null (generado después)
  final String name;       // ✅ Nunca null (requerido)
  final String? description; // ✅ Puede ser null (opcional)

  const Routine({
    this.id,                 // ✅ Opcional en constructor
    required this.name,      // ✅ Requerido
    this.description,        // ✅ Opcional
  });
}
```

### **🔒 Sealed Classes**

**Ver:** `lib/features/routine/presentation/cubits/routine_state.dart`

```dart
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

**Pattern Matching:** `lib/features/routine/presentation/pages/routine_page.dart`

```dart
// ✅ Switch exhaustivo - debe cubrir todos los casos
return switch (state) {
  RoutineInitial() => _buildInitialWidget(),
  RoutineLoading() => _buildLoadingWidget(),
  RoutineGetAllSuccess() => _buildSuccessWidget(state.routines),
  RoutineError() => _buildErrorWidget(state.message),
  // ✅ Compilador garantiza que todos los casos están cubiertos
};
```

### **🔄 Immutability (copyWith)**

**Ver:** `lib/features/routine/domain/entities/routine.dart` líneas ~30-45

```dart
// ✅ copyWith manual para inmutabilidad
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
```

### **🚀 Extension Methods**

**Ver:** `lib/shared/utils/string_utils.dart` (si existe)
**O crear uno ejemplo:** `lib/shared/utils/extensions.dart`

---

## 🎯 **5. GESTIÓN DE ESTADO BLOC**

### **🧠 Cubit Implementation**

**Ver:** `lib/features/routine/presentation/cubits/routine_cubit.dart`

```dart
class RoutineCubit extends Cubit<RoutineState> {
  final AddRoutineUseCase addRoutineUseCase;
  final GetAllRoutineUsecase getAllRoutineUseCase;
  final DeleteRoutineUseCase deleteRoutineUseCase;

  // ✅ Estado inicial
  RoutineCubit({/* ... */}) : super(RoutineInitial()) {
    getAllRoutine(); // ✅ Carga inicial
  }

  // ✅ Método que cambia estado
  Future<void> getAllRoutine() async {
    emit(RoutineLoading());

    final result = await getAllRoutineUseCase(NoParams());
    result.fold(
      (failure) => emit(RoutineError(failure.errorMessage)),
      (rutinas) => emit(RoutineGetAllSuccess(rutinas)),
    );
  }
}
```

### **🎭 Estados Inmutables**

**Ver:** `lib/features/routine/presentation/cubits/routine_state.dart`

```dart
@immutable  // ✅ Garantiza inmutabilidad
sealed class RoutineState {}

final class RoutineGetAllSuccess extends RoutineState {
  final List<Routine> routines; // ✅ Final = inmutable

  RoutineGetAllSuccess(this.routines);

  // ✅ Sin setters, sin mutación posible
}
```

### **🏠 MultiBlocProvider**

**Ver:** `lib/main.dart` líneas ~30-50

```dart
MultiBlocProvider(
  providers: [
    BlocProvider<RoutineCubit>(
      create: (context) => serviceLocator<RoutineCubit>(),
    ),
    BlocProvider<ExerciseCubit>(
      create: (context) => serviceLocator<ExerciseCubit>(),
    ),
    // ✅ Todos los Cubits disponibles globalmente
  ],
  child: MaterialApp.router(/* ... */),
)
```

### **📺 BlocBuilder/BlocConsumer**

**Ver:** `lib/features/routine/presentation/pages/routine_page.dart`

**BlocBuilder:**

```dart
BlocBuilder<RoutineCubit, RoutineState>(
  builder: (context, state) {
    return switch (state) {
      RoutineLoading() => CircularProgressIndicator(),
      RoutineGetAllSuccess() => ListView(/* ... */),
      RoutineError() => Text('Error: ${state.message}'),
      _ => Container(),
    };
  },
)
```

**BlocConsumer:** (buscar en onboarding pages)

```dart
BlocConsumer<PerfilUsuarioCubit, PerfilUsuarioState>(
  listener: (context, state) {
    // ✅ Efectos secundarios (navegación, snackbars)
    if (state is PerfilUsuarioSuccess) {
      context.goNamed('home');
    }
  },
  builder: (context, state) {
    // ✅ UI reactiva
    return /* widget based on state */;
  },
)
```

---

## ⚡ **6. EITHER PATTERN**

### **🎯 Definición de Either**

**Ver:** `pubspec.yaml` línea ~20

```yaml
dependencies:
  fpdart: ^1.1.0 # ✅ Librería para Either
```

### **❌ Definición de Failures**

**Ver:** `lib/core/error/failures.dart`

```dart
abstract class Failure {
  final String errorMessage;
  const Failure({required this.errorMessage});
}

class DatabaseFailure extends Failure {
  const DatabaseFailure({required String errorMessage})
      : super(errorMessage: errorMessage);
}

class ServerFailure extends Failure {
  const ServerFailure({required String errorMessage})
      : super(errorMessage: errorMessage);
}
```

### **🔄 Either en Repositories**

**Ver:** `lib/features/routine/data/repositories/routine_repository_impl.dart`

```dart
@override
Future<Either<Failure, List<Routine>>> getAllRoutine() async {
  try {
    final rutinas = await localDataSource.getAllRoutines();
    return Right(rutinas); // ✅ Éxito
  } on DatabaseException catch (e) {
    return Left(DatabaseFailure(errorMessage: e.toString())); // ✅ Error específico
  } catch (e) {
    return Left(CacheFailure(errorMessage: 'Error inesperado: $e'));
  }
}
```

### **🎭 Either en UseCases**

**Ver:** `lib/features/routine/domain/usecases/get_all_routine_usecase.dart`

```dart
@override
Future<Either<Failure, List<Routine>>> call(NoParams params) async {
  return await repository.getAllRoutine(); // ✅ Propaga Either sin modificar
}
```

### **🎨 Either en Cubits (fold)**

**Ver:** `lib/features/routine/presentation/cubits/routine_cubit.dart`

```dart
Future<void> getAllRoutine() async {
  emit(RoutineLoading());

  final result = await getAllRoutineUseCase(NoParams());
  result.fold(
    (failure) => emit(RoutineError(failure.errorMessage)),    // ✅ Manejo de error
    (rutinas) => emit(RoutineGetAllSuccess(rutinas)),         // ✅ Manejo de éxito
  );
}
```

---

## 🔌 **7. INYECCIÓN DE DEPENDENCIAS**

### **🏪 Service Locator Setup**

**Ver:** `lib/init_dependencies.dart` líneas ~1-10

```dart
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance; // ✅ Instancia global

Future<void> initDependencies() async {
  _initCore();
  _initRoutine();
  _initExercise();
  _initRecord();
  _initSetting();
}
```

### **⚙️ Registro por Capas**

**Ver:** `lib/init_dependencies.dart` función `_initRoutine()` líneas ~40-80

```dart
void _initRoutine() {
  serviceLocator
    // ✅ Data Layer primero
    ..registerFactory<RoutineLocalDataSource>(
      () => RoutineLocalDataSource(serviceLocator(), serviceLocator()),
    )

    // ✅ Domain Layer después
    ..registerFactory<RoutineRepository>(
      () => RoutineRepositoryImpl(
        localDataSource: serviceLocator(),    // ✅ Auto-resolución
        idGenerator: serviceLocator(),        // ✅ Auto-resolución
      ),
    )

    // ✅ UseCases
    ..registerFactory(() => AddRoutineUseCase(serviceLocator()))
    ..registerFactory(() => GetAllRoutineUsecase(serviceLocator()))

    // ✅ Presentation Layer al final
    ..registerFactory(
      () => RoutineCubit(
        addRoutineUseCase: serviceLocator(),
        getAllRoutineUseCase: serviceLocator(),
        deleteRoutineUseCase: serviceLocator(),
      ),
    );
}
```

### **🏭 Tipos de Registro**

**Factory (nueva instancia):**

```dart
serviceLocator.registerFactory<RoutineCubit>(
  () => RoutineCubit(/* ... */),
);
```

**LazySingleton (una instancia cuando se necesita):**

```dart
serviceLocator.registerLazySingleton<DatabaseHelper>(
  () => DatabaseHelper.instance,
);
```

### **💉 Inyección en Constructores**

**Ver:** `lib/features/routine/presentation/cubits/routine_cubit.dart`

```dart
class RoutineCubit extends Cubit<RoutineState> {
  // ✅ Dependencias inyectadas
  final AddRoutineUseCase addRoutineUseCase;
  final GetAllRoutineUsecase getAllRoutineUseCase;
  final DeleteRoutineUseCase deleteRoutineUseCase;

  // ✅ Constructor que recibe dependencias
  RoutineCubit({
    required this.addRoutineUseCase,
    required this.getAllRoutineUseCase,
    required this.deleteRoutineUseCase,
  }) : super(RoutineInitial());
}
```

### **🎯 Uso en Main**

**Ver:** `lib/main.dart` líneas ~15-25

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDependencies(); // ✅ Configurar todas las dependencias

  runApp(MyApp());
}
```

**Y en los BlocProviders:**

```dart
BlocProvider<RoutineCubit>(
  create: (context) => serviceLocator<RoutineCubit>(), // ✅ Resolver dependencia
),
```

---

## 💾 **8. BASE DE DATOS**

### **🏗️ DatabaseHelper Singleton**

**Ver:** `lib/core/database/database_helper.dart`

```dart
class DatabaseHelper {
  static const int _databaseVersion = 1;
  static const String _databaseName = 'gymaster.db';

  // ✅ Singleton implementation
  static DatabaseHelper? _instance;
  static Database? _database;

  static DatabaseHelper get instance {
    _instance ??= DatabaseHelper._internal();
    return _instance!;
  }

  // ✅ Lazy database getter
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
}
```

### **📊 Entity vs DB Model**

**Entity (Domain):** `lib/features/routine/domain/entities/routine.dart`

```dart
class Routine {
  final String? id;
  final String name;
  final DateTime fechaCreacion;  // ✅ DateTime para lógica de negocio
  final bool echo;               // ✅ bool para lógica de negocio

  // ✅ Lógica de dominio
  bool get isCompleted => echo;
  Duration get age => DateTime.now().difference(fechaCreacion);
}
```

**DB Model (Data):** `lib/features/routine/data/models/routine_db_model.dart`

```dart
class RoutineDbModel {
  static const String table = 'routine';
  static const String columnId = 'id';
  static const String columnFechaCreacion = 'fechaCreacion';

  final String fechaCreacion; // ✅ String para SQLite
  final int echo;             // ✅ int para SQLite (0/1)

  // ✅ Conversión a Entity
  Routine toEntity() {
    return Routine(
      fechaCreacion: DateTime.parse(fechaCreacion), // ✅ String -> DateTime
      echo: echo == 1,                              // ✅ int -> bool
    );
  }

  // ✅ Conversión desde Entity
  factory RoutineDbModel.fromEntity(Routine routine) {
    return RoutineDbModel(
      fechaCreacion: routine.fechaCreacion.toIso8601String(), // ✅ DateTime -> String
      echo: routine.echo ? 1 : 0,                             // ✅ bool -> int
    );
  }
}
```

### **🔧 DataSource Pattern**

**Ver:** `lib/features/routine/data/datasources/routine_local_data_source.dart`

```dart
class RoutineLocalDataSource implements InterfaceDataSource {
  final DatabaseHelper databaseHelper;
  final IdGenerator idGenerator;

  Future<List<Routine>> getAllRoutines() async {
    final db = await databaseHelper.database;  // ✅ Acceso a BD
    final maps = await db.query(RoutineDbModel.table);

    return maps.map((map) =>
      RoutineDbModel.fromMap(map).toEntity()   // ✅ DB Model -> Entity
    ).toList();
  }

  Future<void> addRoutine(/* ... */) async {
    final db = await databaseHelper.database;

    await db.insert(
      RoutineDbModel.table,
      RoutineDbModel.fromEntity(routine).toMap(), // ✅ Entity -> DB Model
    );
  }
}
```

---

## 🎨 **9. UI/UX Y DESIGN SYSTEM**

### **🎨 Colores Emocionales (HSB)**

**Ver:** `lib/core/theme/app_colors.dart`

```dart
class AppColors {
  // ✅ Colores principales basados en HSB
  static const Color primario = Color(0xFF6B46C1);     // Púrpura energético
  static const Color secundario = Color(0xFF10B981);   // Verde éxito
  static const Color acento = Color(0xFFFF6B35);       // Naranja motivacional

  // ✅ Colores de estado
  static const Color exitoVerde = Color(0xFF27AE60);
  static const Color errorRojo = Color(0xFFE74C3C);
  static const Color warningAmber = Color(0xFFF39C12);
}
```

### **📏 Sistema de Espaciado (8pt Grid)**

**Ver:** `lib/core/theme/espaciado.dart`

```dart
class Espaciado {
  // ✅ Múltiplos de 8 puntos
  static const double cero = 0;
  static const double xxs = 4;   // 0.5 × 8
  static const double xs = 8;    // 1 × 8
  static const double sm = 16;   // 2 × 8
  static const double md = 24;   // 3 × 8
  static const double lg = 32;   // 4 × 8
  static const double xl = 40;   // 5 × 8
  static const double xxl = 48;  // 6 × 8
}
```

**Uso:** `lib/features/routine/presentation/pages/routine_page.dart`

```dart
Container(
  margin: EdgeInsets.all(Espaciado.md),     // ✅ 24px
  padding: EdgeInsets.all(Espaciado.lg),    // ✅ 32px
  child: Column(
    spacing: Espaciado.sm,                   // ✅ 16px entre elementos
  ),
)
```

### **📝 Tipografía Limitada**

**Ver:** `lib/core/theme/tipografia_gymaster.dart`

```dart
class TipografiaGyMaster {
  // ✅ Solo 6 tamaños permitidos
  static const double tamanoXs = 12.0;   // Labels, badges
  static const double tamanoSm = 14.0;   // Botones, inputs
  static const double tamanoMd = 16.0;   // Texto base
  static const double tamanoLg = 18.0;   // Subtítulos
  static const double tamanoXl = 20.0;   // Títulos
  static const double tamano2xl = 24.0;  // Hero titles

  // ✅ Solo 3 pesos permitidos
  static const FontWeight pesoLigero = FontWeight.w300;
  static const FontWeight pesoRegular = FontWeight.w400;
  static const FontWeight pesoSemiBold = FontWeight.w600;
}
```

### **🎛️ Componentes Reutilizables**

**ChicletButton:** `lib/shared/widgets/chiclet_button.dart`

```dart
class ChicletButton extends StatelessWidget {
  final String texto;
  final VoidCallback? onPressed;
  final TamanoBotonChiclet tamano;
  final Color colorFondo;

  // ✅ Design tokens para consistencia
  double get _altura {
    return switch (tamano) {
      TamanoBotonChiclet.pequeno => 40.0,
      TamanoBotonChiclet.regular => 48.0,
      TamanoBotonChiclet.grande => 56.0,
    };
  }
}
```

**GyMasterChoiceChip:** `lib/shared/widgets/gymaster_choice_chip.dart`

```dart
class GyMasterChoiceChip extends StatelessWidget {
  final String texto;
  final String emoji;
  final bool isSelected;
  final TamanoChoiceChip tamano;

  // ✅ Comportamiento consistente en toda la app
}
```

### **🧭 Navegación Declarativa**

**Ver:** `lib/app_router.dart`

```dart
final appRouter = GoRouter(
  routes: [
    // ✅ Rutas con parámetros
    GoRoute(
      path: '/onboarding/objetivos/:avatarPath',
      name: 'onboarding_objetivos',
      builder: (context, state) => OnboardingObjetivosPage(
        avatarPath: state.pathParameters['avatarPath']!, // ✅ Parámetro tipado
      ),
    ),

    // ✅ Rutas con datos complejos
    GoRoute(
      path: '/onboarding/emocional',
      name: 'onboarding_emocional',
      builder: (context, state) => OnboardingEmocionalPage(
        datosPrevios: state.extra as Map<String, dynamic>, // ✅ Datos extras
      ),
    ),
  ],
);
```

### **🎭 Diseño Emocional**

**Visceral (colores/tipografía):** Ver `app_colors.dart` y `tipografia_gymaster.dart`

**Conductual (microinteracciones):** `lib/shared/widgets/chiclet_button.dart`

```dart
AnimatedContainer(
  duration: Duration(milliseconds: 150),
  transform: isPressed
    ? (Matrix4.identity()..scale(0.95))  // ✅ Feedback visual inmediato
    : Matrix4.identity(),
)
```

**Reflexivo (mensajes motivacionales):** `lib/core/services/emotional_message_service.dart`

---

## 🏢 **10. ARQUITECTURA EMPRESARIAL**

### **📈 Escalabilidad Horizontal**

**Ver estructura:** `lib/features/`

```
features/
├── routine/          ✅ Equipo A trabaja aquí
├── exercise/         ✅ Equipo B trabaja aquí
├── record/           ✅ Equipo C trabaja aquí
├── setting/          ✅ Equipo D trabaja aquí
└── estadisticas/     ✅ Equipo E trabaja aquí (futuro)
```

**Independencia:** Cada feature tiene sus propias capas completas.

### **🔧 Mantenibilidad**

**Separación clara:** Cada clase tiene una responsabilidad específica:

- `RoutineCubit` - Solo gestión de estado UI
- `GetAllRoutineUsecase` - Solo lógica para obtener rutinas
- `RoutineRepository` - Solo contrato de acceso a datos
- `RoutineLocalDataSource` - Solo acceso directo a BD

### **⚡ Performance**

**Lazy Loading:** `lib/init_dependencies.dart`

```dart
// ✅ Se crean solo cuando se necesitan
serviceLocator.registerFactory<RoutineCubit>(
  () => RoutineCubit(/* ... */),
);

// ✅ Se crea una vez, cuando se necesita
serviceLocator.registerLazySingleton<DatabaseHelper>(
  () => DatabaseHelper.instance,
);
```

**Widgets const:** Buscar en cualquier página

```dart
const SizedBox(height: Espaciado.md),    // ✅ const
const Divider(),                         // ✅ const
const CircularProgressIndicator(),       // ✅ const
```

---

## 🎯 **PLAN DE ESTUDIO RECOMENDADO**

### **📅 Día 1-2: Arquitectura Base**

1. ✅ Explora `lib/features/routine/` completa
2. ✅ Ve `lib/init_dependencies.dart`
3. ✅ Examina `lib/core/database/database_helper.dart`

### **📅 Día 3-4: Estado y Datos**

1. ✅ Estudia `routine_cubit.dart` y `routine_state.dart`
2. ✅ Ve `routine_repository_impl.dart`
3. ✅ Examina `routine_local_data_source.dart`

### **📅 Día 5-6: UI y Componentes**

1. ✅ Estudia `app_colors.dart`, `espaciado.dart`, `tipografia_gymaster.dart`
2. ✅ Ve `chiclet_button.dart` y `gymaster_choice_chip.dart`
3. ✅ Examina `app_router.dart`

### **📅 Día 7: Integración**

1. ✅ Ve `main.dart` - punto de entrada
2. ✅ Examina cualquier página completa (ej: `routine_page.dart`)
3. ✅ Practica explicando el flujo completo

---

## 🚀 **CÓMO USAR ESTA GUÍA**

1. **📂 Abre VS Code** con tu proyecto GyMaster
2. **🎯 Ve archivo por archivo** siguiendo las ubicaciones específicas
3. **👁️ Lee línea por línea** los fragmentos mencionados
4. **🔗 Conecta conceptos** entre archivos (ej: cómo UseCase usa Repository)
5. **🗣️ Practica explicando** cada implementación en voz alta
6. **❓ Haz preguntas** sobre lo que no entiendas

### **💡 Tips para el Estudio:**

- **Sigue el flujo de datos:** UI → Cubit → UseCase → Repository → DataSource → DB
- **Ve las interfaces primero:** Entiende el contrato antes de la implementación
- **Busca patrones repetidos:** Lo que ves en `routine` se repite en `exercise`, `setting`, etc.
- **Usa el buscador de VS Code:** `Ctrl+Shift+F` para buscar implementaciones específicas

**¡Con esta guía tienes la hoja de ruta exacta para dominar cada concepto viendo tu propio código!** 🎯
