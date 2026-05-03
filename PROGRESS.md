# Progreso Womi

## Última sesión: 2026-05-02 (fase ride)

### Lo que se hizo
**Flujo de viaje demo-ready:**
- DestinationSelectionScreen: mapa flutter_map + OpenStreetMap, 5 destinos CDMX hardcodeados, card animada, polyline curva animada, cálculo de distancia/precio (Haversine estático), BottomSheet con resumen y botón "Buscar conductora".
- SearchingDriverScreen: fondo `AppGradients.brand`, 3 anillos pulsantes animados con delays escalonados, avatar circular con iniciales, animación de puntos suspensivos, auto-transición a 3.5s con `pushReplacementNamed`.
- ActiveRideScreen: mapa no interactivo con polyline curva y 30 waypoints, marcadores de origen/destino, auto animado interpolando sobre la ruta (50s), ETA countdown dinámico con `WomiGradientText`, BottomSheet fijo con tarjeta de conductora "Ana Martínez" (foto, rating 4.9, auto, badge verificación), sección seguridad (Compartir, Contactos, botón SOS pulsante), diálogo SOS emergencia, botón "Finalizar viaje" outline magenta.
- RideCompletedScreen: fondo lavanda, check animado con gradiente, resumen del viaje (Zócalo → Antara, 14 min, $65 MXN, 6.2 km), 5 estrellas de rating tappables (default 5), botón "Volver al inicio" que guarda actividad en Hive y navega a Home.
- Modelos: DestinationModel (5 destinos CDMX con coordenadas reales), DriverModel (Ana Martínez con datos creíbles), RideModel (cálculo de distancia Haversine, tarifa $25 base + $8/km).
- RideRepository + RideProvider: selección de destino, creación de viaje, guardado de actividad completada en Hive.
- Conexión: barra de búsqueda del Home → DestinationSelectionScreen. Flujo completo cierra el ciclo: Home → Destination → Searching → Active → Completed → Home (con nueva actividad visible en ActivityScreen).

### Decisiones técnicas tomadas
| Decisión | Justificación |
|---|---|
| flutter_map sobre google_maps_flutter | No requiere API key, mapa estático decorativo suficiente para demo. |
| OpenStreetMap tiles | Gratuito, sin límites de uso. Ideal para demo sin costo. |
| Animación auto en 50s | Suficiente para moverse durante toda la explicación de la demo sin llegar al destino instantáneamente. |
| 30 waypoints en polyline curva | Ruta realista con curva sinoidal, no línea recta. |
| SOS pulsante con AnimationController | Efecto sutil pero notorio (escala 1.0→1.05 loop). |
| Iniciales "MG" en avatar | Representa a "María García", consistente con los datos demo del Home. |
| Tarifa $25 + $8/km | Precios creíbles para CDMX (viaje ~$65 MXN para 5km). |

### Archivos clave creados/modificados en esta sesión
**Creados (14 archivos):**
- `lib/features/ride/domain/models/destination_model.dart` — 5 destinos CDMX + origen simulado
- `lib/features/ride/domain/models/driver_model.dart` — datos de Ana Martínez
- `lib/features/ride/domain/models/ride_model.dart` — modelo + cálculos (Haversine, tarifa)
- `lib/features/ride/data/ride_repository.dart` — lógica de viaje + guardado en Hive
- `lib/features/ride/presentation/providers/ride_provider.dart` — estado del viaje
- `lib/features/ride/presentation/screens/destination_selection_screen.dart` — selección destino
- `lib/features/ride/presentation/screens/searching_driver_screen.dart` — búsqueda animada
- `lib/features/ride/presentation/screens/active_ride_screen.dart` — viaje activo (pantalla estrella)
- `lib/features/ride/presentation/screens/ride_completed_screen.dart` — cierre con rating

**Modificados:**
- `pubspec.yaml` — `flutter_map: ^7.0.2`, `latlong2: ^0.9.1`
- `lib/core/router/app_routes.dart` — 4 rutas nuevas (destinationSelection, searchingDriver, activeRide, rideCompleted)
- `lib/main.dart` — +RideProvider en MultiProvider, +4 rutas, +imports
- `lib/features/home/home_screen.dart` — barra de búsqueda navega a DestinationSelectionScreen
- `AGENTS.md` — estado actual y estructura actualizados
- `PROGRESS.md` — archivo actualizado



## Historial de sesiones anteriores

### 2026-05-02 (fase auth/UI) — Sesión inicial: UI completa + auth local + datos dinámicos
- Creación del sistema de diseño completo (`lib/core/theme/`): `AppColors`, `AppGradients`, `AppDimensions`, `AppTextStyles`, `AppShadows`, `AppDurations`, `AppTheme` + barrel export.
- Widgets compartidos (`lib/shared/widgets/`): `WomiCard`, `WomiGradientButton`, `WomiGradientText`, `WomiBottomNav`.
- 4 pantallas estéticas: Home (Explorar), Activity, Wallet (Mi Monedero), Profile.
- Bottom navigation con 4 tabs: Inicio, Actividad, Billetera, Perfil. Círculo degradado en estado activo.
- Rutas centralizadas en `lib/core/router/app_routes.dart`.
- Validadores reutilizables en `lib/core/utils/validators.dart`.
- `AppStrings` en `lib/core/constants/`.

**Fase 2 — Correcciones de identidad visual:**
- Aplicación del `AppGradients.brand` (Azul Real → Magenta) en banner de bienvenida, nombre de usuaria, bottom nav, botones.
- Corrección de colores: icono escudo en Magenta, texto "Viaje seguro" en Azul Real, íconos de destinos recientes en Azul Real sobre círculo lavanda.
- Reconstrucción completa de pantalla Wallet (banner promocional, tarjetas Saldo Womi + Tarjeta vinculada, sección Servicios, botón "Agregar método de pago").
- Layout adaptativo con `LayoutBuilder` (breakpoint 600px, `ConstrainedBox(maxWidth: 800)` para pantallas grandes).
- Corrección de strip blanca en Perfil (`Container` → `Scaffold(backgroundColor: AppColors.primary)`).
- Rediseño de tarjetas 2x2 en Perfil (íconos en círculo lavanda, aspecto 1.1, sombra más sutil, espaciado `spaceM`).
- Nombre en Perfil con `WomiGradientText`, icono Seguridad con gradiente vía `ShaderMask`.

**Fase 3 — Autenticación local y UI dinámica:**
- Modelo `UserModel` con `copyWith`, `toJson`, `fromJson`.
- Excepciones tipadas: `EmailAlreadyExistsException`, `InvalidCredentialsException`, `UserNotFoundException`.
- `LocalStorageService` con Hive (usuarios, sesión, actividades, métodos de pago, destinos recientes).
- `AuthRepository` con register/login/logout/updateUser. Hash sha256 vía `crypto`.
- `AuthProvider` (ChangeNotifier) con `checkSession`, `login`, `register`, `logout`, `updateUser`.
- `SplashScreen`: logo "W" con gradiente, fade in animado, `checkSession()` → Home o Login.
- `LoginScreen`: fondo lavanda, "Bienvenida de nuevo" con gradiente, email + password, validación, loading, error SnackBar magenta.
- `RegisterScreen`: 5 campos (nombre, email, phone, password, confirm), aviso verificación 24h, auto-login post registro.
- Widgets `AuthTextField` y `PasswordField` reutilizables con diseño Womi.
- Navegación: `AppRoutes` con splash `/`, login `/login`, register `/register`, home `/home`.
- `main.dart`: `MultiProvider` con `ChangeNotifierProvider<AuthProvider>`, inicialización Hive asíncrona.
- HomeScreen dinámico: `¡Hola, {firstName}!` con gradiente, avatar con iniciales, destinos recientes del repo (o estado vacío).
- ProfileScreen dinámico: nombre con `WomiGradientText`, badge condicional (verde="Verificada" / magenta="No verificada"), contadores reales.
- WalletScreen dinámico: saldo `walletBalance` formateado MXN, tarjeta del repo (o "Agrega tu primer método"), diálogo para agregar tarjeta.
- ActivityScreen dinámico: lista de actividades del repo, FAB debug (`kDebugMode`) para agregar dato de prueba.
- Flujo de logout: botón outline Magenta "Cerrar sesión" al final del Perfil → diálogo confirmación → `pushNamedAndRemoveUntil(login)`.

### Decisiones técnicas tomadas

| Decisión | Justificación |
|---|---|
| Provider sobre Riverpod | Proyecto no requiere features avanzadas de Riverpod. Provider es suficiente para este alcance. |
| Hive sobre SQLite | No hay queries complejas. Hive es más rápido, sin boilerplate SQL, sin migraciones. |
| sha256 sobre bcrypt | App local sin backend. sha256 es suficiente y más simple. |
| SharedPreferences para sesión | Para el userId activo es más rápido que Hive; la sesión es un flag simple. |
| Hive para datos de usuario y app | Modelos complejos (UserModel, activities, paymentMethods) necesitan almacenamiento estructurado. |
| `init(path:)` opcional en LocalStorageService | Permite tests sin `Hive.initFlutter()` (que requiere engine Flutter completo). |
| `CopyWith` en UserModel | Inmutabilidad. Facilita `auth.updateUser(user.copyWith(balance: newValue))`. |
| `Consumer<AuthProvider>` en pantallas | Reactividad granular. Widget se reconstruye solo cuando AuthProvider notifica cambios. |

### Archivos clave creados/modificados en esta sesión

**Creados (29 archivos):**
- `lib/core/theme/app_colors.dart` — paleta Womi
- `lib/core/theme/app_gradients.dart` — degradados de marca
- `lib/core/theme/app_dimensions.dart` — espaciados, radios, tamaños
- `lib/core/theme/app_text_styles.dart` — tipografías Quicksand + Inter
- `lib/core/theme/app_shadows.dart` — sombras Soft UI
- `lib/core/theme/app_durations.dart` — duraciones de animación
- `lib/core/theme/app_theme.dart` — ThemeData ensamblado
- `lib/core/theme/theme.dart` — barrel export
- `lib/core/constants/app_strings.dart` — textos de UI
- `lib/core/router/app_routes.dart` — rutas nombradas
- `lib/core/utils/validators.dart` — validadores de formulario
- `lib/shared/widgets/womi_card.dart` — tarjeta blanca con sombra
- `lib/shared/widgets/womi_gradient_button.dart` — botón con degradado
- `lib/shared/widgets/womi_gradient_text.dart` — texto con ShaderMask
- `lib/shared/widgets/womi_bottom_nav.dart` — barra de navegación
- `lib/shared/widgets/widgets.dart` — barrel export
- `lib/features/home/home_screen.dart` — pantalla Explorar
- `lib/features/activity/activity_screen.dart` — pantalla Actividad
- `lib/features/wallet/wallet_screen.dart` — pantalla Billetera
- `lib/features/profile/profile_screen.dart` — pantalla Perfil
- `lib/features/auth/domain/models/user_model.dart` — modelo User
- `lib/features/auth/domain/exceptions/auth_exceptions.dart` — excepciones
- `lib/features/auth/data/local_storage_service.dart` — capa Hive
- `lib/features/auth/data/auth_repository.dart` — lógica de auth
- `lib/features/auth/presentation/providers/auth_provider.dart` — estado global
- `lib/features/auth/presentation/screens/splash_screen.dart` — splash
- `lib/features/auth/presentation/screens/login_screen.dart` — login
- `lib/features/auth/presentation/screens/register_screen.dart` — registro
- `lib/features/auth/presentation/widgets/auth_text_field.dart` — input Womi
- `lib/features/auth/presentation/widgets/password_field.dart` — password con toggle

**Modificados:**
- `lib/main.dart` — app shell, provider, rutas, inicialización Hive
- `pubspec.yaml` — dependencias (google_fonts, hive, shared_preferences, crypto, provider, intl)
- `test/widget_test.dart` — test de humo sin Hive
- `.gitignore` — entradas Hive

## Siguiente sesión — pendientes priorizados

### Alta prioridad
- [ ] Tests unitarios para `Validators`, `AuthRepository`, `AuthProvider`
- [ ] Pantalla de viaje activo (mapa, progreso, datos de la conductora)
- [ ] Botón SOS visible en viaje activo
- [ ] Onboarding de verificación 24h (subida selfie + INE, cámara/galería)

### Media prioridad
- [ ] Vista de conductora (registro como conductora, documentos adicionales)
- [ ] Compartir viaje en tiempo real (enlace de tracking)
- [ ] Contactos de confianza (lista, notificaciones)
- [ ] Animaciones de transición entre pantallas

### Baja prioridad / nice-to-have
- [ ] Dark mode (duplicar AppColors con variante oscura)
- [ ] Internacionalización (i18n) usando `AppStrings` como base
- [ ] Integración con Google Maps / Mapbox
- [ ] Pagos reales (Stripe / MercadoPago)
- [ ] Backend (Firebase / Supabase / Node)
- [ ] Widget tests para todas las pantallas

## Bugs conocidos
- 🚧 Avatar en Home navega a Perfil con `pushNamed` en lugar de cambiar el tab en AppShell. Funciona, pero no es ideal (dos instancias de ProfileScreen en el stack).
- 🚧 Test widget se cuelga con `Hive.initFlutter()`. Se requiere `init(path:)` con directorio temporal. El test actual de humo no cubre flujos completos.

## Preguntas abiertas / decisiones pendientes
- ¿Backend? Firebase vs Supabase vs Node propio — Firebase tiene buena integración con Flutter y auth listo.
- ¿Mapas? Google Maps (más preciso en México) vs Mapbox (más barato).
- ¿Pagos reales? MercadoPago es más relevante en México que Stripe.
- ¿Notificaciones push? Firebase Cloud Messaging es el estándar para Flutter.
- ¿Verificación de identidad real? ¿API de INE/OCR o validación manual humana? El modelo actual asume validación humana.
