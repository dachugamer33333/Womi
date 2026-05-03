import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/theme.dart';
import '../../core/constants/app_strings.dart';
import '../../shared/widgets/widgets.dart';
import '../../core/router/app_routes.dart';
import '../auth/presentation/providers/auth_provider.dart';
import 'presentation/widgets/balance_card.dart';
import 'presentation/widgets/payment_card.dart';

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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppDimensions.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
              _buildPromoBanner(),
              SizedBox(height: AppDimensions.spaceL),
              _buildNarrowCards(),
              SizedBox(height: AppDimensions.spaceXL),
              _buildServicesSection(),
              SizedBox(height: AppDimensions.spaceXL),
              _buildAddPaymentButton(context),
            SizedBox(height: AppDimensions.spaceL),
          ],
        ),
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

  Widget _buildBalanceCard() {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        return BalanceCard(
          balance: auth.currentUser?.walletBalance ?? 0.0,
        );
      },
    );
  }

  Widget _buildCardCard() {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        final methods = auth.repository.getPaymentMethods();
        if (methods.isEmpty) {
          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRoutes.addPayment),
            child: const PaymentCard(
              last4: '',
              provider: '',
              cardholderName: '',
              expiryDate: '',
              isEmpty: true,
            ),
          );
        }
        final first = methods.first;
        return PaymentCard(
          last4: first['last4'] as String? ?? '',
          provider: first['provider'] as String? ?? '',
          cardholderName: auth.currentUser?.fullName ?? '',
          expiryDate: '12/28',
        );
      },
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

  Widget _buildAddPaymentButton(BuildContext context) {
    return Center(
      child: WomiGradientButton(
        label: 'Agregar método de pago',
        icon: Icons.add_rounded,
        onPressed: () => Navigator.pushNamed(context, AppRoutes.addPayment),
      ),
    );
  }
}
