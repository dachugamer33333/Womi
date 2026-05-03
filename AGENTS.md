# Womi — Contexto del proyecto

## Descripción
App de movilidad estilo ride-hailing diseñada exclusivamente para mujeres.
Modelo: similar a Uber, con verificación humana de identidad (24h) tanto para usuarias como para conductoras.
Mercado: México (precios en MXN, validación de teléfono mexicano).

## Stack
- Flutter (Dart 3.x)
- Plataformas: Android e iOS
- Estado: Provider (`provider: ^6.1.2`)
- Storage local: Hive (`hive: ^2.2.3`, `hive_flutter: ^1.1.0`) + `shared_preferences: ^2.3.5` para sesión
- Hashing: sha256 (`crypto: ^3.0.7`)
- Tipografías: `google_fonts: ^6.1.0` (Quicksand + Inter)
- Formateo: `intl: ^0.20.2`
- Sin backend (todo local en esta fase)

## Arquitectura
- **Feature-first** en `lib/features/<feature>/{data,domain,presentation}/`
- **Sistema de diseño** centralizado en `lib/core/theme/`
- **Rutas** centralizadas en `lib/core/router/app_routes.dart`
- **Validators** reutilizables en `lib/core/utils/validators.dart`
- **Widgets compartidos** en `lib/shared/widgets/`

## Identidad de marca (NO TOCAR)
- Lavanda primario: `#C7B1F6`
- Azul Real: `#5A75E6`
- Magenta: `#E94EAB`
- **Degradado Womi:** `#5A75E6 → #E94EAB` (Azul Real → Magenta)
- Tipografía títulos: Quicksand
- Tipografía cuerpo: Inter

## Reglas NO NEGOCIABLES
1. CERO `Color(0xFF...)` hardcodeado. Todo viene de `AppColors`.
2. CERO números mágicos. Todo viene de `AppDimensions`.
3. CERO `TextStyle()` inline. Todo viene de `AppTextStyles` o `Theme.of(context).textTheme`.
4. CERO `LinearGradient(...)` inline. Solo `AppGradients.brand` o `AppGradients.lavenderToWhite`.
5. Cada pantalla DEBE tener al menos un elemento con `AppGradients.brand` para reforzar identidad.
6. Contraseñas SIEMPRE hasheadas con sha256 antes de guardar.
7. NO modificar `lib/core/theme/*` sin justificación documentada.
8. NO hardcodear datos del usuario (nombre, saldo, etc.) — todo viene del `AuthProvider`.

## Convenciones de código
- Constructor privado en clases estáticas: `AppColors._();`
- Modelos inmutables con `copyWith`, `toJson`, `fromJson`.
- Excepciones tipadas (`InvalidCredentialsException`), NO Strings.
- Validators puros y reutilizables.
- Archivos cortos (<200 líneas idealmente).
- Nombres explícitos: `auth_repository.dart` > `repo.dart`.

## Estructura de carpetas
```
lib/
├── main.dart
├── core/
│   ├── constants/
│   │   └── app_strings.dart
│   ├── router/
│   │   └── app_routes.dart
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_dimensions.dart
│   │   ├── app_durations.dart
│   │   ├── app_gradients.dart
│   │   ├── app_shadows.dart
│   │   ├── app_text_styles.dart
│   │   ├── app_theme.dart
│   │   └── theme.dart                  # barrel export
│   └── utils/
│       └── validators.dart
├── features/
│   ├── activity/
│   │   └── activity_screen.dart
│   ├── auth/
│   │   ├── data/
│   │   │   ├── auth_repository.dart
│   │   │   └── local_storage_service.dart
│   │   ├── domain/
│   │   │   ├── exceptions/
│   │   │   │   └── auth_exceptions.dart
│   │   │   └── models/
│   │   │       └── user_model.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── auth_provider.dart
│   │       ├── screens/
│   │       │   ├── login_screen.dart
│   │       │   ├── register_screen.dart
│   │       │   └── splash_screen.dart
│   │       └── widgets/
│   │           ├── auth_text_field.dart
│   │           └── password_field.dart
│   ├── home/
│   │   └── home_screen.dart
│   ├── profile/
│   │   └── profile_screen.dart
│   └── wallet/
│       └── wallet_screen.dart
└── shared/
    └── widgets/
        ├── widgets.dart                # barrel export
        ├── womi_bottom_nav.dart
        ├── womi_card.dart
        ├── womi_gradient_button.dart
        └── womi_gradient_text.dart
```

## Estado actual de implementación
- ✅ Sistema de diseño: `AppColors`, `AppGradients`, `AppDimensions`, `AppTextStyles`, `AppShadows`, `AppDurations`, `AppTheme`
- ✅ Widgets compartidos: `WomiCard`, `WomiGradientButton`, `WomiGradientText`, `WomiBottomNav`
- ✅ Bottom navigation con círculo degradado `AppGradients.brand` en estado activo
- ✅ Rutas centralizadas: `AppRoutes` (splash, login, register, home, activity, wallet, profile)
- ✅ Sistema de auth local: `AuthRepository` con Hive, `AuthProvider` con ChangeNotifier
- ✅ Modelo `UserModel` con `copyWith`, `toJson`, `fromJson`, hashing sha256
- ✅ Validadores reutilizables: email, password, phoneMX, required, matchPassword
- ✅ Pantallas de auth: SplashScreen, LoginScreen, RegisterScreen
- ✅ Pantalla Home dinámica: nombre del usuario, iniciales en avatar, destinos recientes del repo
- ✅ Pantalla Activity dinámica: lista de actividades del repo, botón debug (kDebugMode)
- ✅ Pantalla Wallet dinámica: saldo real, métodos de pago del repo, diálogo agregar tarjeta
- ✅ Pantalla Profile dinámica: nombre con gradiente, badge de verificación condicional, contadores reales
- ✅ Flujo de logout: botón "Cerrar sesión" al final del Perfil → diálogo confirmación → `pushNamedAndRemoveUntil`
- 🚧 Navegación avatar Home → Perfil: usa `pushNamed` (no cambia el tab en AppShell)
- ⬜ Pantalla de viaje activo + botón SOS
- ⬜ Onboarding de verificación 24h (subida de selfie + INE)
- ⬜ Vista de conductora (versión espejo)
- ⬜ Compartir viaje en tiempo real
- ⬜ Contactos de confianza
- ⬜ Tests unitarios de auth y validators
- ⬜ Flujo completo de verificación de identidad

## Comandos útiles
- `flutter pub get` — instalar dependencias
- `flutter run` — correr en debug
- `flutter analyze` — análisis estático
- `flutter test` — correr tests
- `flutter build apk` — build Android release
- `flutter build ios` — build iOS release

## Notas importantes para el agente
- Antes de modificar cualquier archivo existente, LEERLO COMPLETO primero.
- Antes de crear un widget nuevo, verificar si ya existe uno similar en `lib/shared/widgets/`.
- Antes de crear una constante, verificar si ya existe en `lib/core/theme/`.
- Si vas a tocar más de 3 archivos en una tarea, primero hacer un plan y mostrarlo al usuario.
- El usuario prefiere entregas paso a paso revisables, NO entregas masivas.
- El usuario habla en español, responder siempre en español.
- Los tests con Hive requieren `Hive.init(path)` con directorio temporal (NO `Hive.initFlutter()`).
- `AuthProvider` debe ser el único punto de acceso a `AuthRepository` desde la UI.
