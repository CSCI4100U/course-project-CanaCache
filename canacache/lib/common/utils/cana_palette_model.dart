import "package:flutter/material.dart";

enum CanaTheme {
  light(
    primaryBgColor: Color(0xFFFFFFFF),
    primaryIconColor: Color(0xFF8E918F),
    primaryTextColor: Color(0xFF0F0F0F),
    primaryFontFamily: "RaleWay",
    secBgColor: Color(0xFFE6E4E4),
    secIconColor: Color(0xFFD0BCFF),
    secTextColor: Color(0xFFD0BCFF),
    secFontFamily: "RaleWay",
    errorBgColor: Color(0xFFD61A1A),
    errorIconColor: Color(0xFFFFFFFF),
    errorTextColor: Color(0xFFFFFFFF),
    errorFontFamily: "RaleWay",
  ),
  dark(
    primaryBgColor: Color(0xFF1C1B1F),
    primaryIconColor: Color(0xFF8E918F),
    primaryTextColor: Color(0xFFFFFFFF),
    primaryFontFamily: "RaleWay",
    secBgColor: Color(0xFF0c0b0b),
    secIconColor: Color(0xFFD0BCFF),
    secTextColor: Color(0xFFD0BCFF),
    secFontFamily: "RaleWay",
    errorBgColor: Color(0xFFD61A1A),
    errorIconColor: Color(0xFFFFFFFF),
    errorTextColor: Color(0xFFFFFFFF),
    errorFontFamily: "RaleWay",
  );

  static const defaultTheme = light;

  final Color primaryBgColor;
  final Color primaryIconColor;
  final Color primaryTextColor;
  final String primaryFontFamily;

  final Color secBgColor;
  final Color secIconColor;
  final Color secTextColor;
  final String secFontFamily;

  final Color errorBgColor;
  final Color errorIconColor;
  final Color errorTextColor;
  final String errorFontFamily;

  const CanaTheme({
    required this.primaryBgColor,
    required this.primaryIconColor,
    required this.primaryTextColor,
    required this.primaryFontFamily,
    required this.secBgColor,
    required this.secIconColor,
    required this.secTextColor,
    required this.secFontFamily,
    required this.errorBgColor,
    required this.errorIconColor,
    required this.errorTextColor,
    required this.errorFontFamily,
  });

  @override
  String toString() => name;

  /// i18n translation key
  String get nameKey => "settings.theme.colour.options.$name";
}
