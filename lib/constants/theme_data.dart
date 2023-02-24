import 'package:flutter/material.dart';

const MaterialColor mcgpalette0 =
    MaterialColor(_mcgpalette0PrimaryValue, <int, Color>{
  50: Color(0xFFE3ECE6),
  100: Color(0xFFB9CFC2),
  200: Color(0xFF8AAF99),
  300: Color(0xFF5B8F70),
  400: Color(0xFF377751),
  500: Color(_mcgpalette0PrimaryValue),
  600: Color(0xFF12572D),
  700: Color(0xFF0E4D26),
  800: Color(0xFF0B431F),
  900: Color(0xFF063213),
});
const int _mcgpalette0PrimaryValue = 0xFF145F32;

const MaterialColor mcgpalette0Accent =
    MaterialColor(mcgpalette0AccentValue, <int, Color>{
  50: Color(0xFFFFE9EC),
  100: Color(0xFFFFC8CE),
  200: Color(0xFFFFA4AE),
  300: Color(0xFFFF808E),
  400: Color(0xFFFF6475),
  500: Color(mcgpalette0AccentValue),
  600: Color(0xFFFF4255),
  700: Color(0xFFFF394B),
  800: Color(0xFFFF3141),
  900: Color(0xFFFF2130),
});
const int mcgpalette0AccentValue = 0xFFFF495D;

final rootTheme = ThemeData(
  primaryColor: const Color(_mcgpalette0PrimaryValue),
  primaryColorLight: const Color(0xFFE3ECE6),
  textTheme: const TextTheme(
      bodyLarge: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 18,
          color: Color.fromRGBO(52, 52, 51, 1)),
      labelSmall: TextStyle(color: Colors.white),
      displayLarge: TextStyle(
          fontFamily: 'Bereit',
          fontWeight: FontWeight.w700,
          color: Color.fromRGBO(52, 52, 51, 1)),
      displayMedium: TextStyle(
          fontFamily: 'Bereit',
          fontWeight: FontWeight.w500,
          color: Color.fromRGBO(52, 52, 51, 1)),
      displaySmall: TextStyle(
          fontFamily: 'Bereit',
          fontWeight: FontWeight.w300,
          fontSize: 32,
          color: Color.fromRGBO(52, 52, 51, 1))),
  fontFamily: 'Ptsans',
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      textStyle: const TextStyle(color: Colors.white),
      minimumSize: const Size(345, 56),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // <-- Radius
      ),
    ),
  ),
  colorScheme: ColorScheme.fromSwatch(
      primarySwatch: mcgpalette0, accentColor: mcgpalette0Accent),
);
