import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.onChanged,
    this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
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
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            validator: validator,
            onChanged: onChanged,
            onEditingComplete: onEditingComplete,
            style: AppTextStyles.bodyMedium,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textBody.withValues(alpha: 0.4),
              ),
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
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
