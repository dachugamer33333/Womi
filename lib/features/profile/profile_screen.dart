import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../../core/constants/app_strings.dart';
import '../../shared/widgets/widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      child: SafeArea(
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
    return Padding(
      padding: EdgeInsets.all(AppDimensions.spaceL),
      child: Column(
        children: [
          CircleAvatar(
            radius: AppDimensions.profilePicSize / 2,
            backgroundColor: AppColors.lavenderLight,
            child: Icon(Icons.person_rounded,
                color: AppColors.secondary,
                size: AppDimensions.profilePicSize / 2),
          ),
          SizedBox(height: AppDimensions.spaceM),
          WomiGradientText(
            text: 'María García',
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
                Icon(Icons.shield_rounded,
                    color: AppColors.accent, size: AppDimensions.iconS),
                SizedBox(width: AppDimensions.spaceXS),
                Text(
                  AppStrings.accountNotVerified,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return WomiCard(
      padding: EdgeInsets.all(AppDimensions.spaceM),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(AppStrings.coupons, '3'),
          _buildDivider(),
          _buildStatItem(AppStrings.wallet, '\$250'),
          _buildDivider(),
          _buildStatItem(AppStrings.cards, '2'),
        ],
      ),
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
        childAspectRatio: 1.3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isSecurity = item.label == AppStrings.security;
        return WomiCard(
          onTap: () {},
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isSecurity)
                ShaderMask(
                  shaderCallback: (bounds) =>
                      AppGradients.brand.createShader(bounds),
                  blendMode: BlendMode.srcIn,
                  child: Icon(item.icon,
                      color: Colors.white, size: AppDimensions.iconXL),
                )
              else
                Icon(item.icon,
                    color: AppColors.secondary, size: AppDimensions.iconXL),
              SizedBox(height: AppDimensions.spaceS),
              Text(
                item.label,
                style: AppTextStyles.titleSmall,
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
