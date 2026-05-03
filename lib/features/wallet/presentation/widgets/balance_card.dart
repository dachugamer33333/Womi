import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class BalanceCard extends StatelessWidget {
  final double balance;
  final VoidCallback? onHideToggle;

  const BalanceCard({
    super.key,
    required this.balance,
    this.onHideToggle,
  });

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
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative bubbles
          Positioned(
            top: -40,
            right: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.account_balance_wallet_rounded,
                          color: Colors.white.withValues(alpha: 0.9),
                          size: AppDimensions.iconM),
                      SizedBox(width: AppDimensions.spaceS),
                      Text(
                        'Saldo Womi',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Womi',
                    style: AppTextStyles.titleSmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppDimensions.spaceL + AppDimensions.spaceS),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$',
                    style: AppTextStyles.displayLarge.copyWith(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(width: AppDimensions.spaceXS),
                  Text(
                    balance.toStringAsFixed(2),
                    style: AppTextStyles.displayLarge.copyWith(
                      color: AppColors.surface,
                      fontSize: 42,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(width: AppDimensions.spaceS),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      'MXN',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppDimensions.spaceL),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Saldo disponible',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                  GestureDetector(
                    onTap: onHideToggle,
                    child: Icon(Icons.visibility_rounded,
                        color: Colors.white.withValues(alpha: 0.5),
                        size: AppDimensions.iconM),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
