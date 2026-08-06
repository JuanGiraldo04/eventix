# Eventix

App Flutter de gestión de eventos deportivos: autenticación, listado de eventos con filtros, reserva y compra simulada de entradas, historial de reservas con tickets. Backend en [Supabase](https://supabase.com).

---

## Demo

https://www.loom.com/share/32bd9b71ec7d4f489238c8efd9cdb83d

---

## Por qué Supabase

Se eligió Supabase como backend por tres razones concretas:

1. **Auth + base de datos + autorización en un solo lugar** — el login/registro de Supabase Auth y Postgres comparten el mismo `auth.uid()`, lo que permite escribir políticas de RLS directamente contra las tablas de negocio sin una capa de autorización aparte.
2. **RLS como capa de seguridad real, no una convención de la app** — cada tabla (`profiles`, `events`, `reservations`, `tickets`) tiene sus policies aplicadas en la base de datos; un usuario no puede leer ni escribir fuera de lo que le corresponde aunque el cliente tenga un bug.
3. **RPC transaccional para la regla de negocio crítica** — confirmar una reserva (reducir cupos, emitir tickets, cambiar el estado) tiene que ser atómico. La función `confirmar_reserva` vive en Postgres y corre todo en una sola transacción, evitando condiciones de carrera entre dos compras simultáneas del mismo evento.

---

## Backend — tablas y RPC usados

| Tabla / función | Tipo | Descripción |
|---|---|---|
| `profiles` | Tabla | Perfil de negocio (nombre, avatar), 1:1 con `auth.users` |
| `events` | Tabla | Catálogo de eventos deportivos (categoría, ciudad, fecha, precio, cupos) |
| `reservations` | Tabla | Reserva de entradas de un usuario para un evento |
| `tickets` | Tabla | Entradas individuales emitidas al confirmar una reserva |
| `confirmar_reserva(p_reserva_id)` | RPC | Reduce cupos, emite tickets y confirma la reserva en una transacción |

RLS habilitado en las 4 tablas. Lectura pública en `events`; el resto restringido al dueño de la fila vía `auth.uid()`. Detalle completo en [supabase/migrations](supabase/migrations).

---

## Estructura del proyecto

```
lib/
├── core/
│   ├── env/                        # Variables de entorno (envied)
│   ├── errors/
│   │   ├── failure.dart            # Sealed class de errores de dominio
│   │   └── supabase_error_mapper.dart  # AuthException/PostgrestException → Failure
│   ├── extensions/
│   │   └── theme_extension.dart    # context.textTheme / .colorScheme / .isDark
│   ├── helpers/
│   │   ├── result.dart             # Result<T> sellado (Success / FailureResult)
│   │   └── execute_repository_call.dart
│   ├── l10n/                       # ARB (es/en) + AppLocalizations generado
│   ├── router/
│   │   ├── app_router.dart         # GoRouter + guard de sesión
│   │   ├── app_shell.dart          # Bottom nav (Explorar / Reservas / Perfil)
│   │   └── go_router_refresh_stream.dart  # Reacciona a onAuthStateChange
│   ├── services/supabase/          # Provider del SupabaseClient
│   └── theme/theme_provider.dart   # ThemeMode (system/light/dark)
│
└── features/
    ├── auth/                       # Login, registro, sesión actual, logout
    ├── events/                     # Listado con filtros, detalle
    ├── reservations/               # Checkout, confirmación, mis reservas, detalle
    ├── profile/                    # Perfil + cerrar sesión
    └── splash/                    # Pantalla inicial

    # Cada feature sigue la misma estructura (ejemplo: auth/)
    auth/
    ├── di/                         # Providers Riverpod de inyección de dependencias
    ├── domain/
    │   ├── entities/               # Clases Dart puras (AppUser)
    │   ├── repositories/           # Interfaz abstracta (AuthRepository)
    │   └── usecases/               # Un archivo por caso de uso
    ├── infrastructure/
    │   ├── remote/
    │   │   ├── remote_auth_datasource.dart      # Interfaz
    │   │   └── supabase/                        # Impl + modelos + mappers
    │   └── repositories/           # Impl del repositorio (Supabase → entidad)
    ├── presentation/
    │   ├── providers/              # AsyncNotifier por caso de uso de UI
    │   ├── pages/
    │   └── widgets/
    └── routes/                     # GoRoute de la feature

supabase/
├── migrations/                     # Schema, RLS, triggers y RPC versionados
└── seed.sql                        # Datos de prueba (15 eventos)
```

---

## Arquitectura

Clean Architecture por feature, tres capas:

**`domain`** — entidades Dart puras, interfaz del repositorio (`abstract interface class`) y casos de uso. Sin dependencias de Supabase ni de Flutter UI.

**`infrastructure`** — datasource que habla con Supabase (auth, `postgrest`, RPC) y devuelve modelos; el repositorio convierte esos modelos a entidades del dominio.

**`presentation`** — Riverpod + `app_ui_kit`. Los providers arman el árbol de dependencias, los notifiers exponen `AsyncValue`, las pages consumen los notifiers.

Flujo unidireccional:

```
Page → Provider (Notifier) → UseCase → Repository (interface)
                                              ↓
                                    RepositoryImpl → Datasource → SupabaseClient
```

---

## Sistema de diseño

Todos los componentes visuales (`AppButton`, `AppTextField`, `AppChip`, `AppCard`, `AppBanner`, `AppEmptyState`, `AppErrorState`, etc.) y los tokens (`AppColors`, `AppSpacing`, `AppRadius`, `AppTypography`) vienen del paquete propio [`app_ui_kit`](https://github.com/JuanGiraldo04/app-ui-kit), como dependencia git.

La paleta de marca es configurable: `AppTheme.light()` / `AppTheme.dark()` aceptan una `AppBrandPalette` opcional — sin pasarla, se usan los colores de Eventix por defecto. Los colores sin slot propio en `ColorScheme` (`success`, `warning`, `info`, `accent`) se leen vía el `ThemeExtension` `AppSemanticColors` (`context.appSemanticColors`), nunca como constante estática, para que cualquier override de paleta se propague a toda la app.

---

## Navegación

`go_router` con `StatefulShellRoute.indexedStack` para el bottom nav (Explorar / Reservas / Perfil). El `redirect` global usa la sesión de Supabase: sin sesión → `/login`; con sesión en `/login` o `/register` → `/events`. El router se refresca automáticamente ante cambios de sesión vía `GoRouterRefreshStream` sobre `Supabase.instance.client.auth.onAuthStateChange`.

Checkout y confirmación de compra quedan fuera del shell (pantalla completa, sin bottom nav).

---

## Manejo de estado

**Riverpod 3** con generación de código (`riverpod_annotation` + `build_runner`), a diferencia de proyectos más simples que lo hacen sin codegen. Cada acción de UI (login, crear reserva, confirmar compra, cerrar sesión) tiene su propio `AsyncNotifier` con tres estados:

| Estado | Cuándo ocurre |
|---|---|
| `AsyncLoading` | Carga inicial o mientras se procesa una acción |
| `AsyncData` | Resultado exitoso |
| `AsyncError` | `Failure` propagado desde el repositorio |

Después de anotar o modificar un provider: `dart run build_runner build --delete-conflicting-outputs`.

---

## Manejo de errores

Todas las llamadas a Supabase pasan por `executeRepositoryCall`, que envuelve el resultado en `Result<T>` (`Success` / `FailureResult`). Las excepciones del SDK se mapean a `Failure` en `supabase_error_mapper.dart`:

| Origen | Failure | Mensaje al usuario |
|---|---|---|
| Credenciales inválidas (`AuthException`) | `UnauthorizedFailure` | Correo o contraseña incorrectos |
| Email ya registrado (`AuthException`) | `ServerFailure` | Ya existe una cuenta con este correo |
| `PostgrestException` código `PGRST116` | `NotFoundFailure` | Recurso no encontrado |
| Otro `PostgrestException` / `AuthException` | `ServerFailure` | Mensaje del servidor |
| `SocketException` | `ConnectionFailure` | Sin conexión a internet |
| Cualquier otra excepción | `UnexpectedFailure` | Error inesperado |

La UI nunca ve una excepción cruda: `.when(loading:, error:, data:)` en cada page castea el error a `Failure` y muestra `failure.userMessage`.

---

## Stack

| Herramienta | Versión | Uso |
|---|---|---|
| Flutter | stable | Framework |
| Dart | ^3.12.0 | Lenguaje |
| supabase_flutter | ^2.16.0 | Auth, Postgres (RLS), RPC |
| flutter_riverpod | ^3.3.1 | Gestión de estado |
| riverpod_annotation | ^4.0.3 | Codegen de providers |
| go_router | ^17.3.0 | Navegación + shell de bottom nav |
| app_ui_kit | git | Sistema de diseño propio (tokens + componentes) |
| envied | ^1.3.5 | Variables de entorno tipadas |
| intl | ^0.20.2 | Localización (es/en) |

---

## Pruebas

### Demo
https://www.loom.com/share/6e452b84bae249df877dedff144dba0e

| Capa | Qué verifica | Herramientas | Dónde vive |
|---|---|---|---|
| **Unitaria** | Un usecase delega bien al repository; un mapper convierte modelos → entidades sin pérdida; un `AsyncNotifier` cambia de estado correctamente; un repository impl propaga `Failure` sin modificarlo | `mocktail`, `ProviderContainer` | `test/features/*/domain`, `.../infrastructure`, `.../presentation/providers` |
| **Widget** | Una pantalla aislada renderiza lo correcto para cada estado (`loading` / `data` / `error` / vacío) sin depender de red ni backend real | `flutter_test`, overrides de Riverpod | `test/features/*/presentation/pages` |
| **Integración (E2E)** | El flujo completo tal como lo vive un usuario: Registro, Login, Filtros, Reserva completa — app real, navegación real, backend Supabase real | `integration_test`, simulador/device real | `integration_test/app_test.dart` |

Los datasources que hablan directo con el SDK de Supabase
(`Supabase*Datasource`) son un caso especial: en vez de mockear su cadena de
query builders (frágil — son clases concretas del SDK, no interfaces
pequeñas), se prueban contra un `SupabaseClient` real apuntando a un host
inexistente, para verificar de forma determinística que cada método traduce
el error de red a la jerarquía `Failure` del proyecto (`mapSupabaseError`).
El *happy path* completo de esos mismos métodos queda cubierto por las
pruebas de integración, que sí hablan con el backend real.

### Qué se probó y por qué

| Área | Qué se probó | Por qué importa |
|---|---|---|
| **Auth** (login, registro, logout, sesión actual) | Mapeo de credenciales inválidas → `UnauthorizedFailure`; delegación usecase → repository; propagación de `Failure` desde el datasource sin perderse; flujo real registro → logout → login en integración | Es la puerta de entrada a toda la app — el `redirect` global del router depende de esto (sesión de Supabase). Un fallo acá bloquea absolutamente todo lo demás |
| **Events** (listado + filtros) | `EventFilterNotifier` cambia solo el campo que se le pide sin tocar el resto del filtro; la página muestra `loading` / datos / `AppEmptyState` / `AppErrorState` según el estado; en integración, aplicar un filtro de categoría contra datos reales y verificar que **solo** aparecen eventos de esa categoría | Es la pantalla principal y los filtros son combinables (categoría + ciudad + fecha + búsqueda) — la forma en que interactúan entre sí es fácil de romper sin darse cuenta al tocar el provider |
| **Reservations / Checkout / Confirmación** | Los usecases `createReservation` / `updateReservationQuantity` / `confirmReservation` delegan bien y propagan `Failure`; **`ConfirmPurchaseNotifier` prueba explícitamente que si falla la actualización de cantidad, `confirmReservation` nunca se llama** (evita confirmar una compra con datos a medio actualizar); en integración, el flujo real completo reserva → checkout → confirmar → aparece en "Mis reservas", que ejercita la RPC transaccional `confirmar_reserva` contra la base de datos real | Es el flujo de negocio más crítico: hay cupos limitados y una compra en firme de por medio. Una condición de carrera o una confirmación parcial acá es el tipo de bug que llega a producción y cuesta dinero real, no solo una UI rota |
| **Profile** | Nombre/email del usuario se muestran correctamente; el botón de logout muestra el error del `Failure` si el logout falla | Además de la pantalla en sí, dispara el logout que el `redirect` global del router usa para decidir a dónde mandar al usuario |
| **Modelos y mappers remotos** | `fromJson` de cada modelo remoto, incluyendo los que traen un *join* anidado (`events(...)` dentro de una reserva); el mapper convierte a la entidad de dominio sin perder ni transformar mal ningún campo | Es el punto donde el JSON de Supabase (snake_case, con nombres de columna reales) se convierte a las entidades Dart de la app. Un desajuste de nombre de campo acá **no rompe la compilación** — rompe en runtime, silenciosamente, con datos reales |
| **Repository impl** | Un resultado exitoso del datasource se envuelve en `Success<T>`; una excepción (incluyendo un `Failure` ya tipado) se envuelve en `FailureResult<T>` **sin perder el tipo original** de `Failure` | Es la capa donde `executeRepositoryCall` decide si la UI ve `AsyncData` o `AsyncError` — si acá se pierde el tipo de `Failure`, el usuario ve "Error inesperado" en vez del mensaje real ("Sin conexión", "Correo o clave incorrectos", etc.) |
| **Datasources Supabase directos** | Que cada método realmente traduce un error de red a la jerarquía `Failure` del proyecto (ver nota arriba) | Es el único punto que habla con el SDK de Supabase sin pasar por una interfaz propia — si algo cambia en cómo el SDK reporta errores, se detecta acá |
| **Integración (4 flujos)** | Registro, Login, Filtros, Reserva completa — elegidos porque son el *critical path* de negocio: sin poder registrarse/loguearse nadie entra a la app; sin filtros la navegación de un catálogo de eventos es inusable; sin poder reservar, no hay producto | Es la única capa que valida routing real, RLS real (si una policy estuviera mal, un usuario real no podría leer/escribir su propia fila y el flujo fallaría) y contratos de red reales — nada de esto lo puede detectar un mock |

### Cobertura

**90.2% de líneas** (1079/1196, tras excluir código generado y localización),
por encima del 80% objetivo del proyecto — 183 pruebas unitarias/widget en 59
archivos + 4 flujos de integración, todas en verde.

Regenerar y ver el reporte localmente:

```bash
./coverage.sh
# abre coverage/html/index.html
```

### Cómo correrlas

```bash
# Unitarias + widget (rápidas, sin dispositivo)
flutter test

# Integración (necesita un simulador/device/navegador real — ver flutter devices)
flutter test integration_test/app_test.dart
```

⚠️ Los 4 flujos de integración corren contra el proyecto Supabase configurado
en `.env` y **crean una cuenta de usuario y una reserva reales** en cada
corrida (no hay limpieza automática todavía).

---

## Environment setup

Este proyecto usa [envied](https://pub.dev/packages/envied) para manejar las variables de entorno.

1. Crea un archivo `.env` en la raiz del proyecto:

```
cp .env.example .env
```

2. Agrega tus credenciales de supabase en `.env`:

```
SUPABASE_URL=your_supabase_project_url_here
SUPABASE_PUBLISHABLE_KEY=your_supabase_publishable_key_here

```

---

## Cómo correr el proyecto

1. Sigue el [Environment setup](#environment-setup) de arriba.

2. Instala dependencias y genera el código:

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

3. Corre la app:

```bash
flutter run
```

El schema de base de datos vive versionado en `supabase/migrations` — aplícalo con la CLI de Supabase (`supabase db push`) o revisa cada archivo para reproducirlo manualmente.

---

## Configuración parametrizable por JSON

### Demo
https://www.loom.com/share/e1081fd8379b4de2a33229c660f74439

Los textos y valores de algunas pantallas no están hardcodeados en el código — vienen de un archivo JSON local que se carga una sola vez al iniciar la app. Cambiar ese archivo cambia el comportamiento visible de la app sin tocar ninguna pantalla ni recompilar lógica de negocio.

### Dónde vive

- [`assets/config/app_config.json`](assets/config/app_config.json) — configuración activa por defecto.
- [`assets/config/app_config_alt.json`](assets/config/app_config_alt.json) — una segunda configuración con valores distintos, pensada para demostrar el toggle (cambia nombre de la app, textos de auth, títulos de sección y el banner).
- Se deserializan con modelos `fromJson` manuales en [`lib/core/config/`](lib/core/config/) (sin code generation) y se exponen vía Riverpod en [`app_config_provider.dart`](lib/core/config/app_config_provider.dart): `activeConfigPathProvider` controla cuál de los dos archivos está activo, `appConfigProvider` lo carga y lo parsea.
- El botón de swap (ícono ⇄) en el AppBar de **Perfil** alterna entre ambos archivos — toda la app se re-renderiza sola porque `appConfigProvider` depende de `activeConfigPathProvider`.

### Qué es parametrizable

| Sección del JSON | Dónde se aplica |
|---|---|
| `app.nombre` | Título de la app a nivel de sistema (`onGenerateTitle`) |
| `auth.login.*` / `auth.registro.*` | Título, subtítulo y label del botón en Login y Registro |
| `eventos.tituloSeccion` | Encabezado de sección sobre la lista de eventos |
| `eventos.saludo` / `.saludoEmoji` | El saludo del header de Eventos (`"Hola, <nombre>" + emoji`) |
| `eventos.categorias` | Chips de filtro por categoría — **label e ícono**, ambos visibles |
| `eventos.estadoVacio` | Título/mensaje del `AppEmptyState` cuando un filtro no encuentra eventos |
| `reservas.tituloSeccion` | Título del AppBar en "Mis reservas" |
| `reservas.estadoVacio` | Título/mensaje del `AppEmptyState` cuando no hay reservas |
| `banners` | Banners informativos sobre la lista de eventos, uno por cada entrada con `activo: true` |
| `checkout.*` | Título del AppBar, label de cantidad/precio/total y label del botón de confirmar en el checkout |
| `confirmacion.*` | Título, subtítulo (con `{evento}` interpolado), labels de entradas/total y los dos botones en la pantalla de confirmación de compra |
| `navbar.*` | Los 3 labels **y los 3 íconos** del bottom nav |
| `perfil.icono` | Ícono decorativo mostrado arriba de la card de perfil |

`app.slogan` se parsea y queda disponible en el modelo, pero hoy no se usa en ninguna pantalla — es un campo libre para cuando se necesite (splash, about, etc.).

Los nombres de ícono (`eventos.categorias[].icono`, `navbar.*_icono`, `perfil.icono`) se resuelven con un único registro compartido: [`iconByName`](lib/core/config/config_icons.dart). Un nombre no reconocido cae a un ícono genérico en vez de romper la app.

### Detalle importante: categorías e `id` vs. `label`

El `id` de cada categoría (`"futbol"`, `"baloncesto"`, …) es el identificador estable que se traduce internamente al valor real que Supabase guarda en `events.categoria` (`"Fútbol"`, `"Baloncesto"`, …, ver [`supabase/seed.sql`](supabase/seed.sql)). El `label` es solo el texto visible del chip. Esto es intencional: si el filtro usara directamente el `label`, activar `app_config_alt.json` (que muestra "Soccer" en vez de "Fútbol") rompería la búsqueda contra datos reales, porque no existe ningún evento con `categoria = "Soccer"` en la base de datos. La traducción `id → valor real` vive en `categoriaBackendValueById` dentro de [`events_page.dart`](lib/features/events/presentation/pages/events_page.dart).

### Cómo agregar una nueva categoría

1. Agrega la entrada en `eventos.categorias` en **ambos** JSON (`app_config.json` y `app_config_alt.json`), con un `id` nuevo y el nombre de ícono que quieras usar (ej. `"sports_volleyball"`).
2. Registra ese `id` en el mapa `categoriaBackendValueById` de `events_page.dart`, apuntando al valor exacto que existe (o vas a crear) en la columna `events.categoria`.
3. Si el ícono no está en el switch de `iconByName` ([`config_icons.dart`](lib/core/config/config_icons.dart)), agrégalo ahí — si no lo reconoce, cae a un ícono genérico por defecto. Es el mismo registro que usan `navbar.*_icono` y `perfil.icono`, así que agregarlo ahí lo deja disponible para las tres secciones.

### Cómo activar o desactivar un banner

Cambia `"activo": true` a `"activo": false` (o viceversa) en la entrada correspondiente dentro de `banners`, en el JSON que quieras editar. Un banner con `activo: false` no se renderiza. Se pueden tener varios banners activos a la vez — se muestran todos, en orden, sobre la lista de eventos. El campo `variante` acepta `"info"`, `"success"`, `"warning"` o `"error"` (cualquier otro valor cae a `"info"`).

### Cómo cambiar los textos de auth

Edita `auth.login.titulo` / `.subtitulo` / `.boton` o `auth.registro.titulo` / `.subtitulo` / `.boton` en el JSON. No hace falta tocar `LoginPage` ni `RegisterPage` — leen esos valores directamente de `appConfigProvider`.

⚠️ A diferencia del resto de la app (que usa ARB + `AppLocalizations` para es/en), estos textos **no están localizados** — el JSON define un solo idioma fijo. Si el dispositivo está en inglés, Login/Registro van a mostrar igual el texto del JSON (español), mientras que los labels de los campos (email, contraseña) sí cambian de idioma porque esos siguen viniendo de los ARB. Es una limitación consciente de este mecanismo, no un bug.

### Cómo cambiar los textos de checkout, confirmación y navbar

Igual que con auth: edita `checkout.*` / `confirmacion.*` / `navbar.*` en el JSON, sin tocar código. Dos detalles:

- `confirmacion.subtituloTemplate` acepta el placeholder literal `{evento}` — `ConfirmacionConfig.subtituloPara(titulo)` lo reemplaza por el título real del evento reservado. Si quitas el placeholder, el texto simplemente no interpola nada.
- El navbar (`AppShell`, fuera de las rutas con `Scaffold` propio) también depende de `appConfigProvider` — por eso el toggle en Perfil cambia los 3 labels **y los 3 íconos** del bottom nav sin necesidad de reiniciar la app.

### Cómo cambiar los íconos (categorías, navbar, perfil)

Todos los nombres de ícono del JSON se resuelven con el mismo registro,
[`iconByName`](lib/core/config/config_icons.dart) — no hay un mapeo distinto
por sección:

- `eventos.categorias[].icono` — ícono de cada chip de filtro.
- `navbar.explorar_icono` / `.reservas_icono` / `.perfil_icono` — íconos del bottom nav (una sola variante por tab, sin distinción outlined/filled al seleccionar — simplificación intencional).
- `perfil.icono` — el ícono decorativo circular arriba de la card de perfil.

Para usar un ícono nuevo: agrega el `case` correspondiente en `iconByName` (nombre de string → `Icons.xxx`) y después referencia ese mismo nombre desde cualquiera de las tres secciones. Un nombre no registrado no rompe la app — cae a un ícono genérico (`Icons.sports`).
