import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../../core/constants/app_strings.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text(
          AppStrings.activity,
          style: AppTextStyles.displayMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              AppStrings.history,
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.secondary,
              ),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: _buildEmptyState(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.receipt_long_rounded,
            size: 56,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: AppDimensions.spaceL),
        Text(
          AppStrings.noActivity,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textBody.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}
