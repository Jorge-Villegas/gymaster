# 📚 Índice de Documentación de Navegación - GyMaster

## 🎯 Bienvenido

Este índice te ayudará a encontrar la información correcta sobre la navegación de GyMaster según tus necesidades.

---

## 📖 Documentos Disponibles

### 1. **rutas_navegacion.md** - Documento Principal

**Mejor para:** Entender la arquitectura general de navegación

📋 Contiene:

- Descripción general de la aplicación
- Diagrama de flujo general
- Módulos principales explicados
- Navegación por tabs
- Flujos completos de usuario
- Configuración técnica
- Estructura de código

🎯 **Ideal para:** Nuevos desarrolladores, onboarding, visión general del proyecto

---

### 2. **mapa_navegacion_completo.md** - Análisis Detallado

**Mejor para:** Entender todos los detalles técnicos

📋 Contiene:

- Diagrama completo del flujo de navegación
- Tabla completa de rutas (17 rutas)
- Flujos de navegación con diagramas de secuencia
- Interconexiones de módulos
- Navegación por parámetros
- State Management y Cubits
- Puntos críticos de navegación
- Casos de uso especiales
- Flujo técnico de inicio de sesión

🎯 **Ideal para:** Desarrolladores experimentados, debugging, casos complejos

---

### 3. **diagrama_visual_navegacion.md** - Visualización

**Mejor para:** Ver el flujo de manera visual y clara

📋 Contiene:

- Vista general simplificada
- Ciclo de vida de la navegación
- Mapa de accesos rápidos
- Estructura por módulo
- Transiciones entre módulos
- Diagrama de componentes
- Matriz de navegación

🎯 **Ideal para:** Diseño arquitectónico, planificación, presentaciones

---

### 4. **referencia_rapida_navegacion.md** - Guía Rápida

**Mejor para:** Copiar y pegar código, referencias rápidas

📋 Contiene:

- Referencia rápida de rutas
- Ejemplos de navegación en Dart
- Tabla de parámetros
- Cubits principales
- Flujos principales
- Validaciones comunes
- Orden de prioridad de rutas
- Errores comunes
- Checklist para agregar rutas

🎯 **Ideal para:** Desarrollo diario, copiar código, quick reference

---

## 🎯 Cómo Seleccionar el Documento Correcto

### ¿Necesito...?

**Entender cómo funciona la navegación en general**
→ Lee **rutas_navegacion.md**

**Implementar una nueva ruta**
→ Usa **referencia_rapida_navegacion.md** + **mapa_navegacion_completo.md**

**Debuggear un problema de navegación**
→ Consulta **mapa_navegacion_completo.md** + **diagrama_visual_navegacion.md**

**Ver el flujo visual de la app**
→ Abre **diagrama_visual_navegacion.md**

**Presentar la arquitectura a alguien**
→ Muestra los Mermaid de **diagrama_visual_navegacion.md**

**Copiar código de ejemplo**
→ Busca en **referencia_rapida_navegacion.md**

**Entender parámetros complejos**
→ Lee **mapa_navegacion_completo.md** sección "Navegación por Parámetros"

---

## 📊 Resumen de Rutas

La aplicación tiene **17 rutas principales** organizadas en **5 módulos**:

```
ENTRADA & ONBOARDING (4 rutas)
├── / (AppStartPage)
├── /onboarding
├── /onboarding_unificado
└── /dialog-loading

RUTINAS (7 rutas)
├── /main?tab=0 (ListaRutinasPage)
├── /rutina/create
├── /rutina/detalle/:rutinaId
├── /agregar-ejercicios/:rutinaId/:sesionId
├── /listar-ejercicios/:musculoId/:nombreMusculo/:rutinaId/:sesionId
├── /agregar-ejercicio-rutina/:rutinaId/:ejercicioId/:ejercicioNombre/:sesionId
└── /detalle-ejercicio

EJERCICIOS (3 rutas)
├── /exercise-catalog
├── /exercise-detail
└── /favorites

HISTORIAL (2 rutas)
├── /main?tab=3 (HistorialConEstadisticasPage)
└── /record

CONFIGURACIÓN (1 ruta)
└── /settings (/main?tab=4)
```

---

## 🔄 Flujos Principales (Resumen)

### 1️⃣ Primer Acceso

```
/ → /onboarding → /onboarding_unificado → /main
```

### 2️⃣ Usuario Habitual

```
/ → /main
```

### 3️⃣ Crear Rutina

```
/main → /rutina/create → /rutina/detalle/:id → /agregar-ejercicios/:id/:sesion → ...
```

### 4️⃣ Explorar Catálogo

```
/main?tab=2 → /exercise-detail → ❤️ Favoritos → /favorites
```

---

## 🛠️ Herramientas y Tecnología

- **Router:** GoRouter
- **State Management:** BLoC/Cubit
- **Persistencia:** SQLite + SharedPreferences
- **Patrón:** Clean Architecture

---

## 📝 Anotaciones por Módulo

### 💪 Rutinas

- 7 rutas totales
- Flujo más complejo
- Múltiples parámetros
- Requiere validación de contexto

### 📚 Ejercicios

- 3 rutas totales
- Integración con favoritos
- Paso de objetos complejos

### ❤️ Favoritos

- Parte del módulo Exercise
- Gestión con FavoritoEjercicioCubit
- Persistencia en base de datos

### 📊 Historial

- 2 rutas
- Integración con estadísticas
- Lectura de datos históricos

### ⚙️ Configuración

- Tema y idioma
- Accesible desde cualquier parte
- Cubit independiente

---

## 🚀 Quick Links

| Necesito...         | Archivo                         | Sección                           |
| ------------------- | ------------------------------- | --------------------------------- |
| Crear nueva ruta    | referencia_rapida_navegacion.md | Checklist para Agregar Nueva Ruta |
| Ejemplo de código   | referencia_rapida_navegacion.md | Ejemplos de Navegación Común      |
| Ver todas las rutas | mapa_navegacion_completo.md     | Tabla Completa de Rutas           |
| Entender Cubits     | mapa_navegacion_completo.md     | Estado Management y Navegación    |
| Ver diagramas       | diagrama_visual_navegacion.md   | Cualquier sección                 |
| Errores comunes     | referencia_rapida_navegacion.md | Errores Comunes                   |

---

## 💡 Tips Importantes

✅ **Siempre usar `context.go()` no `context.push()`** para navegación principal

✅ **Pasar parámetros en path** cuando sean necesarios identificadores

✅ **Usar `extra` para objetos complejos** como `Exercise`

✅ **Query parameters para opciones** como `?tab=2`

✅ **Mantener nombres de rutas descriptivos** para facilitar debugging

✅ **Documentar parámetros requeridos** en cada ruta nueva

---

## 📞 Contacto / Soporte

Si encuentras problemas o tienes preguntas sobre la navegación:

1. Consulta primero **referencia_rapida_navegacion.md** - Errores Comunes
2. Revisa **mapa_navegacion_completo.md** - Puntos Críticos
3. Abre un issue describiendo tu problema

---

## 📈 Estadísticas de Documentación

| Métrica                    | Valor |
| -------------------------- | ----- |
| Total de documentos        | 4     |
| Total de diagramas Mermaid | 20+   |
| Rutas documentadas         | 17    |
| Cubits documentados        | 13    |
| Parámetros documentados    | 7     |
| Líneas de documentación    | 2000+ |

---

## 🎓 Orden de Lectura Recomendado

### Para Nuevos Desarrolladores:

1. Este archivo (Índice)
2. rutas_navegacion.md (Visión general)
3. diagrama_visual_navegacion.md (Visualización)
4. referencia_rapida_navegacion.md (Práctica)

### Para Desarrolladores Experimentados:

1. Este archivo (Orientación rápida)
2. mapa_navegacion_completo.md (Detalles)
3. referencia_rapida_navegacion.md (Implementación)

### Para Architects/Líderes:

1. diagrama_visual_navegacion.md (Visión)
2. mapa_navegacion_completo.md (Detalles)
3. rutas_navegacion.md (Contexto)

---

**Última actualización:** 19 de octubre de 2025  
**Versión:** 1.0  
**Estado:** Documentación Completa ✅
