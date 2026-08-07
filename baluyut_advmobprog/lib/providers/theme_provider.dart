import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    fontFamily: 'Poppins',
  );

  ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    fontFamily: 'Poppins',
  );

  // Enhancement 3: toggled from the new SettingsScreen switch
  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}
