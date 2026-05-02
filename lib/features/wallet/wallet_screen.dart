import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../../core/constants/app_strings.dart';
import '../../shared/widgets/widgets.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text(
          AppStrings.myWallet,
          style: AppTextStyles.displayMedium,
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(AppDimensions.spaceM),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPromoBanner(),
                    SizedBox(height: AppDimensions.spaceL),
                    if (constraints.maxWidth > 600)
                      _buildWideCards()
                    else
                      _buildNarrowCards(),
                    SizedBox(height: AppDimensions.spaceXL),
                    _buildServicesSection(),
                    SizedBox(height: AppDimensions.spaceXL),
                    _buildAddPaymentButton(),
                    SizedBox(height: AppDimensions.spaceL),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.spaceM),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            ),
            child: Icon(Icons.local_offer_rounded,
                color: AppColors.surface, size: AppDimensions.iconL),
          ),
          SizedBox(width: AppDimensions.spaceM),
          Expanded(
            child: Text(
              '¡Gana puntos con cada viaje!\nCanjea por descuentos exclusivos.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.surface,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNarrowCards() {
    return Column(
      children: [
        _buildBalanceCard(),
        SizedBox(height: AppDimensions.spaceM),
        _buildCardCard(),
      ],
    );
  }

  Widget _buildWideCards() {
    return Row(
      children: [
        Expanded(child: _buildBalanceCard()),
        SizedBox(width: AppDimensions.spaceM),
        Expanded(child: _buildCardCard()),
      ],
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.spaceL),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: AppShadows.medium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.account_balance_wallet_rounded,
                  color: Colors.white.withValues(alpha: 0.9),
                  size: AppDimensions.iconL),
              SizedBox(width: AppDimensions.spaceS),
              Text(
                AppStrings.womiBalance,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spaceL),
          Text(
            '\$250.00 MXN',
            style: AppTextStyles.displayLarge.copyWith(
              color: AppColors.surface,
              fontSize: 36,
            ),
          ),
          SizedBox(height: AppDimensions.spaceS),
          Text(
            'Saldo disponible',
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.spaceL),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: AppShadows.medium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.credit_card_rounded,
                  color: Colors.white.withValues(alpha: 0.9),
                  size: AppDimensions.iconL),
              SizedBox(width: AppDimensions.spaceS),
              Text(
                AppStrings.linkedCard,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spaceL),
          Row(
            children: [
              Icon(Icons.credit_card_rounded,
                  color: Colors.white.withValues(alpha: 0.9),
                  size: AppDimensions.iconXL),
              SizedBox(width: AppDimensions.spaceM),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '•••• 4521',
                    style: AppTextStyles.displaySmall.copyWith(
                      color: AppColors.surface,
                      letterSpacing: 2,
                    ),
                  ),
                  Text(
                    'Visa',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServicesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.services,
          style: AppTextStyles.titleMedium,
        ),
        SizedBox(height: AppDimensions.spaceM),
        Row(
          children: [
            Expanded(child: _buildServiceCard('Recargar tiempo aire', Icons.signal_cellular_alt_rounded)),
            SizedBox(width: AppDimensions.spaceM),
            Expanded(child: _buildServiceCard('Tarjetas de regalo', Icons.card_giftcard_rounded)),
          ],
        ),
      ],
    );
  }

  Widget _buildServiceCard(String label, IconData icon) {
    return WomiCard(
      padding: EdgeInsets.symmetric(
        vertical: AppDimensions.spaceM,
        horizontal: AppDimensions.spaceM,
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.lavenderLight,
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            ),
            child: Icon(icon,
                color: AppColors.secondary, size: AppDimensions.iconL),
          ),
          SizedBox(height: AppDimensions.spaceS),
          Text(
            label,
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAddPaymentButton() {
    return Center(
      child: WomiGradientButton(
        label: 'Agregar método de pago',
        icon: Icons.add_rounded,
        onPressed: () {},
      ),
    );
  }
}
