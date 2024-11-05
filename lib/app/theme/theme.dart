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
  // Black (#000000)
  static const Color text = Color(0xFF000000);
}

class ThemeTextStyles {
  // TOOD use GrueneType font
  static TextStyle appBarText = GoogleFonts.ptSans(
    textStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w900,
      fontStyle: FontStyle.italic,
      height: 1.6,
      letterSpacing: 0.02,
    ),
  );
  static TextStyle body = GoogleFonts.ptSans(
    textStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.6,
      letterSpacing: 0.02,
    ),
  );
  static TextStyle smallText = GoogleFonts.ptSans(
    textStyle: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w400,
      height: 1.3,
      letterSpacing: 0.01,
    ),
  );
  static TextStyle h4 = GoogleFonts.ptSans(
    textStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      height: 1,
      letterSpacing: 0.02,
    ),
  );
  static TextStyle h4Title = GoogleFonts.ptSans(
    textStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      height: 1.3,
      letterSpacing: 0.02,
    ),
  );
}

final ThemeData appTheme = ThemeData(
  primaryColor: ThemeColors.primary,
  disabledColor: ThemeColors.disabled,
  textTheme: TextTheme(
    displayMedium: ThemeTextStyles.appBarText,
    bodyLarge: ThemeTextStyles.h4,
    bodyMedium: ThemeTextStyles.body,
    titleMedium: ThemeTextStyles.h4Title,
    labelSmall: ThemeTextStyles.smallText,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: ThemeColors.background,
    selectedItemColor: ThemeColors.primary,
    unselectedItemColor: ThemeColors.disabled,
    selectedLabelStyle: ThemeTextStyles.smallText,
    unselectedLabelStyle: ThemeTextStyles.smallText,
  ),
  scaffoldBackgroundColor: ThemeColors.backgroundSecondary,
);
