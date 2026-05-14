import 'package:flutter/material.dart';

class BillLearnColors {
  static const mainPurple = Color(0xFF6C4EFF);
  static const lightPurple = Color(0xFFEDE9FF);
  static const softGray = Color(0xFFF6F7FB);
  static const ink = Color(0xFF171335);
}

ThemeData buildBillLearnTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: BillLearnColors.mainPurple,
    brightness: Brightness.light,
    primary: BillLearnColors.mainPurple,
    surface: Colors.white,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: BillLearnColors.softGray,
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      backgroundColor: Colors.white,
      foregroundColor: BillLearnColors.ink,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}
