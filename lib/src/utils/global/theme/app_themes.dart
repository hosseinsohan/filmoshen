import 'package:filimo/src/utils/app_colors.dart';
import 'package:flutter/material.dart';

enum AppTheme {
  Light,
  Dark
}

final appThemeData = {
  AppTheme.Light: ThemeData(
    brightness: Brightness.light,
    primaryColor: yellowColor,
    fontFamily: 'IRANYekanMobileMedium',
  ),
  AppTheme.Dark: ThemeData(
    brightness: Brightness.dark,
    primaryColor: bgColor,
    fontFamily: 'IRANYekanMobileMedium',
  )
};