import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

/// Text style variants for elder-friendly display.
enum ElderTextStyle {
  /// 32sp Bold
  title,

  /// 28sp Bold
  subtitle,

  /// 22sp Regular
  body,

  /// 18sp Regular (minimum size)
  caption,
}

/// Elder-friendly text widget that enforces a minimum 18sp font size.
class ElderText extends StatelessWidget {
  const ElderText(
    this.text, {
    super.key,
    this.style = ElderTextStyle.body,
    this.color,
    this.maxLines,
    this.textAlign,
  });

  final String text;
  final ElderTextStyle style;
  final Color? color;
  final int? maxLines;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: _resolveStyle(),
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
      textAlign: textAlign,
    );
  }

  TextStyle _resolveStyle() {
    final Color resolvedColor;
    final double fontSize;
    final FontWeight fontWeight;

    switch (style) {
      case ElderTextStyle.title:
        fontSize = AppSizes.fontTitle; // 32
        fontWeight = FontWeight.bold;
        resolvedColor = color ?? AppColors.darkText;
      case ElderTextStyle.subtitle:
        fontSize = AppSizes.fontSubtitle; // 28
        fontWeight = FontWeight.bold;
        resolvedColor = color ?? AppColors.darkText;
      case ElderTextStyle.body:
        fontSize = AppSizes.fontBody; // 22
        fontWeight = FontWeight.normal;
        resolvedColor = color ?? AppColors.darkText;
      case ElderTextStyle.caption:
        fontSize = AppSizes.fontCaption; // 18
        fontWeight = FontWeight.normal;
        resolvedColor = color ?? AppColors.warmGrey;
    }

    // Enforce minimum — should already be satisfied but just in case.
    final double safeFontSize =
        fontSize < AppSizes.minFontSize ? AppSizes.minFontSize : fontSize;

    return TextStyle(
      fontSize: safeFontSize,
      fontWeight: fontWeight,
      color: resolvedColor,
    );
  }
}
