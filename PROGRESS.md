# Progreso Womi

## Última sesión: 2026-05-02

### Lo que se hizo

**Fase 1 — Sistema de diseño y UI estética:**
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

## Historial de sesiones anteriores

### 2026-05-02 — Sesión inicial: UI completa + auth local + datos dinámicos
Se construyó el proyecto desde cero: sistema de diseño Womi, 4 pantallas estéticas con bottom nav, sistema de auth local con Hive (registro/login/logout), y conexión de todas las pantallas a datos dinámicos del `AuthProvider`. Se corrigieron problemas de identidad visual (degradados, colores, sombras). Se crearon `AGENTS.md` y `PROGRESS.md` para memoria entre sesiones.
