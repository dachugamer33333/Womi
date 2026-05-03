import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/theme.dart';
import '../../core/router/app_routes.dart';
import '../../core/constants/app_strings.dart';
import '../../shared/widgets/widgets.dart';
import '../auth/presentation/providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    children: [
                      _buildProfileHeader(),
                      SizedBox(height: AppDimensions.spaceL),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.spaceM),
                        child: Column(
                          children: [
                            _buildStatsRow(),
                            SizedBox(height: AppDimensions.spaceM),
                            _buildGridMenu(),
                          ],
                        ),
                      ),
                      SizedBox(height: AppDimensions.spaceXL),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.spaceM),
                        child: _buildLogoutButton(context),
                      ),
                      SizedBox(height: AppDimensions.spaceL),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        final user = auth.currentUser;
        final fullName = user?.fullName ?? '';
        final isVerified = user?.isVerified ?? false;
        return Padding(
          padding: EdgeInsets.all(AppDimensions.spaceL),
          child: Column(
            children: [
              CircleAvatar(
                radius: AppDimensions.profilePicSize / 2,
                backgroundColor: AppColors.lavenderLight,
                child: Text(
                  _getInitials(fullName),
                  style: AppTextStyles.displaySmall.copyWith(
                    color: AppColors.secondary,
                  ),
                ),
              ),
              SizedBox(height: AppDimensions.spaceM),
              WomiGradientText(
                text: fullName.isNotEmpty ? fullName : 'Usuario',
                style: AppTextStyles.displayMedium,
              ),
              SizedBox(height: AppDimensions.spaceS),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.spaceM,
                  vertical: AppDimensions.spaceXS,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.2),
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusPill),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isVerified ? Icons.verified_rounded : Icons.shield_rounded,
                      color: isVerified ? AppColors.success : AppColors.accent,
                      size: AppDimensions.iconS,
                    ),
                    SizedBox(width: AppDimensions.spaceXS),
                    Text(
                      isVerified ? 'Cuenta verificada' : AppStrings.accountNotVerified,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: isVerified ? AppColors.success : AppColors.accent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getInitials(String fullName) {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    return parts.length > 1
        ? '${parts.first[0]}${parts.last[0]}'.toUpperCase()
        : parts.first[0].toUpperCase();
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => _showLogoutDialog(context),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.accent,
          side: const BorderSide(color: AppColors.accent, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
          ),
          padding: EdgeInsets.symmetric(
            vertical: AppDimensions.spaceM,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, size: AppDimensions.iconM),
            SizedBox(width: AppDimensions.spaceS),
            Text(
              'Cerrar sesión',
              style: AppTextStyles.button.copyWith(
                color: AppColors.accent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          ),
          title: Text(
            'Cerrar sesión',
            style: AppTextStyles.headline,
          ),
          content: Text(
            '¿Estás segura de que quieres cerrar sesión?',
            style: AppTextStyles.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Cancelar',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textBody,
                ),
              ),
            ),
            WomiGradientButton(
              label: 'Cerrar sesión',
              onPressed: () async {
                Navigator.pop(ctx);
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
        );
      },
    );
  }

  Widget _buildStatsRow() {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        final user = auth.currentUser;
        return WomiCard(
          padding: EdgeInsets.all(AppDimensions.spaceM),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                  AppStrings.coupons,
                  '${user?.couponsCount ?? 0}'),
              _buildDivider(),
              _buildStatItem(
                  AppStrings.wallet,
                  '\$${(user?.walletBalance ?? 0).toStringAsFixed(0)}'),
              _buildDivider(),
              _buildStatItem(
                  AppStrings.cards,
                  '${user?.cardsCount ?? 0}'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.displaySmall.copyWith(
            color: AppColors.secondary,
          ),
        ),
        SizedBox(height: AppDimensions.spaceXS),
        Text(
          label,
          style: AppTextStyles.labelSmall,
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 40,
      color: AppColors.lavenderLight,
    );
  }

  Widget _buildGridMenu() {
    final items = [
      _MenuItem(AppStrings.orders, Icons.shopping_bag_rounded),
      _MenuItem(AppStrings.help, Icons.help_outline_rounded),
      _MenuItem(AppStrings.security, Icons.shield_rounded),
      _MenuItem(AppStrings.settings, Icons.settings_rounded),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        crossAxisSpacing: AppDimensions.spaceM,
        mainAxisSpacing: AppDimensions.spaceM,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isSecurity = item.label == AppStrings.security;
        return WomiCard(
          onTap: () {},
          shadows: AppShadows.soft,
          padding: EdgeInsets.symmetric(
            vertical: AppDimensions.spaceM,
            horizontal: AppDimensions.spaceS,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.lavenderLight,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isSecurity
                      ? ShaderMask(
                          shaderCallback: (bounds) =>
                              AppGradients.brand.createShader(bounds),
                          blendMode: BlendMode.srcIn,
                          child: Icon(item.icon,
                              color: Colors.white,
                              size: AppDimensions.iconL),
                        )
                      : Icon(item.icon,
                          color: AppColors.secondary,
                          size: AppDimensions.iconL),
                ),
              ),
              SizedBox(height: AppDimensions.spaceS),
              Text(
                item.label,
                style:
                    AppTextStyles.titleSmall.copyWith(fontSize: 14),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MenuItem {
  final String label;
  final IconData icon;

  const _MenuItem(this.label, this.icon);
}
