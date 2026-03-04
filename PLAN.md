# PLAN.md — Streakly

## Guía completa de desarrollo y publicación en la App Store

---

# 1. Visión General de Streakly

## ¿Qué es Streakly?

Streakly es una app de seguimiento de hábitos con enfoque **minimalista**. Su propuesta de valor es clara: ser la app que NO te abruma. Sin notificaciones agresivas, sin gamificación excesiva, sin gráficos complejos. Solo vos y tus hábitos.

## Propuesta de valor

**"Sin distracciones. Sin presión. Solo tus hábitos."**

Esa es la frase que define la app. Cada decisión de diseño y funcionalidad debe responder a esta pregunta: ¿esto simplifica o complica la experiencia del usuario?

## Features de la v1

- Crear hábitos con nombre y descripción
- Seleccionar nivel de dificultad por hábito (Fácil: 1pt, Medio: 3pt, Difícil: 5pt)
- Marcar hábitos como completados cada día
- Contador de veces completado por hábito
- Puntaje acumulado (visible pero discreto, no es el centro de la app)
- Sistema de rachas: cuántos días seguidos completaste un hábito
- Persistencia de datos con SwiftData
- Soporte para Dark Mode y Light Mode
- Diseño minimalista, limpio y profesional

## Lo que Streakly NO es (y eso es un feature)

- No tiene notificaciones push
- No tiene sistema de logros/badges
- No tiene gráficos ni estadísticas complejas
- No tiene onboarding de múltiples pantallas
- No tiene suscripción ni compras in-app
- No tiene login ni cuenta de usuario
- No tiene sincronización con la nube

---

# 2. Configuración Inicial del Proyecto

## 2.1 — Corregir el .gitignore

Tu .gitignore actual tiene un conflicto: la línea 77 (`*.xcodeproj`) en la sección de SPM puede interferir con las reglas de las líneas 46-51 que permiten archivos importantes del proyecto. Hay que eliminar esa línea de la sección SPM ya que no usás Swift Package Manager de forma standalone.

**Qué hacer:**
- Abrir `.gitignore`
- En la sección `# Swift Package Manager`, eliminar la línea que dice `*.xcodeproj`
- Esa sección debería quedar solo con: `.swiftpm/`, `Packages/`, `Package.pins`, `Package.resolved`, `.build/`

## 2.2 — Limpiar archivo xcuserstate del repo

El archivo `xcuserstate` se subió en el Initial Commit y no debería estar trackeado (son preferencias locales de tu Xcode, como qué archivo tenías abierto, qué pestañas, etc.). Cada vez que abrís Xcode, este archivo cambia, lo cual genera "cambios" falsos en git.

**Qué hacer:**
- Desde la terminal, ejecutar: `git rm --cached` sobre el archivo xcuserstate que está dentro de `Streakly.xcodeproj/`
- Verificar que `xcuserdata/` y `*.xcuserstate` ya están en el .gitignore (ya lo están)
- Hacer un commit con este cambio

## 2.3 — Configuración de Xcode

Abrí el proyecto en Xcode y andá a la pestaña del proyecto (click en el nombre "Streakly" en el navigator, luego seleccioná el TARGET "Streakly"):

### Pestaña "General"

- **Display Name**: `Streakly` (este es el nombre que aparece debajo del ícono en el iPhone)
- **Bundle Identifier**: `com.facuvogel.Streakly` (o el formato que prefieras, pero debe ser único en el mundo. Usá tu nombre o un dominio que te pertenezca)
- **Version**: `1.0` (este es el número de versión visible para los usuarios)
- **Build**: `1` (este es un número interno que incrementás cada vez que subís un build a App Store Connect)
- **Minimum Deployments**: `iOS 17.0` (esto define la versión mínima de iOS que soporta tu app)
- **Device Orientation**: Solo marcá `Portrait`. Streakly no necesita landscape y simplifica tu desarrollo enormemente. Desmarcá `Landscape Left` y `Landscape Right`.

### Pestaña "Signing & Capabilities"

- **Automatically manage signing**: Dejá este checkbox activado. Xcode se encarga de los certificados y provisioning profiles por vos.
- **Team**: Cuando tengas tu Apple Developer Account, vas a seleccionar tu equipo acá. Por ahora, si no aparece nada, no te preocupes. Vas a poder desarrollar y probar en simulador sin problemas.
- **Bundle Identifier**: Debería coincidir con lo que pusiste en General.

**Nota importante**: Para probar en un dispositivo físico, necesitás al menos un Apple ID configurado en Xcode (no necesariamente el Developer Account de pago). Andá a Xcode → Settings → Accounts y agregá tu Apple ID si no lo hiciste.

### Pestaña "Info"

Acá no necesitás tocar nada por ahora. Más adelante, si necesitaras permisos especiales (cámara, ubicación, etc.), los agregarías acá. Streakly no necesita ningún permiso especial.

## 2.4 — Estructura de carpetas

Creá las siguientes carpetas DENTRO de la carpeta `Streakly/Streakly/` (donde está tu `ContentView.swift` y `StreaklyApp.swift`). Podés crearlas desde Xcode haciendo click derecho → New Group:

```
Streakly/
├── Streakly.xcodeproj/
├── Streakly/
│   ├── StreaklyApp.swift          (ya existe - punto de entrada de la app)
│   ├── ContentView.swift          (ya existe - lo vas a modificar)
│   ├── Models/                    (modelos de datos)
│   ├── ViewModels/                (lógica de negocio - MVVM)
│   ├── Views/                     (todas las pantallas/vistas)
│   ├── Helpers/                   (extensiones, utilidades)
│   ├── Assets.xcassets/           (ya existe - colores, ícono, imágenes)
│   └── Preview Content/           (ya existe - datos de preview)
├── .gitignore
├── PLAN.md
└── README.md
```

**Importante**: Creá las carpetas desde Xcode (New Group), NO desde Finder. Si las creás desde Finder, Xcode no las va a reconocer como parte del proyecto.

---

# 3. Archivos y Carpetas — Qué Debe y Qué No Debe Estar

## Lo que DEBE estar en el proyecto

- **StreaklyApp.swift**: Punto de entrada obligatorio. Sin esto, no compila.
- **Assets.xcassets/AppIcon**: El ícono de la app. Apple rechaza apps sin ícono.
- **Assets.xcassets/AccentColor**: Color de acento de la app.
- **Info.plist** (o su equivalente en el target): Configuración de la app. Xcode lo maneja automáticamente en proyectos nuevos.
- **Todos tus archivos .swift**: Tu código fuente.
- **project.pbxproj**: La configuración del proyecto de Xcode. Sin esto, el proyecto no abre.

## Lo que NO debe estar en el repositorio

- **xcuserdata/**: Preferencias locales de Xcode (ya está en .gitignore).
- **DerivedData/**: Archivos de compilación (ya está en .gitignore).
- **build/**: Archivos de build (ya está en .gitignore).
- **Archivos .xcuserstate**: Estado de la interfaz de Xcode (ya está en .gitignore).
- **Credenciales, API keys, contraseñas**: Nada de esto debería estar en tu código ni en tu repo. Streakly no necesita nada de esto, pero es buena práctica saberlo.
- **Provisioning profiles y certificados**: Xcode los maneja automáticamente con "Automatically manage signing".

## Lo que Apple requiere para aceptar la app

- Ícono de la app en todos los tamaños requeridos (se configura en Assets.xcassets/AppIcon, un solo archivo de 1024x1024 basta y Xcode genera los demás)
- La app debe hacer algo útil (no puede ser una pantalla vacía o un placeholder)
- Debe funcionar sin crashes
- Debe respetar las Human Interface Guidelines de Apple (diseño coherente)
- Debe tener una política de privacidad (URL)
- La descripción en la App Store debe ser precisa (no puede prometer cosas que la app no hace)

---

# 4. Arquitectura MVVM — Explicada Simple

## ¿Qué es MVVM?

MVVM significa **Model - View - ViewModel**. Es una forma de organizar tu código para que no sea todo un lío mezclado. Pensalo así:

```
┌─────────────┐     ┌──────────────────┐     ┌─────────────┐
│             │     │                  │     │             │
│    MODEL    │◄────│    VIEWMODEL     │◄────│    VIEW     │
│  (los datos)│     │  (la lógica)     │     │  (pantalla) │
│             │────►│                  │────►│             │
└─────────────┘     └──────────────────┘     └─────────────┘
```

### Model (Modelo)

Es la **estructura de los datos**. En Streakly, el modelo sería el hábito en sí: su nombre, descripción, dificultad, cuántas veces se completó, etc. El modelo NO sabe cómo se muestra en pantalla. Solo define qué datos existen.

**En tu proyecto**: La carpeta `Models/` — Acá van los structs/classes que definen tus datos.

### View (Vista)

Es **lo que el usuario ve y toca**. Las pantallas, los botones, las listas. La vista NO debería tener lógica de negocio. Solo muestra datos y reporta acciones del usuario.

**En tu proyecto**: La carpeta `Views/` — Acá van tus archivos SwiftUI con las pantallas.

### ViewModel (Modelo de Vista)

Es el **puente** entre el Modelo y la Vista. Acá va la lógica: agregar un hábito, marcar como completado, calcular puntajes, calcular rachas. El ViewModel lee y modifica los datos (Model) y la Vista observa al ViewModel para actualizarse.

**En tu proyecto**: La carpeta `ViewModels/` — Acá van las clases con `@Observable` que manejan la lógica.

## ¿Por qué usarla en Streakly?

1. **Orden**: Sabés exactamente dónde buscar cada cosa.
2. **Mantenimiento**: Si querés cambiar cómo se calcula la racha, solo tocás el ViewModel, no las vistas.
3. **Escalabilidad**: Cuando quieras agregar features en v2, no tenés que reescribir todo.
4. **Portfolio**: Demuestra que entendés arquitectura, que es algo que buscan los empleadores.

## Cómo se aplica en Streakly

```
MODELS:
  └── Habit         → struct/class que define un hábito
                       (nombre, descripción, dificultad, completions, fechas)

VIEWMODELS:
  └── HabitViewModel → clase @Observable que maneja la lógica
                        (agregar hábito, completar hábito, calcular racha, calcular puntos)

VIEWS:
  ├── HabitListView      → pantalla principal con la lista de hábitos
  ├── AddHabitView       → formulario para crear un nuevo hábito
  ├── HabitDetailView    → detalle de un hábito (completions, racha, puntos)
  └── (ContentView)      → punto de entrada que muestra HabitListView
```

**Flujo ejemplo: El usuario marca un hábito como completado**
1. La **View** (HabitDetailView) detecta que el usuario tocó el botón "Completar"
2. La View le dice al **ViewModel**: "Che, completá este hábito"
3. El ViewModel actualiza el **Model**: incrementa el contador, recalcula la racha
4. Como la View observa al ViewModel (gracias a `@Observable`), la pantalla se actualiza automáticamente

## Pista importante

No te obsesiones con que sea MVVM perfecto desde el día 1. Empezá simple y refactorizá después. Es mejor una app que funciona con arquitectura imperfecta que una app que nunca terminás porque querés que la arquitectura sea perfecta.

---

# 5. Modelo de Datos

## El hábito (Habit)

Este es el dato central de tu app. Cada hábito necesita estas propiedades:

| Propiedad | Tipo | Descripción |
|-----------|------|-------------|
| `id` | UUID | Identificador único (para que SwiftUI pueda diferenciar hábitos en listas) |
| `name` | String | Nombre del hábito (ej: "Practicar guitarra") |
| `description` | String | Descripción opcional del hábito |
| `difficulty` | Enum | Fácil (1pt), Medio (3pt) o Difícil (5pt) |
| `completionDates` | [Date] | Array de fechas en las que se completó el hábito |
| `createdAt` | Date | Fecha de creación del hábito |

### ¿Por qué `completionDates` en lugar de un simple contador?

Porque con un array de fechas podés:
- Saber el total de completions (es el `.count` del array)
- Calcular la racha actual (cuántos días seguidos hay hasta hoy)
- En el futuro, mostrar un calendario o historial

Si solo guardaras un número (`completionCount = 5`), no podrías saber cuándo se completó ni calcular rachas.

### Sobre la dificultad (Difficulty)

Definí un enum con tres casos. Cada caso tiene un valor en puntos asociado. Esto es limpio y fácil de extender.

**Pista**: Un enum en Swift puede tener un `rawValue` de tipo Int, lo cual es perfecto para los puntos. También puede conformar a `Codable` y `CaseIterable` (para usarlo fácilmente en un Picker).

### Sobre SwiftData

SwiftData es el reemplazo moderno de CoreData. Te permite guardar datos de forma persistente (que sobrevivan al cierre de la app) de manera muy simple.

**Conceptos clave que necesitás saber:**
- Usás el macro `@Model` en tu clase/struct para decirle a SwiftData que lo persista
- En tu `StreaklyApp.swift` configurás un `modelContainer` para que toda la app tenga acceso a los datos
- En tus views usás `@Query` para leer datos y `@Environment(\.modelContext)` para escribir/borrar datos
- SwiftData guarda y lee los datos automáticamente, no necesitás llamar a "save" manualmente en la mayoría de los casos

**Pista**: Si ya viste `Codable` y `UserDefaults`, pensá en SwiftData como una versión mucho más poderosa y automática de lo mismo. En lugar de encodear/decodear JSON a mano, SwiftData hace todo solo.

**Decisión importante para MVVM + SwiftData**: Con SwiftData, la persistencia la maneja el framework directamente. Tu ViewModel va a usar el `modelContext` para crear/modificar/borrar hábitos, y las Views van a usar `@Query` para leer. Esto simplifica bastante las cosas.

---

# 6. Estructura de Archivos Completa

```
Streakly/
├── Streakly.xcodeproj/
├── Streakly/
│   │
│   ├── StreaklyApp.swift              ← Punto de entrada. Configurás el modelContainer acá.
│   ├── ContentView.swift              ← Vista raíz. Contiene el NavigationStack y muestra HabitListView.
│   │
│   ├── Models/
│   │   ├── Habit.swift                ← Struct/Class del hábito con @Model (SwiftData)
│   │   └── Difficulty.swift           ← Enum de dificultad (easy, medium, hard) con puntos
│   │
│   ├── ViewModels/
│   │   └── HabitViewModel.swift       ← Clase @Observable con toda la lógica de negocio
│   │
│   ├── Views/
│   │   ├── HabitListView.swift        ← Pantalla principal: lista de hábitos
│   │   ├── AddHabitView.swift         ← Sheet/formulario para agregar un hábito nuevo
│   │   └── HabitDetailView.swift      ← Detalle del hábito: completions, racha, puntos, botón completar
│   │
│   ├── Helpers/
│   │   └── Color+Theme.swift          ← Extensión con los colores de la paleta de Streakly
│   │
│   ├── Assets.xcassets/
│   │   ├── AppIcon.appiconset/        ← Ícono de la app (1024x1024)
│   │   ├── AccentColor.colorset/      ← Color de acento (teal)
│   │   └── Contents.json
│   │
│   └── Preview Content/
│       └── Preview Assets.xcassets/
│
├── .gitignore
├── PLAN.md
└── README.md
```

## Orden de creación recomendado

Seguí este orden. Cada paso construye sobre el anterior:

| Orden | Archivo | Por qué en este orden |
|-------|---------|----------------------|
| 1 | `Difficulty.swift` | Es lo más simple. Un enum con 3 casos. Te da confianza para arrancar. |
| 2 | `Habit.swift` | El modelo de datos. Usa el enum de Difficulty. Todo lo demás depende de esto. |
| 3 | `StreaklyApp.swift` | Configurar el modelContainer de SwiftData. Sin esto, nada funciona. |
| 4 | `HabitViewModel.swift` | La lógica de negocio. Ya tenés el modelo, ahora dale comportamiento. |
| 5 | `HabitListView.swift` | La pantalla principal. Ya podés mostrar hábitos (aunque sea datos de prueba). |
| 6 | `AddHabitView.swift` | El formulario. Ahora podés agregar hábitos de verdad. |
| 7 | `HabitDetailView.swift` | El detalle. Completar hábitos, ver racha, ver puntos. |
| 8 | `ContentView.swift` | Conectar todo: NavigationStack + HabitListView. |
| 9 | `Color+Theme.swift` | Pulir los colores y el diseño visual. |
| 10 | `AppIcon` | El ícono, al final cuando todo funcione. |

---

# 7. Plan de Desarrollo — Fase por Fase

## FASE 1: Fundamentos (Semana 1)

**Objetivo**: Tener el modelo de datos funcionando y la estructura del proyecto lista.

### Tareas:

**1.1 — Corregir el .gitignore y limpiar el repo**
- Eliminar la línea `*.xcodeproj` de la sección SPM del .gitignore
- Eliminar el archivo xcuserstate del tracking de git
- Commit: "Fix .gitignore and remove tracked xcuserstate"

**1.2 — Crear la estructura de carpetas**
- Crear las carpetas Models/, ViewModels/, Views/, Helpers/ desde Xcode
- Pista: Click derecho en la carpeta Streakly → New Group

**1.3 — Crear el enum Difficulty**
- Archivo: `Models/Difficulty.swift`
- Tres casos: easy, medium, hard
- Cada caso con un valor en puntos (1, 3, 5)
- Debe conformar a: `Codable`, `CaseIterable`
- Pista: Pensá en un `rawValue` de tipo Int para los puntos, o una computed property
- Pista: `CaseIterable` te permite iterar todos los casos en un Picker fácilmente

**1.4 — Crear el modelo Habit**
- Archivo: `Models/Habit.swift`
- Propiedades: id, name, description, difficulty, completionDates, createdAt
- Debe usar `@Model` de SwiftData
- Pista: `@Model` reemplaza a `Codable` + `UserDefaults`. No necesitás conformar a Codable si usás SwiftData
- Pista: El `id` se genera automáticamente con `UUID()` como valor por defecto
- Pista: `completionDates` arranca como un array vacío `[]`
- Pista: `createdAt` arranca con `Date.now`

**1.5 — Configurar SwiftData en StreaklyApp.swift**
- Agregar `.modelContainer(for: Habit.self)` a tu WindowGroup
- Pista: Esto le dice a la app "guardar y leer datos de tipo Habit"
- Pista: Solo necesitás una línea, es un modifier como cualquier otro

**1.6 — Commit de la Fase 1**
- Commit: "Set up project structure, data model, and SwiftData"

---

## FASE 2: Pantalla Principal — Lista de Hábitos (Semana 1-2)

**Objetivo**: Ver una lista de hábitos en pantalla, aunque sean datos de prueba al principio.

### Tareas:

**2.1 — Crear HabitListView**
- Archivo: `Views/HabitListView.swift`
- Una `List` que muestre todos los hábitos
- Cada fila muestra: nombre del hábito, dificultad, y cuántas veces se completó
- Usar `@Query` de SwiftData para obtener los hábitos
- Pista: `@Query var habits: [Habit]` — SwiftData se encarga de traer todos los hábitos guardados
- Pista: Si la lista está vacía, mostrá un mensaje tipo "No habits yet. Tap + to start." usando `ContentUnavailableView` o un simple `Text` dentro de un `if habits.isEmpty`

**2.2 — Conectar con ContentView**
- ContentView debe tener un `NavigationStack` que muestre `HabitListView`
- Agregar un `.navigationTitle("Streakly")` y un botón "+" en el toolbar
- Pista: `.toolbar { ToolbarItem(placement: .navigationBarTrailing) { Button... } }`

**2.3 — Crear HabitViewModel**
- Archivo: `ViewModels/HabitViewModel.swift`
- Por ahora, solo necesitás un método para agregar un hábito y uno para eliminar
- El ViewModel recibe el `modelContext` para poder crear/borrar datos
- Pista: `modelContext.insert(nuevoHabito)` agrega un hábito
- Pista: `modelContext.delete(habito)` elimina un hábito

**2.4 — Agregar swipe para eliminar**
- En la lista, permitir que el usuario haga swipe a la izquierda para eliminar un hábito
- Pista: `.onDelete` en un `ForEach` dentro de la `List`
- Pista: Conectá el delete con el método del ViewModel

**2.5 — Commit de la Fase 2**
- Commit: "Add habit list view with SwiftData query and delete"

---

## FASE 3: Agregar Hábitos (Semana 2)

**Objetivo**: El usuario puede crear hábitos nuevos desde un formulario.

### Tareas:

**3.1 — Crear AddHabitView**
- Archivo: `Views/AddHabitView.swift`
- Formulario con: TextField para nombre, TextField para descripción, Picker para dificultad
- Botón "Save" para guardar el hábito
- Pista: Usá `@State` para las variables del formulario (name, description, difficulty)
- Pista: Usá `@Environment(\.dismiss)` para cerrar el sheet después de guardar
- Pista: Para el Picker de dificultad, `Difficulty.allCases` te da los tres casos (gracias a CaseIterable)

**3.2 — Mostrar AddHabitView como Sheet**
- Desde HabitListView, al tocar el botón "+", se abre AddHabitView como un `.sheet`
- Pista: Necesitás un `@State var showingAddHabit = false` y `.sheet(isPresented: $showingAddHabit)`

**3.3 — Validación básica**
- No permitir guardar un hábito sin nombre (el botón Save se deshabilita)
- Pista: `.disabled(name.isEmpty)` en el botón Save
- Pista: Opcionalmente, `.trimmingCharacters(in: .whitespaces)` para que no cuenten solo espacios

**3.4 — Commit de la Fase 3**
- Commit: "Add habit creation form with validation"

---

## FASE 4: Detalle del Hábito (Semana 2-3)

**Objetivo**: Al tocar un hábito, ver su detalle y poder marcarlo como completado.

### Tareas:

**4.1 — Crear HabitDetailView**
- Archivo: `Views/HabitDetailView.swift`
- Muestra: nombre, descripción, dificultad, veces completado, racha actual, puntos acumulados
- Botón prominente "Mark as Complete" para registrar una completion
- Pista: Recibí el hábito como parámetro: `let habit: Habit`
- Pista: Como el hábito viene de SwiftData y es una clase con `@Model`, las modificaciones se guardan automáticamente

**4.2 — Navegación desde la lista al detalle**
- En HabitListView, cada fila es un `NavigationLink` que lleva a HabitDetailView
- Pista: `NavigationLink(value: habit)` con `.navigationDestination(for: Habit.self)`
- Pista alternativa (más simple): `NavigationLink { HabitDetailView(habit: habit) } label: { ... }`

**4.3 — Botón "Mark as Complete"**
- Al tocar, agrega la fecha actual al array `completionDates` del hábito
- Solo se puede completar UNA VEZ por día (si ya lo completó hoy, el botón cambia o se deshabilita)
- Pista: Para saber si ya se completó hoy, verificá si alguna fecha en `completionDates` es del mismo día que hoy
- Pista: Usá `Calendar.current.isDateInToday(date)` para esa verificación
- Pista: Cuando se completa, SwiftData guarda el cambio automáticamente

**4.4 — Mostrar información calculada**
- Veces completado: `habit.completionDates.count`
- Puntos del hábito: `habit.completionDates.count * habit.difficulty.points`
- Racha: Calculá los días seguidos hasta hoy (ver Sección 9 para la lógica)

**4.5 — Commit de la Fase 4**
- Commit: "Add habit detail view with completion tracking"

---

## FASE 5: Diseño y Pulido Visual (Semana 3-4)

**Objetivo**: Que la app se vea profesional, minimalista y coherente con la identidad de Streakly.

### Tareas:

**5.1 — Aplicar la paleta de colores**
- Crear `Helpers/Color+Theme.swift` con la extensión de colores (ver Sección 8)
- Configurar el AccentColor en Assets.xcassets con el teal
- Aplicar los colores en todas las vistas

**5.2 — Pulir la lista de hábitos**
- Cada fila debe verse limpia: nombre a la izquierda, info secundaria a la derecha
- Usar tipografía con jerarquía (título más grande, subtítulo más chico y gris)
- Agregar un indicador visual de si ya se completó hoy (un circulito o checkmark)

**5.3 — Pulir el formulario**
- Que los campos tengan labels claros
- Que el Picker de dificultad se vea bien (un SegmentedPicker queda lindo acá)
- Que el botón Save sea claro y prominente

**5.4 — Pulir el detalle**
- Organizar la información en secciones claras
- El botón "Mark as Complete" debe ser grande, centrado y claro
- Si ya se completó hoy, mostrar un estado diferente (ej: checkmark verde en vez del botón)
- Puntaje discreto, no prominente

**5.5 — Estado vacío**
- Cuando no hay hábitos, mostrar un mensaje amable y claro
- Pista: `ContentUnavailableView` es perfecto para esto, viene built-in en iOS 17

**5.6 — Commit de la Fase 5**
- Commit: "Apply visual design, colors, and polish UI"

---

## FASE 6: Dark Mode y Refinamientos (Semana 4)

**Objetivo**: Asegurarte de que la app se ve bien en ambos modos y corregir detalles.

### Tareas:

**6.1 — Revisar Dark Mode**
- Ver la Sección 10 para cómo abordar Dark Mode correctamente
- Probar cada pantalla en ambos modos desde el simulador
- Corregir cualquier color que se vea mal

**6.2 — Revisar accesibilidad básica**
- Verificar que el texto sea legible en ambos modos
- Verificar que los botones sean lo suficientemente grandes para tocar cómodamente (mínimo 44x44 puntos, que es el estándar de Apple)

**6.3 — Probar en diferentes tamaños de iPhone**
- Probar en: iPhone SE (pantalla chica), iPhone 15 (estándar), iPhone 15 Pro Max (grande)
- Verificar que nada se rompa o se vea mal
- Pista: Desde el simulador podés cambiar de dispositivo fácilmente

**6.4 — Commit de la Fase 6**
- Commit: "Add dark mode support and UI refinements"

---

## FASE 7: Ícono y Assets Finales (Semana 4)

**Objetivo**: Crear el ícono de la app y preparar los assets visuales.

### Tareas:

**7.1 — Crear el ícono de la app**
- Necesitás una imagen de **1024x1024 píxeles** en formato PNG, sin transparencia
- Opciones gratuitas para crearlo:
  - **Canva** (canva.com): Gratis, muy fácil de usar, tiene templates para íconos de apps
  - **Figma** (figma.com): Gratis, más profesional, ideal si querés aprender diseño
  - **SF Symbols como base**: Podés usar un símbolo como inspiración y recrearlo en Canva/Figma
- Para Streakly, un buen ícono sería: un fondo teal/verde azulado con un símbolo minimalista (como un checkmark, una llama de racha, o líneas ascendentes representando progreso)
- Pista: Mantené el ícono SIMPLE. Los mejores íconos de App Store son los más simples.
- Pista: Evitá poner texto en el ícono (se ve minúsculo en el iPhone)

**7.2 — Agregar el ícono a Xcode**
- Abrir `Assets.xcassets` → `AppIcon`
- Arrastrar tu imagen de 1024x1024 al slot "All Sizes" (en Xcode 15+, solo necesitás un tamaño y Xcode genera los demás automáticamente)
- Verificar en el simulador que se ve bien

**7.3 — Commit de la Fase 7**
- Commit: "Add app icon"

---

## FASE 8: Testing y Preparación para Publicación (Semana 4-5)

**Objetivo**: Asegurarte de que todo funciona correctamente antes de subir a la App Store.

### Tareas:

**8.1 — Testing manual completo**
Probá TODOS estos escenarios en el simulador:
- [ ] Crear un hábito con nombre y descripción
- [ ] Crear un hábito sin descripción (debería funcionar)
- [ ] Intentar crear un hábito sin nombre (no debería dejar)
- [ ] Crear hábitos con las 3 dificultades
- [ ] Marcar un hábito como completado
- [ ] Intentar marcar el mismo hábito dos veces en el mismo día (no debería dejar)
- [ ] Verificar que la racha se calcula correctamente
- [ ] Verificar que los puntos se calculan correctamente
- [ ] Eliminar un hábito (swipe to delete)
- [ ] Cerrar y abrir la app (los datos deben persistir)
- [ ] Probar en Light Mode
- [ ] Probar en Dark Mode
- [ ] Probar en iPhone SE, iPhone 15, iPhone 15 Pro Max
- [ ] Verificar que no hay crashes

**8.2 — Probar en dispositivo físico (si es posible)**
- Conectá tu iPhone al Mac con cable
- Seleccioná tu dispositivo en Xcode (en lugar del simulador)
- Compilá y probá la app en un dispositivo real
- Pista: Necesitás tu Apple ID configurado en Xcode → Settings → Accounts
- Pista: La primera vez te va a pedir que confíes en el developer en el iPhone: Settings → General → VPN & Device Management

**8.3 — Optimizar el tamaño de la app**
- No debería ser un problema para Streakly ya que es simple, pero verificá que no estés incluyendo assets innecesarios

**8.4 — Commit de la Fase 8**
- Commit: "Complete testing and prepare for App Store submission"

---

# 8. Guía de Diseño

## Paleta de Colores

### Colores principales

| Nombre | Uso | Hex Light Mode | Hex Dark Mode |
|--------|-----|---------------|---------------|
| **Teal (Accent)** | Botones, elementos activos, accent | `#2A9D8F` | `#2A9D8F` (mismo) |
| **Background** | Fondo principal | `#FFFFFF` | `#000000` |
| **Surface** | Tarjetas, cards, celdas | `#F8F9FA` | `#1C1C1E` |
| **Text Primary** | Texto principal | `#1A1A2E` | `#F5F5F5` |
| **Text Secondary** | Texto secundario, subtítulos | `#6B7280` | `#8E8E93` |
| **Success** | Completado, checkmarks | `#2A9D8F` | `#2A9D8F` (mismo teal) |
| **Divider** | Líneas separadoras | `#E5E7EB` | `#2C2C2E` |

### Código de ejemplo para los colores

```swift
// Helpers/Color+Theme.swift

import SwiftUI

extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    let accent = Color("AccentColor")         // Configurado en Assets.xcassets
    let background = Color(.systemBackground) // Se adapta a Light/Dark automáticamente
    let surface = Color(.secondarySystemBackground)
    let textPrimary = Color(.label)           // Negro en light, blanco en dark
    let textSecondary = Color(.secondaryLabel)
    let success = Color("AccentColor")        // Mismo teal
    let divider = Color(.separator)
}
```

**Nota importante**: Fijate que muchos colores usan los colores del SISTEMA de Apple (`Color(.systemBackground)`, `Color(.label)`, etc.). Esto es intencional: estos colores se adaptan automáticamente a Light y Dark mode sin que tengas que hacer nada. Es la forma correcta de manejar colores en iOS.

El único color "custom" real es el **AccentColor (teal `#2A9D8F`)**, que lo configurás en `Assets.xcassets/AccentColor.colorset`.

### Cómo configurar el AccentColor en Assets.xcassets

1. En Xcode, abrí `Assets.xcassets`
2. Seleccioná `AccentColor`
3. En el panel derecho (Attributes Inspector), configurá:
   - **Any Appearance**: Color `#2A9D8F`
   - **Dark Appearance**: Mismo `#2A9D8F` (o si querés, uno ligeramente más brillante como `#3DB8A9`)
4. Este color se usa automáticamente como tint en NavigationStack, botones, etc.

## Tipografía

No uses fuentes custom. Usá las fuentes del sistema de Apple con los estilos predefinidos. Son legibles, profesionales y se adaptan a las preferencias de accesibilidad del usuario.

### Jerarquía de textos

```swift
// Título de pantalla (lo maneja .navigationTitle automáticamente)

// Nombre del hábito en la lista
Text(habit.name)
    .font(.headline)

// Descripción o info secundaria
Text(habit.description)
    .font(.subheadline)
    .foregroundStyle(Color.theme.textSecondary)

// Números grandes (completions, puntos)
Text("\(habit.completionDates.count)")
    .font(.title)
    .fontWeight(.bold)

// Labels pequeños
Text("Total points")
    .font(.caption)
    .foregroundStyle(Color.theme.textSecondary)
```

## Espaciado y Layout

- **Padding general**: Usá el padding por defecto de SwiftUI (`.padding()`) que son 16 puntos. Es consistente y suficiente.
- **Espaciado entre elementos en un VStack**: Usá `spacing: 8` para elementos relacionados, `spacing: 16` para secciones.
- **Bordes redondeados**: `.clipShape(RoundedRectangle(cornerRadius: 12))` para tarjetas o contenedores.
- **Mucho espacio en blanco**: La clave del minimalismo es NO llenar la pantalla. Si dudás entre poner algo o no ponerlo, no lo pongas.

### Ejemplo de estilo para una tarjeta/celda

```swift
// Estilo de contenedor para secciones en el detalle
VStack {
    // contenido
}
.padding()
.background(Color.theme.surface)
.clipShape(RoundedRectangle(cornerRadius: 12))
```

## Íconos (SF Symbols)

Usá SF Symbols para todos los íconos dentro de la app. Son nativos, se adaptan a Dynamic Type y quedan profesionales.

Símbolos sugeridos para Streakly:
- **Agregar hábito**: `plus`
- **Completar hábito**: `checkmark.circle` / `checkmark.circle.fill`
- **Racha/fuego**: `flame` / `flame.fill`
- **Puntos/estrella**: `star` / `star.fill`
- **Dificultad fácil**: `1.circle.fill`
- **Dificultad media**: `2.circle.fill`
- **Dificultad difícil**: `3.circle.fill`
- **Eliminar**: `trash`
- **Hábito no completado hoy**: `circle` (vacío)
- **Hábito completado hoy**: `checkmark.circle.fill` (lleno, color teal)

---

# 9. Sistema de Rachas (Streaks)

## ¿Conviene incluirlo en la v1?

**Sí**, y por estas razones:
1. La app se llama Streakly, sería raro que no muestre rachas
2. La lógica no es tan compleja como parece
3. No contradice el minimalismo si se muestra sutilmente
4. Es el diferenciador principal respecto a un simple counter

## Cómo funciona la lógica (conceptual)

Una racha es: **cuántos días consecutivos (hasta hoy o ayer) se completó el hábito.**

### Algoritmo conceptual:

1. Tomá el array `completionDates` y ordenalas de más reciente a más antigua
2. Eliminá duplicados del mismo día (por si acaso)
3. Empezá desde hoy (o ayer, si hoy todavía no lo completó)
4. Andá día por día hacia atrás contando
5. Cuando encuentres un día sin completion, parás. Ese es el largo de la racha.

### Ejemplo:

```
Hoy: 28 de febrero
completionDates: [28 feb, 27 feb, 26 feb, 24 feb, 23 feb]

Racha actual: 3 (28, 27, 26 son consecutivos. El 25 no está, se corta.)
```

### Pistas para la implementación:

- Usá `Calendar.current` para manejar fechas. No compares fechas directamente porque incluyen hora/minuto/segundo.
- `Calendar.current.isDate(date1, inSameDayAs: date2)` te dice si dos fechas son el mismo día
- `Calendar.current.date(byAdding: .day, value: -1, to: date)` te da el día anterior
- La racha puede empezar desde hoy O desde ayer (si el usuario todavía no completó el hábito hoy, no querés que la racha aparezca como 0 cuando ayer sí lo hizo)
- Poné la lógica de cálculo de racha en el ViewModel o como una computed property en el modelo

### Dónde mostrarlo:

- En el **HabitDetailView**: Mostrar un numerito con un ícono de fuego (🔥 o `flame.fill`)
- Opcionalmente en la **lista**: Un pequeño indicador si la racha es mayor a 0
- **No** hacer que la racha sea lo más prominente de la pantalla — es un dato más, no el centro

---

# 10. Dark Mode

## Cómo abordarlo correctamente

La buena noticia: si usás los colores del sistema de Apple (como sugiero en la Sección 8), **el 90% del Dark Mode funciona solo**.

### Regla de oro

Nunca hardcodees colores como `Color.white` o `Color.black` para fondos o textos. Siempre usá:

```swift
// ✅ CORRECTO — se adapta automáticamente
Color(.systemBackground)    // Blanco en light, negro en dark
Color(.label)               // Negro en light, blanco en dark
Color(.secondaryLabel)      // Gris en ambos modos

// ❌ INCORRECTO — no se adapta
Color.white                 // Siempre blanco, incluso en dark mode
Color.black                 // Siempre negro, incluso en dark mode
```

### Colores del sistema útiles

| Color del sistema | Light Mode | Dark Mode | Uso |
|------------------|------------|-----------|-----|
| `.systemBackground` | Blanco | Negro | Fondo principal |
| `.secondarySystemBackground` | Gris muy claro | Gris muy oscuro | Tarjetas, celdas |
| `.label` | Negro | Blanco | Texto principal |
| `.secondaryLabel` | Gris medio | Gris medio | Texto secundario |
| `.separator` | Gris claro | Gris oscuro | Líneas divisorias |

### Cómo probar Dark Mode

**En el simulador:**
- Mientras la app corre, andá al menú de Xcode: Features → Toggle Appearance
- O desde el iPhone simulado: Settings → Display & Brightness → Dark

**En las previews de SwiftUI:**
- Agregá `.preferredColorScheme(.dark)` a tu preview para ver cómo queda en dark mode

### Qué revisar

- Que los textos sean legibles sobre los fondos
- Que los colores custom (tu teal) se vean bien en ambos modos
- Que no haya elementos "invisibles" (texto blanco sobre fondo blanco, por ejemplo)
- Que las imágenes/íconos se vean bien en ambos fondos

---

# 11. Apple Developer Account

## Paso a paso para registrarte

### Requisitos previos
- Un Apple ID (el que ya usás para iCloud, App Store, etc.)
- Autenticación de dos factores activada en tu Apple ID
- Una tarjeta de crédito/débito internacional (para pagar los USD $99/año)

### Pasos

1. **Andá a** [developer.apple.com/programs/enroll](https://developer.apple.com/programs/enroll)
2. **Iniciá sesión** con tu Apple ID
3. **Seleccioná "Individual / Sole Proprietor"** (persona física) — ya lo decidimos
4. **Completá tus datos personales**: nombre legal completo, dirección, teléfono
5. **Aceptá el Apple Developer Agreement**
6. **Pagá los USD $99** (o equivalente en tu moneda local). Se renueva anualmente.
7. **Esperá la confirmación**: puede tardar desde unas horas hasta 48 horas hábiles. Apple verifica tu identidad.
8. **Una vez aprobado**: volvé a Xcode → Settings → Accounts y tu Apple ID debería aparecer con el Team asociado

### Cuándo hacerlo

No necesitás la cuenta para desarrollar ni probar en simulador. La necesitás para:
- Probar en dispositivo físico de forma prolongada (sin cuenta de pago, las apps expirar a los 7 días)
- Subir tu app a App Store Connect
- Publicar en la App Store

**Recomendación**: Creá la cuenta cuando vayas por la Fase 6-7 del desarrollo. Así cuando terminés de desarrollar, ya la tenés lista.

### Importante sobre el nombre

El nombre que pongas en la cuenta de developer es el que aparece en la App Store como "Desarrollador". Usá tu nombre real y profesional.

---

# 12. Política de Privacidad

## ¿Qué es y por qué Apple la exige?

Una política de privacidad es un documento legal que explica a los usuarios qué datos recopila tu app, cómo los usa, y con quién los comparte. Apple la exige para TODAS las apps, incluso si tu app no recopila ningún dato.

Para Streakly, la política es muy simple porque **todos los datos se guardan localmente en el dispositivo del usuario** y no se envían a ningún servidor.

## Contenido de la política de privacidad de Streakly

La política debe incluir (en inglés, ya que la app es en inglés):

1. **Qué datos almacena la app**: Nombres de hábitos, descripciones y fechas de completación. Todos creados por el usuario.
2. **Dónde se almacenan**: Localmente en el dispositivo. No se envían a servidores externos.
3. **Datos que NO se recopilan**: No se recopila información personal, ubicación, analytics, ni ningún otro dato.
4. **Terceros**: No se comparten datos con terceros.
5. **Contacto**: Un email de contacto para consultas.

## GitHub Pages — Explicado desde cero

### ¿Qué es GitHub Pages?

GitHub Pages es un servicio **gratuito** de GitHub que te permite crear una página web simple a partir de un repositorio. Básicamente, subís un archivo HTML (o Markdown) a un repo de GitHub, y GitHub lo convierte en una página web pública con una URL tipo `tunombredeusuario.github.io/nombre-del-repo`.

Es perfecto para hostear una política de privacidad porque:
- Es gratis
- No necesitás saber hacer páginas web
- No necesitás comprar un dominio
- No necesitás un servidor
- Se actualiza automáticamente cuando editás el archivo

### Paso a paso para crear la política de privacidad con GitHub Pages

**Paso 1: Crear un repositorio nuevo en GitHub**
- Andá a github.com y creá un nuevo repositorio
- Nombre sugerido: `streakly-privacy` o `streakly-support`
- Hacelo **público** (GitHub Pages gratis solo funciona con repos públicos)
- Marcá "Add a README file"

**Paso 2: Crear el archivo de la política**
- Dentro del repo, hacé click en "Add file" → "Create new file"
- Nombralo `index.md` (este es el archivo que GitHub Pages va a mostrar como página principal)
- Escribí la política de privacidad en Markdown (el mismo formato que este PLAN.md)
- Contenido sugerido:

```markdown
# Streakly — Privacy Policy

**Last updated: [fecha de publicación]**

## Overview

Streakly is a habit tracking app designed with your privacy in mind. We believe in simplicity — not just in design, but in how we handle your data.

## Data Collection

**Streakly does not collect any personal data.**

All information you enter in the app (habit names, descriptions, and completion dates) is stored **locally on your device only**. This data never leaves your device and is never transmitted to any server.

## Data Storage

All app data is stored using Apple's SwiftData framework on your device. This data is:
- Stored only on your device
- Not accessible to us or any third party
- Not backed up to any external server by the app itself
- Deleted when you uninstall the app

## Third-Party Services

Streakly does not use any third-party analytics, advertising, or tracking services.

## Your Rights

Since all data is stored locally on your device, you have full control over it at all times. You can delete any habit or all your data directly within the app, or by uninstalling the app.

## Children's Privacy

Streakly does not knowingly collect information from children under 13. The app does not collect any personal information from any user.

## Changes to This Policy

If we update this privacy policy, the changes will be posted on this page with an updated revision date.

## Contact

If you have any questions about this privacy policy, you can contact us at:

**[tu-email@ejemplo.com]**
```

- Hacé click en "Commit new file"

**Paso 3: Activar GitHub Pages**
- Andá a la pestaña **Settings** del repositorio (la ruedita de configuración)
- En el menú lateral izquierdo, buscá **"Pages"**
- En "Source", seleccioná **"Deploy from a branch"**
- En "Branch", seleccioná **"main"** y **"/ (root)"**
- Hacé click en **"Save"**

**Paso 4: Esperar y verificar**
- GitHub tarda entre 1 y 5 minutos en generar la página
- Tu política va a estar disponible en: `https://facuvogel23.github.io/streakly-privacy/`
- Verificá que se ve correctamente visitando esa URL

**Paso 5: Guardar la URL**
- Esa URL es la que vas a poner en App Store Connect cuando te pidan la Privacy Policy URL
- También la podés poner en la descripción de la app

### Nota importante

El repositorio de la política de privacidad debe ser **público** para que GitHub Pages funcione gratis. Esto está bien — la política de privacidad es un documento público por naturaleza. Tu repo principal de Streakly (el del código) puede seguir siendo privado.

---

# 13. Configuración de App Store Connect

## ¿Qué es App Store Connect?

Es la plataforma web de Apple donde gestionás tu app: subís builds, configurás la ficha de la tienda, ves estadísticas, gestionás reviews, etc. Accedés desde [appstoreconnect.apple.com](https://appstoreconnect.apple.com) con tu Apple ID de developer.

## Crear la ficha de Streakly

### Información básica

| Campo | Valor sugerido |
|-------|---------------|
| **App Name** | Streakly |
| **Subtitle** | Simple Habit Tracking (máximo 30 caracteres) |
| **Primary Language** | English (U.S.) |
| **Bundle ID** | com.facuvogel.Streakly (el mismo que en Xcode) |
| **SKU** | streakly-v1 (identificador interno, no lo ve el usuario) |
| **Primary Category** | Productivity |
| **Secondary Category** | Health & Fitness (opcional, pero tiene sentido) |
| **Price** | Free (gratis) |
| **Availability** | All territories (todos los países) |

### Descripción para la App Store

```
No distractions. No pressure. Just your habits.

Streakly is a minimalist habit tracker designed for people who want simplicity, not complexity. Add your habits, mark them complete, and build your streaks — that's it.

FEATURES
• Create habits with a name, description, and difficulty level
• Mark habits as complete each day with a single tap
• Track your streaks — see how many days in a row you've kept going
• Earn points based on habit difficulty (Easy, Medium, Hard)
• Clean, distraction-free design
• Works in Light and Dark mode
• All data stored locally on your device — your privacy matters

Streakly is for you if you're tired of habit apps that overwhelm you with notifications, badges, graphs, and subscriptions. Sometimes, less is more.
```

### Keywords

Tenés un máximo de 100 caracteres para keywords (separadas por comas, sin espacios después de la coma). Apple usa estas palabras para el buscador de la App Store.

```
habit,tracker,streak,daily,routine,minimal,simple,habits,productivity,goals
```

**Pistas sobre keywords:**
- No repitas palabras que ya estén en el nombre o subtítulo de la app (Apple las incluye automáticamente)
- No uses el nombre de competidores
- Usá palabras que la gente realmente buscaría

### Age Rating

Vas a tener que completar un cuestionario sobre contenido (violencia, lenguaje, etc.). Para Streakly, todo es "None" → el rating resultante será **4+** (apta para todo público).

### App Privacy (Privacy Nutrition Labels)

Apple te va a pedir que declares qué datos recopila tu app. Para Streakly:
- Seleccioná: **"Data Not Collected"**
- Esto es verdad: Streakly no recopila ni envía ningún dato del usuario

## Screenshots

### Tamaños requeridos

Apple exige screenshots para al menos estos tamaños de pantalla:

| Dispositivo | Resolución | Requerido |
|------------|------------|-----------|
| iPhone 6.9" (15 Pro Max) | 1320 x 2868 | **Obligatorio** |
| iPhone 6.7" (14 Pro Max) | 1290 x 2796 | **Obligatorio** |
| iPhone 6.5" (11 Pro Max) | 1284 x 2778 | Recomendado |
| iPhone 5.5" (8 Plus) | 1242 x 2208 | Solo si soportás iOS 16 o menor |

**Nota**: Si solo soportás iOS 17+, los dos primeros son los que importan. Podés subir las mismas screenshots para ambos tamaños si la diferencia es mínima.

### Cuántas screenshots

- **Mínimo**: 1 por tamaño
- **Máximo**: 10 por tamaño
- **Recomendado**: 3 a 5 screenshots que muestren las pantallas más importantes

### Qué mostrar en las screenshots

1. **Screenshot 1**: La lista de hábitos con varios hábitos cargados (la pantalla principal)
2. **Screenshot 2**: El detalle de un hábito con racha y puntos visibles
3. **Screenshot 3**: El formulario de agregar hábito
4. **Screenshot 4** (opcional): La misma app en Dark Mode
5. **Screenshot 5** (opcional): El estado vacío con el mensaje amable

### Cómo hacer las screenshots

1. Corré la app en el simulador con el tamaño de iPhone correcto
2. Cargá datos de ejemplo que se vean bien (nombres de hábitos reales, rachas, etc.)
3. Tomá la screenshot: en el simulador, `Cmd + S` guarda una screenshot en tu escritorio
4. Opcionalmente, podés agregar un texto/título sobre la screenshot usando Canva o Figma

**Pista**: Las apps con screenshots que tienen texto encima (tipo "Track your habits effortlessly") con la screenshot de fondo se ven mucho más profesionales. Canva tiene templates para esto.

---

# 14. Proceso de Review de Apple

## ¿Cómo funciona?

Cuando subís tu app a App Store Connect y hacés click en "Submit for Review", un equipo de Apple (personas reales + sistemas automatizados) revisa tu app. Verifican que cumpla con las [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/).

## Tiempos

- **Promedio**: 24 a 48 horas
- **Puede tardar hasta**: 5-7 días en casos raros
- Te llega un email cuando la review termina (aprobada o rechazada)

## Motivos comunes de rechazo (y cómo evitarlos)

### 1. Bugs o crashes
- **Causa**: La app crashea durante la review
- **Cómo evitarlo**: Testeá exhaustivamente (Fase 8). Si funciona en el simulador y en un dispositivo real, deberías estar bien.

### 2. Metadata incompleta o imprecisa
- **Causa**: Screenshots que no reflejan la app real, descripción engañosa, falta privacy policy
- **Cómo evitarlo**: Screenshots reales de tu app, descripción honesta, política de privacidad lista

### 3. Design spam / contenido mínimo
- **Causa**: Apple rechaza apps que son demasiado simples o que no aportan valor
- **Cómo evitarlo**: Streakly tiene suficiente funcionalidad (CRUD de hábitos, completions, rachas, dificultad, persistencia). No debería ser un problema, pero asegurate de que la app se sienta completa y funcional.

### 4. Links rotos
- **Causa**: La URL de la política de privacidad no funciona
- **Cómo evitarlo**: Verificá que tu GitHub Pages esté funcionando antes de submitear

### 5. Categoría incorrecta
- **Causa**: La app está en una categoría que no corresponde
- **Cómo evitarlo**: Productivity es perfecta para Streakly

## Si te rechazan

No te preocupes, es muy común en la primera app. Apple te envía un email explicando por qué te rechazaron y qué tenés que corregir. Corregís el problema, subís un nuevo build, y resubmiteás. No cuesta nada extra.

## Cómo subir el build desde Xcode

1. En Xcode, asegurate de que el "Team" esté seleccionado en Signing & Capabilities
2. Seleccioná "Any iOS Device (arm64)" como destino (en lugar de un simulador)
3. Andá al menú: **Product → Archive**
4. Xcode compila y abre el "Organizer" con tu archive
5. Hacé click en **"Distribute App"**
6. Seleccioná **"App Store Connect"**
7. Seguí los pasos (Upload)
8. Esperá unos minutos a que App Store Connect procese el build
9. Andá a App Store Connect (web) y seleccioná el build para tu versión
10. Completá toda la información de la ficha
11. Hacé click en **"Submit for Review"**

---

# 15. Checklist Pre-Publicación

Antes de hacer click en "Submit for Review", verificá que TODOS estos items estén completos:

## Código y funcionalidad
- [ ] La app no crashea en ningún escenario testeado
- [ ] Todos los features de v1 funcionan correctamente
- [ ] Los datos persisten al cerrar y abrir la app
- [ ] Light Mode se ve correctamente
- [ ] Dark Mode se ve correctamente
- [ ] Probado en al menos 3 tamaños de iPhone (SE, estándar, Pro Max)
- [ ] No hay textos placeholder ni datos de prueba hardcodeados
- [ ] No hay `print()` de debug que se hayan quedado en el código
- [ ] No hay TODOs ni FIXMEs sin resolver

## Xcode
- [ ] Bundle Identifier configurado correctamente
- [ ] Version es "1.0"
- [ ] Build es "1"
- [ ] Minimum Deployments es iOS 17.0
- [ ] Solo Portrait orientation
- [ ] Automatically manage signing está activado
- [ ] Team seleccionado (tu Apple Developer Account)
- [ ] Ícono de la app configurado en Assets.xcassets (1024x1024)
- [ ] AccentColor configurado

## App Store Connect
- [ ] App Name: "Streakly"
- [ ] Subtitle configurado
- [ ] Descripción completa y precisa
- [ ] Keywords configurados (máximo 100 caracteres)
- [ ] Category: Productivity
- [ ] Price: Free
- [ ] Screenshots subidas para los tamaños requeridos
- [ ] Age Rating completado (4+)
- [ ] Privacy Policy URL funcionando
- [ ] App Privacy: "Data Not Collected"
- [ ] Copyright: "[Año] Facundo Vogel" (o tu nombre legal)
- [ ] Support URL (puede ser la misma GitHub Page o tu email)
- [ ] Build seleccionado

## Extras
- [ ] .gitignore corregido y limpio
- [ ] Todos los cambios commiteados en git
- [ ] README.md actualizado
- [ ] Política de privacidad publicada en GitHub Pages y accesible

---

# 16. Mejoras Futuras (v2+)

Estas son ideas para después de publicar la v1. **No las implementes ahora**, pero tenerlas en mente ayuda a no tomar decisiones de arquitectura que las bloqueen.

## Mejoras de baja complejidad
- **Editar hábitos existentes**: Cambiar nombre, descripción o dificultad después de crear el hábito
- **Reordenar hábitos**: Que el usuario pueda mover los hábitos en la lista
- **Confirmación al eliminar**: Un alert de "¿Estás seguro?" antes de borrar un hábito

## Mejoras de complejidad media
- **Widget para la Home Screen**: Un widget simple que muestre los hábitos del día. Los widgets en SwiftUI no son muy complejos y dan mucha visibilidad a la app.
- **Recordatorios opcionales**: Notificaciones locales (no push) que el usuario puede activar si quiere. Coherente con el minimalismo: están ahí si las querés, pero no forzadas.
- **Vista de calendario**: Ver en un calendario qué días se completó cada hábito (similar a la grilla de contribuciones de GitHub)
- **Estadísticas simples**: Porcentaje de completitud semanal/mensual. Solo si se mantiene simple.

## Mejoras de alta complejidad (más adelante)
- **iCloud Sync**: Sincronizar datos entre dispositivos del usuario. SwiftData soporta esto con CloudKit, pero requiere configuración extra.
- **Versión para iPad**: Adaptar el layout para pantalla grande
- **Versión para Apple Watch**: Un complication que muestre la racha del día

## Decisiones de arquitectura que protegen el futuro

Para que estas mejoras sean posibles después, tené en cuenta esto AHORA:
- **Usá SwiftData en lugar de UserDefaults**: SwiftData escala mucho mejor y soporta iCloud Sync nativo
- **Guardá fechas completas (Date) en lugar de solo contadores (Int)**: Así después podés hacer calendario, estadísticas, etc.
- **Mantené la lógica en el ViewModel, no en las Views**: Así cuando agregues nuevas vistas, reutilizás la lógica
- **Usá el AccentColor de Assets.xcassets**: Así después podés agregar themes sin cambiar código

---

# 17. README.md para el Repositorio

Cuando la app esté terminada (o al menos funcional), creá un README.md en la raíz del proyecto con esta estructura:

```markdown
# Streakly

A minimalist habit tracking app for iOS, built with SwiftUI and SwiftData.

**No distractions. No pressure. Just your habits.**

## About

Streakly is designed for people who want a simple, clean way to track their daily
habits without being overwhelmed by notifications, badges, or complex statistics.

This is my first iOS app, built as part of the 100 Days of SwiftUI challenge (Day 47)
and published on the App Store.

## Features

- Create habits with name, description, and difficulty level
- Mark habits as complete each day
- Track your streaks — consecutive days of completion
- Earn points based on habit difficulty (Easy, Medium, Hard)
- Clean, minimalist design
- Light and Dark mode support
- All data stored locally on device

## Tech Stack

- **Language**: Swift
- **UI Framework**: SwiftUI
- **Data Persistence**: SwiftData
- **Architecture**: MVVM
- **Minimum iOS**: 17.0
- **Device**: iPhone

## Screenshots

[Agregar screenshots cuando la app esté terminada]

## Architecture

The app follows the MVVM (Model-View-ViewModel) pattern:

- **Models/**: Data structures (Habit, Difficulty)
- **ViewModels/**: Business logic and data management
- **Views/**: SwiftUI views and screens
- **Helpers/**: Extensions and utilities

## Privacy

Streakly does not collect any user data. All information is stored locally on the device.

[Privacy Policy](https://facuvogel23.github.io/streakly-privacy/)

## Author

**Facundo Vogel**

## License

This project is proprietary. All rights reserved.
```

### Notas sobre el README

- **Screenshots**: Agregalas cuando la app esté terminada. Podés subir las imágenes a una carpeta `Screenshots/` en el repo y referenciarlas en el README.
- **License**: Como es una app para la App Store, no uses licencias open source (MIT, Apache, etc.). Si el repo es privado, "All rights reserved" está bien.
- **Link a la App Store**: Cuando se publique, agregá un link/badge a la App Store.
- Actualizá el README a medida que avances. No tiene que estar perfecto desde el día 1.

---

# Resumen Final — Tu Roadmap

```
FASE 1 (Semana 1)     → Modelo de datos + estructura del proyecto
FASE 2 (Semana 1-2)   → Lista de hábitos en pantalla
FASE 3 (Semana 2)     → Formulario para agregar hábitos
FASE 4 (Semana 2-3)   → Detalle del hábito + completar + rachas
FASE 5 (Semana 3-4)   → Diseño y pulido visual
FASE 6 (Semana 4)     → Dark Mode + refinamientos
FASE 7 (Semana 4)     → Ícono y assets finales
FASE 8 (Semana 4-5)   → Testing + publicación

EN PARALELO:
- Semana 2-3: Registrar Apple Developer Account
- Semana 3-4: Crear política de privacidad en GitHub Pages
- Semana 4-5: Configurar App Store Connect y subir
```

**Recordá**: Las semanas son estimativas. No te presiones. Lo importante es que cada fase esté bien hecha antes de pasar a la siguiente. Si una fase te lleva más tiempo, está perfecto.

¡Mucho éxito con Streakly! 🚀
