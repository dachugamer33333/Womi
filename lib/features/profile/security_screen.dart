import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme.dart';
import '../../../shared/widgets/widgets.dart';
import '../auth/presentation/providers/auth_provider.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isVerified = auth.currentUser?.isVerified ?? false;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: ShaderMask(
          shaderCallback: (bounds) => AppGradients.brand.createShader(bounds),
          blendMode: BlendMode.srcIn,
          child: Text(
            'Tu seguridad es prioridad',
            style: AppTextStyles.displaySmall.copyWith(color: Colors.white),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppDimensions.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildVerificationCard(isVerified),
            SizedBox(height: AppDimensions.spaceM),
            _buildTrustedContactsCard(),
            SizedBox(height: AppDimensions.spaceM),
            _buildShareRideCard(),
            SizedBox(height: AppDimensions.spaceM),
            _buildEmergencyCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationCard(bool isVerified) {
    return WomiCard(
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: isVerified ? null : AppGradients.brand,
              color: isVerified ? AppColors.success : null,
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            ),
            child: Icon(
              isVerified ? Icons.verified_rounded : Icons.shield_rounded,
              color: AppColors.surface,
              size: AppDimensions.iconL,
            ),
          ),
          SizedBox(width: AppDimensions.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isVerified ? 'Cuenta verificada' : 'Verificación pendiente',
                  style: AppTextStyles.titleSmall,
                ),
                SizedBox(height: AppDimensions.spaceXS / 2),
                Text(
                  isVerified
                      ? 'Tu identidad ha sido verificada por el equipo de Womi.'
                      : 'Tu cuenta está siendo verificada. Recibirás una notificación en un plazo de 24 horas.',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textBody.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrustedContactsCard() {
    return WomiCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.people_rounded,
                  color: AppColors.secondary, size: AppDimensions.iconM),
              SizedBox(width: AppDimensions.spaceS),
              Text('Contactos de confianza',
                  style: AppTextStyles.titleSmall),
            ],
          ),
          SizedBox(height: AppDimensions.spaceM),
          Text(
            'Aún no tienes contactos de confianza.',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textBody.withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: AppDimensions.spaceM),
          SizedBox(
            width: double.infinity,
            child: WomiGradientButton(
              label: 'Agregar contacto',
              icon: Icons.person_add_rounded,
              onPressed: () => _showAddContactDialog(),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddContactDialog() {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => WomiDialog(
        title: 'Agregar contacto',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
              ),
            ),
            SizedBox(height: AppDimensions.spaceM),
            TextField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Teléfono',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar',
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textBody)),
          ),
          WomiGradientButton(
            label: 'Guardar',
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Contacto agregado',
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
    );
  }

  Widget _buildShareRideCard() {
    return WomiCard(
      child: Row(
        children: [
          Icon(Icons.share_location_rounded,
              color: AppColors.secondary, size: AppDimensions.iconM),
          SizedBox(width: AppDimensions.spaceS),
          Expanded(
            child: Text(
              'Compartir viaje automáticamente',
              style: AppTextStyles.titleSmall,
            ),
          ),
          Switch(
            value: false,
            onChanged: (_) {},
            activeThumbColor: AppColors.accent,
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyCard() {
    return WomiCard(
      color: AppColors.error.withValues(alpha: 0.08),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_rounded,
                  color: AppColors.error, size: AppDimensions.iconL),
              SizedBox(width: AppDimensions.spaceS),
              Text('En caso de emergencia',
                  style: AppTextStyles.titleSmall
                      .copyWith(color: AppColors.error)),
            ],
          ),
          SizedBox(height: AppDimensions.spaceM),
          Text(
            'Durante un viaje activo, el botón SOS envía una alerta inmediata a tus contactos de confianza y al equipo de Womi. Mantén la calma y sigue las instrucciones en pantalla.',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textBody.withValues(alpha: 0.7),
              height: 1.5,
            ),
          ),
          SizedBox(height: AppDimensions.spaceM),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showSosDemo(),
              icon: const Icon(Icons.warning_rounded),
              label: const Text('Probar SOS'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSosDemo() {
    showDialog(
      context: context,
      builder: (_) => WomiDialog(
        icon: Icons.warning_rounded,
        title: 'Simulación SOS',
        content: Text(
          'En un viaje real, presionar SOS notificará inmediatamente a tus contactos y a Womi. En esta demo, es una simulación.',
          style: AppTextStyles.bodyMedium,
          textAlign: TextAlign.center,
        ),
        actions: [
          WomiGradientButton(
            label: 'Entendido',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
