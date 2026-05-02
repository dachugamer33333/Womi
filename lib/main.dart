import 'package:flutter/material.dart';
import 'core/theme/theme.dart';
import 'core/router/app_routes.dart';
import 'shared/widgets/widgets.dart';
import 'features/home/home_screen.dart';
import 'features/activity/activity_screen.dart';
import 'features/wallet/wallet_screen.dart';
import 'features/profile/profile_screen.dart';

void main() {
  runApp(const WomiApp());
}

class WomiApp extends StatelessWidget {
  const WomiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Womi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.home: (_) => const AppShell(),
        AppRoutes.activity: (_) => const ActivityScreen(),
        AppRoutes.wallet: (_) => const WalletScreen(),
        AppRoutes.profile: (_) => const ProfileScreen(),
      },
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
