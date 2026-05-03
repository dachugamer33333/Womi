import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _changePassword() {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final user = auth.currentUser;
    if (user == null) return;
    final currentHash =
        sha256.convert(utf8.encode(_currentCtrl.text)).toString();
    if (currentHash != user.passwordHash) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('La contraseña actual es incorrecta',
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.surface)),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          ),
        ),
      );
      return;
    }
    final newHash = sha256.convert(utf8.encode(_newCtrl.text)).toString();
    auth.updateUser(user.copyWith(passwordHash: newHash));
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Contraseña actualizada',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.surface)),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Cambiar contraseña', style: AppTextStyles.headline),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppDimensions.spaceM),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: AppDimensions.spaceL),
              TextFormField(
                controller: _currentCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña actual',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Campo requerido' : null,
              ),
              SizedBox(height: AppDimensions.spaceM),
              TextFormField(
                controller: _newCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Nueva contraseña',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                ),
                validator: Validators.password,
              ),
              SizedBox(height: AppDimensions.spaceM),
              TextFormField(
                controller: _confirmCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirmar nueva contraseña',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                ),
                validator: (v) =>
                    Validators.matchPassword(v, _newCtrl.text),
              ),
              SizedBox(height: AppDimensions.spaceXL),
              SizedBox(
                width: double.infinity,
                child: WomiGradientButton(
                  label: 'Cambiar contraseña',
                  icon: Icons.lock_rounded,
                  onPressed: _changePassword,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
