import 'package:flutter/material.dart';
import 'package:gruene_app/gen/fonts.gen.dart';

////**
///  * CONST Colors
///  */
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

const MaterialColor mcgpalette0Secondary =
    MaterialColor(_mcgpalette0SecondaryValue, <int, Color>{
  50: Color(0xFFE9F2E6),
  100: Color(0xFFC8E0BF),
  200: Color(0xFFA3CB95),
  300: Color(0xFF7EB66B),
  400: Color(0xFF62A64B),
  500: Color(_mcgpalette0PrimaryValue),
  600: Color(0xFF3F8E26),
  700: Color(0xFF378320),
  800: Color(0xFF2F791A),
  900: Color(0xFF206810),
});
const int _mcgpalette0SecondaryValue = 0xFF46962B;

const Color softGreen = Color(0xFFDCE7E0);
const Color lightBlack = Color(0xFF201D1B);
const Color darkGrey = Color(0xFF343433);
const Color lightGrey = Color(0xFFD9D9D9);
const Color disabledGrey = lightGrey;

const textTheme = TextTheme(
  /**
      * Headlines
      */
  displayLarge: TextStyle(
      fontFamily: FontFamily.bereit,
      fontWeight: FontWeight.bold,
      fontSize: 24,
      height: 1.16,
      letterSpacing: 1.0,
      color: lightBlack),
  displayMedium: TextStyle(
      fontFamily: FontFamily.ptsans,
      fontWeight: FontWeight.bold,
      fontSize: 20,
      height: 1.3,
      letterSpacing: 1.0,
      color: lightBlack),
  displaySmall: TextStyle(
      fontFamily: FontFamily.ptsans,
      fontWeight: FontWeight.bold,
      fontSize: 18,
      height: 1.33,
      letterSpacing: 1.0,
      color: lightBlack),
  headlineLarge: TextStyle(
      fontFamily: FontFamily.ptsans,
      fontWeight: FontWeight.bold,
      fontSize: 18,
      height: 1.33,
      letterSpacing: 1.0,
      color: lightBlack),
  headlineMedium: TextStyle(
      fontFamily: FontFamily.ptsans,
      fontWeight: FontWeight.normal,
      fontSize: 16,
      height: 1.25,
      letterSpacing: 0,
      color: lightBlack),
  headlineSmall: TextStyle(
      fontFamily: FontFamily.ptsans,
      fontWeight: FontWeight.bold,
      fontSize: 16,
      height: 1.25,
      letterSpacing: 0,
      color: lightBlack),
  /**
      * Body
      */
  bodyLarge: TextStyle(
      fontFamily: FontFamily.ptsans,
      fontWeight: FontWeight.normal,
      fontSize: 14,
      height: 1.71,
      letterSpacing: 0,
      color: lightBlack),
  bodyMedium: TextStyle(
      fontFamily: FontFamily.ptsans,
      fontWeight: FontWeight.bold,
      fontSize: 14,
      height: 1.71,
      letterSpacing: 0,
      color: lightBlack),
  bodySmall: TextStyle(
      fontFamily: FontFamily.ptsans,
      fontWeight: FontWeight.normal,
      fontSize: 12,
      height: 1.5,
      letterSpacing: 1.0,
      color: lightBlack),
  /**
      * Buttons
      */
  labelLarge: TextStyle(
      fontFamily: FontFamily.ptsans,
      fontWeight: FontWeight.bold,
      fontSize: 14,
      height: 1.28,
      letterSpacing: 1.0,
      color: lightBlack),
);

////**
///  * ThemeData
///  */
final rootTheme = ThemeData(
  primaryColor: const Color(_mcgpalette0PrimaryValue),
  primaryColorLight: const Color(0xFFE3ECE6),
  primaryTextTheme: textTheme,
  fontFamily: FontFamily.ptsans,
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
      primarySwatch: mcgpalette0, accentColor: mcgpalette0Secondary),
);
