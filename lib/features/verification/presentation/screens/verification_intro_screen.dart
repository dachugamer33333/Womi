import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../shared/widgets/widgets.dart';

class VerificationIntroScreen extends StatelessWidget {
  const VerificationIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(AppDimensions.spaceL),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    children: [
                      SizedBox(height: AppDimensions.spaceXL),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: AppGradients.brand,
                          shape: BoxShape.circle,
                          boxShadow: AppShadows.medium,
                        ),
                        child: Icon(Icons.shield_rounded,
                            color: AppColors.surface, size: AppDimensions.iconXL),
                      ),
                      SizedBox(height: AppDimensions.spaceL),
                      WomiGradientText(
                        text: 'Verifica tu identidad',
                        style: AppTextStyles.displayMedium,
                      ),
                      SizedBox(height: AppDimensions.spaceM),
                      Text(
                        'Para garantizar la seguridad de todas las usuarias de Womi, verificamos manualmente la identidad de cada cuenta.',
                        style: AppTextStyles.bodyMedium.copyWith(height: 1.5),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppDimensions.spaceL),
                      _buildStep('1', 'Foto frontal de tu INE',
                          Icons.credit_card_rounded),
                      _buildStep('2', 'Foto trasera de tu INE',
                          Icons.flip_to_back_rounded),
                      _buildStep('3', 'Selfie para verificar',
                          Icons.face_rounded),
                      SizedBox(height: AppDimensions.spaceXL),
                      SizedBox(
                        width: double.infinity,
                        child: WomiGradientButton(
                          label: 'Comenzar verificación',
                          icon: Icons.arrow_forward_rounded,
                          onPressed: () => Navigator.pushNamed(
                              context, AppRoutes.ineCapture,
                              arguments: 'front'),
                        ),
                      ),
                      SizedBox(height: AppDimensions.spaceL),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStep(String number, String text, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppDimensions.spaceM),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: AppGradients.brand,
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            ),
            child: Center(
              child: Text(number,
                  style: AppTextStyles.titleSmall
                      .copyWith(color: AppColors.surface)),
            ),
          ),
          SizedBox(width: AppDimensions.spaceM),
          Icon(icon, color: AppColors.secondary, size: AppDimensions.iconM),
          SizedBox(width: AppDimensions.spaceS),
          Expanded(
            child: Text(text, style: AppTextStyles.bodyMedium),
          ),
        ],
      ),
    );
  }
}
