// lib/core/theme/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:news_reader/core/theme/app_colors.dart';
import 'package:news_reader/core/theme/app_theme.dart';
import 'package:news_reader/core/theme/app_fonts.dart';

class ThemeProvider extends ChangeNotifier {
  late Box _settingsBox;
  
  ThemeMode _themeMode = ThemeMode.system;
  ColorScheme _colorScheme = AppColors.charcoalColorScheme;
  String _fontFamily = 'Roboto';
  bool _isInitialized = false;
  
  ThemeProvider() {
    _initializeSettings();
  }
  
  Future<void> _initializeSettings() async {
    // Check if the box exists, if not create it
    if (!Hive.isBoxOpen('settings')) {
      _settingsBox = await Hive.openBox('settings');
    } else {
      _settingsBox = Hive.box('settings');
    }
    
    _loadThemeSettings();
    _isInitialized = true;
    notifyListeners();
  }
  
  ThemeMode get themeMode => _themeMode;
  String get fontFamily => _fontFamily;
  ColorScheme get colorScheme => _colorScheme;
  bool get isInitialized => _isInitialized;
  
  ThemeData get lightTheme => AppTheme.lightTheme(
    colorScheme: _colorScheme,
    fontFamily: _fontFamily,
  );
  
  ThemeData get darkTheme => AppTheme.darkTheme(
    colorScheme: _colorScheme,
    fontFamily: _fontFamily,
  );
  
  void _loadThemeSettings() {
    if (!_isInitialized) return;
    
    final themeModeIndex = _settingsBox.get('themeMode', defaultValue: 0);
    final colorSchemeIndex = _settingsBox.get('colorScheme', defaultValue: 0);
    final fontFamily = _settingsBox.get('fontFamily', defaultValue: 'Roboto');
    
    _themeMode = ThemeMode.values[themeModeIndex];
    _colorScheme = AppColors.availableColorSchemes[colorSchemeIndex];
    
    // Validate that the font family is available
    _fontFamily = AppFonts.availableFonts.contains(fontFamily) 
        ? fontFamily 
        : 'Roboto';
    
    notifyListeners();
  }
  
  void setThemeMode(ThemeMode mode) {
    if (_themeMode == mode || !_isInitialized) return;
    _themeMode = mode;
    _settingsBox.put('themeMode', mode.index);
    notifyListeners();
  }
  
  void setColorScheme(int index) {
    if (!_isInitialized || index < 0 || index >= AppColors.availableColorSchemes.length) return;
    _colorScheme = AppColors.availableColorSchemes[index];
    _settingsBox.put('colorScheme', index);
    notifyListeners();
  }
  
  void setFontFamily(String fontFamily) {
    if (_fontFamily == fontFamily || !_isInitialized) return;
    // Only set the font family if it's in our list of available fonts
    if (AppFonts.availableFonts.contains(fontFamily)) {
      _fontFamily = fontFamily;
      _settingsBox.put('fontFamily', fontFamily);
      notifyListeners();
    }
  }
}