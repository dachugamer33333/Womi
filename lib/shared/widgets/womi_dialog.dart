import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';

class WomiDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget>? actions;
  final IconData? icon;

  const WomiDialog({
    super.key,
    required this.title,
    required this.content,
    this.actions,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(AppDimensions.spaceL),
      child: Container(
        padding: EdgeInsets.all(AppDimensions.spaceL),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          boxShadow: AppShadows.soft,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: AppGradients.brand,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: Icon(icon, color: AppColors.surface, size: AppDimensions.iconL),
              ),
              SizedBox(height: AppDimensions.spaceM),
            ],
            Text(
              title,
              style: AppTextStyles.headline,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppDimensions.spaceM),
            content,
            if (actions != null) ...[
              SizedBox(height: AppDimensions.spaceL),
              if (actions!.length == 2)
                Row(
                  children: actions!.map((a) => Expanded(child: a)).toList(),
                )
              else
                ...actions!,
            ],
          ],
        ),
      ),
    );
  }
}
