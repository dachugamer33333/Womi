import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/router/app_routes.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../shared/widgets/widgets.dart';

class VerificationProcessingScreen extends StatefulWidget {
  const VerificationProcessingScreen({super.key});

  @override
  State<VerificationProcessingScreen> createState() =>
      _VerificationProcessingScreenState();
}

class _VerificationProcessingScreenState
    extends State<VerificationProcessingScreen>
    with TickerProviderStateMixin {
  late final List<AnimationController> _ringCtrls;
  bool _verified = false;
  int _secondsLeft = 30;

  @override
  void initState() {
    super.initState();
    _ringCtrls = List.generate(
      3,
      (i) => AnimationController(
        duration: const Duration(milliseconds: 1800),
        vsync: this,
      ),
    );
    for (int i = 0; i < _ringCtrls.length; i++) {
      Future.delayed(
          Duration(milliseconds: i * 600), () => _ringCtrls[i].repeat());
    }
    _startCountdown();
  }

  void _startCountdown() {
    for (int i = 29; i >= 0; i--) {
      Future.delayed(Duration(seconds: 30 - i), () {
        if (!mounted) return;
        setState(() => _secondsLeft = i);
        if (i == 0) {
          _finalizeVerification();
        }
      });
    }
  }

  void _finalizeVerification() async {
    final auth = context.read<AuthProvider>();
    final user = auth.currentUser;
    if (user != null) {
      await auth.updateUser(user.copyWith(isVerified: true));
    }
    if (!mounted) return;
    setState(() => _verified = true);
  }

  @override
  void dispose() {
    for (final c in _ringCtrls) {
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
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.spaceXL),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_verified)
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                        boxShadow: AppShadows.medium,
                      ),
                      child: Icon(Icons.check_rounded,
                          color: AppColors.surface,
                          size: AppDimensions.iconXL),
                    )
                  else
                    _buildPulsingIcon(),
                  SizedBox(height: AppDimensions.spaceXL),
                  Text(
                    _verified
                        ? '¡Cuenta verificada!'
                        : 'Verificando tu identidad...',
                    style: AppTextStyles.displayMedium.copyWith(
                      color: AppColors.surface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppDimensions.spaceM),
                  Text(
                    _verified
                        ? 'Tu cuenta ha sido verificada exitosamente. Bienvenida a Womi.'
                        : 'Esto puede tomar hasta 24 horas.\nTe notificaremos cuando esté lista.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (!_verified) ...[
                    SizedBox(height: AppDimensions.spaceM),
                    Text(
                      '$_secondsLeft segundos restantes (simulado)',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                  SizedBox(height: AppDimensions.spaceXL),
                  if (_verified)
                    SizedBox(
                      width: double.infinity,
                      child: WomiGradientButton(
                        label: 'Ir al inicio',
                        icon: Icons.home_rounded,
                        onPressed: () => Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.home,
                          (_) => false,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPulsingIcon() {
    return SizedBox(
      width: 160,
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (int i = 0; i < _ringCtrls.length; i++)
            AnimatedBuilder(
              animation: _ringCtrls[i],
              builder: (context, _) {
                final value = _ringCtrls[i].value;
                final radius = 35 + value * 50;
                final opacity = (1.0 - value) * 0.3;
                return Container(
                  width: radius * 2,
                  height: radius * 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: opacity),
                      width: 2,
                    ),
                  ),
                );
              },
            ),
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              boxShadow: AppShadows.soft,
            ),
            child: Icon(Icons.shield_rounded,
                color: AppColors.accent, size: AppDimensions.iconXL),
          ),
        ],
      ),
    );
  }
}
