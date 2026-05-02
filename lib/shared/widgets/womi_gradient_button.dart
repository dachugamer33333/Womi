import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';

class WomiGradientButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final double? height;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? fontSize;
  final IconData? icon;

  const WomiGradientButton({
    super.key,
    required this.label,
    this.onPressed,
    this.height,
    this.borderRadius,
    this.padding,
    this.fontSize,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 48,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(borderRadius ?? AppDimensions.radiusPill),
          gradient: AppGradients.brand,
          boxShadow: AppShadows.soft,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius:
                BorderRadius.circular(borderRadius ?? AppDimensions.radiusPill),
            child: Padding(
              padding: padding ??
                  EdgeInsets.symmetric(
                    horizontal: AppDimensions.spaceL,
                    vertical: AppDimensions.spaceS,
                  ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: AppColors.surface, size: AppDimensions.iconM),
                    SizedBox(width: AppDimensions.spaceS),
                  ],
                  Text(
                    label,
                    style: AppTextStyles.button.copyWith(fontSize: fontSize),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
