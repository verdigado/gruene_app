import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeColors {
  // Primary Green Dark/State Hover Green (#005437)
  static const Color primary = Color(0xFF005437);

  // Secondary Light Green (#008939)
  static const Color secondary = Color(0xFF008939);

  // Secondary Light Green (#008939)
  static const Color tertiary = Color(0xFF46962B);

  // White (#FFFFFF)
  static const Color background = Color(0xFFFFFFFF);

  // Softer Grey (#F9FAFB)
  static const Color backgroundSecondary = Color(0xFFF9FAFB);

  // Black (#000000)
  static const Color text = Color(0xFF000000);

  // Dark Grey (#343433)
  static const Color textAccent = Color(0xFF343433);

  // Middle Grey (#9CABAF)
  static const Color textDisabled = Color(0xFF9CABAF);

}

class ThemeTextStyles {
  // TOOD use GrueneType font
  static TextStyle displayMedium = GoogleFonts.ptSans(
    textStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w900,
      fontStyle: FontStyle.italic,
      height: 1.6,
      letterSpacing: 0.02,
    ),
  );
  static TextStyle displayLarge = displayMedium.copyWith(fontSize: 34, letterSpacing: 0.03);

  static TextStyle titleMedium = GoogleFonts.ptSans(
    textStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      height: 1.3,
      letterSpacing: 0.02,
    ),
  );

  static TextStyle bodyMedium = GoogleFonts.ptSans(
    textStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.6,
      letterSpacing: 0.02,
    ),
  );

  static TextStyle bodyLarge = bodyMedium.copyWith(fontSize: 18, height: 1);

  static TextStyle labelSmall = GoogleFonts.ptSans(
    textStyle: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w400,
      height: 1.3,
      letterSpacing: 0.01,
    ),
  );
}

final ThemeData appTheme = ThemeData.light().copyWith(
  primaryColor: ThemeColors.primary,
  disabledColor: ThemeColors.disabled,
  colorScheme: ThemeData.light().colorScheme.copyWith(
    primary: ThemeColors.primary,
    secondary: ThemeColors.secondary,
    tertiary: ThemeColors.tertiary,
    surface: ThemeColors.background,
    surfaceDim: ThemeColors.backgroundSecondary,
  ),
  textTheme: TextTheme(
    displayLarge: ThemeTextStyles.displayLarge,
    displayMedium: ThemeTextStyles.displayMedium,
    titleMedium: ThemeTextStyles.titleMedium,
    bodyLarge: ThemeTextStyles.bodyLarge,
    bodyMedium: ThemeTextStyles.bodyMedium,
    labelSmall: ThemeTextStyles.labelSmall,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: ThemeColors.background,
    selectedItemColor: ThemeColors.primary,
    unselectedItemColor: ThemeColors.textDisabled,
    selectedLabelStyle: ThemeTextStyles.labelSmall,
    unselectedLabelStyle: ThemeTextStyles.labelSmall,
  ),
  scaffoldBackgroundColor: ThemeColors.backgroundSecondary,
);
