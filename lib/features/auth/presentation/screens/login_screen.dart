import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../shared/widgets/widgets.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/password_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final success = await auth.login(
      email: _emailCtrl.text,
      password: _passwordCtrl.text,
    );

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            auth.errorMessage ?? 'Error al iniciar sesión',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.surface,
            ),
          ),
          backgroundColor: AppColors.accent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppDimensions.spaceL),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Form(
                    key: _formKey,
                    child: Consumer<AuthProvider>(
                      builder: (context, auth, _) {
                        return Column(
                          children: [
                            SizedBox(height: AppDimensions.spaceXXL),
                            _buildLogo(),
                            SizedBox(height: AppDimensions.spaceXL),
                            WomiGradientText(
                              text: 'Bienvenida de nuevo',
                              style: AppTextStyles.displaySmall,
                            ),
                            SizedBox(height: AppDimensions.spaceS),
                            Text(
                              'Inicia sesión para continuar',
                              style: AppTextStyles.bodyMedium,
                            ),
                            SizedBox(height: AppDimensions.spaceXL),
                            AuthTextField(
                              controller: _emailCtrl,
                              label: 'Correo electrónico',
                              hintText: 'tu@correo.com',
                              keyboardType: TextInputType.emailAddress,
                              validator: Validators.email,
                              prefixIcon: Icon(Icons.email_outlined,
                                  color: AppColors.secondary,
                                  size: AppDimensions.iconM),
                            ),
                            SizedBox(height: AppDimensions.spaceM),
                            PasswordField(
                              controller: _passwordCtrl,
                              validator: Validators.password,
                              onChanged: (_) => auth.clearError(),
                            ),
                            SizedBox(height: AppDimensions.spaceXL),
                            SizedBox(
                              width: double.infinity,
                              child: WomiGradientButton(
                                label: auth.isLoading
                                    ? 'Iniciando sesión...'
                                    : 'Iniciar sesión',
                                onPressed: auth.isLoading ? null : _handleLogin,
                                icon: auth.isLoading
                                    ? null
                                    : Icons.login_rounded,
                              ),
                            ),
                            if (auth.isLoading)
                              Padding(
                                padding: EdgeInsets.only(
                                    top: AppDimensions.spaceM),
                                child: CircularProgressIndicator(
                                  color: AppColors.accent,
                                ),
                              ),
                            SizedBox(height: AppDimensions.spaceL),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '¿No tienes cuenta? ',
                                  style: AppTextStyles.bodyMedium,
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.pushReplacementNamed(
                                      context, AppRoutes.register),
                                  child: Text(
                                    'Regístrate',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.accent,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: AppDimensions.spaceXXL),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        gradient: AppGradients.brand,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: AppShadows.medium,
      ),
      child: Center(
        child: Text(
          'W',
          style: AppTextStyles.displayLarge.copyWith(
            color: AppColors.surface,
            fontSize: 36,
          ),
        ),
      ),
    );
  }
}
