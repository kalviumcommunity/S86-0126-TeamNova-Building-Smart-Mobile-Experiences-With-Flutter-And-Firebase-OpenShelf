import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Theme provider for managing app-wide theme state
/// Supports light, dark, and system theme modes with persistence
class ThemeProvider with ChangeNotifier {
  static const String _themePreferenceKey = 'theme_mode';
  ThemeMode _themeMode = ThemeMode.system;
  bool _isInitialized = false;

  ThemeProvider() {
    _loadThemePreference();
  }

  /// Current theme mode
  ThemeMode get themeMode => _themeMode;

  /// Check if the provider has loaded saved preferences
  bool get isInitialized => _isInitialized;

  /// Check if current theme is dark (considering system theme)
  bool isDarkMode(BuildContext context) {
    if (_themeMode == ThemeMode.system) {
      return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  /// Load theme preference from SharedPreferences
  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedThemeIndex = prefs.getInt(_themePreferenceKey);
      
      if (savedThemeIndex != null) {
        _themeMode = ThemeMode.values[savedThemeIndex];
      }
    } catch (e) {
      debugPrint('Error loading theme preference: $e');
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  /// Save theme preference to SharedPreferences
  Future<void> _saveThemePreference(ThemeMode mode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themePreferenceKey, mode.index);
    } catch (e) {
      debugPrint('Error saving theme preference: $e');
    }
  }

  /// Set theme mode and persist the preference
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    
    _themeMode = mode;
    notifyListeners();
    await _saveThemePreference(mode);
  }

  /// Toggle between light and dark mode
  Future<void> toggleTheme(bool isDark) async {
    await setThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  /// Set theme to system default
  Future<void> useSystemTheme() async {
    await setThemeMode(ThemeMode.system);
  }

  /// Set theme to light mode
  Future<void> useLightTheme() async {
    await setThemeMode(ThemeMode.light);
  }

  /// Set theme to dark mode
  Future<void> useDarkTheme() async {
    await setThemeMode(ThemeMode.dark);
  }

  /// Get theme mode display name
  String get currentThemeName {
    switch (_themeMode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }
}
