import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import google_fonts
import 'colors.dart'; // Import the colors.dart file

// Light Theme
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: lightPrimary,
  colorScheme: const ColorScheme.light(
    primary: lightPrimary,
    secondary: lightSecondary,
    onSurface: lightAccent,
  ),
  scaffoldBackgroundColor: lightBackground,
  appBarTheme: const AppBarTheme(
    color: lightPrimary,
    elevation: 0,
  ),
  textTheme: TextTheme(
    bodyLarge: GoogleFonts.roboto(
      fontSize: 16,
      color: lightText,
    ),
    bodyMedium: GoogleFonts.roboto(
      fontSize: 14,
      color: lightText,
    ),
    headlineLarge: GoogleFonts.roboto(
        fontSize: 32, fontWeight: FontWeight.bold, color: lightText),
    headlineMedium: GoogleFonts.roboto(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: lightText,
    ),
    titleSmall: GoogleFonts.roboto(
      fontSize: 18,
      color: lightText,
    ),
  ),
  listTileTheme: ListTileThemeData(
    textColor: lightText,
    iconColor: lightPrimary,
    subtitleTextStyle: TextStyle(color: lightText.withOpacity(0.6)),
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: lightPrimary,
    textTheme: ButtonTextTheme.normal,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: lightPrimary,
  ),
);

// Dark Theme
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: darkPrimary,
  colorScheme: const ColorScheme.dark(
    primary: darkPrimary,
    secondary: darkSecondary,
    onSurface: darkText,
  ),
  scaffoldBackgroundColor: darkBackground,
  appBarTheme: const AppBarTheme(
    color: darkPrimary,
    elevation: 0,
  ),
  textTheme: TextTheme(
    bodyLarge: GoogleFonts.roboto(
      color: darkText,
      fontSize: 16,
    ),
    bodyMedium: GoogleFonts.roboto(
      color: darkText,
      fontSize: 14,
    ),
    headlineLarge: GoogleFonts.roboto(
      color: darkText,
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: GoogleFonts.roboto(
      color: darkText,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    titleSmall: GoogleFonts.roboto(
      color: darkText,
      fontSize: 18,
    ),
  ),
  listTileTheme: ListTileThemeData(
    textColor: darkText,
    iconColor: darkPrimary,
    subtitleTextStyle: TextStyle(color: darkText.withOpacity(0.6)),
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: darkPrimary,
    textTheme: ButtonTextTheme.normal,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: darkPrimary,
  ),
);
