import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samma_tv/presentation/theme/app_color.dart';

class AppTheme{
  const AppTheme._();
  static  ThemeData  lightTheme = _lightTheme;
  static  ThemeData  darkTheme = _darkTheme;
}



ThemeData _lightTheme = ThemeData(
  brightness: Brightness.light,
  textTheme:  GoogleFonts.robotoTextTheme().copyWith(bodyText1: TextStyle(color: AppColor.blackColor)),
 // appBarTheme: const AppBarTheme(color: AppColor.transparent),
);


ThemeData _darkTheme = ThemeData(
  brightness: Brightness.dark,
  textTheme:  GoogleFonts.robotoTextTheme().copyWith(bodyText1: TextStyle(color: AppColor.whiteColor)),
  //appBarTheme: const AppBarTheme(color: AppColor.transparent),
);

