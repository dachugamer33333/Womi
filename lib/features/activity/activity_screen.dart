import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/theme.dart';
import '../../core/constants/app_strings.dart';
import '../../shared/widgets/widgets.dart';
import '../auth/presentation/providers/auth_provider.dart';

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
      body: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          final activities = auth.repository.getActivities();
          if (activities.isEmpty) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: _buildEmptyState(),
                  ),
                );
              },
            );
          }
          return LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: ListView.builder(
                    padding: EdgeInsets.all(AppDimensions.spaceM),
                    itemCount: activities.length,
                    itemBuilder: (context, index) {
                      final a = activities[index];
                      return _buildActivityCard(a);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: kDebugMode
          ? FloatingActionButton.extended(
              onPressed: () => _addTestActivity(context),
              backgroundColor: AppColors.secondary,
              icon: const Icon(Icons.add_rounded, color: Colors.white),
              label: Text(
                'Agregar actividad',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.surface,
                ),
              ),
            )
          : null,
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

  Widget _buildActivityCard(Map<String, dynamic> activity) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppDimensions.spaceM),
      child: WomiCard(
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.lavenderLight,
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              ),
              child: Icon(
                activity['type'] == 'comida'
                    ? Icons.restaurant_rounded
                    : Icons.local_taxi_rounded,
                color: AppColors.secondary,
                size: AppDimensions.iconL,
              ),
            ),
            SizedBox(width: AppDimensions.spaceM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity['name'] as String? ?? '',
                    style: AppTextStyles.titleSmall,
                  ),
                  SizedBox(height: AppDimensions.spaceXS),
                  Text(
                    '${activity['date']} · ${activity['amount']}',
                    style: AppTextStyles.labelSmall,
                  ),
                ],
              ),
            ),
            WomiGradientButton(
              label: AppStrings.orderAgain,
              onPressed: () {},
              height: 36,
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.spaceM,
                vertical: AppDimensions.spaceXS,
              ),
              fontSize: 12,
            ),
          ],
        ),
      ),
    );
  }

  void _addTestActivity(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final activities = auth.repository.getActivities();
    activities.insert(0, {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': 'Viaje a Zona Rosa',
      'type': 'transporte',
      'date': 'Hoy',
      'amount': '\$120.00 MXN',
      'description': 'Viaje seguro con conductora verificada',
    });
    auth.repository.saveActivities(activities);
    if (auth.currentUser != null) {
      auth.updateUser(auth.currentUser!.copyWith(
        walletBalance: auth.currentUser!.walletBalance + 500.0,
        couponsCount: auth.currentUser!.couponsCount + 1,
      ));
    }
  }
}
