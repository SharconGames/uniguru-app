import 'package:flutter/material.dart';

// Define your primary and secondary gradient colors (1st bunch and 2nd bunch)
const List<Color> primaryGradientColors = [
  Color(0xFF61ACEF), // Light Blue
  Color(0xFF9987ED), // Light Purple
  Color(0xFFB679E1), // Lavender
  Color(0xFF9791DB), // Soft Blue
  Color(0xFF74BDCC), // Aqua Blue
  Color(0xFF59D2BF), // Teal
];

const List<Color> secondaryGradientColors = [
  Color(0xFFE4BB1A), // Muted yellow
  Color(0xFFE6C300), // Dimmed golden yellow
  Color(0xFFB9961F), // Dark gold
  Color(0xFF9B6F00), // Muted bronze
];

// Define a constant LinearGradient for primary colors
const LinearGradient primaryGradient = LinearGradient(
  colors: primaryGradientColors,
  begin: Alignment.topCenter,
  end: Alignment.topLeft,
);

const LinearGradient secondaryGradient = LinearGradient(
  colors: secondaryGradientColors,
  begin: Alignment.topCenter,
  end: Alignment.topLeft,
);

final ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: const Color(0xFF0E0513),
  appBarTheme: AppBarTheme(
    backgroundColor: primaryGradientColors.last,
    titleTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
  ),
);
