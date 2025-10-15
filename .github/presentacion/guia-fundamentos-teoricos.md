# 📚 Guía Teórica Completa - Fundamentos para GyMaster

> **Objetivo:** Dominar todos los conceptos teóricos y prácticos necesarios para entender y explicar profesionalmente la arquitectura y tecnologías usadas en GyMaster.  
> **Audiencia:** Tú (para prepararte para la presentación técnica)  
> **Complementa:** guia-presentacion-tecnica.md

---

## 📋 ÍNDICE

1. [Clean Architecture - Fundamentos](#clean-architecture---fundamentos)
2. [Principios SOLID - Teoría y Práctica](#principios-solid---teoría-y-práctica)
3. [Patrones de Diseño en GyMaster](#patrones-de-diseño-en-gymaster)
4. [Flutter y Dart - Conceptos Avanzados](#flutter-y-dart---conceptos-avanzados)
5. [Gestión de Estado con BLoC/Cubit](#gestión-de-estado-con-blocCubit)
6. [Programación Funcional - Either Pattern](#programación-funcional---either-pattern)
7. [Inyección de Dependencias](#inyección-de-dependencias)
8. [Base de Datos y Persistencia](#base-de-datos-y-persistencia)
9. [UI/UX y Design Systems](#uiux-y-design-systems)
10. [Arquitectura de Software Empresarial](#arquitectura-de-software-empresarial)

---

## 🏗️ **1. CLEAN ARCHITECTURE - FUNDAMENTOS**

### **1.1 ¿Qué es Clean Architecture?**

**Definición:**  
Clean Architecture es un patrón arquitectural creado por Robert C. Martin (Uncle Bob) que organiza el código en capas concéntricas, donde las dependencias apuntan hacia adentro, hacia las reglas de negocio.

**Objetivos principales:**

- **Independencia de frameworks:** El código no depende de Flutter, sino que Flutter usa el código
- **Testeable:** La lógica se puede probar sin UI, BD o servicios externos
- **Independiente de la UI:** La UI puede cambiar sin afectar la lógica
- **Independiente de la BD:** Puedes cambiar de SQLite a Firebase sin afectar reglas de negocio
- **Independiente de servicios externos:** Las reglas de negocio no saben sobre APIs externas

### **1.2 Las 4 Capas (de afuera hacia adentro)**

```
🔵 FRAMEWORKS & DRIVERS (Flutter, SQLite, APIs)
    ↓ depende de
🟡 INTERFACE ADAPTERS (Presenters, Controllers, Gateways)
    ↓ depende de
🟢 APPLICATION BUSINESS RULES (Use Cases)
    ↓ depende de
🟠 ENTERPRISE BUSINESS RULES (Entities)
```

**En GyMaster:**

```
📱 PRESENTATION (Pages, Cubits, Widgets) = Interface Adapters
🎯 DOMAIN (UseCases, Entities, Repositories) = Business Rules
💾 DATA (DataSources, Models, Repository Impls) = Frameworks & Drivers
```

### **1.3 Regla de Dependencias**

**LA REGLA MÁS IMPORTANTE:**

> Las dependencias del código fuente solo pueden apuntar hacia adentro. Nada en un círculo interno puede saber algo sobre algo en un círculo externo.

**En la práctica:**

- ✅ `RoutineCubit` puede usar `GetAllRoutineUseCase`
- ✅ `GetAllRoutineUseCase` puede usar `RoutineRepository` (interfaz)
- ❌ `Routine` (entity) NO puede conocer `RoutineCubit`
- ❌ `GetAllRoutineUseCase` NO puede conocer `SQLite` directamente

### **1.4 Ventajas Reales en GyMaster**

1. **Cambio de tecnología sin dolor:**

   - Cambiar de SQLite a Firebase: Solo modificas DataSources
   - Cambiar de BLoC a Riverpod: Solo modificas Presentation
   - Cambiar de Flutter a React Native: Reutilizas Domain completo

2. **Testing sencillo:**

   - Testeas UseCases sin base de datos
   - Testeas lógica de negocio sin UI
   - Mocks fáciles con interfaces

3. **Escalabilidad:**
   - Nuevas features sin tocar código existente
   - Equipos pueden trabajar en paralelo por capas
   - Refactoring seguro y localizado

---

## 🔧 **2. PRINCIPIOS SOLID - TEORÍA Y PRÁCTICA**

### **2.1 Single Responsibility Principle (SRP)**

**Definición:**  
Una clase debe tener una sola razón para cambiar. Cada clase debe tener una única responsabilidad.

**❌ Violación del SRP:**

```dart
class RoutineManager {
  // Responsabilidad 1: Gestión de rutinas
  Future<void> addRoutine(Routine routine) async { }
  Future<List<Routine>> getAllRoutines() async { }

  // Responsabilidad 2: Persistencia
  Future<void> saveToDatabase(Routine routine) async { }

  // Responsabilidad 3: Validación
  bool validateRoutine(Routine routine) { }

  // Responsabilidad 4: Notificaciones
  void notifyRoutineAdded() { }
}
```

**✅ Siguiendo SRP en GyMaster:**

```dart
// Una responsabilidad: Definir caso de uso
class AddRoutineUseCase {
  Future<Either<Failure, Routine>> call(AddRoutineParams params) async { }
}

// Una responsabilidad: Persistir datos
class RoutineLocalDataSource {
  Future<void> addRoutine(RoutineDbModel routine) async { }
}

// Una responsabilidad: Validar entradas
class RoutineValidator {
  bool isValidName(String name) { }
}

// Una responsabilidad: Gestionar estado UI
class RoutineCubit extends Cubit<RoutineState> {
  Future<void> addRoutine(AddRoutineParams params) async { }
}
```

### **2.2 Open/Closed Principle (OCP)**

**Definición:**  
Las entidades de software deben estar abiertas para extensión pero cerradas para modificación.

**En GyMaster:**

```dart
// ✅ Abierto para extensión, cerrado para modificación
abstract class RoutineRepository {
  Future<Either<Failure, List<Routine>>> getAllRoutine();
}

// Extensión 1: Implementación local
class RoutineRepositoryImpl implements RoutineRepository {
  @override
  Future<Either<Failure, List<Routine>>> getAllRoutine() async {
    // Implementación SQLite
  }
}

// Extensión 2: Implementación remota (futuro)
class RoutineApiRepository implements RoutineRepository {
  @override
  Future<Either<Failure, List<Routine>>> getAllRoutine() async {
    // Implementación API REST
  }
}

// El UseCase no cambia nunca, solo cambiamos implementaciones
class GetAllRoutineUsecase {
  final RoutineRepository repository; // ¡Usa la interfaz!

  Future<Either<Failure, List<Routine>>> call() async {
    return await repository.getAllRoutine();
  }
}
```

### **2.3 Liskov Substitution Principle (LSP)**

**Definición:**  
Los objetos de una superclase deben ser reemplazables con objetos de sus subclases sin alterar el funcionamiento del programa.

**En GyMaster:**

```dart
// La interfaz define el contrato
abstract class RoutineRepository {
  Future<Either<Failure, List<Routine>>> getAllRoutine();
}

// Implementación 1
class RoutineRepositoryImpl implements RoutineRepository {
  @override
  Future<Either<Failure, List<Routine>>> getAllRoutine() async {
    // ✅ Cumple el contrato: retorna Either<Failure, List<Routine>>
    return Right(routines);
  }
}

// Implementación 2
class RoutineCacheRepository implements RoutineRepository {
  @override
  Future<Either<Failure, List<Routine>>> getAllRoutine() async {
    // ✅ También cumple el contrato: retorna Either<Failure, List<Routine>>
    return Right(cachedRoutines);
  }
}

// El UseCase funciona con cualquier implementación
class GetAllRoutineUsecase {
  final RoutineRepository repository;

  Future<Either<Failure, List<Routine>>> call() async {
    // ✅ Funciona igual con cualquier implementación que cumpla el contrato
    return await repository.getAllRoutine();
  }
}
```

### **2.4 Interface Segregation Principle (ISP)**

**Definición:**  
Los clientes no deben ser forzados a depender de interfaces que no usan.

**❌ Violación del ISP:**

```dart
abstract class MegaRepository {
  // Rutinas
  Future<List<Routine>> getAllRoutines();
  Future<void> addRoutine(Routine routine);

  // Ejercicios
  Future<List<Exercise>> getAllExercises();
  Future<void> addExercise(Exercise exercise);

  // Estadísticas
  Future<Stats> getStats();

  // Configuraciones
  Future<Settings> getSettings();
}
```

**✅ Siguiendo ISP en GyMaster:**

```dart
// Interfaces específicas y cohesivas
abstract class RoutineRepository {
  Future<Either<Failure, List<Routine>>> getAllRoutine();
  Future<Either<Failure, Routine>> addRoutine(AddRoutineParams params);
}

abstract class ExerciseRepository {
  Future<Either<Failure, List<Exercise>>> getAllExercises();
  Future<Either<Failure, Exercise>> addExercise(AddExerciseParams params);
}

abstract class SettingsRepository {
  Future<Either<Failure, Settings>> getSettings();
  Future<Either<Failure, void>> updateSettings(Settings settings);
}

// Los UseCases solo dependen de lo que necesitan
class GetAllRoutineUsecase {
  final RoutineRepository repository; // ✅ Solo usa RoutineRepository
}

class GetAllExercisesUsecase {
  final ExerciseRepository repository; // ✅ Solo usa ExerciseRepository
}
```

### **2.5 Dependency Inversion Principle (DIP)**

**Definición:**  
Los módulos de alto nivel no deben depender de módulos de bajo nivel. Ambos deben depender de abstracciones.

**❌ Violación del DIP:**

```dart
class RoutineCubit extends Cubit<RoutineState> {
  // ❌ Depende de implementación concreta (bajo nivel)
  final RoutineRepositoryImpl repository;
  final SqliteDataSource dataSource;

  Future<void> getAllRoutines() async {
    // ❌ Conoce detalles de implementación
    final db = await dataSource.database;
    final routines = await db.query('routines');
  }
}
```

**✅ Siguiendo DIP en GyMaster:**

```dart
class RoutineCubit extends Cubit<RoutineState> {
  // ✅ Depende de abstracción (alto nivel)
  final GetAllRoutineUsecase getAllRoutineUseCase;

  RoutineCubit({required this.getAllRoutineUseCase});

  Future<void> getAllRoutines() async {
    // ✅ No conoce detalles de implementación
    final result = await getAllRoutineUseCase(NoParams());
    result.fold(
      (failure) => emit(RoutineError(failure.errorMessage)),
      (routines) => emit(RoutineGetAllSuccess(routines)),
    );
  }
}

class GetAllRoutineUsecase {
  // ✅ Depende de abstracción
  final RoutineRepository repository;

  GetAllRoutineUsecase(this.repository);
}

// ✅ La implementación concreta se inyecta desde fuera
void initDependencies() {
  serviceLocator.registerFactory<RoutineRepository>(
    () => RoutineRepositoryImpl(serviceLocator()),
  );

  serviceLocator.registerFactory(
    () => GetAllRoutineUsecase(serviceLocator()),
  );

  serviceLocator.registerFactory(
    () => RoutineCubit(getAllRoutineUseCase: serviceLocator()),
  );
}
```

---

## 🔄 **3. PATRONES DE DISEÑO EN GYMASTER**

### **3.1 Repository Pattern**

**¿Qué problema resuelve?**  
Encapsula la lógica necesaria para acceder a fuentes de datos. Centraliza funcionalidad común de acceso a datos, proporcionando mejor mantenibilidad y desacoplando la infraestructura o tecnología usada para acceder a las bases de datos de la capa de modelo de dominio.

**Estructura en GyMaster:**

```dart
// 1. Interfaz en Domain (contrato)
abstract class RoutineRepository {
  Future<Either<Failure, List<Routine>>> getAllRoutine();
  Future<Either<Failure, Routine>> addRoutine(AddRoutineParams params);
  Future<Either<Failure, void>> deleteRoutine(String id);
}

// 2. Implementación en Data (detalles técnicos)
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
      return Right(rutinas);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(errorMessage: e.toString()));
    }
  }
}
```

**Ventajas:**

- ✅ Abstrae el origen de datos (SQLite, API, etc.)
- ✅ Fácil de testear con mocks
- ✅ Intercambiable (cambiar BD sin afectar lógica)
- ✅ Centraliza la lógica de acceso a datos

### **3.2 UseCase Pattern (Command Pattern)**

**¿Qué problema resuelve?**  
Encapsula una petición como un objeto, permitiendo parametrizar clientes con diferentes peticiones, encolar peticiones, y soportar operaciones que se pueden deshacer.

**Estructura en GyMaster:**

```dart
// 1. Interfaz base para todos los UseCases
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

// 2. Implementación específica
class GetAllRoutineUsecase implements UseCase<List<Routine>, NoParams> {
  final RoutineRepository repository;

  GetAllRoutineUsecase(this.repository);

  @override
  Future<Either<Failure, List<Routine>>> call(NoParams params) async {
    return await repository.getAllRoutine();
  }
}

// 3. Parámetros tipados
class AddRoutineParams {
  final String name;
  final String? description;
  final DateTime creationDate;

  AddRoutineParams({
    required this.name,
    this.description,
    required this.creationDate,
  });
}
```

**Ventajas:**

- ✅ Una clase = Una acción específica
- ✅ Fácil de testear de forma aislada
- ✅ Reutilizable desde diferentes puntos
- ✅ Logging y auditoría centralizados

### **3.3 Singleton Pattern**

**¿Cuándo usarlo?**  
Para recursos que deben tener una sola instancia en toda la aplicación.

**Implementación en GyMaster:**

```dart
class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  // Constructor privado
  DatabaseHelper._internal();

  // Getter que garantiza una sola instancia
  static DatabaseHelper get instance {
    _instance ??= DatabaseHelper._internal();
    return _instance!;
  }

  // Getter lazy para la base de datos
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
}
```

**Ventajas:**

- ✅ Una sola conexión a BD en toda la app
- ✅ Gestión centralizada de recursos costosos
- ✅ Acceso global controlado

### **3.4 Factory Pattern (con GetIt)**

**¿Qué problema resuelve?**  
Crea objetos sin especificar la clase exacta a crear.

**Implementación en GyMaster:**

```dart
void initDependencies() {
  // Factory: Nueva instancia cada vez
  serviceLocator.registerFactory<RoutineCubit>(
    () => RoutineCubit(
      getAllRoutineUseCase: serviceLocator(),
      addRoutineUseCase: serviceLocator(),
    ),
  );

  // LazySingleton: Una instancia compartida
  serviceLocator.registerLazySingleton<DatabaseHelper>(
    () => DatabaseHelper.instance,
  );
}
```

### **3.5 Observer Pattern (con BLoC/Cubit)**

**¿Qué problema resuelve?**  
Define una dependencia uno-a-muchos entre objetos, para que cuando un objeto cambie de estado, todos sus dependientes sean notificados.

**Implementación en GyMaster:**

```dart
// 1. Observable (Cubit)
class RoutineCubit extends Cubit<RoutineState> {
  Future<void> addRoutine(AddRoutineParams params) async {
    emit(RoutineLoading()); // Notifica a todos los observadores

    final result = await addRoutineUseCase(params);
    result.fold(
      (failure) => emit(RoutineError(failure.errorMessage)),
      (routine) => emit(RoutineAddSuccess(routine)), // Notifica éxito
    );
  }
}

// 2. Observer (Widget)
class RoutinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoutineCubit, RoutineState>(
      builder: (context, state) {
        // Reacciona automáticamente a cambios de estado
        return switch (state) {
          RoutineLoading() => CircularProgressIndicator(),
          RoutineAddSuccess() => Text('¡Rutina añadida!'),
          RoutineError() => Text('Error: ${state.message}'),
          _ => Container(),
        };
      },
    );
  }
}
```

---

## 📱 **4. FLUTTER Y DART - CONCEPTOS AVANZADOS**

### **4.1 Null Safety**

**¿Qué es?**  
Sistema de tipos que garantiza que las variables no pueden ser null a menos que se declare explícitamente.

**En GyMaster:**

```dart
class Routine {
  final String? id;        // Puede ser null (se genera después)
  final String name;       // Nunca null (requerido)
  final String? description; // Puede ser null (opcional)

  const Routine({
    this.id,                 // Opcional
    required this.name,      // Requerido
    this.description,        // Opcional
  });
}

// Uso seguro
void useRoutine(Routine routine) {
  print(routine.name);           // ✅ Seguro, nunca es null
  print(routine.id?.length);     // ✅ Seguro, usa null-aware operator
  print(routine.description ?? 'Sin descripción'); // ✅ Valor por defecto

  // print(routine.id.length);   // ❌ Error de compilación
}
```

### **4.2 Extension Methods**

**¿Para qué sirven?**  
Añaden funcionalidad a tipos existentes sin modificarlos.

**Ejemplo en GyMaster:**

```dart
extension StringExtensions on String {
  bool get isValidRoutineName {
    return isNotEmpty && length >= 3 && length <= 50;
  }

  String get capitalize {
    if (isEmpty) return '';
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}

// Uso
String routineName = 'pecho y tríceps';
if (routineName.isValidRoutineName) {
  print(routineName.capitalize); // "Pecho y tríceps"
}
```

### **4.3 Sealed Classes (Pattern Matching)**

**¿Qué son?**  
Clases que pueden ser subclaseadas solo dentro del mismo archivo, permitiendo pattern matching exhaustivo.

**En GyMaster:**

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

// Pattern matching exhaustivo
Widget buildUI(RoutineState state) {
  return switch (state) {
    RoutineInitial() => Text('Inicial'),
    RoutineLoading() => CircularProgressIndicator(),
    RoutineGetAllSuccess() => ListView(children: state.routines.map(...)),
    RoutineError() => Text('Error: ${state.message}'),
    // ✅ El compilador garantiza que todos los casos están cubiertos
  };
}
```

### **4.4 Immutability (copyWith)**

**¿Por qué importante?**  
Los objetos inmutables son más seguros, predecibles y fáciles de debuggear.

**Implementación manual en GyMaster:**

```dart
class Routine {
  final String? id;
  final String name;
  final DateTime fechaCreacion;

  const Routine({
    this.id,
    required this.name,
    required this.fechaCreacion,
  });

  // ✅ copyWith manual para inmutabilidad
  Routine copyWith({
    String? id,
    String? name,
    DateTime? fechaCreacion,
  }) {
    return Routine(
      id: id ?? this.id,
      name: name ?? this.name,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    );
  }
}

// Uso
Routine original = Routine(name: 'Pecho', fechaCreacion: DateTime.now());
Routine modified = original.copyWith(name: 'Pecho y Tríceps');
// original no se modifica, se crea una nueva instancia
```

---

## 🎯 **5. GESTIÓN DE ESTADO CON BLOC/CUBIT**

### **5.1 ¿Qué es BLoC?**

**BLoC (Business Logic Component):**  
Patrón que separa la lógica de presentación de la lógica de negocio mediante streams.

**Cubit:**  
Versión simplificada de BLoC que usa funciones en lugar de eventos.

### **5.2 ¿Por qué BLoC/Cubit en lugar de setState?**

**setState problems:**

```dart
class RoutinePage extends StatefulWidget {
  @override
  _RoutinePageState createState() => _RoutinePageState();
}

class _RoutinePageState extends State<RoutinePage> {
  List<Routine> routines = [];
  bool isLoading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    loadRoutines(); // ❌ Lógica mezclada con UI
  }

  Future<void> loadRoutines() async {
    setState(() {
      isLoading = true; // ❌ Estado mutable
      error = null;
    });

    try {
      final result = await api.getRoutines(); // ❌ Llamada directa a API
      setState(() {
        routines = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }
}
```

**BLoC/Cubit benefits:**

```dart
// ✅ Lógica separada y testeable
class RoutineCubit extends Cubit<RoutineState> {
  final GetAllRoutineUsecase getAllRoutineUseCase;

  RoutineCubit({required this.getAllRoutineUseCase}) : super(RoutineInitial());

  Future<void> loadRoutines() async {
    emit(RoutineLoading());

    final result = await getAllRoutineUseCase(NoParams());
    result.fold(
      (failure) => emit(RoutineError(failure.errorMessage)),
      (routines) => emit(RoutineGetAllSuccess(routines)),
    );
  }
}

// ✅ UI reactiva y limpia
class RoutinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoutineCubit, RoutineState>(
      builder: (context, state) {
        return switch (state) {
          RoutineLoading() => CircularProgressIndicator(),
          RoutineGetAllSuccess() => RoutineList(routines: state.routines),
          RoutineError() => ErrorWidget(message: state.message),
          _ => Container(),
        };
      },
    );
  }
}
```

### **5.3 Estados Inmutables**

**❌ Estado mutable (problemático):**

```dart
class RoutineState {
  List<Routine> routines;
  bool isLoading;
  String? error;

  RoutineState({
    required this.routines,
    required this.isLoading,
    this.error,
  });
}
```

**✅ Estados inmutables con sealed classes:**

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

### **5.4 Cubits vs BLoCs - ¿Cuándo usar cada uno?**

**Cubit (más simple):**

```dart
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}
```

**BLoC (más complejo, con eventos):**

```dart
abstract class CounterEvent {}
class Increment extends CounterEvent {}
class Decrement extends CounterEvent {}

class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<Increment>((event, emit) => emit(state + 1));
    on<Decrement>((event, emit) => emit(state - 1));
  }
}
```

**Usa Cubit cuando:**

- La lógica es simple
- No necesitas eventos complejos
- Quieres código más limpio y directo

**Usa BLoC cuando:**

- Necesitas eventos complejos
- Quieres traceabilidad completa
- Tienes lógica de negocio muy compleja

---

## ⚡ **6. PROGRAMACIÓN FUNCIONAL - EITHER PATTERN**

### **6.1 ¿Qué problema resuelve Either?**

**Problemas con excepciones tradicionales:**

```dart
// ❌ Problema: Errores ocultos
Future<List<Routine>> getRoutines() async {
  // ¿Qué errores puede lanzar? No está claro
  final result = await api.getRoutines(); // Puede lanzar HttpException
  return result; // Puede lanzar FormatException
}

// ❌ Uso: Fácil ignorar errores
try {
  final routines = await getRoutines();
  // Usar routines...
} catch (e) {
  // ¿Qué tipo de error es? ¿Cómo manejarlo?
  print('Algo salió mal: $e');
}
```

**✅ Solución con Either:**

```dart
// ✅ Errores explícitos en la signatura
Future<Either<Failure, List<Routine>>> getRoutines() async {
  try {
    final result = await api.getRoutines();
    return Right(result); // Éxito
  } on HttpException catch (e) {
    return Left(ServerFailure(errorMessage: e.message)); // Error específico
  } on FormatException catch (e) {
    return Left(ParsingFailure(errorMessage: e.message)); // Error específico
  }
}

// ✅ Uso: Imposible ignorar errores
final result = await getRoutines();
result.fold(
  (failure) {
    // Manejo explícito de errores
    switch (failure.runtimeType) {
      case ServerFailure:
        showSnackBar('Error de servidor');
        break;
      case ParsingFailure:
        showSnackBar('Error de datos');
        break;
    }
  },
  (routines) {
    // Usar datos exitosos
    displayRoutines(routines);
  },
);
```

### **6.2 Tipos de Failure en GyMaster**

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

class CacheFailure extends Failure {
  const CacheFailure({required String errorMessage})
      : super(errorMessage: errorMessage);
}

class NoRecordsFailure extends Failure {
  const NoRecordsFailure({required String errorMessage})
      : super(errorMessage: errorMessage);
}
```

### **6.3 Composición Funcional**

**Encadenamiento de operaciones:**

```dart
Future<Either<Failure, String>> processRoutine() async {
  final routineResult = await getRoutine();

  return routineResult.fold(
    (failure) => Left(failure), // Propagar error
    (routine) async {
      final validationResult = validateRoutine(routine);

      return validationResult.fold(
        (failure) => Left(failure), // Propagar error de validación
        (validRoutine) async {
          final saveResult = await saveRoutine(validRoutine);

          return saveResult.fold(
            (failure) => Left(failure), // Propagar error de guardado
            (savedRoutine) => Right('Rutina procesada: ${savedRoutine.name}'),
          );
        },
      );
    },
  );
}
```

---

## 🔌 **7. INYECCIÓN DE DEPENDENCIAS**

### **7.1 ¿Qué es y por qué es importante?**

**Sin inyección de dependencias:**

```dart
class RoutineCubit extends Cubit<RoutineState> {
  // ❌ Dependencias hardcodeadas
  final repository = RoutineRepositoryImpl();
  final useCase = GetAllRoutineUsecase(repository);

  // ❌ Difícil de testear
  // ❌ Acoplado a implementaciones específicas
  // ❌ No se puede intercambiar implementaciones
}
```

**✅ Con inyección de dependencias:**

```dart
class RoutineCubit extends Cubit<RoutineState> {
  // ✅ Dependencias inyectadas
  final GetAllRoutineUsecase getAllRoutineUseCase;

  RoutineCubit({required this.getAllRoutineUseCase}) : super(RoutineInitial());

  // ✅ Fácil de testear con mocks
  // ✅ Desacoplado de implementaciones
  // ✅ Se pueden intercambiar implementaciones
}
```

### **7.2 Service Locator Pattern con GetIt**

**¿Qué es GetIt?**  
Un service locator simple para Dart y Flutter que permite registrar y recuperar dependencias.

**Registro de dependencias:**

```dart
final serviceLocator = GetIt.instance;

void initDependencies() {
  // 1. Core dependencies
  serviceLocator.registerLazySingleton<DatabaseHelper>(
    () => DatabaseHelper.instance,
  );

  // 2. Data layer
  serviceLocator.registerFactory<RoutineLocalDataSource>(
    () => RoutineLocalDataSource(serviceLocator()),
  );

  serviceLocator.registerFactory<RoutineRepository>(
    () => RoutineRepositoryImpl(
      localDataSource: serviceLocator(),
      idGenerator: serviceLocator(),
    ),
  );

  // 3. Domain layer
  serviceLocator.registerFactory(
    () => GetAllRoutineUsecase(serviceLocator()),
  );

  // 4. Presentation layer
  serviceLocator.registerFactory(
    () => RoutineCubit(
      getAllRoutineUseCase: serviceLocator(),
    ),
  );
}
```

### **7.3 Tipos de Registro**

**Factory:**

```dart
// Nueva instancia cada vez que se solicita
serviceLocator.registerFactory<RoutineCubit>(
  () => RoutineCubit(getAllRoutineUseCase: serviceLocator()),
);
```

**LazySingleton:**

```dart
// Una sola instancia, creada cuando se solicita por primera vez
serviceLocator.registerLazySingleton<DatabaseHelper>(
  () => DatabaseHelper.instance,
);
```

**Singleton:**

```dart
// Una sola instancia, creada inmediatamente
serviceLocator.registerSingleton<Logger>(
  Logger(),
);
```

### **7.4 Beneficios de DI en GyMaster**

1. **Testing:** Inyectar mocks fácilmente
2. **Flexibilidad:** Cambiar implementaciones sin modificar código
3. **Configuración:** Una sola place para configurar todas las dependencias
4. **Lazy loading:** Las dependencias se crean solo cuando se necesitan
5. **Gestión de memoria:** Control sobre el ciclo de vida de objetos

---

## 💾 **8. BASE DE DATOS Y PERSISTENCIA**

### **8.1 SQLite Fundamentals**

**¿Qué es SQLite?**  
Base de datos SQL embebida, serverless, que no requiere configuración.

**Ventajas:**

- ✅ No requiere servidor
- ✅ Multiplataforma
- ✅ ACID compliant
- ✅ Muy rápida para aplicaciones locales
- ✅ Footprint pequeño

**En GyMaster:**

```dart
class DatabaseHelper {
  static const int _databaseVersion = 1;
  static const String _databaseName = 'gymaster.db';

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createDatabase,
      onUpgrade: _upgradeDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE routine (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        fechaCreacion TEXT NOT NULL,
        echo INTEGER NOT NULL,
        color INTEGER NOT NULL
      )
    ''');
  }
}
```

### **8.2 Data Model vs Domain Entity**

**¿Por qué separar?**

- Domain entities son conceptos de negocio puros
- Data models son representaciones técnicas para persistencia

**Domain Entity:**

```dart
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

  // Lógica de dominio
  bool get isCompleted => echo;

  Duration get age => DateTime.now().difference(fechaCreacion);
}
```

**Data Model:**

```dart
class RoutineDbModel {
  static const String table = 'routine';
  static const String columnId = 'id';
  static const String columnName = 'name';
  static const String columnDescription = 'description';
  static const String columnFechaCreacion = 'fechaCreacion';
  static const String columnEcho = 'echo';
  static const String columnColor = 'color';

  final String? id;
  final String name;
  final String? description;
  final String fechaCreacion; // String para SQLite
  final int echo;             // int para SQLite (0/1)
  final int color;

  // Conversión a Entity
  Routine toEntity() {
    return Routine(
      id: id,
      name: name,
      description: description,
      fechaCreacion: DateTime.parse(fechaCreacion),
      echo: echo == 1,
      color: color,
    );
  }

  // Conversión desde Entity
  factory RoutineDbModel.fromEntity(Routine routine) {
    return RoutineDbModel(
      id: routine.id,
      name: routine.name,
      description: routine.description,
      fechaCreacion: routine.fechaCreacion.toIso8601String(),
      echo: routine.echo ? 1 : 0,
      color: routine.color,
    );
  }

  // Conversión a/desde Map para SQLite
  Map<String, dynamic> toMap() {
    return {
      columnId: id,
      columnName: name,
      columnDescription: description,
      columnFechaCreacion: fechaCreacion,
      columnEcho: echo,
      columnColor: color,
    };
  }

  factory RoutineDbModel.fromMap(Map<String, dynamic> map) {
    return RoutineDbModel(
      id: map[columnId],
      name: map[columnName],
      description: map[columnDescription],
      fechaCreacion: map[columnFechaCreacion],
      echo: map[columnEcho],
      color: map[columnColor],
    );
  }
}
```

### **8.3 Transacciones y Consistencia**

**¿Cuándo usar transacciones?**

- Operaciones que involucran múltiples tablas
- Operaciones que deben ser atómicas (todo o nada)

**Ejemplo:**

```dart
Future<void> addRoutineWithExercises(
  Routine routine,
  List<Exercise> exercises,
) async {
  final db = await database;

  await db.transaction((txn) async {
    // 1. Insertar rutina
    await txn.insert('routine', RoutineDbModel.fromEntity(routine).toMap());

    // 2. Insertar ejercicios
    for (final exercise in exercises) {
      await txn.insert('exercise', ExerciseDbModel.fromEntity(exercise).toMap());
    }

    // 3. Crear relaciones
    for (final exercise in exercises) {
      await txn.insert('routine_exercise', {
        'routine_id': routine.id,
        'exercise_id': exercise.id,
      });
    }

    // Si cualquier operación falla, todo se revierte automáticamente
  });
}
```

---

## 🎨 **9. UI/UX Y DESIGN SYSTEMS**

### **9.1 Diseño Emocional (Donald Norman)**

**Los 3 niveles del diseño:**

**Visceral (instintivo):**

- Primera impresión
- Atracción estética
- Reacción emocional inmediata

```dart
// Colores que evocan energía y motivación
class AppColors {
  static const Color primario = Color(0xFF6B46C1);     // Púrpura energético
  static const Color energiaOrange = Color(0xFFFF6B35); // Naranja motivacional
  static const Color exitoVerde = Color(0xFF27AE60);    // Verde logro
}
```

**Conductual (usabilidad):**

- Funcionalidad
- Comprensibilidad
- Eficiencia de uso

```dart
// Feedback inmediato y microinteracciones
class ChicletButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      // Cambio visual inmediato al presionar
      transform: isPressed
        ? (Matrix4.identity()..scale(0.95))
        : Matrix4.identity(),
      child: Material(
        // Ripple effect para feedback táctil
        child: InkWell(
          onTap: onPressed,
          child: Container(/* contenido */),
        ),
      ),
    );
  }
}
```

**Reflexivo (significado):**

- Autoimagen
- Satisfacción personal
- Memories

```dart
// Mensajes que generan orgullo y conexión emocional
class SuccessMessage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '¡Rutina completada! 💪',
          style: TipografiaGyMaster.titulo.copyWith(
            color: AppColors.exitoVerde,
          ),
        ),
        Text(
          'Has entrenado ${diasConsecutivos} días seguidos',
          style: TipografiaGyMaster.textoPrincipal,
        ),
        // Generar orgullo y sentido de logro
      ],
    );
  }
}
```

### **9.2 Sistema de Espaciado (Regla de 8 puntos)**

**¿Por qué 8 puntos?**

- Mayoría de pantallas son múltiplos de 8
- Crea ritmo visual consistente
- Facilita responsive design
- Reduce decisiones arbitrarias

**Implementación:**

```dart
class Espaciado {
  static const double cero = 0;
  static const double xxs = 4;   // 0.5 × 8
  static const double xs = 8;    // 1 × 8
  static const double sm = 16;   // 2 × 8
  static const double md = 24;   // 3 × 8
  static const double lg = 32;   // 4 × 8
  static const double xl = 40;   // 5 × 8
  static const double xxl = 48;  // 6 × 8
}

// Uso consistente en toda la app
Widget buildCard() {
  return Container(
    margin: EdgeInsets.all(Espaciado.md),     // 24px
    padding: EdgeInsets.all(Espaciado.lg),    // 32px
    child: Column(
      spacing: Espaciado.sm,                   // 16px entre elementos
      children: [...],
    ),
  );
}
```

### **9.3 Tipografía Limitada**

**¿Por qué limitar tamaños y pesos?**

- Consistencia visual
- Jerarquía clara
- Reduce decisions fatigue
- Facilita mantenimiento

**Sistema tipográfico:**

```dart
class TipografiaGyMaster {
  // Solo 6 tamaños permitidos
  static const double tamanoXs = 12.0;   // Labels, badges
  static const double tamanoSm = 14.0;   // Botones, inputs
  static const double tamanoMd = 16.0;   // Texto base
  static const double tamanoLg = 18.0;   // Subtítulos
  static const double tamanoXl = 20.0;   // Títulos
  static const double tamano2xl = 24.0;  // Hero titles

  // Solo 3 pesos permitidos
  static const FontWeight pesoLigero = FontWeight.w300;
  static const FontWeight pesoRegular = FontWeight.w400;
  static const FontWeight pesoSemiBold = FontWeight.w600;

  // Estilos predefinidos
  static TextStyle get textoPrincipal => TextStyle(
    fontSize: tamanoMd,
    fontWeight: pesoRegular,
    color: AppColors.textoPrincipal,
  );

  static TextStyle get titulo => TextStyle(
    fontSize: tamanoXl,
    fontWeight: pesoSemiBold,
    color: AppColors.textoPrincipal,
  );
}
```

### **9.4 Componentes Reutilizables**

**Design Token Approach:**

```dart
enum TamanoBotonChiclet { pequeno, regular, grande }

class ChicletButton extends StatelessWidget {
  final String texto;
  final VoidCallback? onPressed;
  final Color colorFondo;
  final Color colorTexto;
  final TamanoBotonChiclet tamano;
  final bool conSombreado;

  // Configuración basada en design tokens
  double get _altura {
    return switch (tamano) {
      TamanoBotonChiclet.pequeno => 40.0,
      TamanoBotonChiclet.regular => 48.0,
      TamanoBotonChiclet.grande => 56.0,
    };
  }

  double get _fontSize {
    return switch (tamano) {
      TamanoBotonChiclet.pequeno => TipografiaGyMaster.tamanoSm,
      TamanoBotonChiclet.regular => TipografiaGyMaster.tamanoMd,
      TamanoBotonChiclet.grande => TipografiaGyMaster.tamanoLg,
    };
  }
}
```

---

## 🏢 **10. ARQUITECTURA DE SOFTWARE EMPRESARIAL**

### **10.1 Escalabilidad**

**Escalabilidad Horizontal:**

- Añadir más features sin afectar existentes
- Equipos trabajando en paralelo
- Módulos independientes

**En GyMaster:**

```
features/
├── routine/          # Equipo A puede trabajar aquí
├── exercise/         # Equipo B puede trabajar aquí
├── record/           # Equipo C puede trabajar aquí
├── setting/          # Equipo D puede trabajar aquí
└── estadisticas/     # Equipo E puede trabajar aquí
```

**Escalabilidad Vertical:**

- Manejar más datos
- Mejor performance
- Optimizaciones

### **10.2 Mantenibilidad**

**Separación de responsabilidades:**

```dart
// ❌ Dificil de mantener
class RoutineManager {
  Future<void> addRoutine(String name) async {
    // Validación
    if (name.isEmpty) throw Exception('Name required');

    // Persistencia
    final db = await openDatabase('gymaster.db');
    await db.insert('routine', {'name': name});

    // UI update
    setState(() {
      routines.add(Routine(name: name));
    });

    // Analytics
    analytics.track('routine_added');
  }
}

// ✅ Fácil de mantener (responsabilidades separadas)
class AddRoutineUseCase {
  Future<Either<Failure, Routine>> call(AddRoutineParams params) async {
    // Solo lógica de caso de uso
    return await repository.addRoutine(params);
  }
}

class RoutineValidator {
  ValidationResult validate(String name) {
    // Solo validación
  }
}

class RoutineCubit {
  Future<void> addRoutine(AddRoutineParams params) async {
    // Solo gestión de estado UI
  }
}
```

### **10.3 Testabilidad**

**Architecture for Testing:**

```dart
// ✅ Testeable por diseño
class GetAllRoutineUsecase {
  final RoutineRepository repository;

  GetAllRoutineUsecase(this.repository);

  Future<Either<Failure, List<Routine>>> call(NoParams params) async {
    return await repository.getAllRoutine();
  }
}

// Test
void main() {
  group('GetAllRoutineUsecase', () {
    late GetAllRoutineUsecase usecase;
    late MockRoutineRepository mockRepository;

    setUp(() {
      mockRepository = MockRoutineRepository();
      usecase = GetAllRoutineUsecase(mockRepository);
    });

    test('should return routines when repository call is successful', () async {
      // Arrange
      final routines = [Routine(name: 'Test')];
      when(() => mockRepository.getAllRoutine())
          .thenAnswer((_) async => Right(routines));

      // Act
      final result = await usecase(NoParams());

      // Assert
      expect(result, Right(routines));
      verify(() => mockRepository.getAllRoutine()).called(1);
    });
  });
}
```

### **10.4 Performance Considerations**

**Lazy Loading:**

```dart
class ServiceLocator {
  // No se crea hasta que se necesita
  static DatabaseHelper? _databaseHelper;

  static DatabaseHelper get databaseHelper {
    return _databaseHelper ??= DatabaseHelper.instance;
  }
}
```

**Efficient State Management:**

```dart
class RoutineCubit extends Cubit<RoutineState> {
  Future<void> updateRoutine(String id, String newName) async {
    final currentState = state;

    if (currentState is RoutineGetAllSuccess) {
      // Actualización optimista
      final updatedRoutines = currentState.routines.map((routine) {
        return routine.id == id
          ? routine.copyWith(name: newName)
          : routine;
      }).toList();

      emit(RoutineGetAllSuccess(updatedRoutines));

      // Persistir en background
      final result = await updateRoutineUseCase(UpdateRoutineParams(id, newName));

      // Revertir si falla
      if (result.isLeft()) {
        emit(currentState); // Revertir al estado anterior
        emit(RoutineError('Failed to update routine'));
      }
    }
  }
}
```

---

## 🎯 **CONCEPTOS CLAVE PARA RECORDAR**

### **Arquitectura:**

1. **Clean Architecture:** Capas con dependencias hacia adentro
2. **SOLID:** Principios que guían el diseño de clases
3. **Repository Pattern:** Abstrae el acceso a datos
4. **UseCase Pattern:** Encapsula lógica de negocio específica

### **Flutter/Dart:**

1. **Null Safety:** Tipos que no pueden ser null a menos que se especifique
2. **Sealed Classes:** Pattern matching exhaustivo
3. **Immutability:** Objetos que no cambian después de creados
4. **Extension Methods:** Añadir funcionalidad a tipos existentes

### **Estado:**

1. **BLoC/Cubit:** Separación de lógica de negocio y UI
2. **Estados inmutables:** Predictibles y fáciles de debuggear
3. **Reactive Programming:** UI reacciona automáticamente a cambios

### **Funcional:**

1. **Either Pattern:** Errores explícitos en place de excepciones
2. **Composition:** Combinar funciones pequeñas en operaciones complejas
3. **Immutability:** Evitar efectos secundarios

### **DI:**

1. **Service Locator:** GetIt para gestionar dependencias
2. **Inversion of Control:** Dependencias inyectadas desde afuera
3. **Factory vs Singleton:** Cuándo crear nuevas instancias vs reutilizar

---

## 🚀 **CÓMO USAR ESTA GUÍA**

1. **Lee sección por sección** - No intentes memorizar todo de una vez
2. **Conecta con tu código** - Ve al código de GyMaster y encuentra ejemplos
3. **Practica explicando** - Explica cada concepto en voz alta
4. **Haz conexiones** - Relaciona conceptos entre sí (ej: SOLID con Clean Architecture)
5. **Prepara ejemplos** - Ten ejemplos específicos de tu código para cada concepto

**¡Con estos fundamentos teóricos, podrás explicar con confianza cada aspecto técnico de GyMaster en tu presentación!** 🎯
