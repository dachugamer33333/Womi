import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';

class WomiGradientText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;

  const WomiGradientText({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return AppGradients.brand.createShader(bounds);
      },
      blendMode: BlendMode.srcIn,
      child: Text(
        text,
        style: (style ?? AppTextStyles.displayMedium).copyWith(color: Colors.white),
        textAlign: textAlign,
        maxLines: maxLines,
      ),
    );
  }
}
