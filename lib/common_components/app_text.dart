import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/constants.dart';

class AppText extends StatelessWidget {
  final String text;
  final String? fontFamily;
  final Color? color;
  final Color? decorationColor;
  final FontWeight? fontWeight;
  final double? fontSize;
  final TextAlign? textAlign;
  final double? height;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? letterSpacing;
  final double? wordSpacing;
  final bool? softWrap;
  final TextDecoration? textDecoration;
  final FontStyle? fontStyle;

  const AppText({
    super.key,
    required this.text,
    this.color,
    this.decorationColor,
    this.fontWeight,
    this.fontSize,
    this.textAlign,
    this.softWrap,
    this.height,
    this.maxLines,
    this.overflow,
    this.letterSpacing,
    this.wordSpacing,
    this.fontFamily,
    this.textDecoration,
    this.fontStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      softWrap: softWrap,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        fontFamily: fontFamily ?? FontFamily.inter,
        color: color ?? AppTheme.contentNeutralSecondary,
        fontWeight: fontWeight ?? FontWeight.w500,
        fontSize: fontSize ?? 16.sp,
        height: height ?? 1.3,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
        decoration: textDecoration,
        fontStyle: fontStyle,
        decorationColor: decorationColor ?? (color ?? AppTheme.contentNeutralSecondary),
      ),
    );
  }
}
