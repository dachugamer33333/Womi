import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/input_formatters.dart';
import '../../../../shared/widgets/womi_gradient_button.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../widgets/payment_card.dart';

class AddPaymentMethodScreen extends StatefulWidget {
  const AddPaymentMethodScreen({super.key});

  @override
  State<AddPaymentMethodScreen> createState() =>
      _AddPaymentMethodScreenState();
}

class _AddPaymentMethodScreenState extends State<AddPaymentMethodScreen> {
  final _numberCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  String _cardType = 'Crédito';

  String _digits() => _numberCtrl.text.replaceAll(RegExp(r'\D'), '');
  String _provider() {
    final d = _digits();
    if (d.isEmpty) return '';
    if (d.startsWith('4')) return 'Visa';
    if (d.startsWith('5')) return 'Mastercard';
    if (d.startsWith('3')) return 'AMEX';
    return '';
  }

  bool get _isValid {
    return _digits().length == 16 &&
        _expiryCtrl.text.length == 5 &&
        _cvvCtrl.text.length >= 3 &&
        _nameCtrl.text.trim().length >= 5;
  }

  @override
  void dispose() {
    _numberCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_isValid) return;
    final auth = context.read<AuthProvider>();
    final methods = auth.repository.getPaymentMethods();
    methods.add({
      'last4': _digits().substring(_digits().length - 4),
      'provider': _provider(),
      'expiry': _expiryCtrl.text,
      'cardholder': _nameCtrl.text.trim(),
    });
    auth.repository.savePaymentMethods(methods);
    final user = auth.currentUser;
    if (user != null) {
      auth.updateUser(user.copyWith(cardsCount: methods.length));
    }
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_rounded,
                color: AppColors.surface, size: AppDimensions.iconM),
            SizedBox(width: AppDimensions.spaceS),
            Text('Tarjeta agregada con éxito',
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.surface)),
          ],
        ),
        backgroundColor: AppColors.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final digits = _digits();
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Agregar tarjeta', style: AppTextStyles.headline),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppDimensions.spaceM),
        child: Column(
          children: [
            // Live preview card
            PaymentCard(
              last4: digits.length >= 4
                  ? digits.substring(0, digits.length.clamp(4, 16))
                  : '',
              provider: _provider(),
              cardholderName: _nameCtrl.text.trim().isEmpty
                  ? 'TU NOMBRE'
                  : _nameCtrl.text.trim(),
              expiryDate: _expiryCtrl.text.isEmpty
                  ? 'MM/AA'
                  : _expiryCtrl.text,
            ),
            SizedBox(height: AppDimensions.spaceL),
            // Form
            _buildField(
              'Número de tarjeta',
              _numberCtrl,
              TextInputType.number,
              [FilteringTextInputFormatter.digitsOnly, CardNumberFormatter()],
              '4521 1234 5678 9012',
            ),
            SizedBox(height: AppDimensions.spaceM),
            Row(
              children: [
                Expanded(
                  child: _buildField(
                    'MM/AA',
                    _expiryCtrl,
                    TextInputType.number,
                    [FilteringTextInputFormatter.digitsOnly, CardExpiryFormatter()],
                    'MM/AA',
                  ),
                ),
                SizedBox(width: AppDimensions.spaceM),
                Expanded(
                  child: _buildField(
                    'CVV',
                    _cvvCtrl,
                    TextInputType.number,
                    [FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4)],
                    '123',
                    obscure: true,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppDimensions.spaceM),
            _buildField(
              'Nombre del titular',
              _nameCtrl,
              TextInputType.text,
              [],
              'ALDO GARCIA',
            ),
            SizedBox(height: AppDimensions.spaceM),
            DropdownButtonFormField<String>(
              initialValue: _cardType,
              decoration: InputDecoration(
                labelText: 'Tipo de tarjeta',
                labelStyle: AppTextStyles.bodySmall,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  borderSide: const BorderSide(
                      color: AppColors.secondary, width: 2),
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'Crédito', child: Text('Crédito')),
                DropdownMenuItem(value: 'Débito', child: Text('Débito')),
              ],
              onChanged: (v) => setState(() => _cardType = v!),
            ),
            SizedBox(height: AppDimensions.spaceXL),
            // AVISO DE SEGURIDAD
            Container(
              padding: EdgeInsets.all(AppDimensions.spaceM),
              decoration: BoxDecoration(
                color: AppColors.lavenderLight,
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
              child: Row(
                children: [
                  Icon(Icons.lock_rounded,
                      color: AppColors.secondary, size: AppDimensions.iconM),
                  SizedBox(width: AppDimensions.spaceS),
                  Expanded(
                    child: Text(
                      'Por seguridad, solo se guardan los últimos 4 dígitos. Nunca almacenamos tu CVV ni el número completo.',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.secondary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppDimensions.spaceL),
            SizedBox(
              width: double.infinity,
              child: WomiGradientButton(
                label: 'Guardar tarjeta',
                icon: Icons.check_rounded,
                onPressed: _isValid ? _save : null,
              ),
            ),
            SizedBox(height: AppDimensions.spaceXL),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController ctrl,
    TextInputType keyboardType,
    List<TextInputFormatter> formatters,
    String hint, {
    bool obscure = false,
  }) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboardType,
      obscureText: obscure,
      inputFormatters: formatters,
      onChanged: (_) => setState(() {}),
      style: AppTextStyles.bodyMedium,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: AppTextStyles.bodySmall,
        hintStyle: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textBody.withValues(alpha: 0.3),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide:
              const BorderSide(color: AppColors.secondary, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppDimensions.spaceM,
          vertical: AppDimensions.spaceS + 2,
        ),
      ),
    );
  }
}
