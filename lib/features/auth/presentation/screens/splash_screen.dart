import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/router/app_routes.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
    _animController.forward();
    _checkAndNavigate();
  }

  Future<void> _checkAndNavigate() async {
    final auth = context.read<AuthProvider>();
    await auth.checkSession();

    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    if (auth.isLoggedIn) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: AppGradients.brand,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                  boxShadow: AppShadows.medium,
                ),
                child: Center(
                  child: Text(
                    'W',
                    style: AppTextStyles.displayLarge.copyWith(
                      color: AppColors.surface,
                      fontSize: 48,
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppDimensions.spaceL),
              ShaderMask(
                shaderCallback: (bounds) =>
                    AppGradients.brand.createShader(bounds),
                blendMode: BlendMode.srcIn,
                child: Text(
                  'Womi',
                  style: AppTextStyles.displayLarge.copyWith(
                    color: Colors.white,
                    fontSize: 40,
                  ),
                ),
              ),
              SizedBox(height: AppDimensions.spaceXL),
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
