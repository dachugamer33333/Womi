import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class PaymentCard extends StatelessWidget {
  final String last4;
  final String provider;
  final String cardholderName;
  final String expiryDate;
  final bool isEmpty;

  const PaymentCard({
    super.key,
    required this.last4,
    required this.provider,
    required this.cardholderName,
    required this.expiryDate,
    this.isEmpty = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isEmpty) return _buildEmpty(context);
    return _buildCard(context);
  }

  Widget _buildEmpty(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppDimensions.spaceXL),
        decoration: BoxDecoration(
          color: AppColors.lavenderLight,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: AppGradients.brand,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add_rounded,
                  color: AppColors.surface, size: AppDimensions.iconL),
            ),
            SizedBox(height: AppDimensions.spaceM),
            Text(
              'Agrega tu primer\nmétodo de pago',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textBody.withValues(alpha: 0.6),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    final isVisa = provider.toLowerCase() == 'visa';
    final isMastercard = provider.toLowerCase() == 'mastercard';
    final isAmex = provider.toLowerCase() == 'amex';
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.spaceL),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.accent, AppColors.accentDark],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        boxShadow: AppShadows.medium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 28,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFD4AF37), Color(0xFFF4D03F)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const Spacer(),
              if (isVisa)
                Text('VISA',
                    style: AppTextStyles.displaySmall.copyWith(
                      color: AppColors.surface,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      fontSize: 22,
                    ))
              else if (isMastercard)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFEB001B).withValues(alpha: 0.85),
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(-6, 0),
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFF79E1B).withValues(alpha: 0.85),
                        ),
                      ),
                    ),
                  ],
                )
              else if (isAmex)
                Text('AMEX',
                    style: AppTextStyles.displaySmall.copyWith(
                      color: AppColors.surface,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      fontSize: 18,
                    ))
              else
                Icon(Icons.credit_card_rounded,
                    color: Colors.white70, size: AppDimensions.iconL),
            ],
          ),
          SizedBox(height: AppDimensions.spaceL),
          Text(
            _formatCardNumber(last4),
            style: const TextStyle(
              fontFamily: 'Courier',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 3,
            ),
          ),
          SizedBox(height: AppDimensions.spaceM),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('TITULAR',
                      style: AppTextStyles.labelSmall
                          .copyWith(color: Colors.white54, fontSize: 9)),
                  Text(cardholderName.toUpperCase(),
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.surface)),
                ],
              ),
              SizedBox(width: AppDimensions.spaceL),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('VENCE',
                      style: AppTextStyles.labelSmall
                          .copyWith(color: Colors.white54, fontSize: 9)),
                  Text(expiryDate,
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.surface)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatCardNumber(String digits) {
    final padded = digits.padRight(16, '•');
    final groups = <String>[];
    for (int i = 0; i < padded.length; i += 4) {
      groups.add(padded.substring(i, (i + 4).clamp(0, padded.length)));
    }
    return groups.join(' ');
  }
}
