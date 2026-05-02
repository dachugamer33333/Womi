import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../../core/router/app_routes.dart';
import '../../core/constants/app_strings.dart';
import '../../shared/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppGradients.lavenderToWhite,
      ),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(AppDimensions.spaceM),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    SizedBox(height: AppDimensions.spaceL),
                    _buildBannerCarousel(constraints),
                    SizedBox(height: AppDimensions.spaceL),
                    _buildSearchSection(),
                    SizedBox(height: AppDimensions.spaceL),
                    _buildRecentDestinations(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              style: AppTextStyles.displayMedium,
              children: [
                TextSpan(text: '¡Hola, '),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: ShaderMask(
                    shaderCallback: (bounds) =>
                        AppGradients.brand.createShader(bounds),
                    blendMode: BlendMode.srcIn,
                    child: Text(
                      'María!',
                      style: AppTextStyles.displayMedium
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
          child: CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.lavenderLight,
            child: Icon(Icons.person_rounded,
                color: AppColors.secondary, size: AppDimensions.iconL),
          ),
        ),
      ],
    );
  }

  Widget _buildBannerCarousel(BoxConstraints constraints) {
    return SizedBox(
      height: 180,
      child: PageView(
        children: [
          _buildGradientBannerCard(
            'Viaja segura con Womi',
            'Conductoras verificadas y viajes monitoreados 24/7',
          ),
          _buildBannerCard(
            'Comparte tu viaje',
            'Envía tu ubicación en tiempo real a tus contactos de confianza',
            AppColors.accent,
          ),
        ],
      ),
    );
  }

  Widget _buildGradientBannerCard(String title, String subtitle) {
    return Padding(
      padding: EdgeInsets.only(right: AppDimensions.spaceM),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
          gradient: AppGradients.brand,
          boxShadow: AppShadows.medium,
        ),
        padding: EdgeInsets.all(AppDimensions.spaceL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              title,
              style: AppTextStyles.displaySmall.copyWith(color: AppColors.surface),
            ),
            SizedBox(height: AppDimensions.spaceS),
            Text(
              subtitle,
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerCard(String title, String subtitle, Color color) {
    return Padding(
      padding: EdgeInsets.only(right: AppDimensions.spaceM),
      child: WomiCard(
        borderRadius: AppDimensions.radiusXL,
        color: color,
        shadows: AppShadows.medium,
        padding: EdgeInsets.all(AppDimensions.spaceL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              title,
              style: AppTextStyles.displaySmall.copyWith(color: AppColors.surface),
            ),
            SizedBox(height: AppDimensions.spaceS),
            Text(
              subtitle,
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return WomiCard(
      padding: EdgeInsets.all(AppDimensions.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shield_rounded,
                  color: AppColors.accent, size: AppDimensions.iconM),
              SizedBox(width: AppDimensions.spaceS),
              Text(
                'Viaje seguro',
                style: AppTextStyles.titleSmall
                    .copyWith(color: AppColors.secondary),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spaceM),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
              boxShadow: AppShadows.card,
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: AppStrings.searchPlaceholder,
                hintStyle: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textBody.withValues(alpha: 0.5)),
                prefixIcon: Icon(Icons.search_rounded,
                    color: AppColors.accent, size: AppDimensions.iconM),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.spaceL,
                  vertical: AppDimensions.spaceM,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentDestinations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.recentDestinations,
          style: AppTextStyles.titleMedium,
        ),
        SizedBox(height: AppDimensions.spaceM),
        ...List.generate(
          3,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: AppDimensions.spaceS),
            child: ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.lavenderLight,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                ),
                child: Icon(Icons.history_rounded,
                    color: AppColors.secondary, size: AppDimensions.iconM),
              ),
              title: Text(
                ['Casa', 'Trabajo', 'Gimnasio'][index],
                style: AppTextStyles.bodyMedium,
              ),
              subtitle: Text(
                ['Av. Principal 123', 'Calle del Sol 456', 'Av. Deportiva 789']
                    [index],
                style: AppTextStyles.labelSmall,
              ),
              trailing: Icon(Icons.chevron_right_rounded,
                  color: AppColors.textBody, size: AppDimensions.iconM),
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }
}
