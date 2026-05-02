import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';

class WomiCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final List<BoxShadow>? shadows;
  final Color? color;
  final VoidCallback? onTap;

  const WomiCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.shadows,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.zero,
      child: Material(
        color: color ?? AppColors.surface,
        borderRadius: BorderRadius.circular(borderRadius ?? AppDimensions.radiusL),
        elevation: 0,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius ?? AppDimensions.radiusL),
          child: Container(
            padding: padding ?? EdgeInsets.all(AppDimensions.spaceM),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius:
                  BorderRadius.circular(borderRadius ?? AppDimensions.radiusL),
              boxShadow: shadows ?? AppShadows.card,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
