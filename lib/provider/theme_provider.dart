import 'package:flutter/material.dart';
 
import '../services/storage_service.dart';
 
class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
 
  bool get isDarkMode => _isDarkMode;
 
  ThemeProvider() {
    _loadTheme();
  }
 
  Future<void> _loadTheme() async {
    _isDarkMode =
        await StorageService.getDarkMode();
 
    notifyListeners();
  }
 
  Future<void> toggleTheme(bool value) async {
    _isDarkMode = value;
 
    notifyListeners();
 
    await StorageService.saveDarkMode(value);
  }
 
  ThemeMode get themeMode {
    return _isDarkMode
        ? ThemeMode.dark
        : ThemeMode.light;
  }
}
 