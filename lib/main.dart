import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/theme.dart';
import 'core/router/app_routes.dart';
import 'shared/widgets/widgets.dart';
import 'features/auth/data/local_storage_service.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/auth/presentation/screens/splash_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/register_screen.dart';
import 'features/home/home_screen.dart';
import 'features/activity/activity_screen.dart';
import 'features/wallet/wallet_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/profile/orders_screen.dart';
import 'features/profile/help_screen.dart';
import 'features/profile/security_screen.dart';
import 'features/profile/settings_screen.dart';
import 'features/ride/presentation/providers/ride_provider.dart';
import 'features/ride/presentation/screens/destination_selection_screen.dart';
import 'features/ride/presentation/screens/searching_driver_screen.dart';
import 'features/ride/presentation/screens/active_ride_screen.dart';
import 'features/ride/presentation/screens/ride_completed_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = LocalStorageService();
  await storage.init();

  final authRepo = AuthRepository(storage);

  runApp(WomiApp(authRepo: authRepo));
}

class WomiApp extends StatelessWidget {
  final AuthRepository authRepo;

  const WomiApp({super.key, required this.authRepo});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authRepo),
        ),
        ChangeNotifierProvider(
          create: (_) => RideProvider(authRepo),
        ),
      ],
      child: MaterialApp(
        title: 'Womi',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: AppRoutes.splash,
        routes: {
          AppRoutes.splash: (_) => const SplashScreen(),
          AppRoutes.login: (_) => const LoginScreen(),
          AppRoutes.register: (_) => const RegisterScreen(),
          AppRoutes.home: (_) => const AppShell(),
          AppRoutes.activity: (_) => const ActivityScreen(),
          AppRoutes.wallet: (_) => const WalletScreen(),
          AppRoutes.profile: (_) => const ProfileScreen(),
          AppRoutes.destinationSelection: (_) =>
              const DestinationSelectionScreen(),
          AppRoutes.searchingDriver: (_) => const SearchingDriverScreen(),
          AppRoutes.activeRide: (_) => const ActiveRideScreen(),
          AppRoutes.rideCompleted: (_) => const RideCompletedScreen(),
          AppRoutes.orders: (_) => const OrdersScreen(),
          AppRoutes.help: (_) => const HelpScreen(),
          AppRoutes.securitySettings: (_) => const SecurityScreen(),
          AppRoutes.settings: (_) => const SettingsScreen(),
        },
      ),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  static const List<Widget> _screens = [
    HomeScreen(),
    ActivityScreen(),
    WalletScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedSwitcher(
            duration: AppDurations.normal,
            child: KeyedSubtree(
              key: ValueKey(_currentIndex),
              child: _screens[_currentIndex],
            ),
          );
        },
      ),
      bottomNavigationBar: WomiBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}
