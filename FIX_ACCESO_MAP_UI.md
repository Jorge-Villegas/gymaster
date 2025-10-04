# 🔧 Fix: Acceso a Map en UI de Estadísticas

## 🚨 Problema Detectado

```
════════ Exception caught by widgets library ═══════════════════════════════════
Class '_Map<String, Object>' has no instance getter 'totalSesiones'.
Receiver: _Map len:5
Tried calling: totalSesiones
════════════════════════════════════════════════════════════════════════════════
```

**Causa**: La UI intentaba acceder a `resumenGeneral` como si fuera un **objeto con propiedades**, pero es un **`Map<String, dynamic>`**.

---

## 🔍 Análisis del Problema

### Map Real del DataSource

```dart
final resultado = {
  'total_sesiones': metricas.first['total_sesiones'] ?? 0,
  'total_series': metricas.first['total_series'] ?? 0,
  'volumen_total': metricas.first['volumen_total'] ?? 0.0,
  'ejercicios_diferentes': metricas.first['ejercicios_diferentes'] ?? 0,
  'racha_dias': racha,
};
```

**Claves disponibles** (snake_case):

- ✅ `total_sesiones`
- ✅ `total_series`
- ✅ `volumen_total`
- ✅ `ejercicios_diferentes`
- ✅ `racha_dias`

### Acceso Incorrecto en UI

```dart
// ❌ INCORRECTO - Intentando acceder como propiedades
valor: '${resumen.totalSesiones}'       // Error: no existe
valor: '${resumen.rachaActual}'         // Error: no existe
valor: '${resumen.tiempoTotalMinutos}'  // Error: no existe
valor: resumen.volumenTotalFormateado   // Error: no existe
```

**Problemas**:

1. ❌ Sintaxis incorrecta (`.propiedad` en vez de `['clave']`)
2. ❌ Nombres en camelCase en vez de snake_case
3. ❌ Propiedades que no existen en el Map

---

## ✅ Solución Aplicada

### Corrección de Acceso al Map

**Archivo**: `lib/features/estadisticas/presentation/pages/estadisticas_page.dart`

```dart
// ✅ CORRECTO - Acceso con claves y manejo de null
TarjetaMetricaWidget(
  icono: Icons.fitness_center,
  valor: '${resumen['total_sesiones'] ?? 0}',
  etiqueta: 'Entrenamientos',
  colorIcono: AppColors.primario,
),

TarjetaMetricaWidget(
  icono: Icons.local_fire_department,
  valor: '${resumen['racha_dias'] ?? 0}',
  etiqueta: 'Racha de días',
  colorIcono: AppColors.acento,
  porcentajeCambio: (resumen['racha_dias'] ?? 0) > 7 ? 15.0 : -5.0,
),

// Estimación de minutos: total_series * 3 minutos por serie
TarjetaMetricaWidget(
  icono: Icons.timer,
  valor: '${((resumen['total_series'] ?? 0) * 3).round()}',
  etiqueta: 'Minutos totales',
  colorIcono: AppColors.secundario,
  subvalor: 'min',
),

// Volumen formateado con 0 decimales + unidad
TarjetaMetricaWidget(
  icono: Icons.trending_up,
  valor: '${(resumen['volumen_total'] ?? 0.0).toStringAsFixed(0)} kg',
  etiqueta: 'Volumen total',
  colorIcono: AppColors.exito,
  porcentajeCambio: 10.0,
),
```

---

## 🎯 Cambios Específicos

### 1. Total Sesiones

```diff
- valor: '${resumen.totalSesiones}',
+ valor: '${resumen['total_sesiones'] ?? 0}',
```

### 2. Racha de Días

```diff
- valor: '${resumen.rachaActual}',
+ valor: '${resumen['racha_dias'] ?? 0}',

- porcentajeCambio: resumen.rachaActual > 7 ? 15.0 : -5.0,
+ porcentajeCambio: (resumen['racha_dias'] ?? 0) > 7 ? 15.0 : -5.0,
```

### 3. Minutos Totales (Calculado)

```diff
- valor: '${resumen.tiempoTotalMinutos}',
+ valor: '${((resumen['total_series'] ?? 0) * 3).round()}',
```

**Nota**: Como no tenemos datos de tiempo real, estimamos **3 minutos por serie** (tiempo promedio incluyendo descanso).

### 4. Volumen Total (Formateado)

```diff
- valor: resumen.volumenTotalFormateado,
+ valor: '${(resumen['volumen_total'] ?? 0.0).toStringAsFixed(0)} kg',
```

**Nota**: Formateamos el volumen con 0 decimales y agregamos la unidad "kg".

---

## 📊 Mapeo Completo

| UI Original (Incorrecto) | Map Real (Correcto) | Tipo   | Notas                                |
| ------------------------ | ------------------- | ------ | ------------------------------------ |
| `totalSesiones`          | `total_sesiones`    | int    | Cuenta de sesiones                   |
| `rachaActual`            | `racha_dias`        | int    | Días consecutivos                    |
| `tiempoTotalMinutos`     | `total_series * 3`  | int    | **Calculado** (no existe en BD)      |
| `volumenTotalFormateado` | `volumen_total`     | double | Formateado con `.toStringAsFixed(0)` |

---

## ✅ Validación

### Compilación

```bash
flutter analyze lib/features/estadisticas/
```

**Resultado**: ✅ Sin errores

### Logs de Ejecución (Antes del fix)

```
❌ Exception: Class '_Map<String, Object>' has no instance getter 'totalSesiones'
```

### Logs de Ejecución (Después del fix)

```
✅ [EstadisticasDataSource] Resumen general obtenido: 2 sesiones, 86 series, racha: 1 días
✅ [EstadisticasRepository] Resumen general obtenido: 2 sesiones
✅ [EstadisticasCubit] Estadísticas cargadas: 3 músculos, 10 ejercicios, 10 recomendaciones
✅ UI renderiza correctamente sin excepciones
```

---

## 💡 Alternativa: Crear Clase ResumenGeneral

Si prefieres acceso con propiedades en vez de Map, puedes crear una clase:

```dart
// lib/features/estadisticas/domain/entities/resumen_general.dart

class ResumenGeneral {
  final int totalSesiones;
  final int totalSeries;
  final double volumenTotal;
  final int ejerciciosDiferentes;
  final int rachaDias;

  const ResumenGeneral({
    required this.totalSesiones,
    required this.totalSeries,
    required this.volumenTotal,
    required this.ejerciciosDiferentes,
    required this.rachaDias,
  });

  // Propiedades calculadas
  int get tiempoTotalMinutos => totalSeries * 3;

  String get volumenTotalFormateado =>
      '${volumenTotal.toStringAsFixed(0)} kg';

  // Factory desde Map
  factory ResumenGeneral.fromMap(Map<String, dynamic> map) {
    return ResumenGeneral(
      totalSesiones: map['total_sesiones'] ?? 0,
      totalSeries: map['total_series'] ?? 0,
      volumenTotal: (map['volumen_total'] ?? 0.0).toDouble(),
      ejerciciosDiferentes: map['ejercicios_diferentes'] ?? 0,
      rachaDias: map['racha_dias'] ?? 0,
    );
  }
}
```

**Ventajas**:

- ✅ Acceso type-safe con propiedades
- ✅ Propiedades calculadas (tiempoTotalMinutos, volumenTotalFormateado)
- ✅ Mejor experiencia de desarrollo (autocompletado)
- ✅ Inmutabilidad garantizada

**Desventajas**:

- ⚠️ Requiere más código (entity + factory)
- ⚠️ Cambiar estado de `Map<String, dynamic>` a `ResumenGeneral`

---

## 🎯 Resumen

| Aspecto         | Estado                                       |
| --------------- | -------------------------------------------- |
| **Problema**    | ❌ Acceso incorrecto a Map como objeto       |
| **Causa**       | UI usaba `.propiedad` en vez de `['clave']`  |
| **Solución**    | ✅ Cambiar a acceso con claves + null safety |
| **Compilación** | ✅ Sin errores                               |
| **Ejecución**   | ✅ UI renderiza correctamente                |
| **Alternativa** | Crear clase `ResumenGeneral` (opcional)      |

---

**Fecha**: 2 de octubre de 2025  
**Archivo modificado**: `estadisticas_page.dart`  
**Cambios**: 4 correcciones de acceso a Map  
**Status**: ✅ **RESUELTO**
