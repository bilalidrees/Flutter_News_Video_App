import 'package:flutter/material.dart';
import 'package:samma_tv/app_localizations.dart';
import 'package:samma_tv/presentation/theme/app_color.dart';

class CustomTextWidget extends StatelessWidget {
  final bool isFromApi;
  final String text;
  final EnumText? fontWeight;
  final double fontSize;
  final Color? color;
  final TextAlign textAlign;
  final double horizontalPadding;
  final double verticalPadding;
  final TextDecoration decoration;
  final TextOverflow? overflow;
  final int? maxLines;
  final double? letterSpacing;

  const CustomTextWidget(this.text,
      {Key? key,
      this.fontWeight,
      this.isFromApi = false,
      this.fontSize = 20,
      this.letterSpacing,
      this.color,
      this.textAlign = TextAlign.center,
      this.horizontalPadding = 0.0,
      this.verticalPadding = 0.0,
      this.decoration = TextDecoration.none,
      this.overflow,
      this.maxLines});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding, vertical: verticalPadding),
      child: Text(
        isFromApi ? text : AppLocalizations.of(context)!.translate(text),
        textAlign: textAlign,
        maxLines: maxLines,
        style: Theme.of(context).textTheme.bodyText1!.copyWith(
            color: color,
            letterSpacing: letterSpacing,
            fontSize: fontSize,
            decoration: decoration,
            fontWeight: fontWeight == EnumText.light
                ? FontWeight.w300
                : fontWeight == EnumText.regular
                    ? FontWeight.w400
                    : fontWeight == EnumText.semiBold
                        ? FontWeight.w600
                        : fontWeight == EnumText.bold
                            ? FontWeight.w700
                            : fontWeight == EnumText.extraBold
                                ? FontWeight.w800
                                : FontWeight.w300),
      ),
    );
  }
}

enum EnumText { light, regular, semiBold, bold, extraBold }

// {
// FontWeight.w100: 'Thin',
// FontWeight.w200: 'ExtraLight',
// FontWeight.w300: 'Light',
// FontWeight.w400: 'Regular',
// FontWeight.w500: 'Medium',
// FontWeight.w600: 'SemiBold',
// FontWeight.w700: 'Bold',
// FontWeight.w800: 'ExtraBold',
// FontWeight.w900: 'Black',
// }
