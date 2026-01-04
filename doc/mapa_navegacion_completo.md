# 🗺️ Mapa Completo de Navegación - GyMaster (DETALLADO)

## 🎯 Diagrama Completo del Flujo de Navegación

```mermaid
graph TD
    Start["🚀 INICIO DE APLICACIÓN<br/>(/)<br/>AppStartPage"]

    Start --> CheckOnboarding{¿Primer acceso?}

    CheckOnboarding -->|SÍ| Onboarding["👋 ONBOARDING BIENVENIDA<br/>(/onboarding)<br/>OnboardingBienvenidaPage"]
    CheckOnboarding -->|NO| MainApp["📱 APP PRINCIPAL<br/>(/main)<br/>BottomNavigationBarExampleApp"]

    Onboarding --> OnboardingUnificado["📋 ONBOARDING UNIFICADO<br/>(/onboarding_unificado)<br/>OnboardingContenedorUnificadoPage"]
    OnboardingUnificado --> MainApp

    MainApp --> BottomNav{Seleccionar Tab}

    BottomNav -->|Tab 0| ListaRutinas["💪 LISTA DE RUTINAS<br/>(/main?tab=0)<br/>ListaRutinasPage"]
    BottomNav -->|Tab 1| Favoritos["❤️ FAVORITOS<br/>(/main?tab=1)<br/>FavoritesPage"]
    BottomNav -->|Tab 2| Catalogo["📚 CATÁLOGO DE EJERCICIOS<br/>(/main?tab=2)<br/>ExerciseCatalogPage"]
    BottomNav -->|Tab 3| Historial["📊 HISTORIAL Y ESTADÍSTICAS<br/>(/main?tab=3)<br/>HistorialConEstadisticasPage"]
    BottomNav -->|Tab 4| Configuracion["⚙️ CONFIGURACIÓN<br/>(/main?tab=4)<br/>SettingPage"]

    %% Rutas de Rutinas
    ListaRutinas --> RutinasAccion{Acción}
    RutinasAccion -->|Crear| AgregarRutina["➕ CREAR RUTINA<br/>(/rutina/create)<br/>AgregarRutinaPage"]
    RutinasAccion -->|Ver Detalle| DetalleRutina["📄 DETALLE RUTINA<br/>(/rutina/detalle/:rutinaId)<br/>DetalleRutinaScreen"]

    AgregarRutina --> MainApp
    DetalleRutina --> DetalleAccion{Acción}
    DetalleAccion -->|Agregar Ejercicio| AgregarEjercicio["🏋️ AGREGAR EJERCICIOS<br/>(/agregar-ejercicios/:rutinaId/:sesionId)<br/>AgregarEjerciciosPage"]
    DetalleAccion -->|Ejecutar Rutina| EjecutarRutina["▶️ EJECUTAR RUTINA"]

    AgregarEjercicio --> SeleccionarMusculo["🔍 LISTAR EJERCICIOS<br/>(/listar-ejercicios/:musculoId<br/>:nombreMusculo:rutinaId:sesionId)<br/>ListarEjerciciosPage"]

    SeleccionarMusculo --> AgregarEjercicioRutina["➕ AGREGAR EJERCICIO RUTINA<br/>(/agregar-ejercicio-rutina<br/>:rutinaId:ejercicioId<br/>:ejercicioNombre:sesionId)<br/>AgregarEjercicioRutinaPage"]

    AgregarEjercicioRutina --> DetalleEjercicio["📋 DETALLE EJERCICIO<br/>(/detalle-ejercicio)<br/>DetalleEjercicioScreen"]

    DetalleEjercicio --> VolverRutina{¿Continuar?}
    VolverRutina -->|Sí| DetalleRutina
    VolverRutina -->|No| ListaRutinas

    %% Rutas de Catálogo y Favoritos
    Catalogo --> CatalogoAccion{Acción}
    CatalogoAccion -->|Ver Detalle| DetalleEjercicioCatalogo["📖 DETALLE EJERCICIO<br/>(/exercise-detail)<br/>ExerciseDetailPage"]

    DetalleEjercicioCatalogo --> DetalleAction{Acción}
    DetalleAction -->|Agregar a Favoritos| AgregarFavorito["❤️ AGREGAR A FAVORITOS"]
    DetalleAction -->|Agregar a Rutina| AgregarARutina["➕ AGREGAR A RUTINA"]

    AgregarFavorito --> Favoritos
    AgregarARutina --> ListaRutinas

    Favoritos --> FavAccion{Acción}
    FavAccion -->|Ver Detalle| DetalleEjercicioCatalogo
    FavAccion -->|Eliminar| EliminarFav["🗑️ ELIMINAR FAVORITO"]
    EliminarFav --> Favoritos

    %% Rutas de Historial
    Historial --> HistorialAccion{Ver}
    HistorialAccion -->|Detalles| HistorialEjercicio["📋 HISTORIAL DE EJERCICIOS<br/>(/record)<br/>HistorialEjerciciosPage"]
    HistorialEjercicio --> Historial

    %% Rutas de Configuración
    Configuracion --> ConfigAccion{Acción}
    ConfigAccion -->|Cambiar Tema| CambiarTema["🌙 CAMBIAR TEMA"]
    ConfigAccion -->|Idioma| CambiarIdioma["🌐 CAMBIAR IDIOMA"]

    CambiarTema --> Configuracion
    CambiarIdioma --> Configuracion

    %% Estilos
    style Start fill:#FF6B6B,color:#fff,stroke:#333,stroke-width:3px
    style Onboarding fill:#FF8787,color:#fff
    style OnboardingUnificado fill:#FFAB91,color:#fff
    style MainApp fill:#4ECDC4,color:#fff,stroke:#333,stroke-width:2px

    style ListaRutinas fill:#45B7D1,color:#fff
    style AgregarRutina fill:#56C596,color:#fff
    style DetalleRutina fill:#4DA6FF,color:#fff
    style AgregarEjercicio fill:#FFD93D,color:#000
    style SeleccionarMusculo fill:#6BCB77,color:#fff
    style AgregarEjercicioRutina fill:#FF6B9D,color:#fff
    style DetalleEjercicio fill:#C44569,color:#fff

    style Catalogo fill:#98D8C8,color:#fff
    style DetalleEjercicioCatalogo fill:#87CEEB,color:#000
    style Favoritos fill:#FFA07A,color:#fff

    style Historial fill:#F7DC6F,color:#000
    style HistorialEjercicio fill:#F4D03F,color:#000

    style Configuracion fill:#BB8FCE,color:#fff
```

---

## 📊 Tabla Completa de Rutas

| #   | Ruta                                                                          | Nombre                 | Página                            | Descripción                                       | Parámetros                                                                         |
| --- | ----------------------------------------------------------------------------- | ---------------------- | --------------------------------- | ------------------------------------------------- | ---------------------------------------------------------------------------------- |
| 1   | `/`                                                                           | appStart               | AppStartPage                      | Pantalla inicial que verifica si es primer acceso | -                                                                                  |
| 2   | `/onboarding`                                                                 | onboarding             | OnboardingBienvenidaPage          | Primera pantalla de bienvenida                    | -                                                                                  |
| 3   | `/onboarding_unificado`                                                       | onboarding_unificado   | OnboardingContenedorUnificadoPage | Onboarding completo unificado                     | -                                                                                  |
| 4   | `/main`                                                                       | listaRutinas           | BottomNavigationBarExampleApp     | Navegación principal con tabs                     | tab (0-4)                                                                          |
| 5   | `/exercise-catalog`                                                           | exerciseCatalog        | BottomNavigationBarExampleApp     | Acceso directo al catálogo (Tab 2)                | -                                                                                  |
| 6   | `/dialog-loading`                                                             | dialogLoading          | LoadingDialogPage                 | Diálogo de carga                                  | -                                                                                  |
| 7   | `/settings`                                                                   | settings               | SettingPage                       | Configuración de la aplicación                    | -                                                                                  |
| 8   | `/rutina/create`                                                              | rutinaCreate           | AgregarRutinaPage                 | Crear nueva rutina                                | -                                                                                  |
| 9   | `/rutina/detalle/:rutinaId`                                                   | detallerutina          | DetalleRutinaScreen               | Ver detalles de una rutina                        | rutinaId                                                                           |
| 10  | `/agregar-ejercicios/:rutinaId/:sesionId`                                     | agregarEjercicios      | AgregarEjerciciosPage             | Agregar ejercicios a rutina                       | rutinaId, sesionId                                                                 |
| 11  | `/listar-ejercicios/:musculoId/:nombreMusculo/:rutinaId/:sesionId`            | listarEjercicios       | ListarEjerciciosPage              | Listar ejercicios por músculo                     | musculoId, nombreMusculo, rutinaId, sesionId                                       |
| 12  | `/agregar-ejercicio-rutina/:rutinaId/:ejercicioId/:ejercicioNombre/:sesionId` | agregarEjercicioRutina | AgregarEjercicioRutinaPage        | Agregar ejercicio específico                      | rutinaId, ejercicioId, ejercicioNombre, sesionId + extra: ejercicioImagenDireccion |
| 13  | `/detalle-ejercicio`                                                          | detalleEjercicio       | DetalleEjercicioScreen            | Detalle del ejercicio en rutina                   | -                                                                                  |
| 14  | `/lista-rutinas-screen`                                                       | listaRutinasScreen     | ListaRutinasPage                  | Pantalla lista de rutinas                         | -                                                                                  |
| 15  | `/exercise-detail`                                                            | exerciseDetail         | ExerciseDetailPage                | Detalle del ejercicio en catálogo                 | extra: Exercise                                                                    |
| 16  | `/favorites`                                                                  | favorites              | FavoritesPage                     | Pantalla de favoritos                             | -                                                                                  |
| 17  | `/record`                                                                     | -                      | HistorialEjerciciosPage           | Historial de ejercicios                           | -                                                                                  |

---

## 🎯 Flujos de Navegación Principales

### Flujo 1: Primer Acceso (New User)

```mermaid
sequenceDiagram
    participant User
    participant App as AppStartPage
    participant OnB1 as OnboardingBienvenida
    participant OnB2 as OnboardingUnificado
    participant Main as MainApp

    User->>App: Abre aplicación
    App->>App: Detecta primer acceso
    App->>OnB1: Navega a onboarding
    OnB1->>OnB2: Continúa con onboarding
    OnB2->>Main: Completa onboarding
    Main->>User: Mostrar app principal
```

### Flujo 2: Usuario Habitual

```mermaid
sequenceDiagram
    participant User
    participant App as AppStartPage
    participant Main as MainApp

    User->>App: Abre aplicación
    App->>App: Detecta que ya pasó onboarding
    App->>Main: Navega directamente
    Main->>User: Mostrar app principal
```

### Flujo 3: Crear y Agregar Ejercicios a Rutina

```mermaid
sequenceDiagram
    participant User
    participant Main as MainApp
    participant ListaRutinas as ListaRutinasPage
    participant AgregarRutina as AgregarRutinaPage
    participant DetalleRutina as DetalleRutinaScreen
    participant AgregarEj as AgregarEjerciciosPage
    participant ListarEj as ListarEjerciciosPage
    participant AgregarEjRut as AgregarEjercicioRutinaPage

    User->>Main: Selecciona Tab 0
    Main->>ListaRutinas: Muestra lista
    User->>ListaRutinas: Clic en "Crear Rutina"
    ListaRutinas->>AgregarRutina: Navega a crear
    User->>AgregarRutina: Completa datos
    AgregarRutina->>DetalleRutina: Navega a detalle
    User->>DetalleRutina: Clic "Agregar Ejercicio"
    DetalleRutina->>AgregarEj: Navega a agregar
    User->>AgregarEj: Selecciona músculo
    AgregarEj->>ListarEj: Muestra ejercicios
    User->>ListarEj: Selecciona ejercicio
    ListarEj->>AgregarEjRut: Navega a configurar
    User->>AgregarEjRut: Configura serie/repeticiones
    AgregarEjRut->>DetalleRutina: Guardar y volver
```

### Flujo 4: Explorar Catálogo y Agregar Favoritos

```mermaid
sequenceDiagram
    participant User
    participant Main as MainApp
    participant Catalogo as ExerciseCatalogPage
    participant DetalleEj as ExerciseDetailPage
    participant Favoritos as FavoritesPage

    User->>Main: Selecciona Tab 2
    Main->>Catalogo: Muestra catálogo
    User->>Catalogo: Busca ejercicio
    Catalogo->>DetalleEj: Muestra detalle
    User->>DetalleEj: Clic "Agregar a Favoritos"
    DetalleEj->>DetalleEj: Agrega a favoritos
    User->>Main: Selecciona Tab 1
    Main->>Favoritos: Muestra favoritos
    User->>Favoritos: Ve su ejercicio guardado
```

---

## 🔄 Interconexiones de Módulos

```mermaid
graph LR
    Setting["⚙️ SETTING<br/>Configuración<br/>Onboarding"]
    Routine["💪 ROUTINE<br/>Gestión de Rutinas<br/>Ejercicios"]
    Exercise["📚 EXERCISE<br/>Catálogo<br/>Favoritos"]
    Record["📊 RECORD<br/>Historial<br/>Estadísticas"]

    Setting ---|Flujo inicial| Routine
    Setting ---|En cualquier momento| Setting

    Routine ---|Agregar a favoritos| Exercise
    Routine ---|Consultar histórico| Record

    Exercise ---|Usar en rutina| Routine
    Exercise ---|Ver histórico| Record

    Record ---|Ir a rutina| Routine
    Record ---|Ir a catálogo| Exercise

    style Setting fill:#BB8FCE,color:#fff
    style Routine fill:#45B7D1,color:#fff
    style Exercise fill:#98D8C8,color:#fff
    style Record fill:#F7DC6F,color:#000
```

---

## 🧭 Navegación por Parámetros

### Path Parameters

```
:rutinaId           → ID único de la rutina
:sesionId           → ID único de la sesión de ejercicios
:musculoId          → ID único del grupo muscular
:nombreMusculo      → Nombre descriptivo del músculo
:ejercicioId        → ID único del ejercicio
:ejercicioNombre    → Nombre descriptivo del ejercicio
```

### Query Parameters

```
tab=0 → ListaRutinasPage (Rutinas)
tab=1 → FavoritesPage (Favoritos)
tab=2 → ExerciseCatalogPage (Catálogo)
tab=3 → HistorialConEstadisticasPage (Historial)
tab=4 → SettingPage (Configuración)
```

### Extra Data

```
Exercise            → Objeto Exercise completo pasado en state.extra
ejercicioImagenDireccion → URL de la imagen del ejercicio en extra
```

---

## 📱 Estado Management y Navegación

### Cubits Principales

```mermaid
graph TD
    RoutineCubit["💪 RoutineCubit<br/>Gestionar rutinas"]
    SeriesCubit["📊 SeriesCubit<br/>Gestionar series"]
    MusculoCubit["🔍 MusculoCubit<br/>Listar músculos"]
    EjercicioCubit["🏋️ EjercicioCubit<br/>Listar ejercicios"]

    AgregarSeriesCubit["➕ AgregarSeriesCubit<br/>Agregar series"]
    EjerciciosByRutinaCubit["📋 EjerciciosByRutinaCubit<br/>Ejercicios por rutina"]
    RealizacionCubit["📝 RealizacionEjercicioCubit<br/>Registrar realización"]
    RealizarRutinaCubit["▶️ RealizarEjercicioRutinaCubit<br/>Ejecutar rutina"]

    SettingCubit["⚙️ SettingCubit<br/>Tema/Idioma"]
    AppStartCubit["🚀 AppStartCubit<br/>Control de onboarding"]
    OnboardingCubit["👋 OnboardingCubit<br/>Onboarding"]

    RecordCubit["📊 RecordCubit<br/>Historial"]
    SelectedRoutineCubit["✓ SelectedRoutineCubit<br/>Rutina seleccionada"]

    ExerciseCubit["📚 ExerciseCubit<br/>Catálogo"]
    FavoritosCubit["❤️ FavoritoEjercicioCubit<br/>Favoritos"]

    style RoutineCubit fill:#45B7D1,color:#fff
    style SeriesCubit fill:#4DA6FF,color:#fff
    style MusculoCubit fill:#6BCB77,color:#fff
    style EjercicioCubit fill:#FFD93D,color:#000

    style AgregarSeriesCubit fill:#FF6B9D,color:#fff
    style EjerciciosByRutinaCubit fill:#C44569,color:#fff
    style RealizacionCubit fill:#9B4D4D,color:#fff
    style RealizarRutinaCubit fill:#FF8C42,color:#fff

    style SettingCubit fill:#BB8FCE,color:#fff
    style AppStartCubit fill:#FF6B6B,color:#fff
    style OnboardingCubit fill:#FF8787,color:#fff

    style RecordCubit fill:#F7DC6F,color:#000
    style SelectedRoutineCubit fill:#F4D03F,color:#000

    style ExerciseCubit fill:#98D8C8,color:#fff
    style FavoritosCubit fill:#FFA07A,color:#fff
```

---

## ⚠️ Puntos Críticos de Navegación

1. **AppStartPage** - Punto de entrada que determina el flujo (onboarding o main)
2. **BottomNavigationBarExampleApp** - Hub central de navegación con 5 tabs
3. **DetalleRutinaScreen** - Punto de acceso para agregar ejercicios
4. **ListarEjerciciosPage** - Filtrado de ejercicios por músculo
5. **ExerciseDetailPage** - Bridge entre catálogo y favoritos/rutinas

---

## 📌 Casos de Uso Especiales

### 1. Navegar Directamente al Catálogo

```
Ruta: /exercise-catalog
Resultado: Muestra BottomNavigationBarExampleApp con Tab 2 activo
```

### 2. Pasar Ejercicio a DetalleEjercicio

```
Ruta: /exercise-detail
Parámetro: state.extra = Exercise (objeto)
Resultado: Muestra detalle del ejercicio con opciones
```

### 3. Cargar Diálogo de Carga

```
Ruta: /dialog-loading
Resultado: Muestra pantalla de carga
```

### 4. Navegar a Tab Específico

```
Ruta: /main?tab=2
Resultado: Abre la app en el Tab 2 (Catálogo)
```

---

## 🚀 Flujo Técnico de Inicio de Sesión

```mermaid
flowchart TD
    A["Aplicación Inicia"] --> B["GoRouter Carga<br/>initialLocation: '/'"]
    B --> C["AppStartPage"]
    C --> D["AppStartCubit<br/>Verifica SharedPreferences"]
    D --> E{¿Primer Acceso?}
    E -->|Sí| F["router.go<br/>'/onboarding'"]
    E -->|No| G["router.go<br/>'/main'"]
    F --> H["OnboardingBienvenidaPage"]
    H --> I["Usuario Completa<br/>Onboarding"]
    I --> J["router.go<br/>'/onboarding_unificado'"]
    J --> K["OnboardingContenedorUnificadoPage"]
    K --> L["Marca en SharedPreferences<br/>onboarding_completo = true"]
    L --> M["router.go<br/>'/main'"]
    G --> N["BottomNavigationBarExampleApp<br/>Muestra App Principal"]
    M --> N

    style A fill:#FF6B6B,color:#fff
    style C fill:#FF8787,color:#fff
    style H fill:#FFAB91,color:#fff
    style N fill:#4ECDC4,color:#fff
```

---

**Última actualización:** 19 de octubre de 2025  
**Versión:** 2.0  
**Estado:** Análisis Completo ✅
