// lib/core/theme/app_colors.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class AppColors {
  // Classic dark shades
  static const ColorScheme navyColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF14213D),        // Navy blue
    onPrimary: Colors.white,
    secondary: Color(0xFF455A64),      // Blue grey
    onSecondary: Colors.white,
    error: Color(0xFF9E2A2B),          // Deep red
    onError: Colors.white,
    background: Color(0xFFF9F9F9),     // Off-white
    onBackground: Color(0xFF212121),    // Almost black
    surface: Colors.white,
    onSurface: Color(0xFF212121),       // Almost black
  );

  static const ColorScheme burgundyColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF692933),        // Burgundy
    onPrimary: Colors.white,
    secondary: Color(0xFF9C6644),      // Copper tone
    onSecondary: Colors.white,
    error: Color(0xFFCF000F),          // Bright red
    onError: Colors.white,
    background: Color(0xFFF9F9F9),     // Off-white
    onBackground: Color(0xFF212121),    // Almost black
    surface: Colors.white,
    onSurface: Color(0xFF212121),       // Almost black
  );

  static const ColorScheme forestColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF1B4332),        // Forest green
    onPrimary: Colors.white,
    secondary: Color(0xFF52796F),      // Sage green
    onSecondary: Colors.white,
    error: Color(0xFFA44A3F),          // Terra cotta
    onError: Colors.white,
    background: Color(0xFFF9F9F9),     // Off-white
    onBackground: Color(0xFF212121),    // Almost black
    surface: Colors.white,
    onSurface: Color(0xFF212121),       // Almost black
  );

  static const ColorScheme charcoalColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF2D3142),        // Charcoal
    onPrimary: Colors.white,
    secondary: Color(0xFF4F5D75),      // Slate
    onSecondary: Colors.white,
    error: Color(0xFF973C40),          // Muted red
    onError: Colors.white,
    background: Color(0xFFF9F9F9),     // Off-white
    onBackground: Color(0xFF212121),    // Almost black
    surface: Colors.white,
    onSurface: Color(0xFF212121),       // Almost black
  );

  static const ColorScheme indigoColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF30415D),        // Indigo
    onPrimary: Colors.white,
    secondary: Color(0xFF8EAEBD),      // Steel blue
    onSecondary: Colors.white,
    error: Color(0xFF973E4C),          // Mulberry
    onError: Colors.white,
    background: Color(0xFFF9F9F9),     // Off-white
    onBackground: Color(0xFF212121),    // Almost black
    surface: Colors.white,
    onSurface: Color(0xFF212121),       // Almost black
  );

  // List of available color schemes
  static final List<ColorScheme> availableColorSchemes = [
    navyColorScheme,
    burgundyColorScheme,
    forestColorScheme,
    charcoalColorScheme,
    indigoColorScheme,
  ];
  
  // Classic neutral colors for UI elements
  static const Color neutralLight = Color(0xFFE0E0E0);
  static const Color neutralMedium = Color(0xFFBDBDBD);
  static const Color neutralDark = Color(0xFF757575);
  
  // Shadow colors
  static final BoxShadow subtleShadow = BoxShadow(
    color: Colors.black.withOpacity(0.08),
    blurRadius: 4,
    offset: const Offset(0, 2),
  );
  
  static final BoxShadow mediumShadow = BoxShadow(
    color: Colors.black.withOpacity(0.12),
    blurRadius: 8,
    offset: const Offset(0, 3),
  );
}