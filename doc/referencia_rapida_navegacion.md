# 🚀 Guía Rápida de Navegación - GyMaster

## ⚡ Referencia Rápida de Rutas

### Rutas por Módulo

#### 🚀 INICIO

```
/                              → AppStartPage (Punto de entrada)
/onboarding                    → OnboardingBienvenidaPage
/onboarding_unificado          → OnboardingContenedorUnificadoPage
/dialog-loading                → LoadingDialogPage
```

#### 📱 PRINCIPAL

```
/main                          → BottomNavigationBarExampleApp
/main?tab=0                    → Tab 0: Rutinas
/main?tab=1                    → Tab 1: Favoritos
/main?tab=2                    → Tab 2: Catálogo
/main?tab=3                    → Tab 3: Historial
/main?tab=4                    → Tab 4: Configuración
```

#### 💪 RUTINAS

```
/rutina/create                                          → AgregarRutinaPage
/rutina/detalle/:rutinaId                              → DetalleRutinaScreen
/agregar-ejercicios/:rutinaId/:sesionId                → AgregarEjerciciosPage
/listar-ejercicios/:musculoId/:nombreMusculo:...       → ListarEjerciciosPage
/agregar-ejercicio-rutina/:rutinaId:ejercicioId:...    → AgregarEjercicioRutinaPage
/detalle-ejercicio                                      → DetalleEjercicioScreen
/lista-rutinas-screen                                  → ListaRutinasPage
```

#### 📚 EJERCICIOS

```
/exercise-catalog                                      → ExerciseCatalogPage (Tab 2)
/exercise-detail                                       → ExerciseDetailPage (+ extra: Exercise)
/favorites                                             → FavoritesPage
```

#### 📊 HISTORIAL

```
/record                                                → HistorialEjerciciosPage
```

#### ⚙️ CONFIGURACIÓN

```
/settings                                              → SettingPage
```

---

## 🎯 Ejemplos de Navegación Común

### Navegar a Crear Rutina

```dart
context.go('/rutina/create');
```

### Navegar a Detalle de Rutina

```dart
context.go('/rutina/detalle/$rutinaId');
```

### Navegar a Listar Ejercicios por Músculo

```dart
context.go('/listar-ejercicios/$musculoId/$nombreMusculo/$rutinaId/$sesionId');
```

### Navegar a Agregar Ejercicio a Rutina

```dart
context.go(
  '/agregar-ejercicio-rutina/$rutinaId/$ejercicioId/$ejercicioNombre/$sesionId',
  extra: {
    'ejercicioImagenDireccion': imageUrl,
  }
);
```

### Navegar a Detalle de Ejercicio del Catálogo

```dart
context.go(
  '/exercise-detail',
  extra: exerciseObject, // Objeto Exercise
);
```

### Navegar a Tab Específico

```dart
context.go('/main?tab=2'); // Abre Tab 2 (Catálogo)
```

### Navegar al Catálogo Directamente

```dart
context.go('/exercise-catalog'); // Abre Tab 2 del catálogo
```

### Navegar al Historial

```dart
context.go('/record');
```

---

## 📊 Parámetros y Su Uso

| Parámetro                  | Tipo           | Uso                           |
| -------------------------- | -------------- | ----------------------------- |
| `rutinaId`                 | String         | ID único de la rutina         |
| `sesionId`                 | String         | ID único de la sesión         |
| `musculoId`                | String         | ID del grupo muscular         |
| `nombreMusculo`            | String         | Nombre legible del músculo    |
| `ejercicioId`              | String         | ID único del ejercicio        |
| `ejercicioNombre`          | String         | Nombre del ejercicio          |
| `tab`                      | String (query) | Número de tab (0-4)           |
| `Exercise`                 | Object (extra) | Objeto completo del ejercicio |
| `ejercicioImagenDireccion` | String (extra) | URL de la imagen              |

---

## 🎮 Cubits Principales

```dart
// Rutinas
RoutineCubit                  → Gestionar rutinas
EjerciciosByRutinaCubit       → Ejercicios por rutina
RealizacionEjercicioCubit     → Registro de realización
RealizarEjercicioRutinaCubit  → Ejecutar ejercicio

// Ejercicios
ExerciseCubit                 → Catálogo de ejercicios
FavoritoEjercicioCubit        → Gestión de favoritos
MusculoCubit                  → Músculos
EjercicioCubit                → Ejercicios individuales

// Series
SeriesCubit                   → Series de ejercicios
AgregarSeriesCubit            → Agregar nueva serie

// Configuración
SettingCubit                  → Tema, idioma, etc.
AppStartCubit                 → Control de onboarding
OnboardingCubit               → Flujo onboarding

// Historial
RecordCubit                   → Registro de ejercicios
SelectedRoutineCubit          → Rutina seleccionada
```

---

## 🔄 Flujos Principales

### Flujo 1: Crear Rutina y Agregar Ejercicios

```
1. ListaRutinasPage
   ↓
2. /rutina/create → AgregarRutinaPage
   ↓
3. /rutina/detalle/:rutinaId → DetalleRutinaScreen
   ↓
4. /agregar-ejercicios/:rutinaId/:sesionId → AgregarEjerciciosPage
   ↓
5. /listar-ejercicios/... → ListarEjerciciosPage
   ↓
6. /agregar-ejercicio-rutina/... → AgregarEjercicioRutinaPage
   ↓
7. /detalle-ejercicio → DetalleEjercicioScreen
```

### Flujo 2: Explorar Catálogo y Agregar a Favoritos

```
1. ExerciseCatalogPage (/main?tab=2)
   ↓
2. /exercise-detail → ExerciseDetailPage (+ Exercise)
   ↓
3. ❤️ Click "Agregar a Favoritos"
   ↓
4. FavoritoEjercicioCubit guarda
   ↓
5. /favorites → FavoritesPage (/main?tab=1)
```

### Flujo 3: Ver Historial

```
1. HistorialConEstadisticasPage (/main?tab=3)
   ↓
2. /record → HistorialEjerciciosPage
   ↓
3. Ver detalles de ejercicios realizados
```

---

## 🛡️ Validaciones Comunes

### Verificar si es primer acceso

```dart
// En AppStartCubit
final isFirstTime = !await SharedPreferencesService.instance
    .hasCompletedOnboarding();

if (isFirstTime) {
  context.go('/onboarding');
} else {
  context.go('/main');
}
```

### Validar parámetros de ruta

```dart
// En página que recibe parámetros
String rutinaId = state.pathParameters['rutinaId']!;
String sesionId = state.pathParameters['sesionId']!;

// Validar que existan
assert(rutinaId.isNotEmpty, 'rutinaId no puede estar vacío');
assert(sesionId.isNotEmpty, 'sesionId no puede estar vacío');
```

### Pasar objeto Exercise

```dart
// Enviando
final Exercise exercise = Exercise(...);
context.go('/exercise-detail', extra: exercise);

// Recibiendo
final exercise = state.extra as Exercise;
```

---

## 📝 Orden de Prioridad de Rutas

1. **Más Específicas** (primero en GoRouter)

   ```dart
   /rutina/detalle/:rutinaId
   /rutina/create
   ```

2. **Generales** (después)

   ```dart
   /main
   /
   ```

3. **Con Múltiples Parámetros** (al final)
   ```dart
   /listar-ejercicios/:musculoId/:nombreMusculo/:rutinaId/:sesionId
   /agregar-ejercicio-rutina/:rutinaId/:ejercicioId/:ejercicioNombre/:sesionId
   ```

---

## 🚨 Errores Comunes

| Error                | Causa               | Solución                                  |
| -------------------- | ------------------- | ----------------------------------------- |
| Ruta no encontrada   | Typo en path        | Copiar de `app_router.dart`               |
| Parámetro vacío      | No pasó parámetro   | Verificar context.go() incluya parámetros |
| Objeto null en extra | No pasó extra       | Usar `state.extra as Tipo?`               |
| Pantalla blanca      | Route duplicada     | Revisar `app_router.dart`                 |
| Atrás no funciona    | Push en lugar de go | Usar `context.go()` no `context.push()`   |

---

## ✅ Checklist para Agregar Nueva Ruta

- [ ] Agregar GoRoute en `app_router.dart`
- [ ] Crear archivo de página en `features/`
- [ ] Definir nombre único de ruta
- [ ] Agregar path con o sin parámetros
- [ ] Crear builder que instancie la página
- [ ] Extraer parámetros en builder
- [ ] Documentar en este archivo
- [ ] Probar navegación con `context.go()`

---

## 🔗 Referencias

- **GoRouter Docs:** https://pub.dev/packages/go_router
- **Flutter Navigation:** https://flutter.dev/docs/development/ui/navigation
- **BLoC Pattern:** https://bloclibrary.dev

---

**Última actualización:** 19 de octubre de 2025  
**Versión:** 1.0  
**Tipo:** Referencia Rápida 📋
