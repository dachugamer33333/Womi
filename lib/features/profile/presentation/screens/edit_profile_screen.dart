import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _photoPath;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().currentUser;
    if (user != null) {
      _nameCtrl.text = user.fullName;
      _phoneCtrl.text = user.phone;
      _photoPath = user.photoPath;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() => _photoPath = image.path);
      }
    } catch (_) {}
  }

  void _showPhotoSource() {
    showDialog(
      context: context,
      builder: (_) => WomiDialog(
        title: 'Foto de perfil',
        content: Text('Elige una opción', style: AppTextStyles.bodyMedium),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
            child: Text('Tomar foto',
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.secondary)),
          ),
          WomiGradientButton(
            label: 'Galería',
            icon: Icons.photo_library_rounded,
            onPressed: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final user = auth.currentUser;
    if (user == null) return;
    final updated = user.copyWith(
      fullName: _nameCtrl.text.trim(),
      phone: _phoneCtrl.text.replaceAll(RegExp(r'\D'), ''),
      photoPath: _photoPath,
    );
    await auth.updateUser(updated);
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Perfil actualizado',
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.surface)),
          backgroundColor: AppColors.secondary,
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
    final user = context.watch<AuthProvider>().currentUser;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Editar perfil', style: AppTextStyles.headline),
        actions: [
          TextButton(
            onPressed: _save,
            child: Text('Guardar',
                style: AppTextStyles.labelLarge
                    .copyWith(color: AppColors.accent)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppDimensions.spaceM),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: AppDimensions.spaceL),
              _buildPhotoSection(),
              SizedBox(height: AppDimensions.spaceXL),
              TextFormField(
                controller: _nameCtrl,
                decoration: InputDecoration(
                  labelText: 'Nombre completo',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Campo requerido' : null,
              ),
              SizedBox(height: AppDimensions.spaceM),
              TextFormField(
                initialValue: user?.email ?? '',
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Email (no editable)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                ),
              ),
              SizedBox(height: AppDimensions.spaceM),
              TextFormField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Teléfono (10 dígitos)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Campo requerido';
                  final d = v.replaceAll(RegExp(r'\D'), '');
                  if (d.length != 10) return 'Debe tener 10 dígitos';
                  return null;
                },
              ),
              SizedBox(height: AppDimensions.spaceXL),
              SizedBox(
                width: double.infinity,
                child: WomiGradientButton(
                  label: 'Cambiar contraseña',
                  icon: Icons.lock_outline_rounded,
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.changePassword),
                ),
              ),
              SizedBox(height: AppDimensions.spaceXXL),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _showDeleteDialog,
                  icon: const Icon(Icons.delete_forever_rounded),
                  label: const Text('Eliminar cuenta'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    ),
                    padding: EdgeInsets.symmetric(vertical: AppDimensions.spaceM),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoSection() {
    return GestureDetector(
      onTap: _showPhotoSource,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: AppColors.lavenderLight,
            backgroundImage:
                _photoPath != null ? FileImage(File(_photoPath!)) : null,
            child: _photoPath == null
                ? Text(
                    _getInitials(
                        context.read<AuthProvider>().currentUser?.fullName ??
                            ''),
                    style: AppTextStyles.displayLarge.copyWith(
                      color: AppColors.secondary,
                      fontSize: 32,
                    ),
                  )
                : null,
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: AppGradients.brand,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.camera_alt_rounded,
                color: AppColors.surface, size: 18),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    return parts.length > 1
        ? '${parts.first[0]}${parts.last[0]}'.toUpperCase()
        : parts.first[0].toUpperCase();
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (_) => WomiDialog(
        title: 'Eliminar cuenta',
        content: Text(
          'Esta acción es irreversible. Todos tus datos serán eliminados.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar',
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textBody)),
          ),
          WomiGradientButton(
            label: 'Eliminar cuenta',
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthProvider>().logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (_) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
