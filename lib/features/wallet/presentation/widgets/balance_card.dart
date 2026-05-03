import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class BalanceCard extends StatelessWidget {
  final double balance;

  const BalanceCard({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.spaceL),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.secondary, AppColors.secondaryDark],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: AppShadows.medium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.account_balance_wallet_rounded,
                  color: Colors.white, size: AppDimensions.iconM),
              SizedBox(width: AppDimensions.spaceS),
              Text('Saldo Womi',
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: Colors.white)),
            ],
          ),
          SizedBox(height: AppDimensions.spaceL),
          Text(
            '\$${balance.toStringAsFixed(2)} MXN',
            style: AppTextStyles.displayLarge.copyWith(
              color: AppColors.surface,
              fontSize: 36,
            ),
          ),
          SizedBox(height: AppDimensions.spaceS),
          Text('Saldo disponible',
              style: AppTextStyles.bodySmall
                  .copyWith(color: Colors.white70)),
        ],
      ),
    );
  }
}
