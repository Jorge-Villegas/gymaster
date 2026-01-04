# 🎨 Visualización Interactiva del Flujo - GyMaster

## 🏗️ Arquitectura Completa de Navegación

```mermaid
graph TB
    Start["🚀 APP START<br/>/<br/>Verificar primer acceso"]

    Start --> Decision{¿Primer acceso?}

    Decision -->|Sí| OB1["👋 ONBOARDING 1<br/>/onboarding<br/>OnboardingBienvenidaPage"]
    Decision -->|No| MainDirect["📱 MAIN APP<br/>/main<br/>Ir directo a app"]

    OB1 --> OB2["📋 ONBOARDING 2<br/>/onboarding_unificado<br/>OnboardingContenedorUnificadoPage"]
    OB2 --> MainApp["📱 MAIN APP<br/>/main<br/>BottomNavigationBarExampleApp"]
    MainDirect --> MainApp

    MainApp --> BottomBar["🔽 BOTTOM NAVIGATION<br/>5 TABS"]

    BottomBar --> Tab0["Tab 0<br/>💪 RUTINAS"]
    BottomBar --> Tab1["Tab 1<br/>❤️ FAVORITOS"]
    BottomBar --> Tab2["Tab 2<br/>📚 CATÁLOGO"]
    BottomBar --> Tab3["Tab 3<br/>📊 HISTORIAL"]
    BottomBar --> Tab4["Tab 4<br/>⚙️ CONFIG"]

    %% Tab 0: Rutinas
    Tab0 --> ListRut["ListaRutinasPage<br/>/main?tab=0"]
    ListRut --> RutAction{Seleccionar}
    RutAction -->|Crear| CR["AgregarRutinaPage<br/>/rutina/create"]
    RutAction -->|Ver| DR["DetalleRutinaScreen<br/>/rutina/detalle/:id"]
    CR --> RutinCreated["✅ Rutina Creada"]
    RutinCreated --> ListRut

    DR --> DetailAction{Acción}
    DetailAction -->|Agregar Ej| AE["AgregarEjerciciosPage<br/>/agregar-ejercicios/:id/:sesion"]
    DetailAction -->|Ejecutar| ER["▶️ Ejecutar Rutina"]

    AE --> MusMus["MusculoPage<br/>Seleccionar músculo"]
    MusMus --> LE["ListarEjerciciosPage<br/>/listar-ejercicios/:musculo/:nombre/:rutina/:sesion"]
    LE --> AddEjRut["AgregarEjercicioRutinaPage<br/>/agregar-ejercicio-rutina/:rutina:ej:nombre:sesion"]
    AddEjRut --> DE["DetalleEjercicioScreen<br/>/detalle-ejercicio"]
    DE --> Series["➕ Agregar Series<br/>AgregarSeriesCubit"]
    Series --> Record["📝 Registrar Realización<br/>RealizacionEjercicioCubit"]
    Record --> Stats["📈 Estadísticas Guardadas"]

    %% Tab 1 y 2: Ejercicios/Favoritos
    Tab1 --> Fav["FavoritesPage<br/>/favorites"]
    Tab2 --> Cat["ExerciseCatalogPage<br/>/exercise-catalog"]

    Cat --> CatSearch["🔍 Buscar Ejercicio"]
    CatSearch --> ExDetail["ExerciseDetailPage<br/>/exercise-detail<br/>Extra: Exercise"]
    ExDetail --> ExAction{Acción}
    ExAction -->|❤️ Agregar| SaveFav["FavoritoEjercicioCubit<br/>Guardar favorito"]
    SaveFav --> Fav
    ExAction -->|Usar| ListRut

    Fav --> FavAction{Acción}
    FavAction -->|Ver| ExDetail
    FavAction -->|Usar en rutina| ListRut
    FavAction -->|❌ Eliminar| DelFav["Eliminar de favoritos"]
    DelFav --> Fav

    %% Tab 3: Historial
    Tab3 --> Hist["HistorialConEstadisticasPage<br>/main?tab=3"]
    Hist --> HistDetail["HistorialEjerciciosPage<br/>/record"]
    HistDetail --> HistStats["📊 Ver Estadísticas<br/>Rendimiento"]

    %% Tab 4: Configuración
    Tab4 --> Settings["SettingPage<br>/settings<br>(/main?tab=4)"]
    Settings --> SettAction{Acción}
    SettAction -->|🌙 Tema| ChangeDark["Cambiar tema<br/>Dark/Light"]
    SettAction -->|🌐 Idioma| ChangeLang["Cambiar idioma<br/>ES/EN"]
    SettAction -->|ℹ️ Info| About["Información"]
    ChangeDark --> Settings
    ChangeLang --> Settings
    About --> Settings

    %% Accesos directos
    Shortcuts["⚡ ACCESOS RÁPIDOS<br/>/exercise-catalog<br/>/lista-rutinas-screen<br/>/dialog-loading"]
    Shortcuts -.->|Directo a| Tab2
    Shortcuts -.->|Directo a| ListRut
    Shortcuts -.->|Loading| LoadDialog["LoadingDialogPage"]

    style Start fill:#FF6B6B,color:#fff,stroke:#333,stroke-width:3px
    style OB1 fill:#FF8787,color:#fff
    style OB2 fill:#FFAB91,color:#fff
    style MainApp fill:#4ECDC4,color:#fff,stroke:#333,stroke-width:2px
    style BottomBar fill:#95E1D3,color:#000,stroke:#333,stroke-width:2px

    style Tab0 fill:#45B7D1,color:#fff
    style ListRut fill:#4A90E2,color:#fff
    style CR fill:#56C596,color:#fff
    style DR fill:#6BCB77,color:#fff
    style AE fill:#FFD93D,color:#000
    style LE fill:#FFD700,color:#000
    style AddEjRut fill:#FF6B9D,color:#fff
    style DE fill:#C44569,color:#fff
    style Series fill:#FF8C42,color:#fff
    style Record fill:#FF6347,color:#fff

    style Tab1 fill:#FFA07A,color:#fff
    style Tab2 fill:#98D8C8,color:#fff
    style Cat fill:#87CEEB,color:#000
    style ExDetail fill:#20B2AA,color:#fff
    style Fav fill:#FFA07A,color:#fff

    style Tab3 fill:#F7DC6F,color:#000
    style Hist fill:#F4D03F,color:#000

    style Tab4 fill:#BB8FCE,color:#fff
    style Settings fill:#9B59B6,color:#fff

    style Shortcuts fill:#FF6B6B,color:#fff,stroke:#333,stroke-width:2px
```

---

## 🎯 Diagrama de Transiciones por Módulo

### 💪 Módulo RUTINAS (Flujo Detallado)

```mermaid
graph TD
    A["📋 ListaRutinasPage<br/>(/main?tab=0)"]

    A -->|Crear Nueva| B["➕ AgregarRutinaPage<br/>(/rutina/create)"]
    A -->|Ver Detalles| C["📄 DetalleRutinaScreen<br/>(/rutina/detalle/:rutinaId)"]

    B -->|Guardar| C

    C -->|Agregar Ej| D["🏋️ AgregarEjerciciosPage<br/>(/agregar-ejercicios/:rutina/:sesion)"]
    C -->|Ejecutar| E["▶️ Realizar Rutina"]

    D -->|Seleccionar| F["🔍 ListarEjerciciosPage<br/>(/listar-ejercicios/:musculo...)"]

    F -->|Elegir| G["➕ AgregarEjercicioRutinaPage<br/>(/agregar-ejercicio-rutina/...)"]

    G -->|Configurar| H["📋 DetalleEjercicioScreen<br/>(/detalle-ejercicio)"]

    H -->|Series| I["📊 Agregar Series<br/>AgregarSeriesCubit"]
    I -->|Registrar| J["📝 Realización<br/>RealizacionEjercicioCubit"]
    J -->|Guardar| K["✅ Completado"]

    K -->|Volver| C
    C -->|Atrás| A

    style A fill:#45B7D1,color:#fff,stroke:#333,stroke-width:2px
    style B fill:#56C596,color:#fff
    style C fill:#4DA6FF,color:#fff,stroke:#333,stroke-width:2px
    style D fill:#FFD93D,color:#000
    style F fill:#6BCB77,color:#fff
    style G fill:#FF6B9D,color:#fff
    style H fill:#C44569,color:#fff
    style I fill:#FF8C42,color:#fff
    style J fill:#FF6347,color:#fff
    style K fill:#90EE90,color:#000
```

---

## 📚 Módulo EJERCICIOS (Flujo Detallado)

```mermaid
graph LR
    A["📚 ExerciseCatalogPage<br/>(/main?tab=2)<br/>o /exercise-catalog"]

    A -->|Buscar| B["🔍 Búsqueda"]
    B -->|Resultados| C["📖 ExerciseDetailPage<br/>(/exercise-detail)"]

    C -->|❤️ Favorito| D["💾 FavoritoEjercicioCubit<br/>Guardar en DB"]
    D -->|Actualizar| E["❤️ FavoritesPage<br/>(/favorites)<br/>(/main?tab=1)"]

    C -->|➕ Usar| F["💪 ListaRutinasPage<br/>Vuelve a rutinas"]

    E -->|Ver| C
    E -->|Usar| F
    E -->|❌ Eliminar| G["🗑️ Actualizar Lista"]
    G -->|Refresco| E

    style A fill:#98D8C8,color:#fff,stroke:#333,stroke-width:2px
    style B fill:#87CEEB,color:#000
    style C fill:#20B2AA,color:#fff,stroke:#333,stroke-width:2px
    style D fill:#FFD700,color:#000
    style E fill:#FFA07A,color:#fff,stroke:#333,stroke-width:2px
    style F fill:#45B7D1,color:#fff
    style G fill:#FF6347,color:#fff
```

---

## 📊 Módulo HISTORIAL (Flujo Simple)

```mermaid
graph TD
    A["📊 HistorialConEstadisticasPage<br/>(/main?tab=3)"]
    A -->|Ver Detalles| B["📋 HistorialEjerciciosPage<br/>(/record)"]
    B -->|Estadísticas| C["📈 RecordCubit<br/>Datos históricos"]
    C -->|Mostrar| D["📉 Gráficos y Stats"]
    D -->|Volver| B
    B -->|Atrás| A

    style A fill:#F7DC6F,color:#000,stroke:#333,stroke-width:2px
    style B fill:#F4D03F,color:#000,stroke:#333,stroke-width:2px
    style C fill:#F1C40F,color:#000
    style D fill:#F39C12,color:#000
```

---

## ⚙️ Módulo CONFIGURACIÓN (Flujo)

```mermaid
graph TD
    A["⚙️ SettingPage<br/>(/settings)<br/>(/main?tab=4)"]

    A -->|Tema| B["🌙 Cambiar Tema"]
    B -->|Dark| C["🌙 Dark Mode"]
    B -->|Light| D["☀️ Light Mode"]
    C -->|Aplicar| A
    D -->|Aplicar| A

    A -->|Idioma| E["🌐 Cambiar Idioma"]
    E -->|Español| F["🇪🇸 Español"]
    E -->|English| G["🇬🇧 English"]
    F -->|Aplicar| A
    G -->|Aplicar| A

    A -->|Info| H["ℹ️ Información"]
    H -->|Volver| A

    style A fill:#BB8FCE,color:#fff,stroke:#333,stroke-width:2px
    style B fill:#9B59B6,color:#fff
    style E fill:#8E44AD,color:#fff
    style H fill:#7D3C98,color:#fff
```

---

## 🚀 Flujo de ONBOARDING

```mermaid
graph TD
    A["🚀 AppStartPage<br/>(/)<br/>Verifica SharedPreferences"]

    A -->|Primera vez| B["👋 OnboardingBienvenidaPage<br/>(/onboarding)"]
    A -->|Ya completo| C["📱 MainApp<br/>(/main)"]

    B -->|Siguiente| D["📋 OnboardingContenedorUnificadoPage<br/>(/onboarding_unificado)"]

    D -->|Introducción| E["✅ Bienvenida"]
    E -->|Siguiente| F["📊 Características"]
    F -->|Siguiente| G["🎯 Cómo Usar"]
    G -->|Completar| H["💾 Guardar Onboarding<br/>SharedPreferences"]

    H -->|Ir a| C

    style A fill:#FF6B6B,color:#fff,stroke:#333,stroke-width:2px
    style B fill:#FF8787,color:#fff
    style D fill:#FFAB91,color:#fff,stroke:#333,stroke-width:2px
    style E fill:#FFD699,color:#000
    style F fill:#FFC566,color:#000
    style G fill:#FFB366,color:#000
    style H fill:#90EE90,color:#000
    style C fill:#4ECDC4,color:#fff,stroke:#333,stroke-width:2px
```

---

## 🔗 Relaciones Entre Módulos

```mermaid
graph TB
    subgraph MAIN["📱 APLICACIÓN CENTRAL"]
        MainApp["BottomNavigationBarExampleApp<br/>5 Tabs"]
    end

    subgraph RUTINAS["💪 RUTINAS"]
        RutMod["Crear, Editar<br/>Ejecutar Rutinas"]
    end

    subgraph EJERCICIOS["📚 EJERCICIOS"]
        EjMod["Catálogo<br/>Favoritos"]
    end

    subgraph HISTORIAL["📊 HISTORIAL"]
        HistMod["Registro<br/>Estadísticas"]
    end

    subgraph CONFIG["⚙️ CONFIG"]
        ConfMod["Tema<br/>Idioma"]
    end

    MAIN -->|Tab 0| RUTINAS
    MAIN -->|Tab 1-2| EJERCICIOS
    MAIN -->|Tab 3| HISTORIAL
    MAIN -->|Tab 4| CONFIG

    RUTINAS -->|Agregar Ej| EJERCICIOS
    RUTINAS -->|Histórico| HISTORIAL
    EJERCICIOS -->|Usar| RUTINAS
    EJERCICIOS -->|Histórico| HISTORIAL
    HISTORIAL -->|Ir a| RUTINAS
    HISTORIAL -->|Ir a| EJERCICIOS

    RUTINAS -.->|Cualquier tiempo| CONFIG
    EJERCICIOS -.->|Cualquier tiempo| CONFIG
    HISTORIAL -.->|Cualquier tiempo| CONFIG

    style MAIN fill:#4ECDC4,color:#fff,stroke:#333,stroke-width:3px
    style RUTINAS fill:#45B7D1,color:#fff
    style EJERCICIOS fill:#98D8C8,color:#fff
    style HISTORIAL fill:#F7DC6F,color:#000
    style CONFIG fill:#BB8FCE,color:#fff
```

---

## 🎮 Estado y Cubits (Estado Management)

```mermaid
graph LR
    subgraph ROUTINE["💪 ROUTINE"]
        RoutineCubit["RoutineCubit"]
        SeriesCubit["SeriesCubit"]
        EjercicioCubit["EjercicioCubit"]
        RealizacionCubit["RealizacionEjercicioCubit"]
    end

    subgraph EXERCISE["📚 EXERCISE"]
        ExerciseCubit["ExerciseCubit"]
        FavoritosCubit["FavoritoEjercicioCubit"]
    end

    subgraph RECORD["📊 RECORD"]
        RecordCubit["RecordCubit"]
        SelectedCubit["SelectedRoutineCubit"]
    end

    subgraph SETTING["⚙️ SETTING"]
        SettingCubit["SettingCubit"]
        AppStartCubit["AppStartCubit"]
        OnboardingCubit["OnboardingCubit"]
    end

    DB[("💾 DATABASE<br/>SQLite")]
    SP[("⚙️ SHARED PREF<br/>Configuración")]

    ROUTINE -->|Leer/Escribir| DB
    EXERCISE -->|Leer/Escribir| DB
    RECORD -->|Leer| DB
    SETTING -->|Leer/Escribir| SP

    style DB fill:#6BCB77,color:#fff,stroke:#333,stroke-width:2px
    style SP fill:#FFD93D,color:#000,stroke:#333,stroke-width:2px
    style ROUTINE fill:#45B7D1,color:#fff
    style EXERCISE fill:#98D8C8,color:#fff
    style RECORD fill:#F7DC6F,color:#000
    style SETTING fill:#BB8FCE,color:#fff
```

---

## 📍 Mapa de Localización de Archivos

```
lib/
├── app_router.dart 🔴 ← Configuración GoRouter
│
├── features/
│   ├── setting/presentation/pages/
│   │   ├── app_start_page.dart 🚀
│   │   ├── onboarding_bienvenida_page.dart 👋
│   │   ├── onboarding_contenedor_unificado_page.dart 📋
│   │   └── setting_page.dart ⚙️
│   │
│   ├── routine/presentation/pages/
│   │   ├── lista_rutina_page.dart 💪
│   │   ├── agregar_rutina_page.dart ➕
│   │   ├── detalle_rutina_page.dart 📄
│   │   ├── agregar_ejercicios_page.dart 🏋️
│   │   ├── listar_ejercicios_page.dart 🔍
│   │   ├── detalle_ejercicio_page.dart 📋
│   │   └── agregar_ejercicios_rutina_page.dart ➕
│   │
│   ├── exercise/presentation/pages/
│   │   ├── exercise_catalog_page.dart 📚
│   │   ├── exercise_detail_page.dart 📖
│   │   └── favorites_page.dart ❤️
│   │
│   └── record/presentation/pages/
│       ├── historial_ejercicios_page.dart 📋
│       └── historial_con_estadisticas_page.dart 📊
│
└── shared/widgets/
    ├── barra_navegacion.dart 🔽
    └── loading_dialog_page.dart ⏳
```

---

**Última actualización:** 19 de octubre de 2025  
**Versión:** 1.0  
**Tipo:** Visualización Interactiva 🎨
