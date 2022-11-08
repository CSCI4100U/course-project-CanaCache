import "package:flutter/material.dart";

class CanaPalette {
  static String defaultTheme = "Default";

  static final Map<String, CanaTheme> _cannaThemes = {
    "Default": CanaTheme(
      themeName: "Default",
      primaryBgColor: const Color(0xFFFFFFFF),
      primaryIconColor: const Color(0xFF8E918F),
      primaryTextColor: const Color(0xFF8E918F),
      primaryFontFamily: "RaleWay",
      secBgColor: const Color(0xFFE6E4E4),
      secIconColor: const Color(0xFFD0BCFF),
      secTextColor: const Color(0xFFD0BCFF),
      secFontFamily: "RaleWay",
      errorBgColor: const Color(0xFFD61A1A),
      errorIconColor: const Color(0xFFFFFFFF),
      errorTextColor: const Color(0xFFFFFFFF),
      errorFontFamily: "RaleWay",
    ),
    "Dark Theme": CanaTheme(
      themeName: "Dark Theme",
      primaryBgColor: const Color(0xFF1C1B1F),
      primaryIconColor: const Color(0xFF8E918F),
      primaryTextColor: const Color(0xFFFFFFFF),
      primaryFontFamily: "RaleWay",
      secBgColor: const Color(0xFF0c0b0b),
      secIconColor: const Color(0xFFD0BCFF),
      secTextColor: const Color(0xFFD0BCFF),
      secFontFamily: "RaleWay",
      errorBgColor: const Color(0xFFD61A1A),
      errorIconColor: const Color(0xFFFFFFFF),
      errorTextColor: const Color(0xFFFFFFFF),
      errorFontFamily: "RaleWay",
    ),
  };

  static CanaTheme initCanaTheme(String theme) {
    if (!isValidTheme(theme)) {
      theme = defaultTheme;
    }
    return cannaThemes[theme];
  }

  static get cannaThemes => _cannaThemes;

  static CanaTheme getCanaTheme(String key) {
    if (!isValidTheme(key)) {
      throw Exception("Invalid Theme Key Passed");
    }
    return _cannaThemes[key]!;
  }

  static bool isValidTheme(String? key) {
    return _cannaThemes.containsKey(key);
  }
}

class CanaTheme {
  final String themeName;

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

  CanaTheme({
    required this.themeName,
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
  String toString() {
    return themeName;
  }
}
