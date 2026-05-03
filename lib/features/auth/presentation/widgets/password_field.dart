import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onChanged;

  const PasswordField({
    super.key,
    required this.controller,
    this.label = 'Contraseña',
    this.hintText,
    this.validator,
    this.textInputAction = TextInputAction.done,
    this.onChanged,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTextStyles.labelLarge,
        ),
        SizedBox(height: AppDimensions.spaceS),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            boxShadow: AppShadows.card,
          ),
          child: TextFormField(
            controller: widget.controller,
            obscureText: _obscure,
            textInputAction: widget.textInputAction,
            validator: widget.validator,
            onChanged: widget.onChanged,
            style: AppTextStyles.bodyMedium,
            decoration: InputDecoration(
              hintText: widget.hintText ?? '••••••••',
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textBody.withValues(alpha: 0.4),
              ),
              prefixIcon: Icon(Icons.lock_outline_rounded,
                  color: AppColors.secondary, size: AppDimensions.iconM),
              suffixIcon: GestureDetector(
                onTap: () => setState(() => _obscure = !_obscure),
                child: Icon(
                  _obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                  color: AppColors.accent,
                  size: AppDimensions.iconM,
                ),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppDimensions.spaceM,
                vertical: AppDimensions.spaceM,
              ),
              errorStyle: AppTextStyles.labelSmall.copyWith(
                color: AppColors.accent,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
