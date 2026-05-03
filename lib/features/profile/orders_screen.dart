import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Mis pedidos', style: AppTextStyles.headline),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.lavenderLight,
              child: Icon(Icons.shopping_bag_rounded,
                  color: AppColors.secondary, size: AppDimensions.iconXL),
            ),
            SizedBox(height: AppDimensions.spaceM),
            Text(
              'Aún no has hecho pedidos',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textBody.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
