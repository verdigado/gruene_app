import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeColors {
  // Primary Green Dark/State Hover Green (#005437)
  static const Color primary = Color(0xFF005437);
  // Secondary Light Green (#008939)
  static const Color secondary = Color(0xFF008939);
  // Middle Grey (#9CABAF)
  static const Color disabled = Color(0xFF9CABAF);
  // White (#FFFFFF)
  static const Color background = Color(0xFFFFFFFF);
  // Softer Grey (#F9FAFB)
  static const Color backgroundSecondary = Color(0xFFF9FAFB);
}

class ThemeTextStyles {
  static TextStyle smallText = GoogleFonts.ptSans(
    textStyle: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w400,
      height: 1.3,
      letterSpacing: 0.01,
    ),
  );
}

final ThemeData appTheme = ThemeData(
  primaryColor: ThemeColors.primary,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: ThemeColors.background,
    selectedItemColor: ThemeColors.primary,
    unselectedItemColor: ThemeColors.disabled,
    selectedLabelStyle: ThemeTextStyles.smallText,
    unselectedLabelStyle: ThemeTextStyles.smallText,
  ),
  scaffoldBackgroundColor: ThemeColors.backgroundSecondary,
);
