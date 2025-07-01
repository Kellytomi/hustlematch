import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Theme state notifier
class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier() : super(false) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('isDarkMode') ?? false;
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    state = !state;
    await prefs.setBool('isDarkMode', state);
  }

  Future<void> setTheme(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    state = isDarkMode;
    await prefs.setBool('isDarkMode', isDarkMode);
  }
}

// Theme provider
final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier();
}); 