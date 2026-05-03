import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme.dart';
import '../../../core/router/app_routes.dart';
import '../../../shared/widgets/widgets.dart';
import '../auth/presentation/providers/auth_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Ajustes', style: AppTextStyles.headline),
      ),
      body: ListView(
        children: [
          _buildOption(
            icon: Icons.edit_rounded,
            title: 'Editar perfil',
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.editProfile),
          ),
          _buildSwitchOption(
            icon: Icons.notifications_rounded,
            title: 'Notificaciones',
            value: true,
            onChanged: (_) {},
          ),
          _buildOption(
            icon: Icons.language_rounded,
            title: 'Idioma',
            trailing: Text('Español', style: AppTextStyles.labelSmall),
          ),
          _buildOption(
            icon: Icons.info_outline_rounded,
            title: 'Acerca de Womi',
            onTap: () => _showAboutDialog(context),
          ),
          SizedBox(height: AppDimensions.spaceXL),
          Divider(indent: AppDimensions.spaceM, endIndent: AppDimensions.spaceM),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.spaceM,
              vertical: AppDimensions.spaceS,
            ),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showLogoutDialog(context),
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Cerrar sesión'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.accent,
                  side: const BorderSide(color: AppColors.accent),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                  padding: EdgeInsets.symmetric(vertical: AppDimensions.spaceM),
                ),
              ),
            ),
          ),
          SizedBox(height: AppDimensions.spaceL),
        ],
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.lavenderLight,
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        ),
        child: Icon(icon, color: AppColors.secondary, size: AppDimensions.iconM),
      ),
      title: Text(title, style: AppTextStyles.bodyMedium),
      trailing: trailing ?? const Icon(Icons.chevron_right_rounded,
          color: AppColors.iconInactive),
      onTap: onTap,
    );
  }

  Widget _buildSwitchOption({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool>? onChanged,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.lavenderLight,
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        ),
        child: Icon(icon, color: AppColors.secondary, size: AppDimensions.iconM),
      ),
      title: Text(title, style: AppTextStyles.bodyMedium),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppColors.accent,
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => WomiDialog(
        title: 'Acerca de Womi',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Womi es la app de movilidad diseñada exclusivamente para mujeres. Viaja segura con conductoras verificadas.',
              style: AppTextStyles.bodyMedium.copyWith(height: 1.5),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppDimensions.spaceM),
            Text('Versión 1.0.0',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textBody.withValues(alpha: 0.5),
                )),
          ],
        ),
        actions: [
          WomiGradientButton(
            label: 'Cerrar',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => WomiDialog(
        title: 'Cerrar sesión',
        content: Text(
          '¿Estás segura de que quieres cerrar sesión?',
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
            label: 'Cerrar sesión',
            onPressed: () async {
              Navigator.pop(context);
              await context.read<AuthProvider>().logout();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (_) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
