import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/theme.dart';
import '../../core/router/app_routes.dart';
import '../../core/constants/app_strings.dart';
import '../../shared/widgets/widgets.dart';
import '../auth/presentation/providers/auth_provider.dart';

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
                    _buildSearchSection(context),
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
    final auth = context.watch<AuthProvider>();
    final firstName = auth.currentUser?.fullName.split(' ').first ?? '';
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
                      '$firstName!',
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
            child: Text(
              _getInitials(auth.currentUser?.fullName ?? ''),
              style: AppTextStyles.titleSmall.copyWith(
                color: AppColors.secondary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getInitials(String fullName) {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    return parts.length > 1
        ? '${parts.first[0]}${parts.last[0]}'.toUpperCase()
        : parts.first[0].toUpperCase();
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

  Widget _buildSearchSection(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.destinationSearch),
      child: WomiCard(
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
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.spaceL,
                vertical: AppDimensions.spaceM + 2,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                boxShadow: AppShadows.card,
              ),
              child: Row(
                children: [
                  Icon(Icons.search_rounded,
                      color: AppColors.accent, size: AppDimensions.iconM),
                  SizedBox(width: AppDimensions.spaceS),
                  Text(
                    AppStrings.searchPlaceholder,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textBody.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentDestinations() {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        final destinations = auth.repository.getRecentDestinations();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.recentDestinations,
              style: AppTextStyles.titleMedium,
            ),
            SizedBox(height: AppDimensions.spaceM),
            if (destinations.isEmpty)
              _buildEmptyDestinations()
            else
              ...destinations.map((dest) => Padding(
                    padding: EdgeInsets.only(bottom: AppDimensions.spaceS),
                    child: ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.lavenderLight,
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radiusS),
                        ),
                        child: Icon(Icons.history_rounded,
                            color: AppColors.secondary,
                            size: AppDimensions.iconM),
                      ),
                      title: Text(
                        dest['name'] as String? ?? '',
                        style: AppTextStyles.bodyMedium,
                      ),
                      subtitle: Text(
                        dest['address'] as String? ?? '',
                        style: AppTextStyles.labelSmall,
                      ),
                      trailing: Icon(Icons.chevron_right_rounded,
                          color: AppColors.textBody,
                          size: AppDimensions.iconM),
                      contentPadding: EdgeInsets.zero,
                    ),
                  )),
          ],
        );
      },
    );
  }

  Widget _buildEmptyDestinations() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.spaceXL),
      decoration: BoxDecoration(
        color: AppColors.lavenderLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Column(
        children: [
          Icon(Icons.explore_outlined,
              color: AppColors.secondary.withValues(alpha: 0.4),
              size: AppDimensions.iconXL),
          SizedBox(height: AppDimensions.spaceM),
          Text(
            'Aún no tienes destinos guardados.\n¡Empieza tu primer viaje!',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textBody.withValues(alpha: 0.6),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
