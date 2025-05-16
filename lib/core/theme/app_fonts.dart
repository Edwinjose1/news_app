// lib/core/theme/app_fonts.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFonts {
  // List of fonts available through Google Fonts
  static const List<String> availableFonts = [
    'Roboto',
    'Lato',
    'Open Sans',
    'Montserrat',
    'Poppins',
    'Raleway',
    'Inter',
    'Nunito',
    'Source Sans Pro',
    'Ubuntu',
  ];

  // Default font if something goes wrong
  static const String defaultFont = 'Roboto';

  // Get the text theme for a specific font family
  static TextTheme getTextTheme(String fontFamily) {
    // Validate font name or use default
    final validFontFamily = availableFonts.contains(fontFamily) ? fontFamily : defaultFont;
    
    // Use Google Fonts to get the text theme
    return GoogleFonts.getTextTheme(
      validFontFamily,
      const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(fontSize: 16, height: 1.5, fontWeight: FontWeight.normal),
        bodyMedium: TextStyle(fontSize: 14, height: 1.5, fontWeight: FontWeight.normal),
        bodySmall: TextStyle(fontSize: 12, height: 1.4, fontWeight: FontWeight.normal),
        labelLarge: TextStyle(fontSize: 14, letterSpacing: 0.25, fontWeight: FontWeight.w500),
        labelMedium: TextStyle(fontSize: 12, letterSpacing: 0.25, fontWeight: FontWeight.w500),
        labelSmall: TextStyle(fontSize: 10, letterSpacing: 0.25, fontWeight: FontWeight.w500),
      ),
    );
  }
  
  // Get specific text style for any font (useful for previews)
  static TextStyle getPreviewStyle(String fontFamily, {double fontSize = 16, FontWeight fontWeight = FontWeight.normal}) {
    return GoogleFonts.getFont(
      availableFonts.contains(fontFamily) ? fontFamily : defaultFont,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }
  
  // Method to check if a font is available
  static bool isFontAvailable(String fontFamily) {
    return availableFonts.contains(fontFamily);
  }
  
  // Get font display name (can be customized if needed)
  static String getFontDisplayName(String fontFamily) {
    return fontFamily;
  }
  
  // Get sample text for font preview
  static String getSampleText() {
    return 'The quick brown fox jumps over the lazy dog';
  }
}