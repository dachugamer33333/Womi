import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../../shared/widgets/womi_gradient_button.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Ayuda', style: AppTextStyles.headline),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppDimensions.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildFaqTile(
              '¿Cómo se verifica mi cuenta?',
              'Tu cuenta será verificada por el equipo de Womi en un plazo máximo de 24 horas. Recibirás una notificación cuando tu identidad haya sido validada.',
            ),
            _buildFaqTile(
              '¿Qué hago en caso de emergencia?',
              'Durante un viaje, puedes presionar el botón SOS en la parte inferior de la pantalla. Esto notificará automáticamente a tus contactos de confianza y al equipo de Womi.',
            ),
            _buildFaqTile(
              '¿Cómo agrego un método de pago?',
              'Ve a la sección de Billetera y selecciona "Agregar método de pago". Puedes registrar tarjetas Visa, Mastercard o AMEX.',
            ),
            SizedBox(height: AppDimensions.spaceL),
            WomiGradientButton(
              label: 'Contactar soporte',
              icon: Icons.mail_outline_rounded,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('soporte@womi.mx',
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: AppColors.surface)),
                    backgroundColor: AppColors.secondary,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqTile(String question, String answer) {
    return Card(
      color: AppColors.surface,
      elevation: 0,
      margin: EdgeInsets.only(bottom: AppDimensions.spaceS),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        title: Text(question, style: AppTextStyles.bodyMedium),
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppDimensions.spaceM,
              0,
              AppDimensions.spaceM,
              AppDimensions.spaceM,
            ),
            child: Text(
              answer,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textBody.withValues(alpha: 0.8),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
