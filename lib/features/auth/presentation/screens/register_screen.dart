import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../shared/widgets/widgets.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/password_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final success = await auth.register(
      fullName: _nameCtrl.text,
      email: _emailCtrl.text,
      phone: _phoneCtrl.text,
      password: _passwordCtrl.text,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '¡Cuenta creada! Bienvenida a Womi',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.surface,
            ),
          ),
          backgroundColor: AppColors.secondary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          ),
        ),
      );
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            auth.errorMessage ?? 'Error al crear la cuenta',
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
                            SizedBox(height: AppDimensions.spaceL),
                            _buildLogo(),
                            SizedBox(height: AppDimensions.spaceL),
                            WomiGradientText(
                              text: 'Crea tu cuenta Womi',
                              style: AppTextStyles.displaySmall,
                            ),
                            SizedBox(height: AppDimensions.spaceS),
                            Text(
                              'Viaja segura con conductoras verificadas',
                              style: AppTextStyles.bodyMedium,
                            ),
                            SizedBox(height: AppDimensions.spaceL),
                            AuthTextField(
                              controller: _nameCtrl,
                              label: 'Nombre completo',
                              hintText: 'Tu nombre y apellido',
                              validator: (v) =>
                                  Validators.required(v, fieldName: 'El nombre'),
                              prefixIcon: Icon(Icons.person_outline_rounded,
                                  color: AppColors.secondary,
                                  size: AppDimensions.iconM),
                            ),
                            SizedBox(height: AppDimensions.spaceM),
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
                            AuthTextField(
                              controller: _phoneCtrl,
                              label: 'Teléfono (10 dígitos)',
                              hintText: '5512345678',
                              keyboardType: TextInputType.phone,
                              validator: Validators.phoneMX,
                              prefixIcon: Icon(Icons.phone_outlined,
                                  color: AppColors.secondary,
                                  size: AppDimensions.iconM),
                            ),
                            SizedBox(height: AppDimensions.spaceM),
                            PasswordField(
                              controller: _passwordCtrl,
                              validator: Validators.password,
                              onChanged: (_) => auth.clearError(),
                            ),
                            SizedBox(height: AppDimensions.spaceM),
                            PasswordField(
                              controller: _confirmCtrl,
                              label: 'Confirmar contraseña',
                              hintText: 'Repite tu contraseña',
                              validator: (v) => Validators.matchPassword(
                                  v, _passwordCtrl.text),
                              textInputAction: TextInputAction.done,
                            ),
                            SizedBox(height: AppDimensions.spaceL),
                            _buildVerificationNotice(),
                            SizedBox(height: AppDimensions.spaceL),
                            SizedBox(
                              width: double.infinity,
                              child: WomiGradientButton(
                                label: auth.isLoading
                                    ? 'Creando cuenta...'
                                    : 'Crear cuenta',
                                onPressed:
                                    auth.isLoading ? null : _handleRegister,
                                icon: auth.isLoading
                                    ? null
                                    : Icons.person_add_rounded,
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
                                  '¿Ya tienes cuenta? ',
                                  style: AppTextStyles.bodyMedium,
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.pushReplacementNamed(
                                      context, AppRoutes.login),
                                  child: Text(
                                    'Inicia sesión',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.accent,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: AppDimensions.spaceL),
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

  Widget _buildVerificationNotice() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.spaceM),
      decoration: BoxDecoration(
        color: AppColors.lavenderLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded,
              color: AppColors.secondary, size: AppDimensions.iconM),
          SizedBox(width: AppDimensions.spaceS),
          Expanded(
            child: Text(
              'Tu cuenta será verificada en un plazo de 24 horas. Mientras tanto podrás explorar la app con funciones limitadas.',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.secondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
