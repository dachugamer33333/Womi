import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/router/app_routes.dart';

class SearchingDriverScreen extends StatefulWidget {
  const SearchingDriverScreen({super.key});

  @override
  State<SearchingDriverScreen> createState() => _SearchingDriverScreenState();
}

class _SearchingDriverScreenState extends State<SearchingDriverScreen>
    with TickerProviderStateMixin {
  late final AnimationController _dotsCtrl;
  late final List<AnimationController> _ringControllers;
  String _dots = '';

  @override
  void initState() {
    super.initState();
    _dotsCtrl = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _ringControllers = List.generate(
      3,
      (i) => AnimationController(
        duration: const Duration(milliseconds: 1800),
        vsync: this,
      ),
    );
    for (int i = 0; i < _ringControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 600),
          () => _ringControllers[i].repeat());
    }

    _animateDots();
    _autoNavigate();
  }

  void _animateDots() {
    _dotsCtrl.addListener(() {
      final v = _dotsCtrl.value;
      setState(() {
        if (v < 0.33) {
          _dots = '.';
        } else if (v < 0.66) {
          _dots = '..';
        } else {
          _dots = '...';
        }
      });
    });
  }

  void _autoNavigate() {
    Future.delayed(const Duration(milliseconds: 3500), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.activeRide);
      }
    });
  }

  @override
  void dispose() {
    _dotsCtrl.dispose();
    for (final c in _ringControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.brand),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: AppDimensions.spaceXL),
                _buildPulsingAvatar(),
                SizedBox(height: AppDimensions.spaceXL),
                Text(
                  'Buscando conductora$_dots',
                  style: AppTextStyles.displayMedium.copyWith(
                    color: AppColors.surface,
                  ),
                ),
                SizedBox(height: AppDimensions.spaceM),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.shield_rounded,
                        color: AppColors.surface.withValues(alpha: 0.9),
                        size: AppDimensions.iconM),
                    SizedBox(width: AppDimensions.spaceS),
                    Text(
                      'Conductoras verificadas cerca de ti',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.surface.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppDimensions.spaceXL * 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPulsingAvatar() {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (int i = 0; i < _ringControllers.length; i++)
            AnimatedBuilder(
              animation: _ringControllers[i],
              builder: (context, _) {
                final value = _ringControllers[i].value;
                final radius = 50 + value * 60;
                final opacity = (1.0 - value) * 0.3;
                return Container(
                  width: radius * 2,
                  height: radius * 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.surface.withValues(alpha: opacity),
                      width: 2,
                    ),
                  ),
                );
              },
            ),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              boxShadow: AppShadows.medium,
            ),
            child: Center(
              child: Text(
                'MG',
                style: AppTextStyles.displayMedium.copyWith(
                  color: AppColors.secondary,
                  fontSize: 32,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
