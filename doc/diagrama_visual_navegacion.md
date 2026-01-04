# 🎯 Diagrama Visual de Navegación - GyMaster

## 📊 Vista General Simplificada

```mermaid
graph TB
    subgraph ENTRADA["🚀 ENTRADA"]
        direction TB
        Start["AppStartPage<br/>(/)<br/>Inicio"]
    end

    subgraph ONBOARDING["👋 ONBOARDING<br/>(Primera Vez)"]
        direction TB
        OB1["OnboardingBienvenidaPage<br/>(/onboarding)"]
        OB2["OnboardingContenedorUnificadoPage<br/>(/onboarding_unificado)"]
        OB1 --> OB2
    end

    subgraph MAIN_APP["📱 APLICACIÓN PRINCIPAL"]
        direction TB
        MainNav["BottomNavigationBarExampleApp<br/>(/main)"]

        subgraph TABS["5 TABS PRINCIPALES"]
            Tab0["Tab 0: Rutinas<br/>ListaRutinasPage"]
            Tab1["Tab 1: Favoritos<br/>FavoritesPage"]
            Tab2["Tab 2: Catálogo<br/>ExerciseCatalogPage"]
            Tab3["Tab 3: Historial<br/>HistorialConEstadisticasPage"]
            Tab4["Tab 4: Configuración<br/>SettingPage"]
        end

        MainNav --> Tab0
        MainNav --> Tab1
        MainNav --> Tab2
        MainNav --> Tab3
        MainNav --> Tab4
    end

    subgraph RUTINAS["💪 MÓDULO RUTINAS"]
        direction TB
        ListRut["ListaRutinasPage<br/>(/main?tab=0)"]
        CreateRut["AgregarRutinaPage<br/>(/rutina/create)"]
        DetailRut["DetalleRutinaScreen<br/>(/rutina/detalle/:id)"]
        AddEj["AgregarEjerciciosPage<br/>(/agregar-ejercicios/:id/:sesion)"]
        ListEj["ListarEjerciciosPage<br/>(/listar-ejercicios/:musculo...)"]
        AddEjRut["AgregarEjercicioRutinaPage<br/>(/agregar-ejercicio-rutina/...)"]
        DetailEj["DetalleEjercicioScreen<br/>(/detalle-ejercicio)"]

        ListRut --> CreateRut
        ListRut --> DetailRut
        DetailRut --> AddEj
        AddEj --> ListEj
        ListEj --> AddEjRut
        AddEjRut --> DetailEj
    end

    subgraph EJERCICIOS["📚 MÓDULO EJERCICIOS"]
        direction TB
        Catalog["ExerciseCatalogPage<br/>(/main?tab=2)"]
        ExDetail["ExerciseDetailPage<br/>(/exercise-detail)"]
        ExCatalogDirect["Acceso Directo<br/>(/exercise-catalog)"]

        Catalog --> ExDetail
        ExCatalogDirect --> Catalog
    end

    subgraph FAVORITOS["❤️ MÓDULO FAVORITOS"]
        direction TB
        FavPage["FavoritesPage<br/>(/main?tab=1)"]
        FavDetail["Detalle Favorito"]

        FavPage --> FavDetail
    end

    subgraph HISTORIAL["📊 MÓDULO HISTORIAL"]
        direction TB
        HistPage["HistorialConEstadisticasPage<br/>(/main?tab=3)"]
        HistDetail["HistorialEjerciciosPage<br/>(/record)"]

        HistPage --> HistDetail
    end

    subgraph CONFIG["⚙️ MÓDULO CONFIGURACIÓN"]
        direction TB
        SettPage["SettingPage<br/>(/main?tab=4)<br/>(/settings)"]
        DialLoad["LoadingDialogPage<br/>(/dialog-loading)"]
    end

    Start --> |¿Primer acceso?| ONBOARDING
    Start --> |No| MAIN_APP
    ONBOARDING --> MAIN_APP

    Tab0 --> RUTINAS
    Tab1 --> FAVORITOS
    Tab2 --> EJERCICIOS
    Tab3 --> HISTORIAL
    Tab4 --> CONFIG

    RUTINAS -.->|Agregar a Favoritos| FAVORITOS
    EJERCICIOS -.->|Usar en Rutina| RUTINAS
    RUTINAS -.->|Ver Histórico| HISTORIAL

    style Start fill:#FF6B6B,color:#fff,stroke:#333,stroke-width:2px
    style OB1 fill:#FF8787,color:#fff
    style OB2 fill:#FFAB91,color:#fff
    style MainNav fill:#4ECDC4,color:#fff,stroke:#333,stroke-width:2px

    style RUTINAS fill:#45B7D1,color:#fff,stroke:#333,stroke-width:2px
    style EJERCICIOS fill:#98D8C8,color:#fff,stroke:#333,stroke-width:2px
    style FAVORITOS fill:#FFA07A,color:#fff,stroke:#333,stroke-width:2px
    style HISTORIAL fill:#F7DC6F,color:#000,stroke:#333,stroke-width:2px
    style CONFIG fill:#BB8FCE,color:#fff,stroke:#333,stroke-width:2px
```

---

## 🔄 Ciclo de Vida de la Navegación

```mermaid
stateDiagram-v2
    [*] --> AppStart

    AppStart --> CheckDB: Verificar base de datos
    CheckDB --> OnboardingCheck: ¿Onboarding completado?

    OnboardingCheck --> Onboarding: NO
    OnboardingCheck --> MainApp: SÍ

    Onboarding --> OnboardingScreen1: Pantalla 1
    OnboardingScreen1 --> OnboardingScreen2: Continuar
    OnboardingScreen2 --> SaveOnboarding: Guardar estado
    SaveOnboarding --> MainApp

    MainApp --> TabSelection: Seleccionar Tab

    TabSelection --> Tab0: Tab 0
    TabSelection --> Tab1: Tab 1
    TabSelection --> Tab2: Tab 2
    TabSelection --> Tab3: Tab 3
    TabSelection --> Tab4: Tab 4

    Tab0 --> RoutineActions: Rutinas
    RoutineActions --> Tab0: Volver

    Tab1 --> FavoritesView: Favoritos
    FavoritesView --> Tab1: Volver

    Tab2 --> CatalogView: Catálogo
    CatalogView --> Tab2: Volver

    Tab3 --> HistoryView: Historial
    HistoryView --> Tab3: Volver

    Tab4 --> SettingsView: Configuración
    SettingsView --> Tab4: Volver

    note right of AppStart
        Punto de entrada
        Verifica primer acceso
    end note

    note right of MainApp
        Hub central
        5 tabs principales
    end note

    note right of Tab0
        Gestión de rutinas
        Crear, editar, ejecutar
    end note
```

---

## 🎯 Mapa de Acceso Rápido (Shortcuts)

```mermaid
graph LR
    SHORTCUTS["⚡ ACCESOS RÁPIDOS"]

    SHORTCUTS -->|/exercise-catalog| Tab2["Tab 2: Catálogo"]
    SHORTCUTS -->|/settings| Config["Configuración"]
    SHORTCUTS -->|/favorites| Tab1["Tab 1: Favoritos"]
    SHORTCUTS -->|/record| Hist["Historial Detalle"]
    SHORTCUTS -->|/lista-rutinas-screen| Tab0["Tab 0: Rutinas"]
    SHORTCUTS -->|/dialog-loading| Load["Diálogo Carga"]

    style SHORTCUTS fill:#FF6B6B,color:#fff,stroke:#333,stroke-width:2px
    style Tab0 fill:#45B7D1,color:#fff
    style Tab1 fill:#FFA07A,color:#fff
    style Tab2 fill:#98D8C8,color:#fff
    style Config fill:#BB8FCE,color:#fff
    style Hist fill:#F7DC6F,color:#000
    style Load fill:#FFD93D,color:#000
```

---

## 📋 Estructura de Pantallas por Módulo

### 💪 MÓDULO RUTINAS

```
ListaRutinasPage (Principal)
├── ➕ Crear Rutina
│   └── AgregarRutinaPage
│       └── Vuelve a ListaRutinasPage
├── 👁️ Ver Detalle
│   └── DetalleRutinaScreen
│       ├── ➕ Agregar Ejercicio
│       │   └── AgregarEjerciciosPage
│       │       └── Seleccionar Músculo
│       │           └── ListarEjerciciosPage
│       │               └── Agregar Ejercicio
│       │                   └── AgregarEjercicioRutinaPage
│       │                       └── DetalleEjercicioScreen
│       └── ▶️ Ejecutar Rutina
│           └── Realizar Series
└── 🔄 Volver a ListaRutinasPage
```

### 📚 MÓDULO EJERCICIOS

```
ExerciseCatalogPage (Principal)
├── 🔍 Buscar Ejercicio
└── 📖 Ver Detalle
    └── ExerciseDetailPage
        ├── ❤️ Agregar a Favoritos
        │   └── FavoritesPage
        └── ➕ Agregar a Rutina
            └── ListaRutinasPage
```

### ❤️ MÓDULO FAVORITOS

```
FavoritesPage (Principal)
├── 📖 Ver Detalle
│   └── ExerciseDetailPage
├── ❌ Eliminar
│   └── Actualizar Lista
└── ➕ Usar en Rutina
    └── ListaRutinasPage
```

### 📊 MÓDULO HISTORIAL

```
HistorialConEstadisticasPage (Principal)
├── 📋 Ver Detalles
│   └── HistorialEjerciciosPage
└── 📈 Estadísticas
    └── Integradas en página
```

### ⚙️ MÓDULO CONFIGURACIÓN

```
SettingPage (Principal)
├── 🌙 Cambiar Tema
├── 🌐 Cambiar Idioma
├── 📊 Ver Estadísticas
└── 📋 Más opciones
```

---

## 🔀 Transiciones Entre Módulos

```mermaid
graph TB
    Rutinas["💪 RUTINAS"]
    Ejercicios["📚 EJERCICIOS"]
    Favoritos["❤️ FAVORITOS"]
    Historial["📊 HISTORIAL"]
    Config["⚙️ CONFIGURACIÓN"]

    Rutinas -->|Agregar a Favoritos| Favoritos
    Rutinas -->|Ver Histórico| Historial

    Ejercicios -->|Crear Favorito| Favoritos
    Ejercicios -->|Usar en Rutina| Rutinas
    Ejercicios -->|Ver Histórico| Historial

    Favoritos -->|Usar en Rutina| Rutinas
    Favoritos -->|Ver Histórico| Historial

    Historial -->|Ir a Rutina| Rutinas
    Historial -->|Ir a Catálogo| Ejercicios

    Config -->|Tema| Config

    style Rutinas fill:#45B7D1,color:#fff
    style Ejercicios fill:#98D8C8,color:#fff
    style Favoritos fill:#FFA07A,color:#fff
    style Historial fill:#F7DC6F,color:#000
    style Config fill:#BB8FCE,color:#fff
```

---

## 🧩 Diagrama de Componentes Principales

```mermaid
graph TD
    GoRouter["🛣️ GoRouter<br/>Motor de Navegación"]

    AppStartPage["🚀 AppStartPage<br/>Punto de Entrada"]
    BottomNav["📱 BottomNavigationBar<br/>Hub Principal"]

    RoutineModule["💪 Routine Module<br/>6 Pantallas"]
    ExerciseModule["📚 Exercise Module<br/>3 Pantallas"]
    RecordModule["📊 Record Module<br/>2 Pantallas"]
    SettingModule["⚙️ Setting Module<br/>4 Pantallas + Dialogs"]

    DatabaseHelper["💾 Database Helper<br/>Persistencia"]
    SharedPref["⚙️ SharedPreferences<br/>Configuración"]

    CubitManager["🎮 BLoC/Cubit Manager<br/>Estado Global"]

    GoRouter -->|Rutas| AppStartPage
    GoRouter -->|Rutas| BottomNav
    GoRouter -->|Rutas| RoutineModule
    GoRouter -->|Rutas| ExerciseModule
    GoRouter -->|Rutas| RecordModule
    GoRouter -->|Rutas| SettingModule

    AppStartPage -->|Decisión| SettingModule
    AppStartPage -->|Si OK| BottomNav

    BottomNav -->|Tab 0| RoutineModule
    BottomNav -->|Tab 1| ExerciseModule
    BottomNav -->|Tab 2| ExerciseModule
    BottomNav -->|Tab 3| RecordModule
    BottomNav -->|Tab 4| SettingModule

    RoutineModule -->|Lee/Escribe| DatabaseHelper
    ExerciseModule -->|Lee/Escribe| DatabaseHelper
    RecordModule -->|Lee/Escribe| DatabaseHelper
    SettingModule -->|Lee/Escribe| SharedPref

    RoutineModule -->|Estado| CubitManager
    ExerciseModule -->|Estado| CubitManager
    RecordModule -->|Estado| CubitManager
    SettingModule -->|Estado| CubitManager

    style GoRouter fill:#FF6B6B,color:#fff,stroke:#333,stroke-width:2px
    style AppStartPage fill:#FF8787,color:#fff,stroke:#333,stroke-width:2px
    style BottomNav fill:#4ECDC4,color:#fff,stroke:#333,stroke-width:2px
    style RoutineModule fill:#45B7D1,color:#fff
    style ExerciseModule fill:#98D8C8,color:#fff
    style RecordModule fill:#F7DC6F,color:#000
    style SettingModule fill:#BB8FCE,color:#fff
    style DatabaseHelper fill:#6BCB77,color:#fff
    style SharedPref fill:#FFD93D,color:#000
    style CubitManager fill:#FF6B9D,color:#fff
```

---

## 📍 Matriz de Navegación

| Desde                             | A                                 | Método                                          | Parámetros                                   |
| --------------------------------- | --------------------------------- | ----------------------------------------------- | -------------------------------------------- |
| AppStartPage                      | OnboardingBienvenidaPage          | context.go()                                    | -                                            |
| OnboardingBienvenidaPage          | OnboardingContenedorUnificadoPage | context.go()                                    | -                                            |
| OnboardingContenedorUnificadoPage | MainApp                           | context.go('/main')                             | -                                            |
| MainApp                           | ListaRutinasPage                  | setState                                        | tab=0                                        |
| ListaRutinasPage                  | AgregarRutinaPage                 | context.go('/rutina/create')                    | -                                            |
| ListaRutinasPage                  | DetalleRutinaScreen               | context.go('/rutina/detalle/:id')               | rutinaId                                     |
| DetalleRutinaScreen               | AgregarEjerciciosPage             | context.go('/agregar-ejercicios/:id/:sesion')   | rutinaId, sesionId                           |
| AgregarEjerciciosPage             | ListarEjerciciosPage              | context.go('/listar-ejercicios/...')            | musculoId, nombreMusculo, rutinaId, sesionId |
| ListarEjerciciosPage              | AgregarEjercicioRutinaPage        | context.go('/agregar-ejercicio-rutina/...')     | rutinaId, ejercicioId, etc                   |
| ExerciseCatalogPage               | ExerciseDetailPage                | context.go('/exercise-detail', extra: Exercise) | exercise                                     |
| ExerciseDetailPage                | FavoritesPage                     | FavoritoEjercicioCubit                          | -                                            |
| FavoritesPage                     | ExerciseDetailPage                | context.go('/exercise-detail', extra: Exercise) | exercise                                     |
| HistorialConEstadisticasPage      | HistorialEjerciciosPage           | context.go('/record')                           | -                                            |

---

**Última actualización:** 19 de octubre de 2025  
**Versión:** 1.0  
**Categoría:** Documentación Visual 📊
