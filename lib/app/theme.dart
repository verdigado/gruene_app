import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeColors {
  static const Color stateHoverGreen = Color(0xFF005437);
  static const Color middleGrey = Color(0xFF9CABAF);
  static const Color white = Color(0xFFFFFFFF);
  static const Color softerGrey = Color(0xFFF9FAFB);
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
  primaryColor: ThemeColors.stateHoverGreen,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: ThemeColors.stateHoverGreen,
    unselectedItemColor: ThemeColors.middleGrey,
    selectedLabelStyle: ThemeTextStyles.smallText,
    unselectedLabelStyle: ThemeTextStyles.smallText,
  ),
  scaffoldBackgroundColor: ThemeColors.softerGrey,
);
