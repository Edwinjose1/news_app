// lib/core/theme/app_theme.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:news_reader/core/theme/app_fonts.dart';

class AppTheme {
  static ThemeData lightTheme({
    required ColorScheme colorScheme,
    required String fontFamily,
  }) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: AppFonts.getTextTheme(fontFamily),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceVariant,
        selectedColor: colorScheme.primary,
        labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        secondaryLabelStyle: TextStyle(color: colorScheme.onPrimary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  static ThemeData darkTheme({
    required ColorScheme colorScheme,
    required String fontFamily,
  }) {
    final darkColorScheme = ColorScheme.fromSeed(
      seedColor: colorScheme.primary,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme,
      textTheme: AppFonts.getTextTheme(fontFamily),
      appBarTheme: AppBarTheme(
        backgroundColor: darkColorScheme.surface,
        foregroundColor: darkColorScheme.onSurface,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: darkColorScheme.surfaceVariant,
        selectedColor: darkColorScheme.primary,
        labelStyle: TextStyle(color: darkColorScheme.onSurfaceVariant),
        secondaryLabelStyle: TextStyle(color: darkColorScheme.onPrimary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkColorScheme.primary,
          foregroundColor: darkColorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}